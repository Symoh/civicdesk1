CivicDesk — Citizen Service Request Management System
1. Project Overview
CivicDesk is a web-based citizen service request management system designed to help citizens submit service-related complaints and reports while allowing administrators to review requests, update their status, and track progress.
The system provides a centralized platform for managing citizen requests, maintaining accountability, and improving communication between citizens and the responsible administration.
2.Key Features

Citizen Features
Submit service requests and complaints.
Provide request descriptions, categories, and locations.
Upload supporting images or evidence, where enabled.
Track submitted requests and their status, where implemented.
Receive a reference number for submitted requests, where implemented.

Administrator Features
Secure administrator login.
View submitted service requests.
View citizen details and request evidence.
Update request statuses.
Add administrator notes and record action taken.
View dashboard statistics.
Maintain request status history.
Prioritize pending requests in the dashboard.
Record the administrator responsible for a status change.

Security Features
Session-based authentication.
Administrator-role access checks.
CSRF token validation for request updates.
Prepared SQL statements.
HTML output escaping.
Database transactions for status updates and history records.
Session cookie security settings.
No-cache headers for sensitive pages.

3. Technology Stack

Frontend: HTML5, CSS3
Backend: PHP
Database: MySQL 
Database Access: PHP PDO
Web Server: Apache or another PHP-compatible web server

4. Project Structure
The project may contain the following files and directories:
CivicDesk/
├── admin.php
├── config.php
├── index.php
├── login.php
├── logout.php
├── register.php
├── submit_request.php
├── request_history.php
├── assets/
│   └── style.css
├── uploads/
└── README.md

5. Requirements
Before installing CivicDesk, ensure that you have:
PHP with PDO MySQL support enabled.
MySQL or MariaDB.
Apache or another compatible web server.
A modern web browser.
A database and user account configured for the application.
PHP extensions such as mbstring may also be required by the current code.

6. Installation and Configuration
Step 1: Place the Project Files
Copy the CivicDesk project folder into your web server's document root.
For example, with XAMPP:
C:\xampp\htdocs\CivicDesk\
Step 2: Create the Database
Open phpMyAdmin or your preferred MySQL administration tool.
Create a database for CivicDesk, using the name configured in your application.
For example:
CREATE DATABASE civicdesk
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;
Import the project's database schema or SQL backup if one is available.
The schema must include the tables and columns used by the application.
Step 3: Configure Database Access
Open config.php and verify that the PDO connection uses your actual database credentials.
A typical connection looks like this:
<?php
$host = 'localhost';
$dbname = 'civicdesk';
$username = 'your_database_user';
$password = 'your_database_password';

$pdo = new PDO(
    "mysql:host=$host;dbname=$dbname;charset=utf8mb4",
    $username,
    $password,
    [
        PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
        PDO::ATTR_EMULATE_PREPARES => false,
    ]
);
Step 4: Configure Uploads
If image uploads are enabled:
Ensure the upload directory exists.
Configure appropriate directory permissions.
Validate file types, file sizes, and file contents on the server.
Generate safe server-side filenames.
Prevent uploaded scripts from being executed.
Store and display only validated file paths.
Step 5: Configure Administrator Access
Ensure that the login