# Student Choice CRM

A full-stack CRM portfolio project for demonstrating student-consultancy workflows. It includes lead and call management, follow-ups, role-based access, reporting, and finance-process tracking.

> **Demo and privacy notice:** The SQL seed records and CSV examples are fictional. Use only synthetic records in screenshots and public demos. Never commit customer information, production database exports, credentials, or real phone numbers. Use a disposable local database for the demo setup below.

## Features

- Lead pipeline and CSV import
- Call management, follow-ups, and call outcomes
- User roles and permissions
- Sanction, PF update, disbursement, and cross-sales workflows
- Team and report views

## Tech stack

- **Frontend:** React, Vite, Bootstrap, React Router
- **Backend:** Node.js, Express
- **Database:** MySQL
- **Authentication:** JWT

## Repository structure

```text
backend/       Express API and database scripts
database/      Base schema, lead/call migrations, and fictional demo records
frontend/      React application
```

## Local demo setup

### Prerequisites

- Node.js and npm
- MySQL

### 1. Configure the backend

From the repository root, copy the example environment file:

```powershell
Copy-Item backend\.env.example backend\.env
```

Edit `backend\.env` and set your local MySQL credentials, a unique `JWT_SECRET`, and a unique `DEMO_ADMIN_PASSWORD` of at least 16 characters. Keep `.env` files private; only `.env.example` files belong in Git.

### 2. Create the local database

Run these commands from the repository root in Windows PowerShell. They use a local MySQL account and prompt for its password:

```powershell
cmd /c "mysql -u root -p < database\schema.sql"
cmd /c "mysql -u root -p < database\lead_migration.sql"
cmd /c "mysql -u root -p < database\call_migration.sql"
```

The base schema creates the database, roles, permissions, and users. The lead and call SQL files add their table structures. To populate the database with fictional sample records for local UI testing, run:

```powershell
cmd /c "mysql -u root -p < database\demo_data.sql"
```

The demo seed uses clearly fictional names, `example.com` email addresses, and reserved `202-555-01xx` phone numbers. It can be re-run without adding the same sample lead or call again.

**Important:** These SQL files and legacy migration scripts are for local demonstration, not production deployment or sanitizing an existing database. Do not run them against a live or customer database. In particular, `backend\src\scripts\migrate-normalized-tables.js` drops and recreates tables; do not run it on a database containing data you need.

### 3. Install and start the backend

```powershell
Set-Location backend
npm install
npm run seed
npm run dev
```

`npm run seed` creates the local demo administrator using the password in `backend\.env`. The login email is `demo.admin@example.com`; the password is the private value you set in `DEMO_ADMIN_PASSWORD`.

### 4. Install and start the frontend

In a second terminal, from the repository root:

```powershell
Copy-Item frontend\.env.example frontend\.env
Set-Location frontend
npm install
npm run dev
```

Open `http://localhost:3000`. The frontend API URL defaults to `http://localhost:5000/api/v1`, matching the backend's default port. If you change the backend port, update `VITE_API_URL` in `frontend\.env`.

## API overview

API routes are served under `/api/v1`. Main route groups include:

- `/auth`, `/users`, `/roles`
- `/leads`, `/calls`
- `/file-updates`, `/sanctions`, `/pf-updates`
- `/disbursements`, `/cross-sales`, `/reports`
- `/health` for the API health response

## Verification scripts

The backend includes targeted lead and call verification scripts. Run them only against your local demo database because they create and remove test records:

```powershell
Set-Location backend
npm run verify:leads
npm run verify:calls
```

Both scripts use the `DEMO_ADMIN_PASSWORD` configured in `backend\.env`.

## Screenshots and public demo

No customer or business records should appear in screenshots or hosted demos. Sign in to your local instance with the fictional demo data, review every visible field, and capture screenshots only after confirming that all displayed records are synthetic. Do not publish demo credentials for a publicly accessible deployment.
