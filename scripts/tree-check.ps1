$ErrorActionPreference = "Stop"

$Root = Resolve-Path (Join-Path $PSScriptRoot "..")
Set-Location $Root

$Expected = @(
  ".editorconfig",
  ".gitattributes",
  ".gitignore",
  ".pre-commit-config.yaml",
  "docker-compose.yml",
  "Dockerfile",
  "README.md",
  ".github\workflows\ci.yml",
  "ai_governance\prompt_catalog.json",
  "ai_governance\evaluation_sample.json",
  "api\manage.py",
  "api\requirements.txt",
  "api\requirements-dev.txt",
  "api\pyproject.toml",
  "api\.env.example",
  "api\pytest.ini",
  "api\londonplan_api\settings.py",
  "api\londonplan_api\urls.py",
  "api\core\middleware.py",
  "api\core\serializers.py",
  "api\core\views.py",
  "api\core\urls.py",
  "api\core\tests\test_health.py",
  "client\londonplan-client\.env.example",
  "client\londonplan-client\proxy.conf.json",
  "client\londonplan-client\openapi-generator-config.json",
  "client\londonplan-client\src\app\api\api-contract.ts",
  "client\londonplan-client\src\app\api\health.service.ts",
  "client\londonplan-client\src\app\features\health-check\health-check.ts",
  "client\londonplan-client\src\app\features\health-check\health-check.html",
  "client\londonplan-client\src\app\features\health-check\health-check.scss",
  "client\londonplan-client\src\app\generated-api\generated-health.service.ts",
  "client\londonplan-client\src\app\generated-api\index.ts",
  "docs\adr\0001-security-by-design.md",
  "docs\adr\0002-openapi-contract-first.md",
  "docs\adr\0003-generated-angular-client.md",
  "docs\adr\0004-ai-governance-and-human-review.md",
  "docs\api\openapi.yaml",
  "infra\postgres-init.sql",
  "scripts\gates.ps1",
  "scripts\audit-python.ps1",
  "scripts\tree-check.ps1",
  "scripts\export-openapi.ps1",
  "scripts\check-openapi-lock.ps1"
)

$Missing = @()
foreach ($p in $Expected) {
  if (!(Test-Path (Join-Path $Root $p))) { $Missing += $p }
}

Write-Host ""
Write-Host "== Current tree (top-level) =="
Get-ChildItem -Force | Select-Object Name | Format-Table -AutoSize

Write-Host ""
if ($Missing.Count -gt 0) {
  Write-Host "== MISSING FILES ==" -ForegroundColor Red
  $Missing | ForEach-Object { Write-Host " - $_" -ForegroundColor Red }
  exit 1
}

Write-Host "== Structure OK ==" -ForegroundColor Green
