# Test Django Installation
Write-Host "Testing Django installation..." -ForegroundColor Cyan

cd backend

if (Test-Path "venv\Scripts\python.exe") {
    Write-Host "Using venv Python: venv\Scripts\python.exe" -ForegroundColor Green
    $pythonExe = ".\venv\Scripts\python.exe"
    
    Write-Host "`nChecking Django installation..." -ForegroundColor Yellow
    & $pythonExe -c "import django; print('Django version:', django.get_version())"
    
    Write-Host "`nRunning Django check..." -ForegroundColor Yellow
    & $pythonExe manage.py check
    
    Write-Host "`nDjango is ready!" -ForegroundColor Green
} else {
    Write-Host "ERROR: Virtual environment not found!" -ForegroundColor Red
    Write-Host "Run .\setup-backend.ps1 first" -ForegroundColor Yellow
}

cd ..



