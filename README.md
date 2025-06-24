# SCUM DS Manager

**SCUM DS Manager** is a PowerShell-based GUI tool that simplifies the installation and setup of a SCUM dedicated server on Windows. Built for transparency and ease of use, it includes hardware checks, dependency management, and install/uninstall options for all required components.

---

## 📚 Table of Contents

- [Features](#features)
- [How to Run](#️how-to-run)
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

### 📦 SCUM Server Setup
- Guided installer for:
  - Visual C++ Redistributable (2015–2022 x64)
  - DirectX End-User Runtime (June 2010)
  - SteamCMD (with configurable install path)
  - SCUM Dedicated Server (via SteamCMD script)
- Handles downloads, silent installs, and path validation
- Install/uninstall support where applicable

### 🧪 One-Click Dependency Checks
- “Run Checks” button verifies all required software is present
- Enables/disables relevant buttons based on detected status
- Log output captures results in real-time

### 📁 Folder Selection UI
- Users can choose custom install locations for SteamCMD and SCUM server
- Path validation and confirmation prompts included

### 🪵 Expandable Log Output
- Built-in logging console shows install actions, output, and errors
- Toggle visibility with an expandable panel

### ⚠️ Built-In Warnings and Disclaimers
- DirectX uninstall limitations explained in-app
- Permanent delete warnings for uninstall actions
- Humorous but clear disclaimer: use at your own risk

### 🔒 Fully Offline, Transparent & Self-Contained
- No telemetry. No webhooks. No funny business
- Native PowerShell and XAML—easily auditable
- Runs with elevated privileges to manage installations

---

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

- [ ] Server launch controls and auto-restart options
- [ ] Server config manager UI
- [ ] Network port validation
- [ ] Backup and restore functionality

---

## License

Creative Commons Attribution-NonCommercial 4.0 International (CC BY-NC 4.0)  
You may copy, modify, and share this tool, but commercial use is not allowed. Attribution required.

[View License](https://creativecommons.org/licenses/by-nc/4.0/)

---

## Support & Contributions

Bugs, suggestions, and feature requests?  
Open an issue or submit a PR on GitHub:  
[https://github.com/rough-ton/scum-ds-manager](https://github.com/rough-ton/scum-ds-manager)
