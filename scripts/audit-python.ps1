$ErrorActionPreference = "Stop"

$Root = Resolve-Path (Join-Path $PSScriptRoot "..")
$ApiPath = Join-Path $Root "api"

Set-Location $ApiPath
.\.venv\Scripts\Activate.ps1

pip-audit -r .\requirements.txt
safety check -r .\requirements.txt

Write-Host "== Python dependency audit complete ==" -ForegroundColor Green
