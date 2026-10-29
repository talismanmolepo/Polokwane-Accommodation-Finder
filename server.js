// server.js
require('dotenv').config();

const express = require('express');
const sql = require('mssql');
const path = require('path');

const app = express();
const PORT = process.env.PORT || 3000;

app.use(express.json());
app.use(express.static(path.join(__dirname, 'public')));

// Connect to the SQL Server database.
const dbConfig = {
    server: process.env.DB_SERVER || 'localhost',
    database: process.env.DB_DATABASE,
    user: process.env.DB_USER || process.env.DB_USERNAME,   // mssql needs "user", not "username"
    password: process.env.DB_PASSWORD,
    options: {
        encrypt: process.env.DB_ENCRYPT === 'true',
        trustServerCertificate: true
    }
};

// Named instance (e.g. SQLEXPRESS) OR a port - never both.
if (process.env.DB_INSTANCE) {
    dbConfig.options.instanceName = process.env.DB_INSTANCE;
} else {
    dbConfig.port = process.env.DB_PORT ? Number(process.env.DB_PORT) : 1433;
}

let poolPromise;

function getPool() {
    if (!poolPromise) {
        poolPromise = new sql.ConnectionPool(dbConfig)
            .connect()
            .then(pool => {
                console.log('Connected to SQL Server database:', dbConfig.database);
                return pool;
            })
            .catch(err => {
                poolPromise = null;   // allow retry on next request
                console.error('SQL Server connection failed:', err.message);
                throw err;
            });
    }
    return poolPromise;
}

// GET: Load all properties from SQL Server.
app.get('/api/properties', async (req, res) => {
    try {
        const pool = await getPool();

        const result = await pool.request().query(`
            SELECT
                p.PropertyID AS id,
                p.PropertyName AS title,
                l.LocationName AS location,
                t.TypeName AS type,
                p.MonthlyRent AS price,
                p.IsNSFASApproved AS nsfas,
                p.PropertyImage AS image,
                p.Description AS description,

                CAST(CASE WHEN EXISTS (
                    SELECT 1
                    FROM dbo.PropertyAmenities pa
                    JOIN dbo.Amenities a
                        ON a.AmenityID = pa.AmenityID
                    WHERE pa.PropertyID = p.PropertyID
                      AND a.AmenityName = N'Wi-Fi'
                ) THEN 1 ELSE 0 END AS bit) AS wifi,

                CAST(CASE WHEN EXISTS (
                    SELECT 1
                    FROM dbo.PropertyAmenities pa
                    JOIN dbo.Amenities a
                        ON a.AmenityID = pa.AmenityID
                    WHERE pa.PropertyID = p.PropertyID
                      AND a.AmenityName = N'Laundry'
                ) THEN 1 ELSE 0 END AS bit) AS laundry,

                CAST(CASE WHEN EXISTS (
                    SELECT 1
                    FROM dbo.PropertyAmenities pa
                    JOIN dbo.Amenities a
                        ON a.AmenityID = pa.AmenityID
                    WHERE pa.PropertyID = p.PropertyID
                      AND a.AmenityName = N'Secure Parking'
                ) THEN 1 ELSE 0 END AS bit) AS parking,

                CAST(CASE WHEN EXISTS (
                    SELECT 1
                    FROM dbo.PropertyAmenities pa
                    JOIN dbo.Amenities a
                        ON a.AmenityID = pa.AmenityID
                    WHERE pa.PropertyID = p.PropertyID
                      AND a.AmenityName = N'Braai Facilities'
                ) THEN 1 ELSE 0 END AS bit) AS braai,

                CAST(CASE WHEN EXISTS (
                    SELECT 1
                    FROM dbo.PropertyAmenities pa
                    JOIN dbo.Amenities a
                        ON a.AmenityID = pa.AmenityID
                    WHERE pa.PropertyID = p.PropertyID
                      AND a.AmenityName = N'Security'
                ) THEN 1 ELSE 0 END AS bit) AS security

            FROM dbo.Properties p
            JOIN dbo.Locations l
                ON l.LocationID = p.LocationID
            JOIN dbo.AccommodationTypes t
                ON t.TypeID = p.TypeID
            ORDER BY p.PropertyID;
        `);

        res.json(result.recordset);
    } catch (error) {
        console.error('Could not load properties:', error);
        res.status(500).json({ message: 'Could not load accommodation listings.' });
    }
});

// POST: Save a contact enquiry.
app.post('/api/enquiries', async (req, res) => {
    const { fullName, emailAddress, phoneNumber, messageText } = req.body;

    if (!fullName || !emailAddress || !phoneNumber || !messageText) {
        return res.status(400).json({
            message: 'Please complete all the enquiry fields.'
        });
    }

    try {
        const pool = await getPool();

        await pool.request()
            .input('FullName', sql.NVarChar(100), fullName.trim())
            .input('EmailAddress', sql.NVarChar(150), emailAddress.trim())
            .input('PhoneNumber', sql.NVarChar(25), phoneNumber.trim())
            .input('MessageText', sql.NVarChar(1000), messageText.trim())
            .query(`
                INSERT INTO dbo.Enquiries
                    (FullName, EmailAddress, PhoneNumber, MessageText)
                VALUES
                    (@FullName, @EmailAddress, @PhoneNumber, @MessageText);
            `);

        res.status(201).json({ message: 'Enquiry saved successfully.' });
    } catch (error) {
        console.error('Could not save enquiry:', error);
        res.status(500).json({ message: 'Could not save the enquiry.' });
    }
});

// POST: Save a booking and its student details.
app.post('/api/bookings', async (req, res) => {
    const {
        fullName,
        phoneNumber,
        emailAddress,
        propertyId,
        moveInDate,
        paymentMethod
    } = req.body;

    const validPayments = ['NSFAS', 'Private', 'Other Bursary'];

    if (
        !fullName || !phoneNumber || !emailAddress ||
        !Number.isInteger(Number(propertyId)) ||
        !moveInDate || !validPayments.includes(paymentMethod)
    ) {
        return res.status(400).json({
            message: 'Please check all the booking details.'
        });
    }

    const parsedDate = new Date(`${moveInDate}T00:00:00`);

    if (Number.isNaN(parsedDate.getTime()) ||
        parsedDate.toISOString().slice(0, 10) !== moveInDate) {
        return res.status(400).json({ message: 'Please enter a valid move-in date.' });
    }

    let transaction;

    try {
        const pool = await getPool();
        transaction = new sql.Transaction(pool);
        await transaction.begin();

        // Check whether this student already exists by email.
        const studentResult = await new sql.Request(transaction)
            .input('EmailAddress', sql.NVarChar(150), emailAddress.trim())
            .query(`
                SELECT StudentID
                FROM dbo.Students
                WHERE EmailAddress = @EmailAddress;
            `);

        let studentId;

        if (studentResult.recordset.length > 0) {
            studentId = studentResult.recordset[0].StudentID;

            await new sql.Request(transaction)
                .input('StudentID', sql.Int, studentId)
                .input('FullName', sql.NVarChar(100), fullName.trim())
                .input('PhoneNumber', sql.NVarChar(25), phoneNumber.trim())
                .query(`
                    UPDATE dbo.Students
                    SET FullName = @FullName,
                        PhoneNumber = @PhoneNumber
                    WHERE StudentID = @StudentID;
                `);
        } else {
            const newStudent = await new sql.Request(transaction)
                .input('FullName', sql.NVarChar(100), fullName.trim())
                .input('PhoneNumber', sql.NVarChar(25), phoneNumber.trim())
                .input('EmailAddress', sql.NVarChar(150), emailAddress.trim())
                .query(`
                    INSERT INTO dbo.Students
                        (FullName, PhoneNumber, EmailAddress)
                    OUTPUT INSERTED.StudentID
                    VALUES
                        (@FullName, @PhoneNumber, @EmailAddress);
                `);

            studentId = newStudent.recordset[0].StudentID;
        }

        await new sql.Request(transaction)
            .input('StudentID', sql.Int, studentId)
            .input('PropertyID', sql.Int, Number(propertyId))
            .input('MoveInDate', sql.Date, moveInDate)
            .input('PaymentMethod', sql.NVarChar(30), paymentMethod)
            .query(`
                INSERT INTO dbo.Bookings
                    (StudentID, PropertyID, MoveInDate, PaymentMethod)
                VALUES
                    (@StudentID, @PropertyID, @MoveInDate, @PaymentMethod);
            `);

        await transaction.commit();

        res.status(201).json({ message: 'Booking saved successfully.' });
    } catch (error) {
        if (transaction) { try { await transaction.rollback(); } catch (e) {} }
        console.error('Could not save booking:', error);

        res.status(500).json({
            message: 'Could not save the booking. Check the property and database connection.'
        });
    }
});

app.listen(PORT, () => {
    console.log(`Website running at http://localhost:${PORT}`);
    getPool().catch(() => {});   // test the DB connection at startup
});