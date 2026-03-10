$ErrorActionPreference = "Stop"

$Root = Resolve-Path (Join-Path $PSScriptRoot "..")
$ApiPath = Join-Path $Root "api"
$ClientPath = Join-Path $Root "client\londonplan-client"

Write-Host "== Tree check ==" -ForegroundColor Cyan
& (Join-Path $Root "scripts\tree-check.ps1")

Write-Host "== Python tests ==" -ForegroundColor Cyan
Set-Location $ApiPath
.\.venv\Scripts\Activate.ps1
pytest

Write-Host "== Django check ==" -ForegroundColor Cyan
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
python manage.py check

Write-Host "== OpenAPI export ==" -ForegroundColor Cyan
Set-Location $Root
& (Join-Path $Root "scripts\export-openapi.ps1")

Write-Host "== OpenAPI lock check ==" -ForegroundColor Cyan
& (Join-Path $Root "scripts\check-openapi-lock.ps1")

Write-Host "== Angular build ==" -ForegroundColor Cyan
Set-Location $ClientPath
npm run build

Write-Host "== OK ==" -ForegroundColor Green
