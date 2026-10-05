# Integrated Eligibility System (IES)

## Overview

The Integrated Eligibility System (IES) is a web-based application developed to provide a centralized platform for managing eligibility and applications for government benefit programs.

The system allows applicants to register, apply for benefit programs, upload required documents, track application status, and complete online payments. Caseworkers can review applications and verify documents, while administrators can manage users, benefits, allocations, and reports.

## Key Features

### Applicant

- User registration and login
- Apply for benefit programs
- Upload required documents
- Track application status
- Online payment integration
- Application receipt generation

### Caseworker

- Review applicant applications
- Verify submitted documents
- Approve or reject applications
- Manage the verification workflow

### Administrator

- Admin dashboard
- Manage user accounts
- Manage benefit programs
- Monitor government allocations
- Manage benefit distribution
- View applications and reports

## Benefit Programs

The system supports the following benefit programs:

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
- Servlets
- JDBC

### Database

- MySQL

### Server

- Apache Tomcat

### Other Technologies

- JavaMail API
- Razorpay Payment Gateway

## Project Modules

- Authentication & Registration
- Applicant Management
- Caseworker Management
- Admin Management
- Benefit Program Management
- Document Upload & Verification
- Application Processing
- Payment Management
- Application Tracking
- Benefit Distribution
- Reports

## System Workflow

1. Applicant registers and logs into the system.
2. Applicant selects an eligible benefit program.
3. Applicant submits the application and required documents.
4. Caseworker reviews and verifies the application.
5. The application is approved or rejected based on verification.
6. Approved applicants proceed through the benefit/payment workflow.
7. Administrators monitor applications, allocations, distributions, and reports.

## Database

The application uses MySQL for storing:

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
│           ├── *.jsp
│           ├── css/
│           └── js/
│
├── pom.xml
├── README.md
└── .gitignore
How to Run
Prerequisites

Make sure the following are installed:

Java JDK
Apache Tomcat
MySQL Server
MySQL Workbench
Eclipse IDE or another compatible Java IDE
Maven
Setup
Clone the repository.
Import the project into your IDE.
Create the required MySQL database.
Configure the database connection for your local environment.
Configure Apache Tomcat.
Configure the email environment variable if email functionality is required.
Deploy the application on Tomcat.
Start the server and open the application in your browser.
Project Objective

The main objective of the Integrated Eligibility System is to simplify the management of multiple benefit programs through a centralized web application while improving application processing, document verification, tracking, payment processing, and administrative management.

Future Scope
Role-based access control improvements
Enhanced reporting and analytics
Improved application security
Cloud deployment
REST API integration
Mobile application support
Automated eligibility verification
Developed By

Sharvari Somvanshi

MCA Project
Sinhgad Institute of Management, Pune
Savitribai Phule Pune University