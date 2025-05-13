<#
.SYNOPSIS
Runs SFC and DISM to check and repair system files and the Windows image.

.DESCRIPTION
This script performs two key system repairs:
1. System File Checker (SFC) scans for corrupted or missing system files and attempts to fix them.
2. Deployment Image Servicing and Management (DISM) verifies and repairs the Windows image itself.

.PARAMETER Silent
Optional. Suppresses console output and progress messages.

.NOTES
Run this script as Administrator. Reboot is recommended afterward.
#>

param (
    [switch]$Silent
)

# Admin check (required for both tools to function)
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Error "This script must be run as Administrator."
    exit 1
}

# Run SFC - scans and repairs protected system files
if (-not $Silent) {
    Write-Host "Running System File Checker (sfc /scannow)..." -ForegroundColor Yellow
}
try {
    sfc /scannow
} catch {
    Write-Warning "SFC scan failed: $_"
}

# Run DISM - checks and repairs the component store (which SFC depends on)
if (-not $Silent) {
    Write-Host "`nRunning DISM RestoreHealth..." -ForegroundColor Yellow
}
try {
    DISM /Online /Cleanup-Image /RestoreHealth
} catch {
    Write-Warning "DISM scan failed: $_"
}

# Final message
if (-not $Silent) {
    Write-Host "`nSFC and DISM scans are complete." -ForegroundColor Green
    Write-Host "If issues were found and repaired, a system reboot is recommended." -ForegroundColor Cyan
}
