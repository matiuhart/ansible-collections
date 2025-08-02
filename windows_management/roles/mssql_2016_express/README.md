# Role: SQL Server 2016 Express Installation

## Description

This Ansible role automates the installation and configuration of Microsoft SQL Server 2016 Express Edition on Windows systems. The role handles the complete setup process including service configuration, TCP/IP protocol enablement, port configuration, and basic security settings with SQL Server Authentication.

## Features

- ✅ Automated SQL Server 2016 Express download and installation
- ✅ Custom instance configuration
- ✅ TCP/IP protocol enablement
- ✅ Custom port configuration (default: 1433)
- ✅ SQL Server Authentication with SA account
- ✅ Automatic service startup configuration
- ✅ Post-installation connectivity verification
- ✅ Idempotent operations (skip if already installed)

## Requirements

### Operating System
- Windows Server 2012 R2 or higher
- Windows 8.1 or higher

### Prerequisites
- .NET Framework 4.6 or higher
- At least 4 GB RAM (8 GB recommended)
- At least 6 GB free disk space
- Administrator privileges

### Dependencies
- PowerShell 5.1 or higher
- Internet connection for installer download

## Variables

### Required Variables
```yaml
# SQL Server instance name
mssql_instance_name: "SQLEXPRESS"

# SA account password (must be strong)
mssql_sa_password: "YourStrongPassword123!"

# Downloads directory
downloads_dir: "C:\\temp"
```

### Optional Variables
```yaml
# TCP port for SQL Server
mssql_tcp_port: "1433"

# Installation timeout (seconds)
sql_install_timeout: 1800

# Service startup configuration
mssql_service_startup: "Automatic"
```

## Variable Reference

| Variable | Description | Default Value | Required |
|----------|-------------|---------------|----------|
| `mssql_instance_name` | SQL Server instance name | `SQLEXPRESS` | Yes |
| `mssql_sa_password` | SA account password | - | Yes |
| `downloads_dir` | Temporary download directory | `C:\\temp` | Yes |
| `mssql_tcp_port` | TCP port for connections | `1433` | No |
| `sql_install_timeout` | Installation timeout in seconds | `1800` | No |

## Password Requirements

The SA password must meet SQL Server's complexity requirements:
- At least 8 characters long
- Contains characters from at least 3 of these categories:
  - Uppercase letters (A-Z)
  - Lowercase letters (a-z)
  - Numbers (0-9)
  - Special characters (!@#$%^&*)

## Usage

### Basic Installation
```yaml
- hosts: database_servers
  vars:
    mssql_instance_name: "SQLEXPRESS"
    mssql_sa_password: "MySecurePassword123!"
    downloads_dir: "C:\\temp"
  roles:
    - mssql_2016_express
```

### Custom Configuration
```yaml
- hosts: database_servers
  vars:
    mssql_instance_name: "PRODUCTION"
    mssql_sa_password: "{{ vault_sql_sa_password }}"  # Use Ansible Vault
    mssql_tcp_port: "1433"
    downloads_dir: "D:\\Downloads"
  roles:
    - mssql_2016_express
```

### Multiple Instances
```yaml
- hosts: database_servers
  tasks:
    - name: Install first SQL instance
      include_role:
        name: mssql_2016_express
      vars:
        mssql_instance_name: "INSTANCE01"
        mssql_sa_password: "Password123!"
        mssql_tcp_port: "1433"
    
    - name: Install second SQL instance
      include_role:
        name: mssql_2016_express
      vars:
        mssql_instance_name: "INSTANCE02"
        mssql_sa_password: "Password456!"
        mssql_tcp_port: "1434"
```

## How It Works

### 1. Pre-Installation Check
- Verifies if SQL Server service already exists
- Displays current installation status
- Skips installation if already present

### 2. Download and Installation
- Downloads SQL Server 2016 Express installer from Microsoft
- Creates configuration file with specified parameters
- Executes silent installation with custom settings

### 3. Service Configuration
- Configures SQL Server service for automatic startup
- Waits for service to become available
- Enables TCP/IP protocol for network connections

### 4. Network Configuration
- Sets custom TCP port (default: 1433)
- Updates registry settings for network protocols
- Restarts SQL Server service if port changes

### 5. Post-Installation Verification
- Tests connectivity using sqlcmd
- Verifies SA account authentication
- Confirms successful installation

## Installation Features

The role installs SQL Server with these features:
- **SQLENGINE**: Database Engine Services
- **CONN**: Client Tools Connectivity
- **IS**: Integration Services
- **BC**: Client Tools Backwards Compatibility
- **SDK**: Client Tools SDK
- **BOL**: Documentation Components

## Security Configuration

### Authentication Mode
- **Mixed Mode**: Both Windows and SQL Server Authentication
- SA account enabled with custom password
- BUILTIN\Administrators added as SQL Server administrators

### Network Security
- TCP/IP protocol enabled for remote connections
- Named Pipes disabled by default
- SQL Browser service disabled for security

## Expected Output

```
TASK [Show SQL Server status] **************************************************
ok: [db_server] => {
    "msg": "SQL Server SQLEXPRESS: Not installed"
}

TASK [Download SQL Server 2016 Express] ***************************************
changed: [db_server]

TASK [Create configuration file for SQL Server] *******************************
changed: [db_server]

TASK [Install SQL Server 2016 Express] ****************************************
changed: [db_server]

TASK [Wait for SQL Server service to be available] ****************************
ok: [db_server]

TASK [Configure TCP port for SQL Server] **************************************
changed: [db_server]

TASK [Restart SQL Server service] *********************************************
changed: [db_server]

TASK [Verify SQL Server connection] *******************************************
ok: [db_server]

TASK [Show installation result] ***********************************************
ok: [db_server] => {
    "msg": "✓ SQL Server 2016 Express installed and configured correctly"
}
```

## Directory Structure

Post-installation directory structure:
```
C:\Program Files\Microsoft SQL Server\
├── MSSQL13.SQLEXPRESS\
│   ├── MSSQL\
│   │   ├── DATA\           # Database files
│   │   └── LOG\            # Transaction logs
│   └── Tools\
├── 130\                    # Shared components
└── Client SDK\
```

## Service Management

### Services Created
| Service Name | Display Name | Startup Type |
|--------------|--------------|--------------|
| `MSSQL$SQLEXPRESS` | SQL Server (SQLEXPRESS) | Automatic |
| `SQLAgent$SQLEXPRESS` | SQL Server Agent (SQLEXPRESS) | Manual |

### Service Commands
```powershell
# Check service status
Get-Service -Name "MSSQL$SQLEXPRESS"

# Start/Stop service
Start-Service -Name "MSSQL$SQLEXPRESS"
Stop-Service -Name "MSSQL$SQLEXPRESS"

# Restart service
Restart-Service -Name "MSSQL$SQLEXPRESS"
```

## Connection Information

### Local Connection
```sql
-- Windows Authentication
sqlcmd -S .\SQLEXPRESS

-- SQL Server Authentication
sqlcmd -S .\SQLEXPRESS -U sa -P "YourPassword"
```

### Remote Connection
```sql
-- Using server name and instance
sqlcmd -S "SERVERNAME\SQLEXPRESS" -U sa -P "YourPassword"

-- Using IP and port
sqlcmd -S "192.168.1.100,1433" -U sa -P "YourPassword"
```

## Troubleshooting

### Installation Issues

**Download Fails:**
```yaml
# Check internet connectivity
- name: Test Microsoft download site
  win_uri:
    url: https://download.microsoft.com
    method: GET
```

**Installation Timeout:**
```yaml
# Increase timeout value
vars:
  sql_install_timeout: 3600  # 1 hour
```

**Insufficient Disk Space:**
```powershell
# Check available space
Get-WmiObject -Class Win32_LogicalDisk | Select-Object DeviceID, FreeSpace
```

### Service Issues

**Service Won't Start:**
```powershell
# Check Windows Event Log
Get-EventLog -LogName Application -Source "MSSQLSERVER" -Newest 10

# Check SQL Server Error Log
Get-Content "C:\Program Files\Microsoft SQL Server\MSSQL13.SQLEXPRESS\MSSQL\Log\ERRORLOG"
```

**Port Configuration Issues:**
```powershell
# Check current port configuration
Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server\MSSQL13.SQLEXPRESS\MSSQLServer\SuperSocketNetLib\Tcp\IPAll"

# Test port connectivity
Test-NetConnection -ComputerName localhost -Port 1433
```

### Connection Issues

**TCP/IP Not Enabled:**
```sql
-- Enable TCP/IP using SQL Server Configuration Manager
-- Or restart the role to reconfigure
```

**Firewall Blocking:**
```powershell
# Add firewall rule
New-NetFirewallRule -DisplayName "SQL Server" -Direction Inbound -Protocol TCP -LocalPort 1433 -Action Allow
```

**Authentication Failures:**
```sql
-- Verify SA account is enabled
SELECT name, is_disabled FROM sys.server_principals WHERE name = 'sa'

-- Reset SA password if needed
ALTER LOGIN sa WITH PASSWORD = 'NewPassword123!'
ALTER LOGIN sa ENABLE
```

## Performance Tuning

### Memory Configuration
```sql
-- Set maximum server memory (MB)
EXEC sp_configure 'max server memory', 2048
RECONFIGURE
```

### Security Hardening
```sql
-- Disable SA account after creating other admin accounts
ALTER LOGIN sa DISABLE

-- Remove BUILTIN\Administrators
DROP LOGIN [BUILTIN\Administrators]
```

## Backup Considerations

### Default Backup Location
```
C:\Program Files\Microsoft SQL Server\MSSQL13.SQLEXPRESS\MSSQL\Backup\
```

### Automated Backup Setup
```sql
-- Create maintenance plan or scheduled jobs
-- Consider third-party backup solutions for production
```

## Role Structure

```
roles/mssql_2016_express/
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
- role: mssql_2016_express
  tags:
    - database
    - mssql
    - sql-server
    - sql-server-2016
    - express
    - windows
```

## Security Best Practices

1. **Use Ansible Vault** for storing SA passwords
2. **Create dedicated service accounts** instead of using built-in accounts
3. **Disable SA account** after creating other admin accounts
4. **Configure Windows Firewall** to restrict database access
5. **Enable SQL Server audit** for compliance requirements
6. **Regular security updates** through Windows Update

## Integration Examples

### With Application Deployment
```yaml
- hosts: app_servers
  roles:
    - mssql_2016_express
    - deploy_application
  vars:
    app_connection_string: "Server={{ ansible_hostname }}\\{{ mssql_instance_name }};Database=AppDB;User Id=AppUser;Password={{ app_db_password }}"
```

### With Backup Configuration
```yaml
- hosts: database_servers
  roles:
    - mssql_2016_express
  post_tasks:
    - name: Create backup directory
      win_file:
        path: "D:\\SQLBackups"
        state: directory
    
    - name: Configure backup maintenance plan
      win_shell: |
        sqlcmd -S ".\{{ mssql_instance_name }}" -Q "CREATE DATABASE BackupTest"
```

## Maintenance

### Regular Tasks
- Monitor SQL Server error logs
- Apply SQL Server cumulative updates
- Review and optimize database performance
- Backup system databases regularly
- Monitor disk space usage

### Updates
- SQL Server 2016 reached end of mainstream support in 2022
- Consider migrating to SQL Server 2019 or later
- Apply latest cumulative updates for security patches

## License

This role is available under the MIT license.

---

**Note:** SQL Server 2016 Express has limitations including 10 GB maximum database size, 1 GB maximum memory usage, and 4 cores maximum. Consider SQL Server Standard or Enterprise for production workloads with higher requirements.