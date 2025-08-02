# Role: IIS, WinAcme and SSL Certificate Management

## Description

This comprehensive Ansible role automates the installation and configuration of Internet Information Services (IIS), WinAcme for SSL certificate management, and manages multiple websites with automatic SSL certificate provisioning through Let's Encrypt. The role provides a complete solution for Windows web server deployment with automated SSL certificate lifecycle management.

## Features

- ✅ Complete IIS installation and configuration
- ✅ WinAcme installation and setup for Let's Encrypt certificates
- ✅ Automated SSL certificate generation and binding
- ✅ Multiple website management with individual app pools
- ✅ Automatic certificate renewal scheduling
- ✅ Structured logging configuration
- ✅ SNI (Server Name Indication) support
- ✅ .NET Framework 4.0 runtime configuration

## Requirements

### Operating System
- Windows Server 2012 R2 or higher
- Windows 10/11 (for development environments)

### Prerequisites
- Internet connectivity for certificate validation
- DNS records properly configured for all domains
- Firewall rules allowing HTTP (80) and HTTPS (443) traffic
- Administrator privileges

### Dependencies
- .NET Framework 4.0 or higher
- PowerShell 5.1 or higher

## Variables

### Required Variables
```yaml
# Email for Let's Encrypt registration
winacme_email: "admin@yourdomain.com"

# Sites configuration
sites:
  - site: "example.com"
    https: 1
  - site: "test.example.com"
    https: 1
  - site: "api.example.com"
    https: 0

# Base paths
iis_apps_path: "D:\\WebApps"
downloads_dir: "C:\\temp"
```

### Optional Variables
```yaml
# WinAcme installation control
winacme_install: true

# WinAcme configuration
winacme_path: "C:\\Program Files\\win-acme"
winacme_store_location: "WebHosting"

# Certificate renewal settings
renewal_days: 55
renewal_time: "02:00:00"
```

## Variable Reference

| Variable | Description | Default Value | Required |
|----------|-------------|---------------|----------|
| `winacme_email` | Email for Let's Encrypt registration | - | Yes |
| `sites` | List of websites to manage | - | Yes |
| `iis_apps_path` | Base directory for web applications | `D:\\WebApps` | Yes |
| `downloads_dir` | Temporary download directory | `C:\\temp` | Yes |
| `winacme_install` | Enable WinAcme installation | `true` | No |
| `winacme_path` | WinAcme installation directory | `C:\\Program Files\\win-acme` | No |
| `winacme_store_location` | Certificate store location | `WebHosting` | No |

## Site Configuration Schema

```yaml
sites:
  - site: "domain.com"        # Domain name
    https: 1                  # 1 = Enable HTTPS, 0 = HTTP only
```

## Usage

### Basic Playbook
```yaml
- hosts: web_servers
  vars:
    winacme_email: "certificates@company.com"
    sites:
      - site: "www.company.com"
        https: 1
      - site: "api.company.com"
        https: 1
    iis_apps_path: "D:\\WebApps"
    downloads_dir: "C:\\temp"
  roles:
    - iis-winacme-management
```

### Advanced Configuration
```yaml
- hosts: web_servers
  vars:
    winacme_email: "ssl-admin@company.com"
    winacme_install: true
    winacme_store_location: "WebHosting"
    iis_apps_path: "E:\\Websites"
    sites:
      - site: "main.company.com"
        https: 1
      - site: "staging.company.com"
        https: 1
      - site: "internal.company.com"
        https: 0  # Internal site without SSL
  roles:
    - iis-winacme-management
```

## How It Works

### 1. IIS Installation (`install_iis.yml`)
- Installs IIS Web Server feature
- Installs IIS Management Console
- Configures essential services (W3SVC, WAS)
- Creates base directory structure
- Configures default application pool for .NET 4.0

### 2. WinAcme Installation (`install_winacme.yml`)
- Downloads latest WinAcme from GitHub releases
- Extracts and configures WinAcme
- Creates configuration file with Let's Encrypt settings
- Sets up automatic renewal scheduled task
- Adds WinAcme to system PATH

### 3. Site Management (`manage_sites.yml`)
- Inventories existing SSL certificates
- Generates new certificates for HTTPS-enabled sites
- Creates directory structure for each site
- Configures individual application pools
- Creates IIS websites with proper bindings
- Configures SSL bindings with SNI support

## Directory Structure

The role creates the following directory structure:

```
D:\WebApps\
├── site1.com\
├── site2.com\
└── site3.com\

D:\IIS-LOGS\
└── websites\
    ├── site1.com\
    ├── site2.com\
    └── site3.com\

C:\Program Files\win-acme\
├── wacs.exe
├── settings.json
└── [certificate cache]
```

## Certificate Management

### Automatic Generation
- Certificates are automatically generated for sites with `https: 1`
- Uses Let's Encrypt ACME v2 API
- Stores certificates in Windows Certificate Store (WebHosting)
- Creates friendly names matching domain names

### Renewal Process
- Scheduled task runs daily at 2:00 AM
- Certificates renewed 55 days before expiration
- Email notifications for renewal events
- Automatic IIS binding updates

### Manual Certificate Operations
```powershell
# Check certificate status
& "C:\Program Files\win-acme\wacs.exe" --list

# Force renewal
& "C:\Program Files\win-acme\wacs.exe" --renew --id [certificate-id]

# Create new certificate
& "C:\Program Files\win-acme\wacs.exe" --source manual --host "newsite.com"
```

## Logging Configuration

Each site is configured with:
- **Location**: `D:\IIS-LOGS\websites\[sitename]\`
- **Format**: W3C Extended Log Format
- **Rotation**: Hourly log files
- **Fields**: Standard IIS fields including date, time, client IP, method, URI, status

## Expected Output

```
TASK [Install IIS and management tools] ***************************************
changed: [web_server]

TASK [Verify IIS is running] ***************************************************
ok: [web_server]

TASK [Download WinAcme] ********************************************************
changed: [web_server]

TASK [Create SSL certificate for example.com] *********************************
changed: [web_server]

TASK [Create IIS website for example.com] *************************************
changed: [web_server]

TASK [Create HTTPS binding for example.com] ***********************************
changed: [web_server]
```

## Troubleshooting

### Common Issues

**Certificate Generation Fails:**
```bash
# Check DNS resolution
nslookup domain.com

# Verify HTTP challenge accessibility
curl http://domain.com/.well-known/acme-challenge/test

# Check WinAcme logs
Get-Content "C:\Program Files\win-acme\Logs\*.log" | Select-Object -Last 50
```

**IIS Site Not Starting:**
```powershell
# Check application pool status
Get-IISAppPool

# Verify site configuration
Get-IISSite

# Check Windows Event Logs
Get-EventLog -LogName System -Source "IIS*" -Newest 10
```

**SSL Binding Issues:**
```powershell
# List all SSL certificates
Get-ChildItem -Path Cert:\LocalMachine\WebHosting

# Check IIS bindings
Get-WebBinding

# Verify certificate thumbprint
netsh http show sslcert
```

### Log Locations

| Component | Log Location |
|-----------|--------------|
| IIS Access Logs | `D:\IIS-LOGS\websites\[site]\` |
| IIS Error Logs | `%SystemRoot%\System32\LogFiles\HTTPERR\` |
| WinAcme Logs | `C:\Program Files\win-acme\Logs\` |
| Windows Event Log | Event Viewer → Windows Logs → System |

## Security Considerations

- Certificates stored in Windows Certificate Store with proper ACLs
- Application pools run with ApplicationPoolIdentity
- Automatic security updates for certificates
- SNI enabled for multi-domain support
- Private keys marked as exportable for backup purposes

## Performance Optimization

- Individual application pools per site for isolation
- Structured logging with hourly rotation to prevent large files
- Efficient certificate lookup using thumbprint dictionary
- Minimal memory footprint with .NET 4.0 runtime

## Role Structure

```
roles/iis-winacme-management/
├── tasks/
│   ├── main.yml
│   ├── install_iis.yml
│   ├── install_winacme.yml
│   └── manage_sites.yml
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
- role: iis-winacme-management
  tags:
    - iis
    - web-server
    - ssl
    - certificates
    - winacme
    - letsencrypt
    - windows
```

## Integration Examples

### With Load Balancer
```yaml
- hosts: web_servers
  serial: 1  # Deploy one server at a time
  vars:
    sites:
      - site: "app.company.com"
        https: 1
  pre_tasks:
    # Remove from load balancer
  roles:
    - iis-winacme-management
  post_tasks:
    # Add back to load balancer
```

## Maintenance

### Regular Tasks
- Monitor certificate expiration dates
- Review WinAcme logs for renewal issues
- Update WinAcme to latest version quarterly
- Backup certificate store monthly
- Review IIS logs for errors

### Updates
- WinAcme updates: Download from [GitHub releases](https://github.com/win-acme/win-acme/releases)
- IIS updates: Install through Windows Update
- .NET Framework updates: Install latest security patches

## License

This role is available under the MIT license.

---

**Note:** This role requires proper DNS configuration and firewall rules for Let's Encrypt domain validation. Ensure all domains resolve correctly before running the playbook.