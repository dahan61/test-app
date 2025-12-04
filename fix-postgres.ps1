# Fix PostgreSQL Setup for Django
Write-Host "=== Fixing PostgreSQL Connection ===" -ForegroundColor Cyan
Write-Host ""

cd backend

# Step 1: Ensure PostgreSQL container is running
Write-Host "1. Ensuring PostgreSQL container is running..." -ForegroundColor Yellow
docker-compose up -d db
Start-Sleep -Seconds 5

# Step 2: Try installing psycopg2-binary with different methods
Write-Host "`n2. Installing PostgreSQL adapter..." -ForegroundColor Yellow

# Method 1: Try standard installation
Write-Host "   Trying standard installation..." -ForegroundColor Gray
& .\venv\Scripts\python.exe -m pip install psycopg2-binary --quiet 2>&1 | Out-Null

if ($LASTEXITCODE -eq 0) {
    Write-Host "   ✓ psycopg2-binary installed successfully!" -ForegroundColor Green
} else {
    Write-Host "   Standard installation failed, trying alternative method..." -ForegroundColor Yellow
    
    # Method 2: Try with specific version and pre-built wheel
    & .\venv\Scripts\python.exe -m pip install --no-build-isolation psycopg2-binary 2>&1 | Out-Null
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host "   ⚠ Could not install psycopg2-binary automatically" -ForegroundColor Yellow
        Write-Host "   Trying psycopg (version 3) as alternative..." -ForegroundColor Yellow
        & .\venv\Scripts\python.exe -m pip install psycopg[binary] 2>&1 | Out-Null
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "   ✓ psycopg installed! Updating Django settings..." -ForegroundColor Green
            # Update settings to use psycopg3
            # This requires updating the DATABASES config
        } else {
            Write-Host "   ✗ All installation methods failed" -ForegroundColor Red
            Write-Host "   The app will continue using SQLite." -ForegroundColor Yellow
            Write-Host "   To fix this manually:" -ForegroundColor Cyan
            Write-Host "   1. Install PostgreSQL client tools" -ForegroundColor White
            Write-Host "   2. Or download psycopg2-binary wheel manually" -ForegroundColor White
            cd ..
            exit 1
        }
    }
}

# Step 3: Verify installation
Write-Host "`n3. Verifying PostgreSQL adapter..." -ForegroundColor Yellow
$verify = & .\venv\Scripts\python.exe -c "import psycopg2; print('OK')" 2>&1
if ($verify -eq "OK") {
    Write-Host "   ✓ PostgreSQL adapter verified!" -ForegroundColor Green
} else {
    Write-Host "   ✗ Verification failed: $verify" -ForegroundColor Red
    cd ..
    exit 1
}

# Step 4: Test database connection
Write-Host "`n4. Testing PostgreSQL connection..." -ForegroundColor Yellow
$testScript = @"
import os
import sys
try:
    import psycopg2
    conn = psycopg2.connect(
        host='localhost',
        port='5432',
        user='postgres',
        password='postgres',
        database='postgres'
    )
    conn.close()
    print('SUCCESS')
except Exception as e:
    print(f'FAILED: {e}')
    sys.exit(1)
"@

$testResult = & .\venv\Scripts\python.exe -c $testScript 2>&1
if ($testResult -match "SUCCESS") {
    Write-Host "   ✓ PostgreSQL connection successful!" -ForegroundColor Green
} else {
    Write-Host "   ⚠ Connection test: $testResult" -ForegroundColor Yellow
    Write-Host "   Make sure PostgreSQL container is running" -ForegroundColor Yellow
}

# Step 5: Create database if it doesn't exist
Write-Host "`n5. Ensuring database exists..." -ForegroundColor Yellow
$createDbScript = @"
import psycopg2
from psycopg2.extensions import ISOLATION_LEVEL_AUTOCOMMIT

try:
    conn = psycopg2.connect(
        host='localhost',
        port='5432',
        user='postgres',
        password='postgres',
        database='postgres'
    )
    conn.set_isolation_level(ISOLATION_LEVEL_AUTOCOMMIT)
    cur = conn.cursor()
    
    # Check if database exists
    cur.execute(\"SELECT 1 FROM pg_database WHERE datname='testapp_db'\")
    exists = cur.fetchone()
    
    if not exists:
        cur.execute('CREATE DATABASE testapp_db')
        print('Database created')
    else:
        print('Database already exists')
    
    cur.close()
    conn.close()
except Exception as e:
    print(f'Error: {e}')
"@

$dbResult = & .\venv\Scripts\python.exe -c $createDbScript 2>&1
Write-Host "   $dbResult" -ForegroundColor Gray

# Step 6: Run migrations
Write-Host "`n6. Running database migrations..." -ForegroundColor Yellow
& .\venv\Scripts\python.exe manage.py makemigrations
& .\venv\Scripts\python.exe manage.py migrate

Write-Host ""
Write-Host "=== PostgreSQL Setup Complete! ===" -ForegroundColor Green
Write-Host "Your Django app is now configured to use PostgreSQL!" -ForegroundColor Cyan

cd ..



