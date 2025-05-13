<#
.SYNOPSIS
Re-registers key Windows Update-related DLLs using regsvr32.

.DESCRIPTION
Some update-related components are implemented as COM objects and rely on proper DLL registration.
Corruption or missing entries can block the update agent or cause cryptic errors.

.PARAMETER Silent
Optional. Suppresses output for quiet runs.

.NOTES
Mostly useful for older Windows versions or very broken systems.
Modern Win10/11 rarely need this unless you're manually exorcising update demons.
#>

param (
    [switch]$Silent
)

# Admin check — regsvr32 silently fails without elevation
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Error "This script must be run as Administrator."
    exit 1
}

# List of DLLs commonly re-registered in classic WuReset workflows
$dlls = @(
    "atl.dll",
    "urlmon.dll",
    "mshtml.dll",
    "shdocvw.dll",
    "browseui.dll",
    "jscript.dll",
    "vbscript.dll",
    "scrrun.dll",
    "msxml.dll",
    "msxml3.dll",
    "msxml6.dll",
    "actxprxy.dll",
    "softpub.dll",
    "wintrust.dll",
    "dssenh.dll",
    "rsaenh.dll",
    "gpkcsp.dll",
    "sccbase.dll",
    "slbcsp.dll",
    "cryptdlg.dll",
    "oleaut32.dll",
    "ole32.dll",
    "shell32.dll",
    "initpki.dll",
    "wuapi.dll",
    "wuaueng.dll",
    "wuaueng1.dll",
    "wucltui.dll",
    "wups.dll",
    "wups2.dll",
    "wuweb.dll",
    "qmgr.dll",
    "qmgrprxy.dll",
    "wucltux.dll",
    "muweb.dll",
    "wuwebv.dll"
)

# Function to re-register DLL using regsvr32
function Register-Dll {
    param ([string]$DllName)

    $dllPath = Join-Path $env:SystemRoot "System32\$DllName"
    if (-not (Test-Path $dllPath)) {
        if (-not $Silent) {
            Write-Warning "$DllName not found. Skipping."
        }
        return
    }

    try {
        # /s = silent registration (no UI)
        Start-Process -FilePath "regsvr32.exe" -ArgumentList "/s `"$dllPath`"" -Wait -NoNewWindow
        if (-not $Silent) {
            Write-Host "$DllName registered successfully." -ForegroundColor Green
        }
    } catch {
        Write-Warning "Failed to register $DllName: $_"
    }
}

# Go through the DLL list and attempt registration
foreach ($dll in $dlls) {
    Register-Dll -DllName $dll
}

if (-not $Silent) {
    Write-Host "`nAll available DLLs have been processed for registration." -ForegroundColor Cyan
}
