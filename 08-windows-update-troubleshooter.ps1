<#
.SYNOPSIS
Launches the built-in Windows Update Troubleshooter.

.DESCRIPTION
Opens the Windows Troubleshooting UI focused on fixing Windows Update problems.
Useful when everything else seems fine but updates still fail silently or with vague errors.

.PARAMETER Silent
Included for consistency. Has no effect—this is a GUI action.

.NOTES
Requires Windows 10 or later. Actual executable is `msdt.exe`.
Does not return results to the script. This is an interactive tool.
#>

param (
    [switch]$Silent
)

# Confirm Administrator rights
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Error "This script must be run as Administrator."
    exit 1
}

# Path to Microsoft Diagnostic Tool (GUI-based)
$msdtPath = "$env:SystemRoot\System32\msdt.exe"

# The built-in Windows Update troubleshooter ID
$troubleshooterId = "WindowsUpdateDiagnostic"

if (-not (Test-Path $msdtPath)) {
    Write-Error "msdt.exe not found. This version of Windows may not support the classic troubleshooter."
    exit 1
}

try {
    # /id launches a specific troubleshooter, if available
    Start-Process -FilePath $msdtPath -ArgumentList "/id $troubleshooterId" -NoNewWindow
    if (-not $Silent) {
        Write-Host "Windows Update Troubleshooter launched." -ForegroundColor Green
        Write-Host "Follow the on-screen instructions to complete the process." -ForegroundColor Cyan
    }
} catch {
    Write-Warning "Failed to launch the Windows Update Troubleshooter: $_"
}
