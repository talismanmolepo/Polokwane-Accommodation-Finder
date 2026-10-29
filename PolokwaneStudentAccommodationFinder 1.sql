IF DB_ID(N'PolokwaneStudentAccomodation') IS NULL
CREATE DATABASE PolokwaneStudentAccommodation;
GO
USE PolokwaneStudentAccommodation;
GO

DROP TABLE IF EXISTS dbo.Favorites;
DROP TABLE IF EXISTS dbo.PropertyAmenities;
DROP TABLE IF EXISTS dbo.Enquiries;
DROP TABLE IF EXISTS dbo.Bookings;
DROP TABLE IF EXISTS dbo.Students;
DROP TABLE IF EXISTS dbo.Amenities;
DROP TABLE IF EXISTS dbo.Properties;
DROP TABLE IF EXISTS dbo.AccommodationTypes;
DROP TABLE IF EXISTS dbo.Locations;
GO

CREATE TABLE dbo.Locations (
    LocationID INT IDENTITY(1,1) PRIMARY KEY,
    LocationName NVARCHAR(80) NOT NULL UNIQUE
);

CREATE TABLE dbo.AccommodationTypes (
    TypeID INT IDENTITY(1,1) PRIMARY KEY,
    TypeName NVARCHAR(60) NOT NULL UNIQUE
);

CREATE TABLE dbo.Properties (
    PropertyID INT PRIMARY KEY,
    PropertyName NVARCHAR(150) NOT NULL,
    LocationID INT NOT NULL,
    TypeID INT NOT NULL,
    MonthlyRent DECIMAL(10,2) NOT NULL CHECK (MonthlyRent > 0),
    IsNSFASApproved BIT NOT NULL DEFAULT 0,
    PropertyImage NVARCHAR(500) NULL,
    Description NVARCHAR(1000) NULL,
    CONSTRAINT FK_Properties_Locations FOREIGN KEY (LocationID) REFERENCES dbo.Locations(LocationID),
    CONSTRAINT FK_Properties_Types FOREIGN KEY (TypeID) REFERENCES dbo.AccommodationTypes(TypeID)
);

CREATE TABLE dbo.Amenities (
    AmenityID INT IDENTITY(1,1) PRIMARY KEY,
    AmenityName NVARCHAR(60) NOT NULL UNIQUE
);

CREATE TABLE dbo.PropertyAmenities (
    PropertyID INT NOT NULL,
    AmenityID INT NOT NULL,
    PRIMARY KEY (PropertyID, AmenityID),
    FOREIGN KEY (PropertyID) REFERENCES dbo.Properties(PropertyID),
    FOREIGN KEY (AmenityID) REFERENCES dbo.Amenities(AmenityID)
);

CREATE TABLE dbo.Students (
    StudentID INT IDENTITY(1,1) PRIMARY KEY,
    FullName NVARCHAR(100) NOT NULL,
    PhoneNumber NVARCHAR(25) NOT NULL,
    EmailAddress NVARCHAR(150) NOT NULL UNIQUE,
    DateCreated DATETIME2 NOT NULL DEFAULT SYSDATETIME()
);

CREATE TABLE dbo.Bookings (
    BookingID INT IDENTITY(1,1) PRIMARY KEY,
    StudentID INT NOT NULL,
    PropertyID INT NOT NULL,
    MoveInDate DATE NOT NULL,
    PaymentMethod NVARCHAR(30) NOT NULL
        CHECK (PaymentMethod IN ('NSFAS', 'Private', 'Other Bursary')),
    BookingStatus NVARCHAR(20) NOT NULL DEFAULT 'Pending'
        CHECK (BookingStatus IN ('Pending', 'Approved', 'Declined', 'Cancelled')),
    BookingDate DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    FOREIGN KEY (StudentID) REFERENCES dbo.Students(StudentID),
    FOREIGN KEY (PropertyID) REFERENCES dbo.Properties(PropertyID)
);

CREATE TABLE dbo.Enquiries (
    EnquiryID INT IDENTITY(1,1) PRIMARY KEY,
    FullName NVARCHAR(100) NOT NULL,
    EmailAddress NVARCHAR(150) NOT NULL,
    PhoneNumber NVARCHAR(25) NOT NULL,
    MessageText NVARCHAR(1000) NOT NULL,
    EnquiryDate DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    EnquiryStatus NVARCHAR(20) NOT NULL DEFAULT 'New'
);

CREATE TABLE dbo.Favorites (
    StudentID INT NOT NULL,
    PropertyID INT NOT NULL,
    DateSaved DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    PRIMARY KEY (StudentID, PropertyID),
    FOREIGN KEY (StudentID) REFERENCES dbo.Students(StudentID),
    FOREIGN KEY (PropertyID) REFERENCES dbo.Properties(PropertyID)
);
GO

-- Add locations and accommodation types
INSERT INTO dbo.Locations (LocationName) VALUES
(N'Annadale'),
(N'Bendor'),
(N'Eduan Park'),
(N'Fauna Park'),
(N'Flora Park'),
(N'Ivy Park'),
(N'Penina Park'),
(N'Polokwane CBD'),
(N'Serala View'),
(N'Seshego'),
(N'Sterpark'),
(N'Thornhill'),
(N'Welgelegen');
INSERT INTO dbo.AccommodationTypes (TypeName) VALUES
(N'1 Bedroom Apartment'),
(N'Bachelor Studio'),
(N'Sharing Room'),
(N'Single Room');
INSERT INTO dbo.Amenities (AmenityName) VALUES
(N'Wi-Fi'),
(N'Laundry'),
(N'Secure Parking'),
(N'Braai Facilities'),
(N'Security');

-- Add the 39 accommodation listings from the website demo
INSERT INTO dbo.Properties (PropertyID, PropertyName, LocationID, TypeID, MonthlyRent, IsNSFASApproved, PropertyImage, Description)
VALUES
(1, N'Flora Park Executive Student Residence', (SELECT LocationID FROM dbo.Locations WHERE LocationName = N'Flora Park'), (SELECT TypeID FROM dbo.AccommodationTypes WHERE TypeName = N'Single Room'), 3200.00, 1, N'https://images.unsplash.com/photo-1555854877-bab0e564b8d5?auto=format&fit=crop&w=800&q=80', N'Spacious fully-furnished single bedroom located 5 minutes walk to shopping centers and taxi routes to UL and TUT.'),
(2, N'Serala View Student Haven', (SELECT LocationID FROM dbo.Locations WHERE LocationName = N'Serala View'), (SELECT TypeID FROM dbo.AccommodationTypes WHERE TypeName = N'Sharing Room'), 2400.00, 1, N'https://images.unsplash.com/photo-1595526114035-0d45ed16cfbf?auto=format&fit=crop&w=800&q=80', N'Comfortable two-bed sharing room with individual study desks, high-speed fibre internet, and solar power backup.'),
(3, N'Bendor Luxury Student Studio', (SELECT LocationID FROM dbo.Locations WHERE LocationName = N'Bendor'), (SELECT TypeID FROM dbo.AccommodationTypes WHERE TypeName = N'Bachelor Studio'), 4500.00, 0, N'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?auto=format&fit=crop&w=800&q=80', N'Modern private studio apartment featuring ensuite bathroom, kitchenette, and electric perimeter security.'),
(4, N'Fauna Park Student Heights', (SELECT LocationID FROM dbo.Locations WHERE LocationName = N'Fauna Park'), (SELECT TypeID FROM dbo.AccommodationTypes WHERE TypeName = N'Single Room'), 3100.00, 1, N'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?auto=format&fit=crop&w=800&q=80', N'Quiet study environment with communal kitchen, quiet study hall, and 24-hour security guards.'),
(5, N'Polokwane CBD Scholar Hub', (SELECT LocationID FROM dbo.Locations WHERE LocationName = N'Polokwane CBD'), (SELECT TypeID FROM dbo.AccommodationTypes WHERE TypeName = N'Sharing Room'), 2200.00, 1, N'https://images.unsplash.com/photo-1512918728675-ed5a9ecdebfd?auto=format&fit=crop&w=800&q=80', N'Central town location close to Capricorn TVET College and TUT Polokwane main entrance.'),
(6, N'Seshego Zone 1 Student Complex', (SELECT LocationID FROM dbo.Locations WHERE LocationName = N'Seshego'), (SELECT TypeID FROM dbo.AccommodationTypes WHERE TypeName = N'Single Room'), 2100.00, 1, N'https://images.unsplash.com/photo-1493809842364-78817add7ffb?auto=format&fit=crop&w=800&q=80', N'Affordable accredited accommodation with transport links directly to central campuses.'),
(7, N'Sterpark Premier Student Manor', (SELECT LocationID FROM dbo.Locations WHERE LocationName = N'Sterpark'), (SELECT TypeID FROM dbo.AccommodationTypes WHERE TypeName = N'1 Bedroom Apartment'), 4800.00, 0, N'https://images.unsplash.com/photo-1502005229762-cf1b2da7c5d6?auto=format&fit=crop&w=800&q=80', N'Exclusive single-occupancy flatlet with premium finishes, private balcony, and DSTV connections.'),
(8, N'Eduan Park Villa', (SELECT LocationID FROM dbo.Locations WHERE LocationName = N'Eduan Park'), (SELECT TypeID FROM dbo.AccommodationTypes WHERE TypeName = N'Single Room'), 3300.00, 1, N'https://images.unsplash.com/photo-1513694203232-719a280e022f?auto=format&fit=crop&w=800&q=80', N'Friendly student house featuring garden green space, braai area, and daily communal cleaning.'),
(9, N'Ivy Park Student Lodge', (SELECT LocationID FROM dbo.Locations WHERE LocationName = N'Ivy Park'), (SELECT TypeID FROM dbo.AccommodationTypes WHERE TypeName = N'Sharing Room'), 2300.00, 1, N'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?auto=format&fit=crop&w=800&q=80', N'Budget friendly double sharing unit fully fitted with lockers, study lamps, and gas stove cookers.'),
(10, N'Thornhill Student Suites', (SELECT LocationID FROM dbo.Locations WHERE LocationName = N'Thornhill'), (SELECT TypeID FROM dbo.AccommodationTypes WHERE TypeName = N'Bachelor Studio'), 4400.00, 0, N'https://images.unsplash.com/photo-1536376072261-38c75010e6c9?auto=format&fit=crop&w=800&q=80', N'Modern studio close to Thornhill Shopping Centre with automated access gates and uncapped wifi.'),
(11, N'Welgelegen House of Study', (SELECT LocationID FROM dbo.Locations WHERE LocationName = N'Welgelegen'), (SELECT TypeID FROM dbo.AccommodationTypes WHERE TypeName = N'Single Room'), 3400.00, 1, N'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?auto=format&fit=crop&w=800&q=80', N'Peaceful neighborhood residence equipped with backup water tanks, security cameras, and study desk.'),
(12, N'Annadale Campus Close Lodge', (SELECT LocationID FROM dbo.Locations WHERE LocationName = N'Annadale'), (SELECT TypeID FROM dbo.AccommodationTypes WHERE TypeName = N'Sharing Room'), 2000.00, 1, N'https://images.unsplash.com/photo-1522771739844-6a9f6d5f14af?auto=format&fit=crop&w=800&q=80', N'Economical shared room near major taxi hubs and public transport terminals in Polokwane.'),
(13, N'Penina Park Student Residence', (SELECT LocationID FROM dbo.Locations WHERE LocationName = N'Penina Park'), (SELECT TypeID FROM dbo.AccommodationTypes WHERE TypeName = N'Single Room'), 3000.00, 1, N'https://images.unsplash.com/photo-1540518614846-7ede433c5172?auto=format&fit=crop&w=800&q=80', N'Comfortable private room in a secure gated street close to Polokwane Golf Course.'),
(14, N'Flora Park Green Gardens', (SELECT LocationID FROM dbo.Locations WHERE LocationName = N'Flora Park'), (SELECT TypeID FROM dbo.AccommodationTypes WHERE TypeName = N'Bachelor Studio'), 3900.00, 1, N'https://images.unsplash.com/photo-1554995207-c18c203602cb?auto=format&fit=crop&w=800&q=80', N'Self-contained bachelor pad with private shower, kitchenette, and DSTV connection.'),
(15, N'Flora Park Central Court', (SELECT LocationID FROM dbo.Locations WHERE LocationName = N'Flora Park'), (SELECT TypeID FROM dbo.AccommodationTypes WHERE TypeName = N'Sharing Room'), 2500.00, 1, N'https://images.unsplash.com/photo-1484154218962-a197022b5858?auto=format&fit=crop&w=800&q=80', N'Neat twin sharing room in popular student complex with biometric front door locks.'),
(16, N'Serala View Crest Flatlet', (SELECT LocationID FROM dbo.Locations WHERE LocationName = N'Serala View'), (SELECT TypeID FROM dbo.AccommodationTypes WHERE TypeName = N'1 Bedroom Apartment'), 4600.00, 0, N'https://images.unsplash.com/photo-1560185127-6ed189bf02f4?auto=format&fit=crop&w=800&q=80', N'Stylish 1-bedroom unit ideal for postgraduates wanting peace and private kitchen facilities.'),
(17, N'Serala View Campus Nest', (SELECT LocationID FROM dbo.Locations WHERE LocationName = N'Serala View'), (SELECT TypeID FROM dbo.AccommodationTypes WHERE TypeName = N'Single Room'), 3250.00, 1, N'https://images.unsplash.com/photo-1616486338812-3dadae4b4ace?auto=format&fit=crop&w=800&q=80', N'Fully furnished single room with weekly cleaning included and uncapped 100Mbps fibre.'),
(18, N'Bendor Corner Residence', (SELECT LocationID FROM dbo.Locations WHERE LocationName = N'Bendor'), (SELECT TypeID FROM dbo.AccommodationTypes WHERE TypeName = N'Single Room'), 3500.00, 1, N'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?auto=format&fit=crop&w=800&q=80', N'Secure perimeter residence located close to Cycad Shopping Centre with backup generator power.'),
(19, N'Bendor Heights Student Flats', (SELECT LocationID FROM dbo.Locations WHERE LocationName = N'Bendor'), (SELECT TypeID FROM dbo.AccommodationTypes WHERE TypeName = N'Sharing Room'), 2600.00, 1, N'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?auto=format&fit=crop&w=800&q=80', N'Spacious 2-sleeper room with fitted wardrobes and large desks.'),
(20, N'Fauna Park Palms', (SELECT LocationID FROM dbo.Locations WHERE LocationName = N'Fauna Park'), (SELECT TypeID FROM dbo.AccommodationTypes WHERE TypeName = N'Bachelor Studio'), 4100.00, 0, N'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?auto=format&fit=crop&w=800&q=80', N'Private bachelor flat with ensuite toilet, shower, and built-in hot plate cookers.'),
(21, N'Polokwane CBD Metro House', (SELECT LocationID FROM dbo.Locations WHERE LocationName = N'Polokwane CBD'), (SELECT TypeID FROM dbo.AccommodationTypes WHERE TypeName = N'Single Room'), 2900.00, 1, N'https://images.unsplash.com/photo-1555854877-bab0e564b8d5?auto=format&fit=crop&w=800&q=80', N'Walking distance to supermarkets and major student transport lines across Polokwane.'),
(22, N'Polokwane CBD Plaza Rooms', (SELECT LocationID FROM dbo.Locations WHERE LocationName = N'Polokwane CBD'), (SELECT TypeID FROM dbo.AccommodationTypes WHERE TypeName = N'Sharing Room'), 2100.00, 1, N'https://images.unsplash.com/photo-1595526114035-0d45ed16cfbf?auto=format&fit=crop&w=800&q=80', N'Affordable accredited sharing room for students on a budget seeking central accessibility.'),
(23, N'Seshego Zone 2 Student Village', (SELECT LocationID FROM dbo.Locations WHERE LocationName = N'Seshego'), (SELECT TypeID FROM dbo.AccommodationTypes WHERE TypeName = N'Sharing Room'), 1950.00, 1, N'https://images.unsplash.com/photo-1502005229762-cf1b2da7c5d6?auto=format&fit=crop&w=800&q=80', N'Highly social student community setting with communal TV lounge and study area.'),
(24, N'Seshego Zone 4 Manor', (SELECT LocationID FROM dbo.Locations WHERE LocationName = N'Seshego'), (SELECT TypeID FROM dbo.AccommodationTypes WHERE TypeName = N'Single Room'), 2300.00, 1, N'https://images.unsplash.com/photo-1513694203232-719a280e022f?auto=format&fit=crop&w=800&q=80', N'Quiet single rooms with study desk, book shelving, and communal gas kitchen.'),
(25, N'Sterpark Oasis Apartments', (SELECT LocationID FROM dbo.Locations WHERE LocationName = N'Sterpark'), (SELECT TypeID FROM dbo.AccommodationTypes WHERE TypeName = N'Bachelor Studio'), 4300.00, 0, N'https://images.unsplash.com/photo-1536376072261-38c75010e6c9?auto=format&fit=crop&w=800&q=80', N'Upscale studio room equipped with microwave, fridge, and air conditioning.'),
(26, N'Eduan Park Heights', (SELECT LocationID FROM dbo.Locations WHERE LocationName = N'Eduan Park'), (SELECT TypeID FROM dbo.AccommodationTypes WHERE TypeName = N'Sharing Room'), 2450.00, 1, N'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?auto=format&fit=crop&w=800&q=80', N'Clean shared room with separate single beds and individual study space.'),
(27, N'Ivy Park Oasis', (SELECT LocationID FROM dbo.Locations WHERE LocationName = N'Ivy Park'), (SELECT TypeID FROM dbo.AccommodationTypes WHERE TypeName = N'Single Room'), 2800.00, 1, N'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?auto=format&fit=crop&w=800&q=80', N'Quiet residential setting with solar backup lighting during loadshedding.'),
(28, N'Thornhill Executive Residence', (SELECT LocationID FROM dbo.Locations WHERE LocationName = N'Thornhill'), (SELECT TypeID FROM dbo.AccommodationTypes WHERE TypeName = N'1 Bedroom Apartment'), 4900.00, 0, N'https://images.unsplash.com/photo-1554995207-c18c203602cb?auto=format&fit=crop&w=800&q=80', N'Spacious private apartment featuring fully equipped kitchen, lounge, and private bathroom.'),
(29, N'Welgelegen Student Lodge', (SELECT LocationID FROM dbo.Locations WHERE LocationName = N'Welgelegen'), (SELECT TypeID FROM dbo.AccommodationTypes WHERE TypeName = N'Sharing Room'), 2500.00, 1, N'https://images.unsplash.com/photo-1522771739844-6a9f6d5f14af?auto=format&fit=crop&w=800&q=80', N'Two sleeper room with study desks and high security electric fencing.'),
(30, N'Flora Park Sunburst House', (SELECT LocationID FROM dbo.Locations WHERE LocationName = N'Flora Park'), (SELECT TypeID FROM dbo.AccommodationTypes WHERE TypeName = N'Single Room'), 3350.00, 1, N'https://images.unsplash.com/photo-1540518614846-7ede433c5172?auto=format&fit=crop&w=800&q=80', N'Bright and airy single bedroom in established quiet suburb close to food outlets.'),
(31, N'Serala View Garden Studios', (SELECT LocationID FROM dbo.Locations WHERE LocationName = N'Serala View'), (SELECT TypeID FROM dbo.AccommodationTypes WHERE TypeName = N'Bachelor Studio'), 4200.00, 0, N'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?auto=format&fit=crop&w=800&q=80', N'Modern self-catering studio with private entrance and shade-net parking bay.'),
(32, N'Bendor Scholar Haven', (SELECT LocationID FROM dbo.Locations WHERE LocationName = N'Bendor'), (SELECT TypeID FROM dbo.AccommodationTypes WHERE TypeName = N'Single Room'), 3600.00, 1, N'https://images.unsplash.com/photo-1512918728675-ed5a9ecdebfd?auto=format&fit=crop&w=800&q=80', N'NSFAS accredited single room with high speed internet and weekly cleaning service.'),
(33, N'Fauna Park Executive Flat', (SELECT LocationID FROM dbo.Locations WHERE LocationName = N'Fauna Park'), (SELECT TypeID FROM dbo.AccommodationTypes WHERE TypeName = N'1 Bedroom Apartment'), 4700.00, 0, N'https://images.unsplash.com/photo-1560185127-6ed189bf02f4?auto=format&fit=crop&w=800&q=80', N'Private flatlet with separate bedroom, open plan kitchenette, and private garden patio.'),
(34, N'Polokwane CBD Union House', (SELECT LocationID FROM dbo.Locations WHERE LocationName = N'Polokwane CBD'), (SELECT TypeID FROM dbo.AccommodationTypes WHERE TypeName = N'Single Room'), 2950.00, 1, N'https://images.unsplash.com/photo-1493809842364-78817add7ffb?auto=format&fit=crop&w=800&q=80', N'Conveniently located single room with access control and communal laundry area.'),
(35, N'Seshego Zone 3 House', (SELECT LocationID FROM dbo.Locations WHERE LocationName = N'Seshego'), (SELECT TypeID FROM dbo.AccommodationTypes WHERE TypeName = N'Single Room'), 2200.00, 1, N'https://images.unsplash.com/photo-1513694203232-719a280e022f?auto=format&fit=crop&w=800&q=80', N'Homely setup in Seshego with DSTV in common room and fully fenced yard.'),
(36, N'Eduan Park Eco House', (SELECT LocationID FROM dbo.Locations WHERE LocationName = N'Eduan Park'), (SELECT TypeID FROM dbo.AccommodationTypes WHERE TypeName = N'Single Room'), 3100.00, 1, N'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?auto=format&fit=crop&w=800&q=80', N'Eco-friendly residence with solar geysers and borehole water backup supply.'),
(37, N'Flora Park Campus Corner', (SELECT LocationID FROM dbo.Locations WHERE LocationName = N'Flora Park'), (SELECT TypeID FROM dbo.AccommodationTypes WHERE TypeName = N'Sharing Room'), 2400.00, 1, N'https://images.unsplash.com/photo-1595526114035-0d45ed16cfbf?auto=format&fit=crop&w=800&q=80', N'Twin room with study desks, private wardrobes, and shared full bathroom.'),
(38, N'Bendor Green Park Villa', (SELECT LocationID FROM dbo.Locations WHERE LocationName = N'Bendor'), (SELECT TypeID FROM dbo.AccommodationTypes WHERE TypeName = N'Bachelor Studio'), 4350.00, 0, N'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?auto=format&fit=crop&w=800&q=80', N'Upmarket studio flat with private kitchen stove and covered car park.'),
(39, N'Flora Park Prestige Residence', (SELECT LocationID FROM dbo.Locations WHERE LocationName = N'Flora Park'), (SELECT TypeID FROM dbo.AccommodationTypes WHERE TypeName = N'1 Bedroom Apartment'), 4600.00, 0, N'https://images.unsplash.com/photo-1502005229762-cf1b2da7c5d6?auto=format&fit=crop&w=800&q=80', N'Luxury student flat with dedicated study room, lounge, and private bathroom.');

-- Link each property to the facilities it offers
INSERT INTO dbo.PropertyAmenities (PropertyID, AmenityID) VALUES
(1, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Wi-Fi')),
(1, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Laundry')),
(1, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Secure Parking')),
(1, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Braai Facilities')),
(1, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Security')),
(2, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Wi-Fi')),
(2, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Laundry')),
(2, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Braai Facilities')),
(2, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Security')),
(3, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Wi-Fi')),
(3, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Laundry')),
(3, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Secure Parking')),
(3, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Braai Facilities')),
(3, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Security')),
(4, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Wi-Fi')),
(4, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Laundry')),
(4, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Secure Parking')),
(4, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Security')),
(5, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Wi-Fi')),
(5, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Laundry')),
(5, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Security')),
(6, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Wi-Fi')),
(6, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Secure Parking')),
(6, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Braai Facilities')),
(6, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Security')),
(7, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Wi-Fi')),
(7, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Laundry')),
(7, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Secure Parking')),
(7, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Braai Facilities')),
(7, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Security')),
(8, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Wi-Fi')),
(8, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Laundry')),
(8, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Secure Parking')),
(8, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Braai Facilities')),
(8, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Security')),
(9, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Wi-Fi')),
(9, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Laundry')),
(9, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Secure Parking')),
(9, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Security')),
(10, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Wi-Fi')),
(10, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Laundry')),
(10, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Secure Parking')),
(10, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Braai Facilities')),
(10, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Security')),
(11, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Wi-Fi')),
(11, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Laundry')),
(11, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Secure Parking')),
(11, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Braai Facilities')),
(11, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Security')),
(12, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Wi-Fi')),
(12, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Secure Parking')),
(12, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Security')),
(13, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Wi-Fi')),
(13, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Laundry')),
(13, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Secure Parking')),
(13, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Braai Facilities')),
(13, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Security')),
(14, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Wi-Fi')),
(14, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Laundry')),
(14, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Secure Parking')),
(14, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Security')),
(15, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Wi-Fi')),
(15, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Laundry')),
(15, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Braai Facilities')),
(15, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Security')),
(16, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Wi-Fi')),
(16, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Laundry')),
(16, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Secure Parking')),
(16, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Braai Facilities')),
(16, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Security')),
(17, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Wi-Fi')),
(17, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Laundry')),
(17, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Secure Parking')),
(17, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Security')),
(18, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Wi-Fi')),
(18, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Laundry')),
(18, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Secure Parking')),
(18, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Braai Facilities')),
(18, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Security')),
(19, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Wi-Fi')),
(19, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Laundry')),
(19, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Secure Parking')),
(19, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Security')),
(20, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Wi-Fi')),
(20, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Laundry')),
(20, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Secure Parking')),
(20, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Braai Facilities')),
(20, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Security')),
(21, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Wi-Fi')),
(21, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Laundry')),
(21, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Security')),
(22, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Wi-Fi')),
(22, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Security')),
(23, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Wi-Fi')),
(23, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Laundry')),
(23, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Secure Parking')),
(23, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Braai Facilities')),
(23, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Security')),
(24, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Wi-Fi')),
(24, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Laundry')),
(24, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Secure Parking')),
(24, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Security')),
(25, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Wi-Fi')),
(25, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Laundry')),
(25, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Secure Parking')),
(25, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Braai Facilities')),
(25, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Security')),
(26, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Wi-Fi')),
(26, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Laundry')),
(26, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Secure Parking')),
(26, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Security')),
(27, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Wi-Fi')),
(27, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Laundry')),
(27, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Secure Parking')),
(27, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Braai Facilities')),
(27, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Security')),
(28, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Wi-Fi')),
(28, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Laundry')),
(28, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Secure Parking')),
(28, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Braai Facilities')),
(28, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Security')),
(29, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Wi-Fi')),
(29, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Laundry')),
(29, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Secure Parking')),
(29, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Security')),
(30, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Wi-Fi')),
(30, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Laundry')),
(30, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Secure Parking')),
(30, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Braai Facilities')),
(30, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Security')),
(31, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Wi-Fi')),
(31, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Laundry')),
(31, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Secure Parking')),
(31, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Braai Facilities')),
(31, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Security')),
(32, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Wi-Fi')),
(32, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Laundry')),
(32, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Secure Parking')),
(32, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Security')),
(33, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Wi-Fi')),
(33, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Laundry')),
(33, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Secure Parking')),
(33, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Braai Facilities')),
(33, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Security')),
(34, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Wi-Fi')),
(34, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Laundry')),
(34, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Security')),
(35, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Wi-Fi')),
(35, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Secure Parking')),
(35, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Braai Facilities')),
(35, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Security')),
(36, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Wi-Fi')),
(36, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Laundry')),
(36, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Secure Parking')),
(36, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Braai Facilities')),
(36, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Security')),
(37, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Wi-Fi')),
(37, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Laundry')),
(37, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Secure Parking')),
(37, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Security')),
(38, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Wi-Fi')),
(38, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Laundry')),
(38, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Secure Parking')),
(38, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Braai Facilities')),
(38, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Security')),
(39, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Wi-Fi')),
(39, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Laundry')),
(39, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Secure Parking')),
(39, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Braai Facilities')),
(39, (SELECT AmenityID FROM dbo.Amenities WHERE AmenityName = N'Security'));

-- A few useful queries to test the database

-- 1. Show all accommodation with suburb, type and rent
SELECT p.PropertyName, l.LocationName, t.TypeName, p.MonthlyRent, p.IsNSFASApproved
FROM dbo.Properties p
JOIN dbo.Locations l ON p.LocationID = l.LocationID
JOIN dbo.AccommodationTypes t ON p.TypeID = t.TypeID
ORDER BY p.MonthlyRent;

-- 2. Find NSFAS-approved rooms under R3,500
SELECT p.PropertyName, l.LocationName, p.MonthlyRent
FROM dbo.Properties p
JOIN dbo.Locations l ON p.LocationID = l.LocationID
WHERE p.IsNSFASApproved = 1 AND p.MonthlyRent < 3500
ORDER BY p.MonthlyRent;

-- 3. Show the facilities for each property
SELECT p.PropertyName, a.AmenityName
FROM dbo.Properties p
JOIN dbo.PropertyAmenities pa ON p.PropertyID = pa.PropertyID
JOIN dbo.Amenities a ON pa.AmenityID = a.AmenityID
ORDER BY p.PropertyName, a.AmenityName;

-- 4. Count the number of listings in each suburb
SELECT l.LocationName, COUNT(*) AS NumberOfProperties
FROM dbo.Properties p
JOIN dbo.Locations l ON p.LocationID = l.LocationID
GROUP BY l.LocationName
ORDER BY NumberOfProperties DESC;
GO