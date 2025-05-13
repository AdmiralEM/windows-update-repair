<#
.SYNOPSIS
Cleans up superseded updates and unnecessary components using DISM.

.DESCRIPTION
This script runs the DISM /StartComponentCleanup command, which reduces the size of the WinSxS folder
by removing superseded (old) versions of components. Useful after cumulative updates or servicing stack updates.

.PARAMETER Silent
Optional. Suppresses console output.

.NOTES
No reboot required. Safe to run on production systems.
#>

param (
    [switch]$Silent
)

# Admin check – DISM commands require elevated privileges
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Error "This script must be run as Administrator."
    exit 1
}

if (-not $Silent) {
    Write-Host "Running component cleanup via DISM..." -ForegroundColor Yellow
}

try {
    DISM /Online /Cleanup-Image /StartComponentCleanup
    if (-not $Silent) {
        Write-Host "Component cleanup completed." -ForegroundColor Green
    }
} catch {
    Write-Warning "Component cleanup failed: $_"
}
