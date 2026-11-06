<#
.SYNOPSIS
  Encrypt all site source files at rest into secure/*.age using age.

.DESCRIPTION
  Layer 1: encryption at rest in the GitHub repo. Run this locally whenever
  you change a source file, then commit the updated secure/*.age blobs.
  Plaintext source is git-ignored and never committed. Decryption happens
  only at deploy time (GitHub Actions) or locally via decrypt.ps1.

  Encryption uses PUBLIC keys (recipients) only — no private key needed to
  encrypt. The private key is required solely to decrypt.

.NOTES
  Requires tools/age/age.exe (downloaded official binary) OR age on PATH.
#>
[CmdletBinding()]
param(
  [string]$Recipients
)

$ErrorActionPreference = "Stop"
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$root = Resolve-Path (Join-Path $scriptDir "..")
if (-not $Recipients) { $Recipients = Join-Path $root "age-recipients.txt" }
$secure = Join-Path $root "secure"

# Locate age: prefer the vendored binary, fall back to PATH.
$ageLocal = Join-Path $root "tools\age\age.exe"
$age = if (Test-Path $ageLocal) { $ageLocal } else { "age" }

# Source files to encrypt at rest (the full site: HTML + CSS + JS + assets).
$files = @(
  "index.html",
  "project.html",
  "styles.css",
  "modern.css",
  "data.js",
  "graphics.js",
  "motion.js",
  "app.js",
  "project.js",
  "logo.svg",
  "robots.txt",
  "sitemap.xml",
  "resume.pdf"
)

if (-not (Test-Path $Recipients)) {
  throw "Recipients file not found: $Recipients"
}

# Build -R <recipients-file> argument (age reads one public key per line,
# ignoring blank lines and lines starting with #).
New-Item -ItemType Directory -Force -Path $secure | Out-Null

$encrypted = 0
$missing = @()
foreach ($f in $files) {
  $src = Join-Path $root $f
  if (-not (Test-Path $src)) { $missing += $f; continue }
  $out = Join-Path $secure ($f + ".age")
  & $age --encrypt --recipients-file $Recipients --output $out $src
  if ($LASTEXITCODE -ne 0) { throw "age failed to encrypt $f (exit $LASTEXITCODE)" }
  Write-Host ("[encrypt] {0,-16} -> secure/{0}.age" -f $f)
  $encrypted++
}

if ($missing.Count -gt 0) {
  Write-Warning ("Skipped (not found): {0}" -f ($missing -join ", "))
}
Write-Host "`n[encrypt] done. $encrypted file(s) encrypted into secure/."
