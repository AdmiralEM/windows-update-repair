# Windows Update Repair Scripts (PowerShell-Only)

This repo contains modular PowerShell scripts that replicate the functionality of common Windows Update repair tools like [WuReset](https://wureset.com/)—but without the need to run unapproved EXEs or mystery meat installers.

These scripts are designed to be:
- 🔧 **Individual:** Use one step at a time based on what you're troubleshooting.
- 🧠 **Readable:** Fully commented for learning and clarity.
- ⚙️ **Flexible:** Supports silent mode for automation, or interactive mode for guided use.

---

## 🚀 Quick Start

**Run a script interactively:**
```powershell
.\01-stop-update-services.ps1
