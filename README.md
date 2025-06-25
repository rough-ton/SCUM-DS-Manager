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
- Detects and displays system information: OS version, RAM, disk space
- Validates minimum specs (8 GB RAM, 50 GB free disk space, Windows Server x64)
- Visual feedback with green checkmarks or red flags
- Includes warnings for unsupported OS environments
![image](https://github.com/user-attachments/assets/30eced64-55d2-4a34-9052-a7015c95891a)

### 📦 SCUM Server Setup
- Guided installer for:
  - Visual C++ Redistributable (2015–2022 x64)
  - DirectX End-User Runtime (June 2010)
  - SteamCMD (with configurable install path)
  - SCUM Dedicated Server (via SteamCMD script)
- Handles downloads, silent installs, and path validation
- Install/uninstall support where applicable
![image](https://github.com/user-attachments/assets/f6edc713-4073-428d-b10e-a7ef7e46a746)

### 🔒 Fully Offline, Transparent & Self-Contained
- No telemetry. No webhooks. No funny business
- Native PowerShell and XAML—easily auditable
- Runs with elevated privileges to manage installations

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

- [ ] Server settings manager UI
- [ ] Server updates
- [ ] Scheduled server restarts
- [ ] Network port validation
- [ ] Backup and restore functionality

---

## 📄 License

This project is licensed under the [Creative Commons Attribution-NonCommercial 4.0 International (CC BY-NC 4.0)](https://creativecommons.org/licenses/by-nc/4.0/).

You’re free to use, modify, and share this code for personal or non-commercial purposes. Commercial use is **not allowed** without prior written permission.

*** Interested in commercial use? Contact me to discuss licensing options.

---

## Support & Contributions

Bugs, suggestions, and feature requests?  
Open an issue or submit a PR on GitHub:  
[https://github.com/rough-ton/scum-ds-manager](https://github.com/rough-ton/scum-ds-manager)
