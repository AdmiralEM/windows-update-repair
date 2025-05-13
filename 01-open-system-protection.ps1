<#
.SYNOPSIS
Opens the System Protection settings UI.

.DESCRIPTION
This launches the System Properties dialog focused on the System Protection tab,
allowing users to configure or enable System Restore. This is useful before
performing manual system repairs or registry edits.

.PARAMETER Silent
Has no effect—this is a GUI launcher.
#>

param (
    [switch]$Silent
)

# Ensure script is running as Administrator to make changes in the UI later
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Error "This script must be run as Administrator."
    exit 1
}

try {
    Start-Process -FilePath "SystemPropertiesProtection.exe"
    if (-not $Silent) {
        Write-Host "System Protection settings opened. You can now configure restore points." -ForegroundColor Green
    }
} catch {
    Write-Warning "Failed to launch System Protection settings: $_"
}
