# Backend Setup Script
# This script helps set up the Django backend

# Refresh PATH
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

Write-Host "=== Django Backend Setup ===" -ForegroundColor Cyan
Write-Host ""

# Check if we're in the right directory
if (-not (Test-Path "backend\manage.py")) {
    Write-Host "Error: Please run this script from the project root directory" -ForegroundColor Red
    exit 1
}

# Navigate to backend
Set-Location backend

# Create virtual environment if it doesn't exist
if (-not (Test-Path "venv")) {
    Write-Host "1. Creating virtual environment..." -ForegroundColor Yellow
    python -m venv venv
}

# Activate virtual environment
Write-Host "2. Activating virtual environment..." -ForegroundColor Yellow
.\venv\Scripts\Activate.ps1

# Upgrade pip
Write-Host "3. Upgrading pip..." -ForegroundColor Yellow
python -m pip install --upgrade pip

# Install dependencies
Write-Host "4. Installing Python dependencies..." -ForegroundColor Yellow
# Try installing with psycopg2-binary first, fall back to dev requirements if it fails
pip install -r requirements.txt 2>&1 | Out-Null
if ($LASTEXITCODE -ne 0) {
    Write-Host "   psycopg2-binary installation failed, using SQLite instead..." -ForegroundColor Yellow
    pip install -r requirements-dev.txt
    Write-Host "   Note: Using SQLite for development. PostgreSQL can be configured later." -ForegroundColor Cyan
} else {
    Write-Host "   All dependencies installed successfully!" -ForegroundColor Green
}

if ($LASTEXITCODE -ne 0) {
    Write-Host "Error installing dependencies" -ForegroundColor Red
    exit 1
}

# Check if .env file exists
if (-not (Test-Path ".env")) {
    Write-Host "`n5. Creating .env file..." -ForegroundColor Yellow
    @"
SECRET_KEY=django-insecure-change-this-in-production-12345
DEBUG=True
DB_NAME=testapp_db
DB_USER=postgres
DB_PASSWORD=postgres
DB_HOST=localhost
DB_PORT=5432
"@ | Out-File -FilePath ".env" -Encoding utf8
    Write-Host "Created .env file with default values" -ForegroundColor Green
} else {
    Write-Host "`n2. .env file already exists, skipping..." -ForegroundColor Gray
}

# Make migrations
Write-Host "`n6. Creating database migrations..." -ForegroundColor Yellow
python manage.py makemigrations

# Run migrations
Write-Host "`n7. Running database migrations..." -ForegroundColor Yellow
python manage.py migrate

Write-Host "`n=== Setup Complete! ===" -ForegroundColor Green
Write-Host "`nTo start the Django server, run:" -ForegroundColor Cyan
Write-Host "  .\start-django.ps1" -ForegroundColor White
Write-Host "`nOr manually:" -ForegroundColor Gray
Write-Host "  cd backend" -ForegroundColor White
Write-Host "  .\venv\Scripts\Activate.ps1" -ForegroundColor White
Write-Host "  python manage.py runserver" -ForegroundColor White

Set-Location ..

