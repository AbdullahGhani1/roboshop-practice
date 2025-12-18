# Linux System Management: Quick Reference Guide

## Table of Contents

1. [Process Management](#process-management)
2. [Sudoers](#sudoers)
3. [User Management](#user-management)
4. [Package Management](#package-management)
5. [Service Management](#service-management)
6. [Permissions Management](#permissions-management)

---

## Process Management {#process-management}

### What is a Process?

Every command in Linux creates a **process** with a unique **PID** (Process ID).

### Viewing Processes

```bash
# Show processes in current session only
ps

# Show processes for current user
ps -u

# Show ALL processes (all users + system)
ps -e

# Show all processes with full details
ps -ef

# Filter specific process
ps -ef | grep ssh
ps -ef | grep nginx
```

**Common ps -ef Output:**

```
UID    PID  PPID  C STIME TTY      TIME CMD
root   1234 1     0 10:30 ?        00:00:01 /usr/sbin/sshd
nginx  5678 1234  0 10:31 ?        00:00:00 nginx: worker process
```

### Killing Processes

#### Normal Kill

```bash
# Run process in background
sleep 300 &

# Find PID
ps -ef | grep sleep

# Kill normally
kill <PID>

# Verify it's gone
ps -ef | grep sleep
```

#### Force Kill (-9)

Some processes ignore normal kill signals:

```bash
# Download test script
curl -s https://raw.githubusercontent.com/devopstrainings/linux-basics-katakoda/master/linux-adminstration/files/no-kill.sh -o /tmp/no-kill.sh

# Run in background
sh /tmp/no-kill.sh &

# Find PID
ps -ef | grep sleep

# Try normal kill (WON'T WORK)
kill <PID>

# Force kill (WORKS)
kill -9 <PID>
```

### Kill Signals

| Signal    | Number       | Description          | Use Case               |
| --------- | ------------ | -------------------- | ---------------------- |
| `SIGTERM` | 15 (default) | Graceful termination | Normal kill            |
| `SIGKILL` | 9            | Force kill           | When process won't die |
| `SIGHUP`  | 1            | Hangup/reload config | Reload without restart |

### Useful Process Commands

```bash
# Interactive process viewer
top

# Show process tree
ps -ef --forest
pstree

# Find process by name
pgrep nginx
pidof nginx

# Kill process by name
pkill nginx
killall nginx
```

### Self-Exploration Tasks

- What happens to child processes when parent is killed?
- What are zombie/orphan processes?
- How to set process priority (nice/renice)?
- Explore `top`, `htop`, `ps aux`

---

## Sudoers {#sudoers}

### Why Sudo?

- **Don't login as root** for security
- Login as normal user, execute commands as root
- Provides audit trail

### Basic Usage

```bash
# This will FAIL (no permissions)
kill <pid-of-other-user>

# This will WORK (with sudo privileges)
sudo kill <pid-of-other-user>
```

### Common Sudo Commands

```bash
# Run command as root
sudo command

# Run command as specific user
sudo -u username command

# Switch to root shell
sudo -i
sudo su -

# Edit files requiring root
sudo vi /etc/ssh/sshd_config
sudo nano /etc/hosts

# Run previous command with sudo
sudo !!
```

### Check Sudo Privileges

```bash
# List your sudo privileges
sudo -l

# Check if you have sudo access
sudo -v
```

### Adding Users to Sudoers

**Ubuntu/Debian:**

```bash
sudo usermod -aG sudo username
```

**CentOS/RHEL:**

```bash
sudo usermod -aG wheel username
```

**Manual edit (advanced):**

```bash
sudo visudo
# Add: username ALL=(ALL) NOPASSWD: ALL
```

### Privilege Escalation Tools

- **sudo** - Default, widely used
- **PowerBroker** - Enterprise solution
- **Centrify** - Identity management
- More: https://www.sudo.ws/other.html

**Note:** In production, user privileges are managed via **SSO** (Single Sign-On) systems.

---

## User Management {#user-management}

### Why Create Users?

- Applications should run as **normal users**, not root
- Security best practice (CIS Benchmark)
- Limits damage if compromised

### Adding Users

```bash
# Create user
sudo useradd sample

# Verify user creation
id sample
# Output: uid=1001(sample) gid=1001(sample) groups=1001(sample)

# Create user with home directory
sudo useradd -m username

# Create user with specific shell
sudo useradd -s /bin/bash username
```

### User Information

```bash
# Check user details
id username

# Check all users
cat /etc/passwd

# Check user groups
groups username
```

### Setting Passwords

```bash
# Set password for user
sudo passwd username

# Set password for yourself
passwd
```

### Application Users (Functional Users)

Application users typically **don't have passwords** (security standard):

```bash
# Create system user (no home, no login)
sudo useradd -r -s /sbin/nologin appuser

# Example: Check system service users
ps -ef | grep httpd
ps -ef | grep nginx
ps -ef | grep mysql
```

### Common Service Users

```bash
# Install services for testing
curl -s https://raw.githubusercontent.com/devopstrainings/linux-basics-katakoda/master/linux-adminstration/files/daemon-services.sh | sudo bash

# Check which user runs services
ps -ef | grep httpd      # Runs as 'apache' or 'www-data'
ps -ef | grep tomcat     # Runs as 'tomcat'
ps -ef | grep mariadb    # Runs as 'mysql'
```

### User Management Commands

```bash
# Delete user
sudo userdel username

# Delete user with home directory
sudo userdel -r username

# Modify user
sudo usermod -s /bin/zsh username

# Lock user account
sudo usermod -L username

# Unlock user account
sudo usermod -U username
```

---

## Package Management {#package-management}

### Package Managers by OS

| OS Family     | Package Manager   | Package Format |
| ------------- | ----------------- | -------------- |
| RedHat/CentOS | `dnf` / `yum`     | `.rpm`         |
| Ubuntu/Debian | `apt` / `apt-get` | `.deb`         |
| Arch Linux    | `pacman`          | `.pkg.tar.xz`  |

**Focus:** RedHat family (CentOS) using **dnf**

### Listing Packages

```bash
# List installed packages
sudo dnf list installed

# List available packages (not installed)
sudo dnf list available

# List all packages (installed + available)
sudo dnf list all

# Search for specific package
sudo dnf list all | grep nginx
```

### Installing Packages

```bash
# Install package (with confirmation prompt)
sudo dnf install nginx

# Install without prompt
sudo dnf install nginx -y

# Install specific version
sudo dnf install nginx-1.20.0 -y

# Install from URL
sudo dnf install https://pkg.jenkins.io/redhat-stable/jenkins-2.190.2-1.1.noarch.rpm -y
```

### Removing Packages

```bash
# Remove package
sudo dnf remove nginx -y

# Remove with dependencies
sudo dnf autoremove nginx -y
```

### Updating Packages

```bash
# Update specific package
sudo dnf update nginx -y

# Update all packages
sudo dnf update -y

# Check for updates
sudo dnf check-update
```

### Package Information

```bash
# Show package info
sudo dnf info nginx

# Search packages
sudo dnf search nginx

# Show package dependencies
sudo dnf deplist nginx
```

### Repository Management

Repositories are configured in `/etc/yum.repos.d/*.repo`

```bash
# List repositories
sudo dnf repolist

# Check repo files
ls /etc/yum.repos.d/

# Add new repository (Jenkins example)
sudo curl https://pkg.jenkins.io/redhat-stable/jenkins.repo -o /etc/yum.repos.d/jenkins.repo

# Import GPG key
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key

# Now Jenkins is available
sudo dnf list | grep jenkins
sudo dnf install jenkins -y
```

### Common Package Operations

```bash
# Clean cache
sudo dnf clean all

# List package files
rpm -ql nginx

# Check which package owns a file
rpm -qf /usr/sbin/nginx

# Verify package integrity
rpm -V nginx
```

---

## Service Management {#service-management}

### What are Services?

Services (daemons) run continuously in the background, unlike foreground commands that exit when session closes.

### Service Manager: systemctl

Modern Linux uses **systemd** with `systemctl` command.

### Listing Services

```bash
# List all services
sudo systemctl list-units -t service

# List running services only
sudo systemctl list-units -t service --state=running

# List failed services
sudo systemctl list-units -t service --state=failed
```

### Managing Services

```bash
# Check service status
sudo systemctl status nginx

# Start service
sudo systemctl start nginx

# Stop service
sudo systemctl stop nginx

# Restart service
sudo systemctl restart nginx

# Reload configuration (without restart)
sudo systemctl reload nginx

# Enable service (start at boot)
sudo systemctl enable nginx

# Disable service (don't start at boot)
sudo systemctl disable nginx

# Enable and start immediately
sudo systemctl enable --now nginx
```

### Service Status Information

```bash
sudo systemctl status nginx
```

**Output shows:**

- Active status (running/stopped)
- Main PID
- Memory usage
- Recent logs
- **Enabled/Disabled** for boot startup

### Common Service Commands

```bash
# Check if service is active
sudo systemctl is-active nginx

# Check if service is enabled
sudo systemctl is-enabled nginx

# Check if service failed
sudo systemctl is-failed nginx

# Show service logs
sudo journalctl -u nginx

# Follow service logs (real-time)
sudo journalctl -u nginx -f
```

### Boot Startup

```bash
# Before enabling
sudo systemctl status nginx
# Shows: "disabled" in output

# Enable for boot startup
sudo systemctl enable nginx

# After enabling
sudo systemctl status nginx
# Shows: "enabled" in output

# Disable boot startup
sudo systemctl disable nginx
```

### Creating Custom Services

**Note:** If software doesn't come with systemd service file, you can create one. (Covered in future classes)

Basic service file location: `/etc/systemd/system/myapp.service`

---

## Permissions Management {#permissions-management}

### Two Aspects of File Properties

1. **File Ownership** (who owns the file)
2. **File Permissions** (what they can do)

### File Ownership

Every file has:

- **Owner** (user)
- **Group Owner** (group)

### Viewing Ownership

```bash
# Create test file
touch sample.txt

# View ownership
ls -l sample.txt
# Output: -rw-r--r-- 1 username groupname 0 Dec 17 10:30 sample.txt
#         ^          ^ ^        ^
#         |          | |        |
#         permissions owner   group
```

### Changing Ownership

#### Change Owner (chown)

```bash
# Change owner only
sudo chown centos sample.txt

# Verify
ls -l sample.txt
```

#### Change Group (chgrp)

```bash
# Create group first
sudo groupadd devops

# Change group
sudo chgrp devops sample.txt

# Verify
ls -l sample.txt
```

#### Change Both at Once

```bash
# Change owner and group together
sudo chown centos:devops sample.txt
ls -l sample.txt

# Change back to root
sudo chown root:root sample.txt
ls -l sample.txt
```

#### Recursive Change (for directories)

```bash
# Change ownership recursively
sudo chown -R username:groupname /path/to/directory
```

### File Permissions

#### Permission Types

- **r** = read (4)
- **w** = write (2)
- **x** = execute (1)

#### Owner Types

- **u** = user (owner)
- **g** = group
- **o** = others

### Understanding Permission Output

```
-rw-r--r--  1 root root 0 Dec 17 10:30 sample.txt
│││ │ │ │
│││ │ │ └── Others permissions (r--)
│││ │ └──── Group permissions (r--)
│││ └────── Owner permissions (rw-)
││└──────── Number of hard links
│└───────── File type (- = file, d = directory, l = link)
└────────── First dash is file type indicator
```

**Permission Breakdown:**

```
-rw-r--r--
 │  │  │
 │  │  └── Others: read only
 │  └───── Group: read only
 └──────── Owner: read + write
```

### Changing Permissions (chmod)

#### Symbolic Method

```bash
# Create test file
touch sample.txt
ls -l sample.txt

# Add permissions
chmod u+x sample.txt      # Owner can execute
chmod g+w sample.txt      # Group can write
chmod o+r sample.txt      # Others can read

# Remove permissions
chmod u-x sample.txt      # Remove execute from owner
chmod g-w sample.txt      # Remove write from group

# Set exact permissions
chmod u=rw sample.txt     # Owner: read+write only
chmod g=r sample.txt      # Group: read only
chmod o= sample.txt       # Others: no permissions

# Multiple changes at once
chmod u+rwx,g+rx,o+r sample.txt

# Give all permissions to everyone
chmod ugo+rwx sample.txt
ls -l sample.txt
# Output: -rwxrwxrwx
```

#### Numeric Method (Octal)

**Permission Values:**

- r = 4
- w = 2
- x = 1

**Common Permissions:**

```bash
chmod 755 sample.txt    # rwxr-xr-x (common for executables)
chmod 644 sample.txt    # rw-r--r-- (common for files)
chmod 600 sample.txt    # rw------- (private files)
chmod 700 sample.txt    # rwx------ (private executables)
chmod 777 sample.txt    # rwxrwxrwx (all permissions - avoid!)
```

**How Numeric Works:**

```
chmod 755 sample.txt
      ││└── Others: r-x (4+0+1 = 5)
      │└─── Group:  r-x (4+0+1 = 5)
      └──── Owner:  rwx (4+2+1 = 7)
```

### Directory Permissions

Directories need **execute (x)** permission to be accessed:

```bash
# Create directory
mkdir testdir

# Remove execute permission
chmod -x testdir

# Try to access (FAILS)
cd testdir

# Restore execute
chmod +x testdir

# Now works
cd testdir
```

### Recursive Permissions

```bash
# Change permissions recursively
chmod -R 755 /path/to/directory

# Change ownership and permissions
sudo chown -R www-data:www-data /var/www/html
sudo chmod -R 755 /var/www/html
```

### Common Permission Scenarios

#### Web Server Files

```bash
# Web files (Apache/Nginx)
sudo chown -R www-data:www-data /var/www/html
sudo chmod -R 644 /var/www/html/*.html
sudo chmod -R 755 /var/www/html  # Directories
```

#### Application Files

```bash
# Application owned by app user
sudo chown -R appuser:appuser /opt/myapp
sudo chmod -R 750 /opt/myapp
```

#### Private Files

```bash
# SSH keys
chmod 600 ~/.ssh/id_rsa
chmod 644 ~/.ssh/id_rsa.pub
chmod 700 ~/.ssh
```

#### Scripts

```bash
# Make script executable
chmod +x script.sh
chmod 755 script.sh
```

---

## Quick Reference

### Process Management

```bash
ps -ef | grep process     # Find process
kill <PID>                # Normal kill
kill -9 <PID>             # Force kill
top                       # Interactive monitor
```

### User & Permissions

```bash
sudo useradd username           # Add user
sudo chown user:group file      # Change ownership
chmod 755 file                  # Change permissions
```

### Package Management

```bash
sudo dnf install package -y     # Install
sudo dnf remove package -y      # Remove
sudo dnf update -y              # Update all
```

### Service Management

```bash
sudo systemctl start service    # Start
sudo systemctl stop service     # Stop
sudo systemctl enable service   # Auto-start at boot
sudo systemctl status service   # Check status
```

---

**Document Version:** 1.0  
**Last Updated:** December 17, 2025  
**Target Audience:** Linux Administrators, DevSecOps Engineers
