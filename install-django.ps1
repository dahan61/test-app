# Install Django in Virtual Environment
Write-Host "=== Installing Django in Virtual Environment ===" -ForegroundColor Cyan
Write-Host ""

cd backend

if (-not (Test-Path "venv\Scripts\python.exe")) {
    Write-Host "ERROR: Virtual environment not found!" -ForegroundColor Red
    Write-Host "Creating virtual environment..." -ForegroundColor Yellow
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
    python -m venv venv
}

Write-Host "Installing Django and dependencies..." -ForegroundColor Yellow
.\venv\Scripts\python.exe -m pip install --upgrade pip
.\venv\Scripts\python.exe -m pip install Django==5.0.1 djangorestframework==3.14.0 django-cors-headers==4.3.1 python-dotenv==1.0.0

Write-Host ""
Write-Host "Verifying installation..." -ForegroundColor Yellow
.\venv\Scripts\python.exe -c "import django; print('Django', django.get_version(), 'installed successfully!')"

Write-Host ""
Write-Host "Running migrations..." -ForegroundColor Yellow
.\venv\Scripts\python.exe manage.py makemigrations
.\venv\Scripts\python.exe manage.py migrate

Write-Host ""
Write-Host "=== Installation Complete! ===" -ForegroundColor Green
Write-Host "Run .\start-django.ps1 to start the server" -ForegroundColor Cyan

cd ..



