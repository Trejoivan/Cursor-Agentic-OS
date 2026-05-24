$ErrorActionPreference = "Stop"

function Import-DotEnv {
  param([Parameter(Mandatory=$true)][string]$Path)
  if (!(Test-Path $Path)) { return }
  Get-Content $Path | ForEach-Object {
    $line = $_.Trim()
    if ($line.Length -eq 0) { return }
    if ($line.StartsWith("#")) { return }
    $parts = $line -split "=", 2
    if ($parts.Length -ne 2) { return }
    $name = $parts[0].Trim()
    $value = $parts[1].Trim()
    if ($name.Length -eq 0) { return }
    [System.Environment]::SetEnvironmentVariable($name, $value, "Process")
  }
}

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$root = Split-Path -Parent $here

if (!(Test-Path (Join-Path $root ".env")) -and (Test-Path (Join-Path $root ".env.example"))) {
  Write-Host "No .env found. Copying .env.example -> .env"
  Copy-Item (Join-Path $root ".env.example") (Join-Path $root ".env")
  Write-Host "Edit agentic-db/.env and set a strong POSTGRES_PASSWORD, then re-run this script."
  exit 1
}

Import-DotEnv (Join-Path $root ".env")

$appDb = $env:POSTGRES_DB
$appUser = $env:POSTGRES_USER
$appPassword = $env:POSTGRES_PASSWORD

if ([string]::IsNullOrWhiteSpace($appDb) -or [string]::IsNullOrWhiteSpace($appUser) -or [string]::IsNullOrWhiteSpace($appPassword)) {
  throw "Missing POSTGRES_DB / POSTGRES_USER / POSTGRES_PASSWORD in agentic-db/.env"
}

$hostName = if ($env:PGHOST) { $env:PGHOST } else { "localhost" }
$port = if ($env:PGPORT) { $env:PGPORT } else { "5432" }
$adminUser = if ($env:PGADMINUSER) { $env:PGADMINUSER } else { "postgres" }
$adminDb = if ($env:PGADMINDB) { $env:PGADMINDB } else { "postgres" }

Write-Host "This will create/alter role '$appUser', create DB '$appDb', and apply schema."
Write-Host "Admin connection: postgresql://$adminUser@${hostName}:$port/$adminDb"

if (-not $env:PGPASSWORD) {
  $secure = Read-Host -Prompt "Enter password for admin user '$adminUser' (input hidden)" -AsSecureString
  $env:PGPASSWORD = [Runtime.InteropServices.Marshal]::PtrToStringAuto(
    [Runtime.InteropServices.Marshal]::SecureStringToBSTR($secure)
  )
}

$bootstrapSql = Join-Path $root "db\\bootstrap.sql"
$initSql = Join-Path $root "db\\init.sql"

psql -h $hostName -p $port -U $adminUser -d $adminDb `
  -v app_db="$appDb" -v app_user="$appUser" -v app_password="$appPassword" `
  -f $bootstrapSql

# Apply schema as app user (so object ownership matches)
$env:PGPASSWORD = $appPassword
psql -h $hostName -p $port -U $appUser -d $appDb -f $initSql

Write-Host "Done. Connect with:"
Write-Host "  psql ""postgresql://$appUser:$appPassword@localhost:$port/$appDb"""

