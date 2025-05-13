<#
.SYNOPSIS
Flushes the DNS resolver cache.

.DESCRIPTION
Stale or corrupted DNS entries can prevent Windows Update or apps from
resolving Microsoft servers correctly. This script clears the local DNS cache.

.PARAMETER Silent
Optional. Runs without user output.

.NOTES
Does NOT affect configured DNS servers or static entries.
#>

param (
    [switch]$Silent
)

# Ensure script is being run as Administrator (required for DNS flush)
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Error "This script must be run as Administrator."
    exit 1
}

if (-not $Silent) {
    Write-Host "Flushing DNS resolver cache..." -ForegroundColor Yellow
}

try {
    # Classic fix: clears locally cached DNS entries
    ipconfig /flushdns | Out-Null

    if (-not $Silent) {
        Write-Host "DNS cache successfully flushed." -ForegroundColor Green
    }
} catch {
    Write-Warning "Failed to flush DNS cache: $_"
}
