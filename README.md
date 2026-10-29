# Polokwane Student Living

## 1. Project Overview

Polokwane Student Living is a student accommodation website designed to help students find accommodation in and around Polokwane. The system aims to make it easier for students to explore properties, view accommodation details, and submit booking requests or enquiries.

This project is being developed as part of the Software Design and Engineering group project.

## 2. Project Objectives

The main objectives of the project are to:

- Provide a website where students can explore accommodation options.
- Display property information, including locations, rental prices and available facilities.
- Allow students to submit booking requests and enquiries.
- Store and manage accommodation-related information in a database.
- Connect the website to a backend that processes requests and communicates with the database.
- Provide a user-friendly and organised way to access student accommodation information.

## 3. Technologies Used

| Technology | Purpose |
|---|---|
| HTML | Creates the structure of the website. |
| CSS | Controls the website's appearance and layout. |
| JavaScript | Adds interactive features and sends requests to the backend. |
| Node.js | Runs the JavaScript backend. |
| Express.js | Handles website requests through API routes. |
| Microsoft SQL Server | Stores and manages project data. |
| `mssql` | Allows the Node.js application to communicate with SQL Server. |
| `dotenv` | Loads database configuration from environment variables. |
| GitHub | Stores the source code and supports collaboration between group members. |

## 4. Main System Components

### Front End

The front end is the part of the website that users see and interact with. It uses HTML, CSS and JavaScript to display accommodation information and provide forms for booking requests and enquiries.

### Back End

The backend uses Node.js and Express.js to receive requests from the website, validate submitted information, communicate with SQL Server and return responses to the front end.

### Database

The project uses Microsoft SQL Server to store and organise information. The database is called `PolokwaneStudentLiving`.

The database schema includes the following tables:

| Table | Purpose |
|---|---|
| `Locations` | Stores accommodation location information. |
| `AccommodationTypes` | Stores different types of accommodation. |
| `Properties` | Stores property details. |
| `Amenities` | Stores accommodation facilities. |
| `PropertyAmenities` | Connects properties with their amenities. |
| `Students` | Stores student information where required. |
| `Bookings` | Stores booking requests. |
| `Enquiries` | Stores enquiries submitted by users. |
| `Favorites` | Supports saving favourite properties. |

The actual database relationships and available fields are defined in the SQL setup script.

## 5. How the System Works

The expected system flow is:

1. A student opens the Polokwane Student Living website.
2. The website displays accommodation information and available forms.
3. JavaScript sends a request to the backend when information is needed or a form is submitted.
4. Express.js receives the request and processes it.
5. The backend communicates with SQL Server to retrieve or save information.
6. The backend returns a response to the website.
7. The website displays the relevant information or a confirmation message.

**Important:** Each feature must be implemented and tested before it can be considered fully functional.

## 6. Project Requirements

Before running the project, ensure that you have:

- [ ] Node.js and npm installed.
- [ ] Microsoft SQL Server installed or access to a reachable SQL Server instance.
- [ ] SQL Server Management Studio (SSMS), or another suitable database management tool.
- [ ] The project source code downloaded or cloned from GitHub.
- [ ] The project database created using the supplied SQL setup script.
- [ ] A configured `.env` file containing the correct database connection settings.

## 7. Installation and Setup

### Step 1: Clone the repository

Open a terminal and run:

```bash
git clone YOUR_GITHUB_REPOSITORY_URL
```

Replace `YOUR_GITHUB_REPOSITORY_URL` with the actual URL of the group's GitHub repository.

Move into the project directory:

```bash
cd YOUR_PROJECT_FOLDER
```

### Step 2: Install the required packages

If the project uses Express.js, SQL Server and dotenv, install the dependencies with:

```bash
npm install
```

If the project does not yet contain a `package.json` file, initialise it and install the required packages:

```bash
npm init -y
npm install express mssql dotenv
```

### Step 3: Create the database

1. Open SQL Server Management Studio.
2. Connect to the appropriate SQL Server instance.
3. Open the project's SQL setup script.
4. Review the script before executing it.
5. Execute the script to create the database tables and any sample data included in it.
6. Confirm that the `PolokwaneStudentLiving` database and its tables exist.

**Warning:** If the setup script drops and recreates existing tables, running it again may erase existing data. Only run such scripts when you intend to rebuild the development database.

### Step 4: Configure the environment variables

Create a file named `.env` in the project root directory.

Example configuration:

```env
DB_SERVER=localhost
DB_DATABASE=PolokwaneStudentLiving
DB_USER=student_app
DB_PASSWORD=replace_with_your_password
DB_PORT=1433
PORT=3000
```

Replace the example values with the correct settings for your SQL Server instance.

The database login must exist, have permission to access the project database, and use an authentication method supported by the SQL Server configuration.

If your project uses Windows Authentication instead, follow the integrated-authentication configuration supported by your Node.js database driver rather than using the SQL login example above.

### Step 5: Protect sensitive information

Create or update the `.gitignore` file in the project root:

```gitignore
.env
.env.*
!.env.example
node_modules/
```

Never upload actual database passwords or other private credentials to GitHub.

You may provide an `.env.example` file containing placeholder values to help other group members configure their own environments.

### Step 6: Run the application

Start the backend using the command that matches your project's configuration.

For example, if `server.js` is the backend entry point:

```bash
node server.js
```

If a start script is configured in `package.json`, you may instead run:

```bash
npm start
```

Use the address and port printed by the application to open the website, provided the front end is served by the backend or configured to run separately.

## 8. API Routes

The planned API routes include:

| Method | Endpoint | Purpose |
|---|---|---|
| GET | `/api/properties` | Retrieves property listings. |
| POST | `/api/enquiries` | Submits an enquiry. |
| POST | `/api/bookings` | Submits a booking request. |

These routes must be implemented in the Express backend and connected to the appropriate database queries before they will work as intended.

## 9. Testing

The group should test the following areas:

- **Website testing:** Check that pages, navigation, forms and buttons behave correctly.
- **Property testing:** Confirm that the correct property records are retrieved and displayed.
- **Booking testing:** Submit valid and invalid booking details and verify the backend response.
- **Enquiry testing:** Check that submitted enquiries are validated and stored correctly.
- **Database testing:** Confirm that queries return the expected information and records are saved in the correct tables.
- **Error handling:** Test missing fields, invalid input and database connection failures.
- **Integration testing:** Verify that the front end, backend and database work together.

## 10. Security Considerations

The project should follow these security practices:

- Keep database credentials out of front-end code and public repositories.
- Validate all submitted information on the server.
- Use parameterised SQL queries to reduce the risk of SQL injection.
- Give the application database account only the permissions it needs.
- Avoid displaying database credentials or sensitive internal errors to users.
- Store only the personal information required by the application.

## 11. Group Collaboration

GitHub is used to share source code and track changes made by group members.

To contribute to the project:

1. Clone the repository.
2. Configure the local database and environment variables.
3. Make changes in the relevant project files.
4. Test the changes before committing them.
5. Commit and push changes according to the group's agreed workflow.
6. Communicate with other group members to avoid conflicting changes.

Each group member may need their own local database configuration. Using GitHub does not automatically share a running SQL Server database.

## 12. Limitations and Future Improvements

Possible future improvements include:

- Adding more accommodation listings and detailed property information.
- Improving property search and filtering.
- Adding student registration and login functionality.
- Improving booking status management.
- Adding stronger input validation and user-friendly error messages.
- Deploying the front end and backend to suitable hosting services.
- Connecting the hosted backend to a securely configured, accessible database.

These improvements should only be described as completed features once they have been implemented and tested.

## 13. Conclusion

Polokwane Student Living aims to provide a convenient platform for students searching for accommodation in Polokwane. The project combines web technologies with a backend application and a relational database to manage property information, booking requests and enquiries.

The project also provides an opportunity to apply software engineering concepts such as database design, application development, system integration, testing, security and collaborative version control.

---

**Project:** Polokwane Student Living  
**Course:** Software Design and Engineering  
**Group:** Group 5  
**Repository:** Add the group's GitHub repository URL here.
