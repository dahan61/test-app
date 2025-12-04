# Refresh PATH environment variable
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

Write-Host "Installing Python dependencies..." -ForegroundColor Green
pip install -r requirements.txt

Write-Host "`nCreating database migrations..." -ForegroundColor Green
python manage.py makemigrations

Write-Host "`nRunning migrations..." -ForegroundColor Green
python manage.py migrate

Write-Host "`nSetup complete! You can now run: python manage.py runserver" -ForegroundColor Green



