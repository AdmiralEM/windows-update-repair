<#
.SYNOPSIS
Resets the Windows Sockets (Winsock) catalog.

.DESCRIPTION
Winsock settings can get corrupted, blocking Windows Update, network connectivity,
or causing strange DNS failures. This resets it to default.

.PARAMETER Silent
Optional. Runs without prompts or extra output.

.NOTES
Requires reboot to fully apply changes. Doesn’t touch IP settings.
#>

param (
    [switch]$Silent
)

# Check for Admin rights — this command is useless without them
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Error "You must run this script as Administrator."
    exit 1
}

# Notify user if not in silent mode
if (-not $Silent) {
    Write-Host "Resetting Winsock..." -ForegroundColor Yellow
}

try {
    # The hammer: resets Winsock catalog to its default configuration
    netsh winsock reset | Out-Null

    if (-not $Silent) {
        Write-Host "Winsock reset successfully." -ForegroundColor Green
        Write-Host "A system reboot is required to complete this action." -ForegroundColor Cyan
    }
} catch {
    Write-Warning "Winsock reset failed: $_"
}
