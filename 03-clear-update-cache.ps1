<#
.SYNOPSIS
Clears the contents of the SoftwareDistribution and Catroot2 folders.

.DESCRIPTION
These folders hold temporary update data. Corrupt files here are a frequent source of
update failures, so clearing them is a go-to fix—but must be done *after* stopping
Windows Update services.

.PARAMETER Silent
Optional. Runs in quiet mode without prompts or extra output.
#>

param (
    [switch]$Silent
)

# Confirm this script is being run as Administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Error "This script must be run as Administrator." 
    exit 1
}

# Directories to clean out
$updateDirs = @(
    "$env:SystemRoot\SoftwareDistribution",
    "$env:SystemRoot\System32\catroot2"
)

# Function to clear the contents of a directory (but not delete the directory itself)
function Clear-Directory {
    param (
        [string]$Path
    )

    if (Test-Path $Path) {
        try {
            # Just delete everything *inside* the directory
            Get-ChildItem -Path $Path -Recurse -Force -ErrorAction SilentlyContinue | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue

            if (-not $Silent) {
                Write-Host "Cleared contents of: $Path" -ForegroundColor Green
            }
        } catch {
            Write-Warning "Failed to fully clear $Path: $_"
        }
    } elseif (-not $Silent) {
        Write-Warning "$Path not found. Skipping."
    }
}

# Run the cleaner on each target folder
foreach ($dir in $updateDirs) {
    Clear-Directory -Path $dir
}

if (-not $Silent) {
    Write-Host "`nUpdate cache folders have been cleared. You can now restart the update services." -ForegroundColor Cyan
}
