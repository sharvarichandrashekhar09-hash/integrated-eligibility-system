# Integrated Eligibility System (IES)

## Overview

The Integrated Eligibility System (IES) is a web-based application developed to provide a centralized platform for managing applications and eligibility for multiple government benefit programs.

The system provides separate workflows for applicants, caseworkers, and administrators. Applicants can register, apply for benefit programs, upload documents, and track their applications. Caseworkers can review and verify applications, while administrators can manage users, benefits, allocations, and reports.

## Key Features

### Applicant Module
- User registration and login
- Apply for benefit programs
- Upload required documents
- Track application status
- Online payment functionality
- Application receipt generation

### Caseworker Module
- Review applications
- Verify applicant documents
- Approve or reject applications
- Manage application verification workflow

### Admin Module
- Admin dashboard
- Manage user accounts
- Manage benefit programs
- Monitor benefit allocations
- Manage benefit distribution
- View applications and reports

## Benefit Programs

The system includes the following benefit programs:

- SNAP – Supplemental Nutrition Assistance Program
- CCAP – Child Care Assistance Program
- RIW – Refugee Integration and Welfare
- Medicaid
- Medicare
- QHP – Qualified Health Plan

## Technologies Used

### Frontend
- HTML
- CSS
- JavaScript
- JSP

### Backend
- Java
- Java Servlets
- JDBC

### Database
- MySQL

### Server
- Apache Tomcat

### Additional Technologies
- JavaMail API
- Razorpay Payment Gateway
- Maven

## Project Modules

- Authentication and Registration
- Applicant Management
- Caseworker Management
- Admin Management
- Benefit Program Management
- Document Upload and Verification
- Application Processing
- Payment Management
- Application Tracking
- Benefit Distribution
- Reports

## System Workflow

1. Applicant registers and logs into the system.
2. Applicant selects a benefit program.
3. Applicant submits the application and required documents.
4. Caseworker reviews and verifies the application.
5. The application is approved or rejected based on verification.
6. Approved applications proceed through the relevant benefit and payment workflow.
7. Administrators monitor applications, allocations, distributions, and reports.

## Database

MySQL is used to manage application data, including:

- User information
- Applicant details
- Benefit applications
- Document information
- Application status
- Payment information
- Benefit allocation and distribution data

## Project Structure

```text
integrated-eligibility-system/
│
├── src/
│   └── main/
│       ├── java/
│       │   └── com/
│       │       └── eligibility/
│       │           ├── servlet/
│       │           └── util/
│       │
│       └── webapp/
│           ├── WEB-INF/
│           ├── JSP pages
│           ├── CSS
│           └── JavaScript
│
├── pom.xml
├── README.md
└── .gitignore
How to Run
Prerequisites

Install the following:

JDK
Eclipse IDE
Apache Tomcat 9
MySQL Server
MySQL Workbench
Maven
Setup
Clone the repository.
Import the project into Eclipse as an existing Maven project.
Create and configure the required MySQL database.
Update the local database configuration according to your environment.
Configure Apache Tomcat 9 in Eclipse.
Add the project to the Tomcat server.
Configure the email environment variable if email functionality is required.
Start the Tomcat server.
Open the application in your browser.
Security

Sensitive information such as:

Database passwords
Email app passwords
API keys
Payment gateway credentials

should be stored in local environment variables or configuration files and should not be committed to the repository.

Future Scope
Enhanced role-based access control
Improved reporting and analytics
REST API integration
Cloud deployment
Automated eligibility verification
Improved application security
Mobile application support
Developed By

Sharvari Somvanshi

MCA Graduate
Sinhgad Institute of Management, Pune
Savitribai Phule Pune University

GitHub

Integrated Eligibility System
