<#
.SYNOPSIS
Starts the Windows Update services (wuauserv, bits, cryptsvc, msiserver).

.DESCRIPTION
Use this after stopping services and performing maintenance (like clearing caches or resetting Winsock).
It restores normal update operations.

.PARAMETER Silent
Optional. Suppresses output for quiet runs.

.NOTES
Services are started only if they are not already running.
#>

param (
    [switch]$Silent
)

# List of Windows Update-related services to start
$services = @(
    "wuauserv",    # Windows Update
    "bits",        # Background Intelligent Transfer Service
    "cryptsvc",    # Cryptographic Services
    "msiserver"    # Windows Installer
)

# Function to start a service if it's not already running
function Start-ServiceIfStopped {
    param (
        [string]$ServiceName
    )

    $service = Get-Service -Name $ServiceName -ErrorAction SilentlyContinue

    if ($null -eq $service) {
        if (-not $Silent) {
            Write-Warning "$ServiceName not found. Skipping."
        }
        return
    }

    if ($service.Status -ne 'Running') {
        try {
            if (-not $Silent) {
                Write-Host "Starting $ServiceName..." -ForegroundColor Yellow
            }

            Start-Service -Name $ServiceName -ErrorAction Stop

            if (-not $Silent) {
                Write-Host "$ServiceName started successfully." -ForegroundColor Green
            }
        } catch {
            Write-Warning "Failed to start $ServiceName: $_"
        }
    } elseif (-not $Silent) {
        Write-Host "$ServiceName is already running." -ForegroundColor Gray
    }
}

# Start all the relevant services
foreach ($svc in $services) {
    Start-ServiceIfStopped -ServiceName $svc
}

if (-not $Silent) {
    Write-Host "`nAll applicable Windows Update services are now running." -ForegroundColor Cyan
}
