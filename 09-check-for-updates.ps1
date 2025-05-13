<#
.SYNOPSIS
Triggers a Windows Update scan and optionally installs updates.

.DESCRIPTION
Uses the built-in WindowsUpdateProvider module to scan for available updates.
Installs updates if requested. Meant for verification after performing repair actions.

.PARAMETER Install
If set, available updates will be installed automatically.

.PARAMETER Silent
Suppresses output.

.NOTES
Requires Windows 10 or later. Must be run as Administrator.
#>

param (
    [switch]$Install,
    [switch]$Silent
)

# Ensure we're running as Administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Error "This script must be run as Administrator."
    exit 1
}

# Import the WindowsUpdateProvider if available
if (-not (Get-Command Get-WindowsUpdate -ErrorAction SilentlyContinue)) {
    try {
        Import-Module WindowsUpdateProvider -ErrorAction Stop
    } catch {
        Write-Error "WindowsUpdateProvider module not available. Script requires Windows 10 or later."
        exit 1
    }
}

# Optional message
if (-not $Silent) {
    Write-Host "Initiating Windows Update scan..." -ForegroundColor Yellow
}

try {
    $updates = Get-WindowsUpdate
    if (-not $updates) {
        if (-not $Silent) {
            Write-Host "No updates available." -ForegroundColor Green
        }
    } else {
        if (-not $Silent) {
            Write-Host "$($updates.Count) update(s) found." -ForegroundColor Cyan
        }

        if ($Install) {
            if (-not $Silent) {
                Write-Host "Installing available updates..." -ForegroundColor Yellow
            }

            Install-WindowsUpdate -Confirm:$false

            if (-not $Silent) {
                Write-Host "Update installation initiated. Reboot may be required." -ForegroundColor Green
            }
        } elseif (-not $Silent) {
            Write-Host "Use the -Install flag to apply updates." -ForegroundColor Gray
        }
    }
} catch {
    Write-Warning "Update scan failed: $_"
}
