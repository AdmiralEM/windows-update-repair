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

## 📜 Script List

| File | What It Does |
|------|--------------|
| `01-stop-update-services.ps1` | Stops Windows Update-related services (wuauserv, bits, cryptsvc, msiserver). |
| `02-clear-update-cache.ps1` | (Coming Soon) Clears `SoftwareDistribution` and `Catroot2` folders. |
| `03-reset-winsock.ps1` | (Planned) Resets the Winsock stack to fix networking issues. |
| `04-flush-dns.ps1` | (Planned) Flushes DNS resolver cache. |
| `05-reregister-dlls.ps1` | (Planned) Re-registers update-related DLLs (mostly legacy). |
| `06-start-update-services.ps1` | (Planned) Restarts the services stopped earlier. |
| `07-run-sfc-dism.ps1` | (Planned) Runs `SFC` and `DISM` scans to check and repair system files. |
| `08-windows-update-troubleshooter.ps1` | (Planned) Launches the built-in Windows Update troubleshooter. |
| `09-check-for-updates.ps1` | (Planned) Checks for updates using PowerShell. |

---

## 🧰 Requirements

- **OS:** Windows 10 / 11
- **Permissions:** Must be run as Administrator (right-click > Run as Administrator or run from elevated shell).
- **Execution Policy:** Scripts may require `Set-ExecutionPolicy RemoteSigned` or `Bypass` if blocked.

---

## ❗ Disclaimer

These scripts are provided *as-is*. They are safer than random tools off the internet, but you're still responsible for using them correctly. If you're working in an enterprise or restricted environment, check your policies before executing.

---

## 🧠 Why Use These?

Because most "Windows Update Fixer" tools are either:
- 🔒 Not allowed on locked-down systems
- 🤡 Sloppily built with poor transparency
- 🤫 Doing mystery things behind the scenes

This repo is for those who want full control, transparency, and the ability to script or learn without bullshit.

---

## 📦 Future Plans

- Add an optional logging mechanism
- Create a wrapper script that chains all steps in sequence
- Support CLI flags for step-by-step, dry-run, or verbose modes

---

## 🛠️ License

MIT. Do whatever the hell you want, just don’t pretend you wrote it first.
