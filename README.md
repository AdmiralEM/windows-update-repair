# Windows Update Repair Scripts (PowerShell-Only)

This repo contains modular PowerShell scripts that replicate the functionality of common Windows Update repair tools like [WuReset](https://wureset.com/)—but without the need to run unapproved EXEs or installers.

These scripts are designed to be:
- **Individual:** Use one step at a time based on what you're troubleshooting.
- **Readable:** Fully commented for learning and clarity.
- **Flexible:** Supports silent mode for automation, or interactive mode for guided use.

---

## 🚀 Quick Start

**Run a script interactively:**
```powershell
.-stop-update-services.ps1
```

**Run it silently (for automation / scripts):**
```powershell
.-stop-update-services.ps1 -Silent
```

---

## Recommended Script Order

| # | Script | Purpose |
|----|--------|---------|
| 01 | `01-open-system-protection.ps1` | Opens System Protection settings (optional prep for restoring later). |
| 02 | `02-stop-update-services.ps1` | Stops Windows Update, BITS, CryptSvc, and MSI services. |
| 03 | `03-clear-update-cache.ps1` | Deletes `SoftwareDistribution` and `Catroot2`. |
| 04 | `04-cleanup-superseded-components.ps1` | Removes superseded updates using DISM. |
| 05 | `05-reset-winsock.ps1` | Resets Winsock (fixes corrupt TCP/IP stack). |
| 06 | `06-flush-dns.ps1` | Flushes DNS cache to fix resolution issues. |
| 07 | `07-reregister-dlls.ps1` | Re-registers Windows Update-related DLLs. |
| 08 | `08-start-update-services.ps1` | Starts the services stopped in script 2. |
| 09 | `09-run-sfc-dism.ps1` | Runs SFC + DISM to repair system files and image health. |
| 10 | `10-reset-microsoft-store.ps1` | Clears Microsoft Store cache via `wsreset.exe`. |
| 11 | `11-force-gpupdate.ps1` | Forces group policy refresh (`gpupdate /force`). |
| 12 | `12-launch-windows-update-troubleshooter.ps1` | Opens Windows Update Troubleshooter GUI. |
| 13 | `13-check-for-updates.ps1` | Scans (and optionally installs) updates via PowerShell. |
| 14 | `14-get-product-key.ps1` | Shows the system’s Windows product key (from BIOS/registry). |

---

## Requirements

- **OS:** Windows 10 / 11
- **Permissions:** Must be run as Administrator (right-click > Run as Administrator or run from elevated shell).
- **Execution Policy:** Scripts may require `Set-ExecutionPolicy RemoteSigned` or `Bypass` if blocked.

---

## Disclaimer

These scripts are provided *as-is*. They are safer than random tools off the internet, but you're still responsible for using them correctly. If you're working in an enterprise or restricted environment, check your policies before executing.

---

## Why Use These?

Because most "Windows Update Fixer" tools are either:
- Not allowed on locked-down systems
- Sloppily built with poor transparency
- Doing mystery things behind the scenes

This repo is for those who want full control, transparency, and the ability to script or learn without bullshit.

---

## Future Plans

- Add an optional logging mechanism
- Create a wrapper script that chains all steps in sequence
- Support CLI flags for step-by-step, dry-run, or verbose modes

---

## 🛠️ License

GNU
