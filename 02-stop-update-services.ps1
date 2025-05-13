<#
.SYNOPSIS
Stops core Windows Update services: wuauserv, bits, cryptsvc, and msiserver.

.DESCRIPTION
These services often interfere with manual maintenance (like clearing update cache),
so stopping them is usually step one in any Windows Update troubleshooting process.

.PARAMETER Silent
Optional. Suppresses output for quiet/silent execution. Good for scripting.
#>

param (
    [switch]$Silent
)

# Define the list of services typically involved in update operations.
# You might not see msiserver running unless Windows Installer is in use,
# but it's common to include it for completeness.
$services = @(
    "wuauserv",    # Windows Update Service
    "bits",        # Background Intelligent Transfer Service
    "cryptsvc",    # Cryptographic Services (signatures, certificates, etc.)
    "msiserver"    # Windows Installer (used during updates or installations)
)

# Function to stop a service if it's running
function Stop-ServiceIfRunning {
    param (
        [string]$ServiceName
    )

    # Attempt to get the service object. If it doesn't exist, move on.
    $service = Get-Service -Name $ServiceName -ErrorAction SilentlyContinue

    if ($null -eq $service) {
        if (-not $Silent) {
            Write-Warning "$ServiceName not found on this system. Skipping."
        }
        return
    }

    # Only try to stop it if it's actually running
    if ($service.Status -eq 'Running') {
        try {
            if (-not $Silent) {
                Write-Host "Stopping $ServiceName..." -ForegroundColor Yellow
            }

            # Forcefully stop the service (some are stubborn bastards)
            Stop-Service -Name $ServiceName -Force -ErrorAction Stop

            if (-not $Silent) {
                Write-Host "$ServiceName stopped successfully." -ForegroundColor Green
            }
        } catch {
            # If it fails, tell the user but keep going
            Write-Warning "Failed to stop $ServiceName: $_"
        }
    } elseif (-not $Silent) {
        Write-Host "$ServiceName is already stopped." -ForegroundColor Gray
    }
}

# Loop through and try to stop each defined service
foreach ($svc in $services) {
    Stop-ServiceIfRunning -ServiceName $svc
}

# Optional final message to reassure the user that things went to plan
if (-not $Silent) {
    Write-Host "`nAll relevant Windows Update services have been stopped (if they were running)." -ForegroundColor Cyan
}
