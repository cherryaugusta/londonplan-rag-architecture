$ErrorActionPreference = "Stop"

$Root = Resolve-Path (Join-Path $PSScriptRoot "..")
$ApiPath = Join-Path $Root "api"
$OutPath = Join-Path $Root "docs\api\openapi.yaml"

Set-Location $ApiPath
.\.venv\Scripts\Activate.ps1

$env:DJANGO_DEBUG="1"
$env:DJANGO_SECRET_KEY="INSECURE_DEV_ONLY_CHANGE_ME"
$env:DJANGO_ALLOWED_HOSTS="localhost,127.0.0.1"
$env:DB_NAME="londonplan"
$env:DB_USER="londonplan"
$env:DB_PASSWORD="londonplan_dev_password"
$env:DB_HOST="127.0.0.1"
$env:DB_PORT="55432"
$env:REDIS_URL="redis://localhost:6379/0"
$env:CORS_ALLOWED_ORIGINS="http://localhost:4200,http://127.0.0.1:4200"

python manage.py spectacular --file $OutPath
Write-Host "== OpenAPI exported to $OutPath ==" -ForegroundColor Green
