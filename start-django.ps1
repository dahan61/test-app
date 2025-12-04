# Start Django Server
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

Write-Host "Starting Django server on http://localhost:8000" -ForegroundColor Green
Write-Host "Press Ctrl+C to stop" -ForegroundColor Yellow
Write-Host ""

Set-Location backend

# Use venv Python directly
if (Test-Path "venv\Scripts\python.exe") {
    Write-Host "Using virtual environment Python..." -ForegroundColor Cyan
    $pythonExe = ".\venv\Scripts\python.exe"
} else {
    Write-Host "Virtual environment not found. Using system Python..." -ForegroundColor Yellow
    $pythonExe = "python"
}

& $pythonExe manage.py runserver

