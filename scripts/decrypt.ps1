<#
.SYNOPSIS
  Decrypt secure/*.age back into plaintext source for local editing.

.DESCRIPTION
  Local-only helper. Uses your age PRIVATE key (default: ~/.age/portfolio-key.txt).
  By default it decrypts into the repo root so you can edit, run, and re-encrypt.
  Use -OutDir to decrypt into a separate folder (e.g. dist/) instead.

  The private key is NEVER read from or written to the repo.

.PARAMETER Identity
  Path to the age private key file. Defaults to ~/.age/portfolio-key.txt.

.PARAMETER OutDir
  Where to write decrypted files. Defaults to the repo root.
#>
[CmdletBinding()]
param(
  [string]$Identity,
  [string]$OutDir
)

$ErrorActionPreference = "Stop"
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$root = Resolve-Path (Join-Path $scriptDir "..")
if (-not $Identity) { $Identity = Join-Path $env:USERPROFILE ".age\portfolio-key.txt" }
$secure = Join-Path $root "secure"
if (-not $OutDir) { $OutDir = $root }

$ageLocal = Join-Path $root "tools\age\age.exe"
$age = if (Test-Path $ageLocal) { $ageLocal } else { "age" }

if (-not (Test-Path $Identity)) {
  throw "Private key not found: $Identity. Pass -Identity <path> to your age key."
}
if (-not (Test-Path $secure)) {
  throw "No secure/ directory found. Nothing to decrypt."
}

New-Item -ItemType Directory -Force -Path $OutDir | Out-Null

$decrypted = 0
Get-ChildItem -Path $secure -Filter *.age | ForEach-Object {
  $outName = $_.Name -replace '\.age$', ''
  $out = Join-Path $OutDir $outName
  & $age --decrypt --identity $Identity --output $out $_.FullName
  if ($LASTEXITCODE -ne 0) { throw "age failed to decrypt $($_.Name) (exit $LASTEXITCODE)" }
  Write-Host ("[decrypt] secure/{0} -> {1}" -f $_.Name, $outName)
  $decrypted++
}

Write-Host "`n[decrypt] done. $decrypted file(s) decrypted into $OutDir."
