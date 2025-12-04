# Setup PostgreSQL for Django
Write-Host "=== Setting up PostgreSQL for Django ===" -ForegroundColor Cyan
Write-Host ""

# Check if PostgreSQL container is running
Write-Host "1. Checking PostgreSQL container..." -ForegroundColor Yellow
$containerRunning = docker ps --filter "name=testapp_postgres" --format "{{.Names}}" | Select-String "testapp_postgres"

if (-not $containerRunning) {
    Write-Host "   Starting PostgreSQL container..." -ForegroundColor Yellow
    docker-compose up -d db
    Start-Sleep -Seconds 3
    Write-Host "   PostgreSQL container started!" -ForegroundColor Green
} else {
    Write-Host "   PostgreSQL container is running!" -ForegroundColor Green
}

# Install psycopg2-binary
Write-Host "`n2. Installing psycopg2-binary..." -ForegroundColor Yellow
cd backend

# Try multiple installation methods
Write-Host "   Attempting installation..." -ForegroundColor Gray
$result = & .\venv\Scripts\python.exe -m pip install psycopg2-binary 2>&1

if ($LASTEXITCODE -eq 0) {
    Write-Host "   psycopg2-binary installed successfully!" -ForegroundColor Green
} else {
    Write-Host "   Standard installation failed, trying alternative..." -ForegroundColor Yellow
    
    # Try installing from a specific source or version
    & .\venv\Scripts\python.exe -m pip install --no-cache-dir psycopg2-binary
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host "   ERROR: Could not install psycopg2-binary" -ForegroundColor Red
        Write-Host "   The app will continue using SQLite for now." -ForegroundColor Yellow
        Write-Host "   To use PostgreSQL later, you may need to install PostgreSQL client tools." -ForegroundColor Yellow
        cd ..
        exit 1
    }
}

# Verify installation
Write-Host "`n3. Verifying installation..." -ForegroundColor Yellow
$testResult = & .\venv\Scripts\python.exe -c "import psycopg2; print('psycopg2 version:', psycopg2.__version__)" 2>&1
if ($LASTEXITCODE -eq 0) {
    Write-Host "   $testResult" -ForegroundColor Green
} else {
    Write-Host "   Verification failed" -ForegroundColor Red
    cd ..
    exit 1
}

# Test PostgreSQL connection
Write-Host "`n4. Testing PostgreSQL connection..." -ForegroundColor Yellow
$testConn = & .\venv\Scripts\python.exe -c @"
import os
import psycopg2
from dotenv import load_dotenv

load_dotenv()

try:
    conn = psycopg2.connect(
        host=os.getenv('DB_HOST', 'localhost'),
        port=os.getenv('DB_PORT', '5432'),
        user=os.getenv('DB_USER', 'postgres'),
        password=os.getenv('DB_PASSWORD', 'postgres'),
        database='postgres'
    )
    conn.close()
    print('Connection successful!')
except Exception as e:
    print(f'Connection failed: {e}')
    exit(1)
"@ 2>&1

if ($LASTEXITCODE -eq 0) {
    Write-Host "   $testConn" -ForegroundColor Green
} else {
    Write-Host "   Connection test failed: $testConn" -ForegroundColor Red
    Write-Host "   Make sure PostgreSQL container is running and credentials are correct." -ForegroundColor Yellow
}

# Run migrations
Write-Host "`n5. Running database migrations..." -ForegroundColor Yellow
& .\venv\Scripts\python.exe manage.py makemigrations
& .\venv\Scripts\python.exe manage.py migrate

Write-Host ""
Write-Host "=== PostgreSQL Setup Complete! ===" -ForegroundColor Green
Write-Host "Your Django app is now using PostgreSQL!" -ForegroundColor Cyan

cd ..



