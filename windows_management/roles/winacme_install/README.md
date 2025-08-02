# Role: WinAcme Installation

## Description

This Ansible role automates the installation and configuration of WinAcme (Windows ACME Simple) on Windows systems. WinAcme is a powerful SSL certificate management tool that integrates with Let's Encrypt and other ACME-compliant Certificate Authorities to provide automated certificate provisioning and renewal for Windows environments.

## Features

- ✅ Automated WinAcme download and installation
- ✅ Complete configuration file setup
- ✅ Let's Encrypt ACME v2 integration
- ✅ Automatic certificate renewal scheduling
- ✅ Email notification configuration
- ✅ System PATH integration
- ✅ Customizable certificate store location
- ✅ Idempotent installation (skip if already present)

## Requirements

### Operating System
- Windows Server 2012 R2 or higher
- Windows 10/11

### Prerequisites
- .NET Framework 4.8 or higher
- Administrator privileges
- Internet connectivity for certificate validation
- Valid email address for Let's Encrypt registration

### Dependencies
- PowerShell 5.1 or higher
- Windows Task Scheduler
- Access to download from GitHub releases

## Variables

### Required Variables
```yaml
# Installation directory
winacme_path: "C:\\Program Files\\win-acme"

# Email for Let's Encrypt registration and notifications
winacme_email: "admin@yourdomain.com"

# Downloads directory
downloads_dir: "C:\\temp"
```

### Optional Variables
```yaml
# Certificate store location
winacme_store_location: "WebHosting"

# Renewal settings
winacme_renewal_days: 55
winacme_renewal_time: "09:00:00"

# SMTP settings (optional)
winacme_smtp_server: null
winacme_smtp_port: 587
winacme_smtp_user: null
winacme_smtp_password: null
```

## Variable Reference

| Variable | Description | Default Value | Required |
|----------|-------------|---------------|----------|
| `winacme_path` | Installation directory | `C:\\Program Files\\win-acme` | Yes |
| `winacme_email` | Email for notifications and registration | - | Yes |
| `downloads_dir` | Temporary download directory | `C:\\temp` | Yes |
| `winacme_store_location` | Windows certificate store | `WebHosting` | No |
| `winacme_renewal_days` | Days before expiry to renew | `55` | No |
| `winacme_renewal_time` | Daily renewal check time | `09:00:00` | No |

## Usage

### Basic Installation
```yaml
- hosts: web_servers
  vars:
    winacme_email: "certificates@company.com"
    winacme_path: "C:\\Program Files\\win-acme"
    downloads_dir: "C:\\temp"
  roles:
    - winacme_install
```

### Custom Configuration
```yaml
- hosts: web_servers
  vars:
    winacme_email: "ssl-admin@company.com"
    winacme_path: "D:\\Tools\\win-acme"
    winacme_store_location: "My"
    winacme_renewal_days: 30
    winacme_renewal_time: "02:00:00"
    downloads_dir: "C:\\Downloads"
  roles:
    - winacme_install
```

### With SMTP Notifications
```yaml
- hosts: web_servers
  vars:
    winacme_email: "certificates@company.com"
    winacme_smtp_server: "smtp.company.com"
    winacme_smtp_port: 587
    winacme_smtp_user: "certificates@company.com"
    winacme_smtp_password: "{{ vault_smtp_password }}"
  roles:
    - winacme_install
```

## How It Works

### 1. Pre-Installation Check
- Verifies if WinAcme is already installed by checking for `wacs.exe`
- Displays current installation status
- Skips installation if already present

### 2. Download and Extraction
- Downloads latest WinAcme release from GitHub
- Creates installation directory
- Extracts ZIP archive to installation path
- Verifies extraction by checking for executable

### 3. Configuration Setup
- Creates comprehensive `settings.json` configuration file
- Configures Let's Encrypt ACME v2 endpoint
- Sets up email notifications
- Configures certificate store preferences
- Sets renewal schedule parameters

### 4. System Integration
- Adds WinAcme to system PATH for global access
- Verifies installation by checking version
- Creates scheduled task for automatic renewals

### 5. Scheduled Task Creation
- Daily renewal check at configured time
- Runs under SYSTEM account with highest privileges
- Configured for 24-hour interval checks
- 2-hour execution time limit

## Configuration Details

### ACME Settings
```json
{
  "Acme": {
    "DefaultBaseUri": "https://acme-v02.api.letsencrypt.org/",
    "PostAsGet": true
  }
}
```

### Renewal Schedule
```json
{
  "ScheduledTask": {
    "RenewalDays": 55,
    "StartBoundary": "09:00:00",
    "ExecutionTimeLimit": "02:00:00",
    "RandomDelay": "00:00:00"
  }
}
```

### Certificate Store Options
- **WebHosting**: Default for IIS websites
- **My**: Personal certificate store
- **Root**: Trusted Root Certification Authorities
- **CA**: Intermediate Certification Authorities

## Expected Output

```
TASK [Verify if WinAcme is already installed] *********************************
ok: [web_server]

TASK [Show WinAcme status] ****************************************************
ok: [web_server] => {
    "msg": "WinAcme: Not installed"
}

TASK [Create directory for WinAcme] ******************************************
changed: [web_server]

TASK [Download WinAcme] *******************************************************
changed: [web_server]

TASK [Extract WinAcme] ********************************************************
changed: [web_server]

TASK [Create initial WinAcme configuration] **********************************
changed: [web_server]

TASK [Add WinAcme to system PATH] ********************************************
changed: [web_server]

TASK [Verify WinAcme installation] *******************************************
ok: [web_server]

TASK [Show WinAcme version] ***************************************************
ok: [web_server] => {
    "msg": "✓ WinAcme installed: win-acme.v2.2.9.1701 (RELEASE, PLUGGABLE)"
}

TASK [Create scheduled task for automatic renewal] ***************************
changed: [web_server]
```

## Post-Installation Usage

### Command Line Examples
```powershell
# Show help
wacs --help

# List current certificates
wacs --list

# Create new certificate interactively
wacs

# Create certificate for specific domain
wacs --source manual --host "example.com" --accepttos

# Force renewal of all certificates
wacs --renew --force

# Show version information
wacs --version
```

### Common Certificate Operations
```powershell
# Create certificate with IIS binding
wacs --source iis --siteid 1 --accepttos

# Create wildcard certificate
wacs --source manual --host "*.example.com" --accepttos

# Create certificate with custom store
wacs --source manual --host "example.com" --store certificatestore --certificatestore My

# Create certificate with email validation
wacs --source manual --host "example.com" --validation http --accepttos
```

## Directory Structure

Post-installation structure:
```
C:\Program Files\win-acme\
├── wacs.exe                 # Main executable
├── settings.json           # Configuration file
├── Data\                   # Certificate cache and logs
├── Scripts\                # Custom scripts
├── Plugins\                # Plugin assemblies
└── Logs\                   # Application logs
```

## Scheduled Task Details

The role creates a scheduled task with these properties:
- **Name**: "WinAcme Certificate Renewal"
- **User**: SYSTEM
- **Trigger**: Daily at 09:00 AM
- **Recurrence**: Every 24 hours
- **Timeout**: 2 hours
- **Privilege Level**: Highest

### Task Management Commands
```powershell
# View task details
Get-ScheduledTask -TaskName "WinAcme Certificate Renewal"

# Run task manually
Start-ScheduledTask -TaskName "WinAcme Certificate Renewal"

# Check task history
Get-WinEvent -FilterHashtable @{LogName='Microsoft-Windows-TaskScheduler/Operational'; ID=200,201}
```

## Troubleshooting

### Installation Issues

**Download Fails:**
```yaml
# Check GitHub connectivity
- name: Test GitHub connectivity
  win_uri:
    url: https://api.github.com/repos/win-acme/win-acme/releases/latest
    method: GET
```

**Extraction Fails:**
```powershell
# Check ZIP file integrity
Test-Path "C:\temp\win-acme.zip"
Get-FileHash "C:\temp\win-acme.zip" -Algorithm SHA256
```

**PATH Issues:**
```powershell
# Verify PATH contains WinAcme
$env:PATH -split ';' | Where-Object { $_ -like "*win-acme*" }

# Refresh environment variables
[Environment]::GetEnvironmentVariable("PATH", "Machine")
```

### Configuration Issues

**Invalid Email Format:**
- Ensure email address is valid and accessible
- Check DNS MX records for email domain

**ACME Endpoint Issues:**
```powershell
# Test ACME endpoint connectivity
Invoke-WebRequest -Uri "https://acme-v02.api.letsencrypt.org/directory"
```

**Certificate Store Permissions:**
```powershell
# Check certificate store access
Get-ChildItem -Path Cert:\LocalMachine\WebHosting
```

### Runtime Issues

**Scheduled Task Not Running:**
```powershell
# Check task status
Get-ScheduledTask -TaskName "WinAcme Certificate Renewal" | Select-Object State, LastRunTime, LastTaskResult

# Check task logs
Get-EventLog -LogName System -Source "Task Scheduler" -Newest 10
```

**Certificate Validation Failures:**
- Verify domain DNS resolution
- Check firewall rules for HTTP/HTTPS traffic
- Ensure web server is accessible from internet

### Log Analysis

**WinAcme Logs Location:**
```
C:\Program Files\win-acme\Logs\
├── wacs.log                # Main application log
├── wacs.verbose.log        # Detailed debug log
└── [date]\                 # Daily log archives
```

**Common Log Patterns:**
```powershell
# Search for errors
Select-String -Path "C:\Program Files\win-acme\Logs\wacs.log" -Pattern "ERROR"

# Check renewal results
Select-String -Path "C:\Program Files\win-acme\Logs\wacs.log" -Pattern "Renewal"
```

## Security Considerations

### File Permissions
- WinAcme directory requires read/write access for SYSTEM account
- Configuration file contains sensitive settings
- Private keys stored in Windows Certificate Store with appropriate ACLs

### Network Security
- ACME challenges require temporary HTTP accessibility
- Consider firewall rules for validation periods
- Use DNS validation for internal-only servers

### Email Security
- Store SMTP credentials in Ansible Vault
- Use application-specific passwords when possible
- Monitor notification emails for security alerts

## Integration Examples

### With IIS Management
```yaml
- hosts: web_servers
  roles:
    - winacme_install
    - iis_configuration
  post_tasks:
    - name: Create certificate for main site
      win_shell: |
        wacs --source iis --siteid 1 --accepttos --emailaddress {{ winacme_email }}
      args:
        chdir: "{{ winacme_path }}"
```

### With Load Balancer
```yaml
- hosts: web_servers
  serial: 1
  roles:
    - winacme_install
  tasks:
    - name: Generate certificates for load-balanced domains
      win_shell: |
        wacs --source manual --host "{{ item }}" --accepttos --emailaddress {{ winacme_email }}
      loop: "{{ load_balanced_domains }}"
      args:
        chdir: "{{ winacme_path }}"
```

## Performance Optimization

### Renewal Efficiency
- Configure appropriate renewal days (30-55 days before expiry)
- Use DNS validation for faster processing
- Implement certificate caching strategies

### Resource Usage
- Schedule renewals during low-traffic periods
- Monitor disk space for certificate cache
- Clean up old log files regularly

## Maintenance Tasks

### Regular Maintenance
```yaml
# Clean old logs (keep last 30 days)
- name: Clean WinAcme logs
  win_shell: |
    Get-ChildItem "{{ winacme_path }}\Logs" -Recurse | 
    Where-Object { $_.CreationTime -lt (Get-Date).AddDays(-30) } | 
    Remove-Item -Force
```

### Health Checks
```yaml
# Verify certificate expiration dates
- name: Check certificate expiration
  win_shell: |
    wacs --list --verbose
  register: cert_status
  args:
    chdir: "{{ winacme_path }}"
```

### Updates
- Monitor WinAcme GitHub releases for updates
- Test updates in staging environments
- Review changelog for breaking changes

## Role Structure

```
roles/winacme_install/
├── tasks/
│   └── main.yml
├── defaults/
│   └── main.yml
├── vars/
│   └── main.yml
├── templates/
├── files/
└── README.md
```

## Suggested Tags

```yaml
- role: winacme_install
  tags:
    - winacme
    - ssl
    - certificates
    - letsencrypt
    - acme
    - security
    - windows
```

## Advanced Configuration

### Custom ACME Endpoints
```json
{
  "Acme": {
    "DefaultBaseUri": "https://acme-staging-v02.api.letsencrypt.org/",
    "PostAsGet": true
  }
}
```

### Plugin Configuration
```json
{
  "Plugins": {
    "ValidationPlugins": ["Http", "Dns"],
    "StorePlugins": ["CertificateStore", "PemFiles"],
    "InstallationPlugins": ["IIS", "Script"]
  }
}
```

## License

This role is available under the MIT license.

---

**Note:** WinAcme is a third-party tool. Please review the [official documentation](https://www.win-acme.com/) and [GitHub repository](https://github.com/win-acme/win-acme) for the latest features and updates. Let's Encrypt certificates have a 90-day validity period and require automatic renewal.