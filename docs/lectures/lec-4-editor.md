# Linux File Editors: A Comprehensive DevSecOps Guide

## Table of Contents

1. [Introduction](#introduction)
2. [Overview of Linux Editors](#overview)
3. [Vi/Vim Editor - Essential Guide](#vi-editor)
4. [Sed Editor - Stream Editor for Automation](#sed-editor)
5. [Other Linux Editors](#other-editors)
6. [Real-World DevSecOps Scenarios](#real-world-scenarios)
7. [Best Practices](#best-practices)
8. [Troubleshooting](#troubleshooting)

---

## Introduction {#introduction}

Linux provides multiple text editors for file manipulation and configuration management. As a DevSecOps professional or Linux administrator, understanding these editors is crucial for system configuration, troubleshooting, and automation workflows.

**Key Editors in Linux:**

- **vi/vim** - Universal, powerful, default on most systems
- **sed** - Stream editor for automation and batch processing
- **nano** - User-friendly, beginner-oriented
- **emacs** - Feature-rich, extensible
- **gedit** - GUI-based editor

### Why Multiple Editors?

Different editors serve different purposes:

- **Interactive editing**: vi, nano, emacs
- **Automated editing**: sed, awk
- **GUI environments**: gedit, kate, sublime
- **Emergency recovery**: vi (always available)

---

## Overview of Linux Editors {#overview}

### Editor Availability by System

| Editor | Default on Most Systems | Availability          | Use Case                  |
| ------ | ----------------------- | --------------------- | ------------------------- |
| vi/vim | ✅ Yes (~90%)           | Universal             | System administration     |
| sed    | ✅ Yes                  | Universal             | Automation scripts        |
| nano   | ❌ No (often installed) | Common                | Beginner-friendly editing |
| emacs  | ❌ No                   | Requires installation | Advanced development      |
| gedit  | ❌ No                   | GUI environments only | Desktop editing           |

### DevSecOps Editing Philosophy

In modern DevSecOps practices, direct server editing is minimized:

```yaml
Traditional Approach:
  - SSH to server
  - Edit configuration files directly
  - Test changes
  - Risk: Human error, no version control

Modern DevSecOps Approach:
  - Edit code locally in IDE (VSCode, IntelliJ)
  - Version control (Git)
  - Automated deployment via CI/CD
  - Configuration management (Ansible, Terraform)
  - Minimal manual server changes
```

**Key Principles:**

1. **Local Development First**: Edit on local desktop with full IDE support
2. **Version Control**: All changes tracked in Git
3. **Automation Over Manual**: Use configuration management tools
4. **Immutable Infrastructure**: Replace, don't modify servers
5. **Emergency Only**: Direct server editing for troubleshooting only

**When to Use Each Approach:**

```javascript
// Local IDE Editing (90% of work)
1. Application code development
2. Configuration file creation
3. Script writing
4. Documentation

// Direct Server Editing with vi (10% of work)
1. Emergency troubleshooting
2. Quick configuration fixes
3. Log file inspection
4. System recovery

// Automated Editing with sed (Automation scripts)
1. CI/CD pipeline modifications
2. Deployment scripts
3. Configuration template processing
4. Bulk file updates
```

---

## Vi/Vim Editor - Essential Guide {#vi-editor}

### Overview

`vi` (Visual Editor) is the most universal text editor in Linux/Unix systems. It's guaranteed to be present on virtually every Linux distribution, making it essential for system administrators and DevSecOps engineers.

**Key Characteristics:**

- **Modal editor**: Different modes for different operations
- **Lightweight**: Fast startup, minimal resources
- **Universal**: Available on all Unix-like systems
- **Powerful**: Extensive commands and capabilities
- **Terminal-based**: Works over SSH, no GUI needed

### Vi Operating Modes

Vi operates in three primary modes:

| Mode             | Purpose                       | How to Enter                  |
| ---------------- | ----------------------------- | ----------------------------- |
| **Command Mode** | Navigate and execute commands | `ESC` key (default mode)      |
| **Insert Mode**  | Type and edit text            | `i`, `I`, `a`, `A`, `o`, `O`  |
| **Ex Mode**      | Execute extended commands     | `:` (colon) from command mode |

### Basic Vi Workflow

#### Opening a File

```bash
vi filename.txt          # Open existing file or create new
vi +10 filename.txt      # Open at line 10
vi +/pattern filename.txt # Open at first occurrence of pattern
```

#### Standard Editing Workflow

**Method 1: Basic Edit and Save**

```bash
1. vi file              # Open file
2. Press 'i' or 'Insert' # Enter Insert mode
3. Make your changes    # Edit the content
4. Press 'ESC'          # Return to Command mode
5. Type ':wq'           # Write and quit
6. Press 'Enter'        # Execute command
```

**Method 2: Edit Without Saving**

```bash
1. vi file              # Open file
2. Press 'i' or 'Insert' # Enter Insert mode
3. Make your changes    # Edit the content
4. Press 'ESC'          # Return to Command mode
5. Type ':q!'           # Quit without saving
6. Press 'Enter'        # Execute command
```

### Essential Vi Commands

#### Entering Insert Mode

| Command | Description                 |
| ------- | --------------------------- |
| `i`     | Insert before cursor        |
| `I`     | Insert at beginning of line |
| `a`     | Append after cursor         |
| `A`     | Append at end of line       |
| `o`     | Open new line below         |
| `O`     | Open new line above         |
| `s`     | Substitute character        |
| `S`     | Substitute line             |

#### Navigation Commands (Command Mode)

| Command | Description               |
| ------- | ------------------------- |
| `h`     | Move left                 |
| `j`     | Move down                 |
| `k`     | Move up                   |
| `l`     | Move right                |
| `0`     | Move to beginning of line |
| `$`     | Move to end of line       |
| `gg`    | Go to first line          |
| `G`     | Go to last line           |
| `10G`   | Go to line 10             |
| `w`     | Move forward one word     |
| `b`     | Move backward one word    |

#### Editing Commands (Command Mode)

| Command  | Description                       |
| -------- | --------------------------------- |
| `x`      | Delete character under cursor     |
| `X`      | Delete character before cursor    |
| `dd`     | Delete entire line                |
| `5dd`    | Delete 5 lines                    |
| `dw`     | Delete word                       |
| `D`      | Delete from cursor to end of line |
| `yy`     | Copy (yank) line                  |
| `5yy`    | Copy 5 lines                      |
| `p`      | Paste after cursor                |
| `P`      | Paste before cursor               |
| `u`      | Undo last change                  |
| `Ctrl+r` | Redo                              |

#### Search Commands

| Command    | Description                  |
| ---------- | ---------------------------- |
| `/pattern` | Search forward for pattern   |
| `?pattern` | Search backward for pattern  |
| `n`        | Repeat search forward        |
| `N`        | Repeat search backward       |
| `*`        | Search for word under cursor |

#### Save and Exit Commands (Ex Mode)

| Command       | Description                        |
| ------------- | ---------------------------------- |
| `:w`          | Save (write) file                  |
| `:w filename` | Save as filename                   |
| `:q`          | Quit (fails if unsaved changes)    |
| `:q!`         | Quit without saving                |
| `:wq`         | Save and quit                      |
| `:x`          | Save and quit (only if changes)    |
| `ZZ`          | Save and quit (command mode)       |
| `ZQ`          | Quit without saving (command mode) |

### Practical Vi Examples

#### Example 1: Edit SSH Configuration

```bash
# Open SSH config file
sudo vi /etc/ssh/sshd_config

# Navigate to line with Port
/Port

# Press 'i' to enter insert mode
# Change: Port 22
# To:     Port 2222

# Press ESC
# Type: :wq
# Press Enter
```

#### Example 2: Quick Comment Addition

```bash
# Open configuration file
vi /etc/nginx/nginx.conf

# Navigate to line to comment
# Press 'I' (insert at beginning)
# Type '#' to comment
# Press ESC
# Type: :wq
```

#### Example 3: Search and Replace

```bash
# Open file
vi logfile.txt

# In Ex mode, replace all occurrences
:%s/ERROR/WARNING/g

# Save and exit
:wq
```

### Vi Search and Replace

#### Basic Syntax

```vim
:[range]s/pattern/replacement/[flags]
```

#### Examples

| Command             | Description                              |
| ------------------- | ---------------------------------------- |
| `:s/old/new/`       | Replace first occurrence in current line |
| `:s/old/new/g`      | Replace all occurrences in current line  |
| `:%s/old/new/g`     | Replace all occurrences in file          |
| `:%s/old/new/gc`    | Replace with confirmation                |
| `:10,20s/old/new/g` | Replace in lines 10-20                   |
| `:%s/old/new/gi`    | Replace case-insensitive                 |

### Vi Configuration Tips

#### Minimal Vi Skills for DevSecOps

**Focus on these essential operations (80/20 rule):**

✅ **Must Know:**

1. Open file: `vi filename`
2. Enter insert mode: `i`
3. Exit insert mode: `ESC`
4. Save and quit: `:wq`
5. Quit without saving: `:q!`
6. Navigate: Arrow keys
7. Delete line: `dd`
8. Undo: `u`

⚠️ **Nice to Know:**

- Advanced navigation
- Macros and registers
- Visual mode
- Split windows
- Plugins

**Time Investment Recommendation:**

- Spend 1-2 hours learning basics
- Practice with real configuration files
- Learn advanced features later when needed
- Focus on automation with sed for bulk operations

### Creating .vimrc Configuration

```bash
# Create basic vim configuration
cat > ~/.vimrc << 'EOF'
" Basic settings
set number              " Show line numbers
set tabstop=4          " Tab width
set shiftwidth=4       " Indent width
set expandtab          " Use spaces instead of tabs
set autoindent         " Auto indent
set hlsearch           " Highlight search results
set ignorecase         " Case insensitive search
set smartcase          " Smart case search
syntax on              " Enable syntax highlighting

" Easier navigation
nnoremap <C-j> 5j
nnoremap <C-k> 5k

" Quick save and quit
nnoremap <C-s> :w<CR>
EOF
```

### Vi Troubleshooting

#### Common Issues

**1. Stuck in Insert Mode**

```
Problem: Can't execute commands
Solution: Press ESC key multiple times
```

**2. Can't Save File (Permission Denied)**

```bash
# While in vi, write with sudo
:w !sudo tee %

# Or quit and reopen with sudo
:q!
sudo vi filename
```

**3. Accidental Changes, Can't Exit**

```
Solution: :q! (quit without saving)
```

**4. File Being Edited by Another Process**

```bash
# Vi shows: Swap file found
# Options:
# O - Open read-only
# E - Edit anyway
# R - Recover
# Q - Quit
# D - Delete swap file (if you're sure)
```

**5. Remove Swap File**

```bash
# List swap files
ls -la .*.swp

# Remove if not needed
rm .filename.swp
```

---

## Sed Editor - Stream Editor for Automation {#sed-editor}

### Overview

`sed` (Stream Editor) is a powerful command-line tool for parsing and transforming text. Unlike interactive editors, sed is designed for **automated text processing** in scripts and pipelines.

**Key Characteristics:**

- **Non-interactive**: Processes text automatically
- **Stream-oriented**: Works with text streams (pipes)
- **Scriptable**: Perfect for automation and CI/CD
- **Fast**: Efficient for large files
- **Universal**: Available on all Linux systems

### Why Sed for DevSecOps?

```yaml
DevOps/DevSecOps Automation Needs:
  Configuration Management:
    - Update application configs during deployment
    - Modify environment variables
    - Template processing

  CI/CD Pipelines:
    - Version number updates
    - Configuration file modifications
    - Build script adjustments

  System Administration:
    - Batch configuration updates
    - Log file processing
    - Security hardening scripts
```

### Sed Basic Syntax

```bash
sed [OPTIONS] 'command' [FILE]
sed [OPTIONS] -e 'command1' -e 'command2' [FILE]
```

**Common Options:**

- `-i` : Edit file in-place (modify original file)
- `-i.bak` : Edit in-place with backup
- `-e` : Execute multiple commands
- `-n` : Suppress automatic printing

### Core Sed Operations

#### 1. Search and Replace

**Basic Syntax:**

```bash
sed 's|PATTERN|REPLACEMENT|[FLAGS]' file
```

**Delimiters:** You can use any delimiter (/, |, #, @)

```bash
sed 's/old/new/' file          # Using /
sed 's|old|new|' file           # Using |
sed 's#old#new#' file           # Using #
sed 's@old@new@' file           # Using @
```

**Why use different delimiters?**

```bash
# Problem: Lots of escaping needed
sed 's/\/usr\/local\/bin/\/opt\/bin/' file

# Solution: Use | delimiter for paths
sed 's|/usr/local/bin|/opt/bin|' file
```

#### Example 1: Simple Replacement

```bash
# Replace 'nologin' with 'yeslogin'
sed 's|nologin|yeslogin|' /etc/passwd

# With -i to modify file
sed -i 's|nologin|yeslogin|' /etc/passwd
```

#### Example 2: Global Replacement (Replace All)

```bash
# Replace only first occurrence per line
sed 's|root|ADMIN|' passwd

# Replace all occurrences per line (g flag)
sed 's|root|ADMIN|g' passwd
```

**Output Comparison:**

```
Original line:
root:x:0:0:root:/root:/bin/bash

Without 'g' flag (s|root|ADMIN|):
ADMIN:x:0:0:root:/root:/bin/bash

With 'g' flag (s|root|ADMIN|g):
ADMIN:x:0:0:ADMIN:/ADMIN:/bin/bash
```

#### Example 3: Case-Insensitive Replacement

```bash
# Case-insensitive replacement (i flag)
sed 's|root|ADMIN|i' passwd

# This will match: root, Root, ROOT, RooT
```

#### Example 4: Combined Flags

```bash
# Global + Case-insensitive (gi flags)
sed 's|root|ADMIN|gi' passwd

# This replaces ALL occurrences case-insensitively
```

### Advanced Search and Replace

#### Replacement with Special Characters

```bash
# Replace URL in config file
sed -i 's|http://old.domain.com|https://new.domain.com|g' config.ini

# Replace email addresses
sed -i 's|admin@old.com|devops@new.com|g' contacts.txt

# Replace environment variables
sed -i 's|DB_HOST=localhost|DB_HOST=db.production.com|' .env
```

#### Using Backreferences

```bash
# Capture and reuse patterns
sed 's|\([0-9]\{1,3\}\)\.\([0-9]\{1,3\}\)\.\([0-9]\{1,3\}\)\.\([0-9]\{1,3\}\)|IP: \1.\2.\3.\4|' log.txt

# Swap two words
sed 's|\(ERROR\) \(.*\)|\2 \1|' log.txt
# Before: ERROR Database connection failed
# After:  Database connection failed ERROR
```

#### Replace Only on Specific Lines

```bash
# Replace only on line 5
sed '5 s|old|new|' file.txt

# Replace on lines 10-20
sed '10,20 s|old|new|' file.txt

# Replace from line 5 to end
sed '5,$ s|old|new|' file.txt
```

### 2. Adding Lines

Sed provides three ways to add content:

- **i** : Insert line **before** pattern/line
- **a** : Append line **after** pattern/line
- **c** : Change (replace) entire line

#### Adding by Line Number

```bash
# Insert before line 1 (at the beginning)
sed '1 i Hello World' passwd

# Append after line 1
sed '1 a Hello World' passwd

# Replace line 1 completely
sed '1 c Hello World' passwd
```

**Output Examples:**

```bash
# Original file (first 3 lines):
root:x:0:0:root:/root:/bin/bash
daemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin
bin:x:2:2:bin:/bin:/usr/sbin/nologin

# sed '1 i Hello World' passwd
Hello World
root:x:0:0:root:/root:/bin/bash
daemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin

# sed '1 a Hello World' passwd
root:x:0:0:root:/root:/bin/bash
Hello World
daemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin

# sed '1 c Hello World' passwd
Hello World
daemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin
bin:x:2:2:bin:/bin:/usr/sbin/nologin
```

#### Adding by Pattern Match

```bash
# Insert line before pattern match
sed '/root/ i Hello World' passwd

# Append line after pattern match
sed '/root/ a Hello World' passwd

# Replace line containing pattern
sed '/root/ c Hello World' passwd
```

**Practical Examples:**

```bash
# Add comment before specific configuration
sed -i '/Port 22/ i # SSH Port Configuration' /etc/ssh/sshd_config

# Add new configuration after existing line
sed -i '/ServerName/ a ServerAlias www.example.com' /etc/apache2/sites-available/default.conf

# Replace deprecated configuration
sed -i '/OldDirective/ c NewDirective value' /etc/config.conf
```

### 3. Deleting Lines

#### Delete by Pattern

```bash
# Delete all lines containing 'root'
sed '/root/ d' passwd

# Delete lines NOT containing 'root' (inverse)
sed '/root/ !d' passwd
```

#### Delete by Line Number

```bash
# Delete line 10
sed '10 d' passwd

# Delete lines 5-15
sed '5,15 d' passwd

# Delete from line 20 to end
sed '20,$ d' passwd

# Delete first line
sed '1 d' passwd

# Delete last line
sed '$ d' passwd
```

#### Delete Empty Lines

```bash
# Remove all blank lines
sed '/^$/d' file.txt

# Remove blank lines and lines with only whitespace
sed '/^[[:space:]]*$/d' file.txt
```

#### Delete Comment Lines

```bash
# Remove lines starting with #
sed '/^#/d' config.conf

# Remove comments and blank lines
sed '/^#/d; /^$/d' config.conf
```

### Multiple Operations with -e

You can chain multiple sed commands using `-e` option:

```bash
# Multiple operations in one command
sed -e '1 d' -e '10 a Hello' -e 's|root|ADMIN|' passwd

# Equivalent to:
sed '1 d' passwd | sed '10 a Hello' | sed 's|root|ADMIN|'
```

**Complex Example:**

```bash
# Configuration file processing
sed -i \
  -e 's|DEBUG=true|DEBUG=false|g' \
  -e 's|DB_HOST=localhost|DB_HOST=prod-db.example.com|g' \
  -e '/# Production Settings/a LOG_LEVEL=error' \
  -e '/deprecated_option/d' \
  config.ini
```

### In-Place Editing

#### Without Backup

```bash
# Modify file directly (DANGEROUS)
sed -i 's|old|new|g' important_file.txt
```

#### With Backup (RECOMMENDED)

```bash
# Create backup with .bak extension
sed -i.bak 's|old|new|g' important_file.txt

# Create backup with custom extension
sed -i.backup 's|old|new|g' important_file.txt

# Create backup with timestamp
sed -i.$(date +%Y%m%d) 's|old|new|g' important_file.txt
```

### Preview Changes Before Applying

```bash
# Preview changes without modifying file
sed 's|old|new|g' file.txt

# Compare original vs modified
diff file.txt <(sed 's|old|new|g' file.txt)

# Show only changed lines
sed -n 's|old|new|gp' file.txt
```

### DevSecOps Automation Examples

#### Example 1: Update Application Version

```bash
#!/bin/bash
# Update version number in package.json

VERSION="2.1.0"
sed -i.bak "s|\"version\": \".*\"|\"version\": \"$VERSION\"|" package.json
```

#### Example 2: Environment Configuration

```bash
#!/bin/bash
# Switch from development to production

sed -i.backup \
  -e 's|ENV=development|ENV=production|g' \
  -e 's|DEBUG=true|DEBUG=false|g' \
  -e 's|DB_HOST=localhost|DB_HOST=prod-db-01.internal|g' \
  .env
```

#### Example 3: Security Hardening

```bash
#!/bin/bash
# Harden SSH configuration

sudo sed -i.original \
  -e 's|^#*PermitRootLogin.*|PermitRootLogin no|' \
  -e 's|^#*PasswordAuthentication.*|PasswordAuthentication no|' \
  -e 's|^#*Port.*|Port 2222|' \
  /etc/ssh/sshd_config

# Restart SSH service
sudo systemctl restart sshd
```

#### Example 4: Log File Sanitization

```bash
#!/bin/bash
# Remove sensitive information from logs

sed -i \
  -e 's|password=[^&]*|password=REDACTED|g' \
  -e 's|api_key=[^&]*|api_key=REDACTED|g' \
  -e 's|token=[^&]*|token=REDACTED|g' \
  /var/log/application.log
```

#### Example 5: Bulk Configuration Update

```bash
#!/bin/bash
# Update database connection in multiple config files

for config in /etc/app/config*.ini; do
  sed -i.bak \
    -e 's|db.host=.*|db.host=new-db-server.internal|' \
    -e 's|db.port=.*|db.port=5432|' \
    "$config"
done
```

#### Example 6: CI/CD Pipeline Configuration

```bash
#!/bin/bash
# Update Kubernetes deployment with new image tag

IMAGE_TAG="v${BUILD_NUMBER}"

sed -i \
  "s|image: myapp:.*|image: myapp:${IMAGE_TAG}|" \
  kubernetes/deployment.yaml

# Commit the change
git add kubernetes/deployment.yaml
git commit -m "Update deployment image to ${IMAGE_TAG}"
```

### Sed Best Practices

#### 1. Always Test Before In-Place Editing

```bash
# First, preview the changes
sed 's|old|new|g' file.txt | less

# Then apply if correct
sed -i 's|old|new|g' file.txt
```

#### 2. Create Backups for Critical Files

```bash
# Always backup important files
sed -i.backup 's|old|new|g' /etc/important.conf
```

#### 3. Use Meaningful Delimiters

```bash
# Bad: Hard to read with many escapes
sed 's/\/usr\/local\/bin/\/opt\/bin/' file

# Good: Use | for paths
sed 's|/usr/local/bin|/opt/bin|' file
```

#### 4. Use Variables for Maintainability

```bash
# Instead of hardcoding values
sed -i "s|old_domain|$NEW_DOMAIN|g" config.ini
sed -i "s|old_port|$NEW_PORT|g" config.ini
```

#### 5. Combine Operations Efficiently

```bash
# Less efficient: Multiple sed calls
sed -i 's|a|A|g' file
sed -i 's|b|B|g' file
sed -i 's|c|C|g' file

# More efficient: Single sed call
sed -i -e 's|a|A|g' -e 's|b|B|g' -e 's|c|C|g' file
```

### Sed Command Reference

| Operation            | Command       | Example                        |
| -------------------- | ------------- | ------------------------------ |
| Replace first match  | `s/old/new/`  | `sed 's/foo/bar/' file`        |
| Replace all matches  | `s/old/new/g` | `sed 's/foo/bar/g' file`       |
| Case-insensitive     | `s/old/new/i` | `sed 's/foo/bar/i' file`       |
| In-place edit        | `-i`          | `sed -i 's/foo/bar/' file`     |
| Backup + edit        | `-i.bak`      | `sed -i.bak 's/foo/bar/' file` |
| Delete line          | `d`           | `sed '5d' file`                |
| Delete pattern       | `/pattern/d`  | `sed '/error/d' file`          |
| Insert before        | `i\text`      | `sed '5 i\New line' file`      |
| Append after         | `a\text`      | `sed '5 a\New line' file`      |
| Replace line         | `c\text`      | `sed '5 c\New line' file`      |
| Print specific lines | `-n` + `p`    | `sed -n '10,20p' file`         |
| Multiple commands    | `-e`          | `sed -e 'cmd1' -e 'cmd2' file` |

---

## Other Linux Editors {#other-editors}

### Nano Editor

**Overview:**

- Beginner-friendly
- Simple interface
- Built-in command help
- Common on modern Linux distributions

**Basic Usage:**

```bash
# Open file
nano filename.txt

# Common shortcuts (shown at bottom)
Ctrl+O : Save (WriteOut)
Ctrl+X : Exit
Ctrl+K : Cut line
Ctrl+U : Paste
Ctrl+W : Search
Ctrl+\ : Search and replace
Ctrl+G : Help
```

**When to Use Nano:**

- Quick edits on servers with nano installed
- Teaching beginners
- Simple text editing without learning curve

### Emacs Editor

**Overview:**

- Extremely powerful and extensible
- Built-in programming language (Elisp)
- Can do almost anything (text editor, file manager, email client, etc.)
- Steep learning curve

**Basic Usage:**

```bash
# Open file
emacs filename.txt

# Basic commands
Ctrl+X Ctrl+S : Save
Ctrl+X Ctrl+C : Exit
Ctrl+K : Cut line
Ctrl+Y : Paste
Ctrl+S : Search forward
```

**When to Use Emacs:**

- Development work with extensive customization
- When you need an integrated development environment
- Power users who invest time in learning

### Gedit Editor

**Overview:**

- GNOME desktop GUI editor
- Simple and intuitive
- Syntax highlighting
- Plugin support

**Usage:**

```bash
# Open from terminal
gedit filename.txt

# Open multiple files
gedit file1.txt file2.txt file3.txt
```

**When to Use Gedit:**

- Desktop Linux environments
- GUI-based editing preference
- Quick file viewing with syntax highlighting

---

## Real-World DevSecOps Scenarios {#real-world-scenarios}

### Scenario 1: Configuration Deployment Script

```bash
#!/bin/bash
# deploy-config.sh - Deploy configuration to multiple servers

ENVIRONMENT=$1
CONFIG_FILE="app.conf"

if [ "$ENVIRONMENT" == "production" ]; then
    # Production settings
    sed -i.backup \
        -e 's|DEBUG=.*|DEBUG=false|' \
        -e 's|LOG_LEVEL=.*|LOG_LEVEL=error|' \
        -e 's|DB_HOST=.*|DB_HOST=prod-db-cluster.internal|' \
        -e 's|CACHE_HOST=.*|CACHE_HOST=prod-redis.internal|' \
        "$CONFIG_FILE"
elif [ "$ENVIRONMENT" == "staging" ]; then
    # Staging settings
    sed -i.backup \
        -e 's|DEBUG=.*|DEBUG=true|' \
        -e 's|LOG_LEVEL=.*|LOG_LEVEL=info|' \
        -e 's|DB_HOST=.*|DB_HOST=staging-db.internal|' \
        -e 's|CACHE_HOST=.*|CACHE_HOST=staging-redis.internal|' \
        "$CONFIG_FILE"
else
    echo "Usage: $0 {production|staging}"
    exit 1
fi

echo "Configuration updated for $ENVIRONMENT environment"
cat "$CONFIG_FILE"
```

### Scenario 2: Security Audit and Remediation

```bash
#!/bin/bash
# security-harden.sh - Automated security hardening

echo "=== Security Hardening Script ==="

# 1. Harden SSH configuration
echo "Hardening SSH..."
sudo sed -i.$(date +%Y%m%d) \
    -e 's|^#*PermitRootLogin.*|PermitRootLogin no|' \
    -e 's|^#*PasswordAuthentication.*|PasswordAuthentication no|' \
    -e 's|^#*PermitEmptyPasswords.*|PermitEmptyPasswords no|' \
    -e 's|^#*X11Forwarding.*|X11Forwarding no|' \
    -e 's|^#*MaxAuthTries.*|MaxAuthTries 3|' \
    /etc/ssh/sshd_config

# 2. Update sysctl security settings
echo "Updating kernel parameters..."
sudo sed -i.backup \
    -e '/net.ipv4.conf.all.accept_redirects/d' \
    -e '/net.ipv4.conf.all.send_redirects/d' \
    /etc/sysctl.conf

cat >> /etc/sysctl.conf << 'EOF'
# Security hardening
net.ipv4.conf.all.accept_redirects = 0
net.ipv4.conf.all.send_redirects = 0
net.ipv4.conf.all.accept_source_route = 0
net.ipv4.tcp_syncookies = 1
EOF

# 3. Disable unnecessary services
echo "Checking for unnecessary services..."
# Add your service checks here

echo "Security hardening completed!"
```

### Scenario 3: Log Rotation and Cleanup

```bash
#!/bin/bash
# log-rotate.sh - Custom log rotation with sanitization

LOG_DIR="/var/log/application"
RETENTION_DAYS=30

# Archive old logs
find "$LOG_DIR" -name "*.log" -mtime +$RETENTION_DAYS -exec gzip {} \;

# Sanitize current logs (remove sensitive data)
for log in "$LOG_DIR"/*.log; do
    if [ -f "$log" ]; then
        sed -i \
            -e 's|password=[^&[:space:]]*|password=REDACTED|g' \
            -e 's|api_key=[^&[:space:]]*|api_key=REDACTED|g' \
            -e 's|token=[^&[:space:]]*|token=REDACTED|g' \
            -e 's|Authorization: Bearer [^[:space:]]*|Authorization: Bearer REDACTED|g' \
            "$log"
    fi
done

echo "Log rotation and sanitization completed"
```

### Scenario 4: Multi-Environment Configuration Management

```bash
#!/bin/bash
# config-manager.sh - Manage configs across environments

CONFIG_TEMPLATE="config.template"
ENV_FILE=".env.$1"

if [ ! -f "$ENV_FILE" ]; then
    echo "Environment file $ENV_FILE not found"
    exit 1
fi

# Read environment variables
source "$ENV_FILE"

# Process template with environment-specific values
sed -e "s|{{DB_HOST}}|$DB_HOST|g" \
    -e "s|{{DB_PORT}}|$DB_PORT|g" \
    -e "s|{{DB_NAME}}|$DB_NAME|g" \
    -e "s|{{CACHE_HOST}}|$CACHE_HOST|g" \
    -e "s|{{LOG_LEVEL}}|$LOG_LEVEL|g" \
    -e "s|{{DEBUG_MODE}}|$DEBUG_MODE|g" \
    "$CONFIG_TEMPLATE" > "config.${1}.ini"

echo "Configuration generated for environment: $1"
```

### Scenario 5: Kubernetes Manifest Updates

```bash
#!/bin/bash
# k8s-update-image.sh - Update Kubernetes deployment image

DEPLOYMENT_FILE="kubernetes/deployment.yaml"
NEW_IMAGE="myapp:${CI_COMMIT_SHA}"
NEW_REPLICAS="${REPLICAS:-3}"

# Update image and replica count
sed -i.backup \
    -e "s|image: myapp:.*|image: ${NEW_IMAGE}|" \
    -e "s|replicas: [0-9]*|replicas: ${NEW_REPLICAS}|" \
    "$DEPLOYMENT_FILE"

echo "Updated deployment:"
echo "  Image: ${NEW_IMAGE}"
echo "  Replicas: ${NEW_REPLICAS}"

# Validate YAML
kubectl apply --dry-run=client -f "$DEPLOYMENT_FILE"
```

### Scenario 6: Compliance Configuration Checker

```bash
#!/bin/bash
# compliance-check.sh - Check configurations for compliance

echo "=== Compliance Configuration Check ==="

# Check SSH configuration
echo "1. SSH Configuration:"
if grep -q "^PermitRootLogin no" /etc/ssh/sshd_config; then
    echo "   [PASS] Root login disabled"
else
    echo "   [FAIL] Root login not properly disabled"
    # Auto-remediate
    sudo sed -i 's|^#*PermitRootLogin.*|PermitRootLogin no|' /etc/ssh/sshd_config
    echo "   [FIXED] Updated configuration"
fi

# Check for plaintext passwords in configs
echo "2. Configuration File Security:"
if grep -r "password\s*=\s*[^$]" /etc/app/*.conf 2>/dev/null | grep -v "#"; then
    echo "   [FAIL] Plaintext passwords found"
    # Log findings
    grep -r "password\s*=" /etc/app/*.conf 2>/dev/null >> /var/log/compliance-violations.log
else
    echo "   [PASS] No plaintext passwords in configs"
fi

# Check file permissions
echo "3. File Permissions:"
WORLD_WRITABLE=$(find /etc -type f -perm -002 2>/dev/null | wc -l)
if [ "$WORLD_WRITABLE" -gt 0 ]; then
    echo "   [WARN] $WORLD_WRITABLE world-writable files in /etc"
else
    echo "   [PASS] No world-writable files in /etc"
fi

echo "Compliance check completed"
```

---

## Best Practices {#best-practices}

### General Editor Best Practices

#### 1. Always Create Backups

```bash
# Before editing critical files
cp /etc/important.conf /etc/important.conf.backup.$(date +%Y%m%d)

# Or use sed with backup
sed -i.backup 's|old|new|' /etc/important.conf
```

#### 2. Test Changes in Safe Environment

```bash
# Preview sed changes
sed 's|old|new|g' file.txt | less

# Test in development first
# Then staging
# Finally production
```

#### 3. Use Version Control

```bash
# Track configuration changes
cd /etc
git init
git add important.conf
git commit -m "Before modification"

# Make changes
sed -i 's|old|new|' important.conf

# Review and commit
git diff
git commit -am "Updated configuration"
```

#### 4. Document Changes

```bash
# Add comments explaining changes
sed -i "/Port 22/i # Changed port for security compliance $(date +%Y-%m-%d)" sshd_config
sed -i 's|Port 22|Port 2222|' sshd_config
```

#### 5. Validate After Changes

```bash
# For configuration files, always validate
nginx -t                    # Nginx
sshd -t                     # SSH
apache2ctl configtest       # Apache
systemctl daemon-reload     # Systemd
```

### Automation Best Practices

#### 1. Idempotent Scripts

```bash
# Bad: Always appends
echo "new_setting=value" >> config.conf

# Good: Check if exists first
if ! grep -q "new_setting=" config.conf; then
    echo "new_setting=value" >> config.conf
fi

# Better: Use sed to update or add
sed -i '/new_setting=/c\new_setting=value' config.conf
```

#### 2. Error Handling

```bash
#!/bin/bash
set -euo pipefail  # Exit on error

# Check if file exists
if [ ! -f "/etc/config.conf" ]; then
    echo "Error: Configuration file not found"
    exit 1
fi

# Backup before modification
cp /etc/config.conf /etc/config.conf.backup || {
    echo "Error: Cannot create backup"
    exit 1
}

# Make changes
sed -i 's|old|new|' /etc/config.conf || {
    echo "Error: sed command failed"
    cp /etc/config.conf.backup /etc/config.conf
    exit 1
}
```

#### 3. Logging

```bash
#!/bin/bash
LOG_FILE="/var/log/config-updates.log"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

log "Starting configuration update"
sed -i.backup 's|old|new|' config.conf
log "Configuration updated successfully"
```

### Security Best Practices

#### 1. Sanitize Sensitive Data

```bash
# Remove passwords from logs
sed -i 's|password=[^&[:space:]]*|password=REDACTED|g' application.log

# Remove API keys
sed -i 's|api_key=[^&[:space:]]*|api_key=REDACTED|g' application.log

# Remove tokens
sed -i 's|Bearer [^[:space:]]*|Bearer REDACTED|g' access.log
```

#### 2. Restrict File Permissions

```bash
# After editing sensitive files
chmod 600 /etc/app/secrets.conf
chown root:root /etc/app/secrets.conf
```

#### 3. Audit Configuration Changes

```bash
# Track who changed what
echo "$(date) - $(whoami) - Modified /etc/ssh/sshd_config" >> /var/log/config-audit.log
```

---

## Troubleshooting {#troubleshooting}

### Common Vi Issues

#### Issue 1: Stuck in Insert Mode

**Symptoms:** Commands don't work, everything types as text
**Solution:**

```
Press ESC key several times
If still stuck: Press Ctrl+C
Last resort: Kill terminal and reconnect
```

#### Issue 2: Can't Save File

**Symptoms:** "Permission denied" or "E45: 'readonly' option is set"
**Solution:**

```bash
# Method 1: Save with sudo from within vi
:w !sudo tee %

# Method 2: Exit and reopen with sudo
:q!
sudo vi filename

# Method 3: Change file permissions (if appropriate)
chmod u+w filename
```

#### Issue 3: Accidental Changes

**Symptoms:** Made unwanted changes, don't want to save
**Solution:**

```
Press ESC
Type: :q!
Press Enter
This quits without saving any changes
```

#### Issue 4: File Already Being Edited

**Symptoms:** "Swap file found" warning
**Solution:**

```
Options when you see the warning:
[O]pen Read-Only     - View without editing
[E]dit anyway        - Edit (may lose other changes)
[R]ecover           - Recover from swap file
[Q]uit              - Exit without opening
[D]elete it         - Delete swap file (use if sure)

# To manually remove swap file:
rm .filename.swp
```

### Common Sed Issues

#### Issue 1: Changes Not Applied

**Problem:** Forgot `-i` option
**Solution:**

```bash
# Wrong: Only displays changes
sed 's|old|new|' file.txt

# Correct: Modifies file
sed -i 's|old|new|' file.txt
```

#### Issue 2: Delimiter Conflicts

**Problem:** Pattern contains delimiter character
**Solution:**

```bash
# Problem: / in pattern causes issues
sed 's/\/usr\/local/\/opt/' file   # Hard to read

# Solution: Use different delimiter
sed 's|/usr/local|/opt|' file       # Much clearer
```

#### Issue 3: Special Characters Not Escaped

**Problem:** Regex characters not properly escaped
**Solution:**

```bash
# Wrong: . matches any character
sed 's|192.168.1.1|192.168.1.2|' file

# Correct: Escape dots
sed 's|192\.168\.1\.1|192\.168\.1\.2|' file
```

#### Issue 4: Unintended Global Replacements

**Problem:** Forgot to limit scope of changes
**Solution:**

```bash
# Replace only first occurrence
sed 's|old|new|' file

# Replace all occurrences
sed 's|old|new|g' file

# Replace only on specific lines
sed '10,20 s|old|new|g' file
```

### Debugging Sed Commands

#### Test Without Modifying

```bash
# Preview changes
sed 's|old|new|g' file.txt | less

# Show only changed lines
sed -n 's|old|new|gp' file.txt

# Compare before and after
diff file.txt <(sed 's|old|new|g' file.txt)
```

#### Verbose Debugging

```bash
# Show what sed is doing (use -n and p flag)
sed -n 's|pattern|replacement|gp' file.txt

# Test with small subset
head -20 largefile.txt | sed 's|old|new|g'
```

---

## Summary

### Key Takeaways

**Vi Editor:**

- ✅ Universal, always available
- ✅ Learn basic operations only (80/20 rule)
- ✅ Essential for emergency troubleshooting
- ⚠️ Don't spend excessive time on advanced features

**Sed Editor:**

- ✅ Perfect for automation scripts
- ✅ Essential for CI/CD pipelines
- ✅ Powerful for batch processing
- ✅ Core tool for DevSecOps workflows

**Modern DevSecOps Approach:**

1. **Develop Locally**: Use IDEs (VSCode, IntelliJ)
2. **Version Control**: All changes in Git
3. **Automate**: Use sed in deployment scripts
4. **Emergency Only**: Vi for server troubleshooting

### Quick Reference Card

```
VI ESSENTIALS:
  vi file          # Open file
  i                # Insert mode
  ESC              # Command mode
  :wq              # Save and quit
  :q!              # Quit without saving
  dd               # Delete line
  u                # Undo

SED ESSENTIALS:
  sed 's|old|new|g' file           # Replace all
  sed -i 's|old|new|' file         # In-place edit
  sed '/pattern/d' file            # Delete lines
  sed '5 i\text' file              # Insert line
  sed -e 'cmd1' -e 'cmd2' file     # Multiple commands
```

### Recommended Learning Path

**Week 1: Vi Basics**

- 30 minutes: Basic editing workflow
- Practice: Edit 5 different config files
- Focus: Open, edit, save, quit

**Week 2: Sed Fundamentals**

- 1 hour: Search and replace
- 1 hour: Insert, append, delete
- Practice: Write 3 automation scripts

**Week 3: Integration**

- Create deployment script using sed
- Automate configuration management
- Build CI/CD integration

**Ongoing:**

- Learn advanced features as needed
- Focus on automation over manual editing
- Keep improving DevOps workflows

---

**Document Version:** 1.0  
**Last Updated:** December 17, 2025  
**Author:** DevSecOps Documentation Team  
**Target Audience:** Linux Administrators, DevSecOps Engineers, System Administrators
