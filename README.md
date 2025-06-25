# SCUM DS Manager

**SCUM DS Manager** is a PowerShell-based GUI tool that simplifies the installation and setup of a SCUM dedicated server on Windows. Built for transparency and ease of use, it includes hardware checks, dependency management, and install/uninstall options for all required components.

---

## 📚 Table of Contents

- [Features](#features)
- [How to Run](#how-to-run)
- [Roadmap](#roadmap)
- [License](#license)
- [Support & Contributions](#support--contributions)

---

## Features

### ✅ Hardware Requirements Check
![image](https://github.com/user-attachments/assets/f33cd747-5491-4ccc-806a-55b1f7049c04)
- Detects and displays system information: OS version, CPU, RAM, disk space
- Validates minimum specs (4 logical cores, 16 GB RAM, 200 GB free disk space, Windows Server x64)
- Visual feedback with green checkmarks or red flags
- Includes warnings for unsupported OS environments

### 📦 SCUM Server Setup
![image](https://github.com/user-attachments/assets/8b56e682-0bac-484c-945e-acdce59dbc33)
- Guided installer for:
  - Visual C++ Redistributable (2015–2022 x64)
  - DirectX End-User Runtime (June 2010)
  - SteamCMD (with configurable install path)
  - SCUM Server Files (via SteamCMD)
  - startserver.bat generation with custom port
  - Auto-Start Scheduled Task to start the SCUM server when the OS boots
  - SCUM Server Auto-Restart task
    - You could generate multiple tasks if you wanted to restart once per day and every 4 hours.
      ![image](https://github.com/user-attachments/assets/4179cf22-e724-42aa-9af2-f594e3fd106c)



### ⚙️ SCUM Server Settings Editor
![image](https://github.com/user-attachments/assets/e6de69b5-2436-4efe-9411-821548ffa7f2)
- Edit the ServerSettings.ini
  - General, World, Respawn, Vehicles, Damage, Features are all dynamically pulled from the .ini file.
- Backup the current config before making edits.
![image](https://github.com/user-attachments/assets/3a25a442-a342-4871-8f49-e806644e1d0e)

### 🔒 Fully Offline, Transparent & Self-Contained
- No telemetry. No webhooks. No funny business
- Native PowerShell and XAML—easily auditable
---
<a name="how-to-run"></a>
## 🖥️ How to Run

> **Requirements:**  
> - Windows Server (64-bit)  
> - PowerShell 5.1+  
> - Administrator privileges

### Run from PowerShell

1. **Download** the `scum-ds-manager.ps1` script from this repository.
2. **Right-click** the file and select **Run with PowerShell**, or open PowerShell and run:

   ```powershell
   Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
   .\scum-ds-manager.ps1
   ```

3. The GUI will launch automatically.

> ⚠️ Note: You may need to unblock the script before running:
>
> ```powershell
> Unblock-File -Path .\scum-ds-manager.ps1
> ```

---

## Roadmap

- [ ] SCUM Server updates
- [ ] Network port validation
- [ ] Containerized SCUM Server!

---

## License

This project is licensed under the [Creative Commons Attribution-NonCommercial 4.0 International (CC BY-NC 4.0)](https://creativecommons.org/licenses/by-nc/4.0/).

You’re free to use, modify, and share this code for personal or non-commercial purposes. Commercial use is **not allowed** without prior written permission.

Interested in commercial use? Contact me to discuss licensing options.

---

## Support & Contributions

Bugs, suggestions, and feature requests?  
Open an issue or submit a PR on GitHub:  
[https://github.com/rough-ton/scum-ds-manager](https://github.com/rough-ton/scum-ds-manager)
