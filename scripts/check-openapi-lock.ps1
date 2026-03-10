$ErrorActionPreference = "Stop"

$Root = Resolve-Path (Join-Path $PSScriptRoot "..")
$SchemaPath = Join-Path $Root "docs\api\openapi.yaml"

if (!(Test-Path $SchemaPath)) {
  Write-Host "Missing schema file: $SchemaPath" -ForegroundColor Red
  exit 1
}

git diff --exit-code -- $SchemaPath | Out-Null
if ($LASTEXITCODE -ne 0) {
  Write-Host "OpenAPI schema drift detected. Re-export and commit docs\api\openapi.yaml." -ForegroundColor Red
  exit 1
}

Write-Host "== OpenAPI lock OK ==" -ForegroundColor Green
