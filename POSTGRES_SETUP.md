# PostgreSQL Setup Guide

## Quick Setup

Run the setup script:
```powershell
.\fix-postgres.ps1
```

## Manual Setup

### 1. Ensure PostgreSQL Container is Running

```powershell
docker-compose up -d db
```

Check if it's running:
```powershell
docker ps
```

### 2. Install PostgreSQL Adapter

The app needs `psycopg2-binary` to connect to PostgreSQL. Try these methods in order:

#### Method 1: Standard Installation
```powershell
cd backend
.\venv\Scripts\Activate.ps1
pip install psycopg2-binary
```

#### Method 2: If Method 1 Fails - Install from Wheel
```powershell
cd backend
.\venv\Scripts\Activate.ps1
pip install --only-binary=:all: psycopg2-binary
```

#### Method 3: Alternative - Use psycopg (v3)
```powershell
cd backend
.\venv\Scripts\Activate.ps1
pip install psycopg[binary]
```

**Note:** If using psycopg v3, you'll need to update Django settings to use it.

### 3. Verify Installation

Test if psycopg2 is installed:
```powershell
cd backend
.\venv\Scripts\python.exe -c "import psycopg2; print('Success!')"
```

### 4. Create Database

The database should be created automatically by Docker Compose, but you can verify:

```powershell
cd backend
.\venv\Scripts\python.exe test-postgres.py
```

This script will:
- Check if psycopg2 is installed
- Test PostgreSQL connection
- Create the database if it doesn't exist

### 5. Run Migrations

```powershell
cd backend
.\venv\Scripts\Activate.ps1
python manage.py makemigrations
python manage.py migrate
```

### 6. Verify Configuration

Check your `.env` file in `backend/` directory:
```env
DB_NAME=testapp_db
DB_USER=postgres
DB_PASSWORD=postgres
DB_HOST=localhost
DB_PORT=5432
```

## Troubleshooting

### Issue: psycopg2-binary installation fails

**Solution 1:** Install PostgreSQL client tools
- Download from: https://www.postgresql.org/download/windows/
- Or use: `choco install postgresql` (if you have Chocolatey)

**Solution 2:** Use SQLite temporarily
- The app will automatically fall back to SQLite if psycopg2 is not available
- You can switch to PostgreSQL later

**Solution 3:** Use a pre-built wheel
- Download a compatible wheel from: https://www.lfd.uci.edu/~gohlke/pythonlibs/#psycopg
- Install with: `pip install path/to/wheel_file.whl`

### Issue: Connection refused

**Check:**
1. PostgreSQL container is running: `docker ps`
2. Port 5432 is accessible: `Test-NetConnection localhost -Port 5432`
3. Credentials in `.env` match Docker Compose settings

### Issue: Database doesn't exist

The database should be created automatically by Docker Compose. If not:

```powershell
docker exec -it testapp_postgres psql -U postgres -c "CREATE DATABASE testapp_db;"
```

## Current Status

Your Django settings are configured to:
1. Try PostgreSQL first (if psycopg2 is available)
2. Fall back to SQLite automatically (if psycopg2 is not available)

This means the app will work even without PostgreSQL, but you'll get better performance and features with PostgreSQL.



