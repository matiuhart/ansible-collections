# Role: .NET Framework 4.8 Installation

## Description

This Ansible role automates the installation of Microsoft .NET Framework 4.8 on Windows systems. The role checks if the required version is already installed before proceeding with download and installation, avoiding unnecessary installations.

## Features

- ✅ Pre-installation version verification
- ✅ Automatic download from official Microsoft servers
- ✅ Silent installation without interruptions
- ✅ Automatic reboot detection
- ✅ Post-installation verification
- ✅ Informative progress messages

## Requirements

### Operating System
- Windows Server 2012 R2 or higher
- Windows 8.1 or higher

### Required Variables
```yaml
downloads_dir: "C:\\temp"  # Temporary directory for downloads
```

### Dependencies
- Internet connection to download the installer
- Administrator privileges on target system

## Variables

| Variable | Description | Default Value | Required |
|----------|-------------|---------------|----------|
| `downloads_dir` | Directory for temporary files | `C:\\temp` | Yes |

## Usage

### Basic Playbook
```yaml
- hosts: windows_servers
  roles:
    - role: dotnet-framework-48
      vars:
        downloads_dir: "C:\\temp"
```

### Playbook with Custom Variables
```yaml
- hosts: windows_servers
  vars:
    downloads_dir: "D:\\downloads"
  roles:
    - dotnet-framework-48
```

## How It Works

### 1. Initial Verification
The role checks the current .NET Framework version by querying the Windows registry:
- Path: `HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full`
- Key: `Release`
- Minimum required value: `528040` (.NET Framework 4.8)

### 2. Download and Installation
If the required version is not present:
- Downloads the web installer from official Microsoft servers
- URL: `https://download.microsoft.com/download/7/D/E/7DE045F2-F793-4E7B-9E9A-69CFA6892C6D/NDP48-Web.exe`
- Executes silent installation with `/quiet /norestart` parameters

### 3. Final Verification
Confirms successful installation by checking the registry again.

## .NET Framework Release Values

| Version | Release Value |
|---------|---------------|
| 4.8     | 528040        |
| 4.7.2   | 461808        |
| 4.7.1   | 461308        |
| 4.7     | 460798        |

## Reboot Handling

The role automatically detects if a reboot is required after installation and sets the `ansible_reboot_pending` variable for later processing.

## Expected Output

```
TASK [Verify if .NET Framework 4.8 is already installed] *********************
ok: [windows_server]

TASK [Show current .NET Framework version] ************************************
ok: [windows_server] => {
    "msg": "Detected .NET Framework version: 528040"
}

TASK [Confirm .NET Framework 4.8 installation] *******************************
ok: [windows_server]

TASK [Show installation result] ***********************************************
ok: [windows_server] => {
    "msg": "✓ .NET Framework 4.8 installed successfully. Release: 528040"
}
```

## Troubleshooting

### Common Issues

**Download Error:**
- Verify internet connectivity
- Check that no proxy/firewall is blocking the download

**Installation Error:**
- Verify administrator permissions
- Check available disk space
- Review Windows logs for specific errors

**Version not detected correctly:**
- Verify that Windows registry is not corrupted
- Run `sfc /scannow` to repair system files

## Role Structure

```
roles/dotnet-framework-48/
├── tasks/
│   └── main.yml
├── vars/
│   └── main.yml
├── defaults/
│   └── main.yml
└── README.md
```

## Suggested Tags

```yaml
- role: dotnet-framework-48
  tags:
    - dotnet
    - framework
    - prerequisites
    - windows
```

## License

This role is available under the MIT license.

## Maintenance

- Update download URL if Microsoft changes the location
- Verify compatibility with new Windows versions
- Update Release value for new .NET Framework versions

---

**Note:** This role installs .NET Framework 4.8, which is the latest version of .NET Framework. For modern applications, consider migrating to .NET Core/.NET 5+ which is cross-platform and has better performance.