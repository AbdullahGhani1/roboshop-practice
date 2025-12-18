# Command Line Browser and File Extraction: A Comprehensive DevSecOps Guide

## Table of Contents

1. [Introduction](#introduction)
2. [Curl - Command Line Browser](#curl)
3. [Wget - Alternative File Downloader](#wget)
4. [Tar - Archive Extraction](#tar)
5. [Zip/Unzip - ZIP Archive Management](#zip)
6. [Advanced Download Techniques](#advanced-techniques)
7. [Real-World DevSecOps Scenarios](#real-world-scenarios)
8. [Best Practices](#best-practices)
9. [Troubleshooting](#troubleshooting)

---

## Introduction {#introduction}

Command line tools for browsing URLs, downloading files, and extracting archives are essential skills for DevSecOps professionals. These tools enable automation of software deployments, configuration management, and CI/CD pipelines.

**Key Use Cases in DevSecOps:**

- Downloading application binaries and dependencies
- Fetching configuration files from remote sources
- API testing and monitoring
- Automated software installations
- CI/CD pipeline artifact management
- Container image builds
- Infrastructure as Code (IaC) implementations

**Tools Covered:**

- **curl** - Swiss army knife for URL operations
- **wget** - Robust file downloader
- **tar** - Archive extraction and compression
- **zip/unzip** - ZIP file management

---

## Curl - Command Line Browser {#curl}

### Overview

`curl` (Client URL) is a command-line tool for transferring data with URLs. It supports numerous protocols including HTTP, HTTPS, FTP, SFTP, and more.

**Key Features:**

- Transfer data to/from servers
- Support for multiple protocols
- REST API testing
- Download files
- Upload data
- Authentication support
- Cookie handling
- Custom headers

### Basic Syntax

```bash
curl [OPTIONS] [URL]
```

### Common Use Cases

#### 1. Fetch URL Content (Basic Browsing)

```bash
# Display webpage content
curl www.google.com

# Fetch API response
curl https://api.github.com/users/octocat

# Follow redirects automatically
curl -L https://example.com
```

**Output Example:**

```html
<!DOCTYPE html>
<html>
  <head>
    <title>Example Domain</title>
  </head>
  <body>
    <div>
      <h1>Example Domain</h1>
      <p>This domain is for use in illustrative examples...</p>
    </div>
  </body>
</html>
```

#### 2. Download Files

**Method 1: Specify Output Filename (-o flag)**

```bash
# Download with custom filename
curl https://archive.apache.org/dist/tomcat/tomcat-8/v8.0.0-RC1/bin/apache-tomcat-8.0.0-RC1-deployer.tar.gz -o apache-tomcat.tar.gz

# Download to specific directory
curl https://example.com/file.zip -o /tmp/downloads/file.zip
```

**Method 2: Use Original Filename (-O flag)**

```bash
# Download with original filename
curl -O https://archive.apache.org/dist/tomcat/tomcat-8/v8.0.0-RC1/bin/apache-tomcat-8.0.0-RC1-deployer.tar.gz

# This creates: apache-tomcat-8.0.0-RC1-deployer.tar.gz
```

**Comparison:**

| Flag          | Behavior                  | Use Case                              |
| ------------- | ------------------------- | ------------------------------------- |
| `-o filename` | Save to specified name    | Custom naming, different location     |
| `-O`          | Save with remote filename | Keep original name, current directory |

#### 3. Follow Redirects

```bash
# Without -L, stops at redirect
curl https://github.com/user/repo/archive/main.zip

# With -L, follows redirects automatically
curl -L https://github.com/user/repo/archive/main.zip -o repo.zip
```

**Why -L is Important:**
Many URLs (especially GitHub, CDNs) use redirects. Without `-L`, curl stops at the redirect and won't download the actual file.

#### 4. Show Download Progress

```bash
# Show progress bar
curl -# -O https://example.com/largefile.iso

# Silent mode (no progress)
curl -s https://api.example.com/data

# Verbose output (debugging)
curl -v https://example.com
```

#### 5. Resume Interrupted Downloads

```bash
# Resume download from where it stopped
curl -C - -O https://example.com/largefile.iso

# -C - automatically figures out where to resume from
```

### Advanced Curl Operations

#### HTTP Methods

```bash
# GET request (default)
curl https://api.example.com/users

# POST request with data
curl -X POST https://api.example.com/users \
  -H "Content-Type: application/json" \
  -d '{"name":"John","email":"john@example.com"}'

# PUT request
curl -X PUT https://api.example.com/users/123 \
  -H "Content-Type: application/json" \
  -d '{"name":"John Updated"}'

# DELETE request
curl -X DELETE https://api.example.com/users/123

# PATCH request
curl -X PATCH https://api.example.com/users/123 \
  -H "Content-Type: application/json" \
  -d '{"email":"newemail@example.com"}'
```

#### Headers and Authentication

```bash
# Add custom headers
curl -H "Authorization: Bearer token123" \
  -H "Accept: application/json" \
  https://api.example.com/data

# Basic authentication
curl -u username:password https://example.com/api

# Bearer token authentication
curl -H "Authorization: Bearer YOUR_TOKEN" \
  https://api.example.com/protected

# Show response headers
curl -I https://example.com

# Include response headers in output
curl -i https://example.com
```

#### Cookies

```bash
# Save cookies to file
curl -c cookies.txt https://example.com/login

# Use cookies from file
curl -b cookies.txt https://example.com/dashboard

# Send specific cookie
curl -b "session=abc123" https://example.com
```

#### Upload Files

```bash
# Upload file via POST
curl -X POST https://example.com/upload \
  -F "file=@/path/to/file.pdf" \
  -F "description=Important document"

# Upload multiple files
curl -X POST https://example.com/upload \
  -F "file1=@document.pdf" \
  -F "file2=@image.jpg"
```

#### API Testing

```bash
# Test REST API endpoint
curl -X GET https://api.github.com/repos/torvalds/linux

# POST JSON data
curl -X POST https://httpbin.org/post \
  -H "Content-Type: application/json" \
  -d '{"key":"value","number":42}'

# Format JSON output (with jq)
curl -s https://api.github.com/users/octocat | jq '.'

# Save response and check status
curl -w "\nHTTP Status: %{http_code}\n" \
  -o response.json \
  https://api.example.com/data
```

#### Timeout and Retry

```bash
# Set connection timeout
curl --connect-timeout 10 https://example.com

# Set maximum time for entire operation
curl --max-time 30 https://example.com

# Retry on failure
curl --retry 3 --retry-delay 5 https://example.com

# Retry only on specific errors
curl --retry 3 --retry-connrefused https://example.com
```

### DevSecOps Curl Examples

#### Example 1: Download Application Binary

```bash
#!/bin/bash
# Download and verify application binary

APP_VERSION="2.1.0"
DOWNLOAD_URL="https://releases.example.com/myapp-${APP_VERSION}.tar.gz"
CHECKSUM_URL="${DOWNLOAD_URL}.sha256"

# Download binary
curl -L -o myapp.tar.gz "$DOWNLOAD_URL"

# Download checksum
curl -L -o myapp.tar.gz.sha256 "$CHECKSUM_URL"

# Verify checksum
sha256sum -c myapp.tar.gz.sha256

if [ $? -eq 0 ]; then
    echo "Download verified successfully"
    tar -xzf myapp.tar.gz
else
    echo "Checksum verification failed!"
    exit 1
fi
```

#### Example 2: Health Check Monitoring

```bash
#!/bin/bash
# Monitor service health

ENDPOINT="https://api.example.com/health"
MAX_RETRIES=3
RETRY_COUNT=0

while [ $RETRY_COUNT -lt $MAX_RETRIES ]; do
    HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" "$ENDPOINT")

    if [ "$HTTP_STATUS" -eq 200 ]; then
        echo "Service is healthy"
        exit 0
    else
        echo "Health check failed (Status: $HTTP_STATUS), retrying..."
        RETRY_COUNT=$((RETRY_COUNT + 1))
        sleep 5
    fi
done

echo "Service health check failed after $MAX_RETRIES attempts"
exit 1
```

#### Example 3: API Deployment Trigger

```bash
#!/bin/bash
# Trigger deployment via API

DEPLOY_API="https://ci.example.com/api/deploy"
API_TOKEN="your-secret-token"
ENVIRONMENT="production"
VERSION="v2.1.0"

RESPONSE=$(curl -s -X POST "$DEPLOY_API" \
  -H "Authorization: Bearer $API_TOKEN" \
  -H "Content-Type: application/json" \
  -d "{
    \"environment\": \"$ENVIRONMENT\",
    \"version\": \"$VERSION\",
    \"notify\": true
  }")

echo "Deployment triggered: $RESPONSE"
```

### Curl Command Options Reference

| Option       | Description               | Example                    |
| ------------ | ------------------------- | -------------------------- |
| `-o <file>`  | Save output to file       | `curl -o file.zip URL`     |
| `-O`         | Save with remote filename | `curl -O URL`              |
| `-L`         | Follow redirects          | `curl -L URL`              |
| `-I`         | Show headers only         | `curl -I URL`              |
| `-i`         | Include headers in output | `curl -i URL`              |
| `-s`         | Silent mode               | `curl -s URL`              |
| `-v`         | Verbose output            | `curl -v URL`              |
| `-#`         | Show progress bar         | `curl -# -O URL`           |
| `-C -`       | Resume download           | `curl -C - -O URL`         |
| `-X`         | HTTP method               | `curl -X POST URL`         |
| `-H`         | Add header                | `curl -H "Key: Value" URL` |
| `-d`         | Send data                 | `curl -d "data" URL`       |
| `-u`         | Authentication            | `curl -u user:pass URL`    |
| `-F`         | Upload file               | `curl -F "file=@path" URL` |
| `-b`         | Send cookies              | `curl -b cookies.txt URL`  |
| `-c`         | Save cookies              | `curl -c cookies.txt URL`  |
| `--retry`    | Retry attempts            | `curl --retry 3 URL`       |
| `--max-time` | Timeout                   | `curl --max-time 30 URL`   |

---

## Wget - Alternative File Downloader {#wget}

### Overview

`wget` is another popular command-line tool for downloading files. While curl is more versatile for URL operations, wget excels at recursive downloads and mirroring websites.

### Basic Syntax

```bash
wget [OPTIONS] [URL]
```

### Common Use Cases

#### 1. Simple File Download

```bash
# Basic download
wget https://example.com/file.zip

# Download with custom filename
wget -O custom-name.zip https://example.com/file.zip

# Download to specific directory
wget -P /tmp/downloads https://example.com/file.zip
```

#### 2. Recursive Download

```bash
# Download entire website
wget -r -np -k https://example.com/docs/

# Options:
# -r : recursive
# -np : no parent (don't go up directories)
# -k : convert links for local viewing
```

#### 3. Resume Download

```bash
# Resume interrupted download
wget -c https://example.com/largefile.iso
```

#### 4. Background Download

```bash
# Download in background
wget -b https://example.com/largefile.iso

# Check progress
tail -f wget-log
```

#### 5. Multiple Files

```bash
# Download multiple URLs from file
cat > urls.txt << EOF
https://example.com/file1.zip
https://example.com/file2.tar.gz
https://example.com/file3.pdf
EOF

wget -i urls.txt
```

### Wget vs Curl Comparison

| Feature             | Curl                         | Wget             |
| ------------------- | ---------------------------- | ---------------- |
| Protocol support    | Many (HTTP, FTP, SFTP, etc.) | HTTP, HTTPS, FTP |
| API testing         | Excellent                    | Limited          |
| File downloads      | Good                         | Excellent        |
| Recursive downloads | No                           | Yes              |
| Resume downloads    | Yes                          | Yes              |
| Library mode        | Yes                          | No               |
| Default behavior    | Display to stdout            | Save to file     |

**When to Use:**

- **Curl**: API testing, single file downloads, scripting, data transfer
- **Wget**: Recursive downloads, mirroring sites, batch downloads

---

## Tar - Archive Extraction {#tar}

### Overview

`tar` (Tape Archive) is the standard Unix/Linux tool for creating and extracting archive files. In the Linux world, most software distributions use `.tar.gz` or `.tar.bz2` formats.

### Basic Syntax

```bash
tar [OPTIONS] [ARCHIVE] [FILES]
```

### Common Compression Formats

| Extension           | Compression                | Command Option      |
| ------------------- | -------------------------- | ------------------- |
| `.tar`              | None (archive only)        | No compression flag |
| `.tar.gz` / `.tgz`  | Gzip                       | `-z`                |
| `.tar.bz2` / `.tbz` | Bzip2 (better compression) | `-j`                |
| `.tar.xz`           | XZ (best compression)      | `-J`                |

### Extracting Archives

#### 1. Extract tar.gz Files

```bash
# Basic extraction
tar -xf apache-tomcat-8.0.0-RC1-deployer.tar.gz

# Extract with verbose output
tar -xvf apache-tomcat-8.0.0-RC1-deployer.tar.gz

# Extract to specific directory
tar -xf apache-tomcat-8.0.0-RC1-deployer.tar.gz -C /opt/tomcat/
```

**Options Explained:**

- `-x` : Extract files
- `-f` : Specify archive filename
- `-v` : Verbose (show files being extracted)
- `-C` : Change to directory before extraction

#### 2. Extract Different Compression Types

```bash
# tar.gz (gzip)
tar -xzf archive.tar.gz

# tar.bz2 (bzip2)
tar -xjf archive.tar.bz2

# tar.xz (xz)
tar -xJf archive.tar.xz

# Modern tar auto-detects compression
tar -xf archive.tar.gz    # Auto-detects gzip
tar -xf archive.tar.bz2   # Auto-detects bzip2
```

#### 3. List Contents Without Extracting

```bash
# List contents
tar -tf archive.tar.gz

# List with details (verbose)
tar -tvf archive.tar.gz
```

**Example Output:**

```
drwxr-xr-x  0 user group       0 Dec 17 10:30 apache-tomcat-8.0.0/
-rw-r--r--  0 user group   57092 Dec 17 10:30 apache-tomcat-8.0.0/LICENSE
-rw-r--r--  0 user group    1397 Dec 17 10:30 apache-tomcat-8.0.0/NOTICE
drwxr-xr-x  0 user group       0 Dec 17 10:30 apache-tomcat-8.0.0/bin/
```

#### 4. Extract Specific Files

```bash
# Extract only specific file
tar -xf archive.tar.gz path/to/specific/file.txt

# Extract multiple specific files
tar -xf archive.tar.gz file1.txt file2.txt

# Extract files matching pattern
tar -xf archive.tar.gz --wildcards '*.conf'
```

#### 5. Strip Directory Components

```bash
# Extract without top-level directory
tar -xf archive.tar.gz --strip-components=1

# Original structure: archive/dir/file.txt
# After extraction: dir/file.txt
```

### Creating Archives

#### 1. Create tar.gz Archive

```bash
# Create compressed archive
tar -czf backup.tar.gz /path/to/directory

# Create with verbose output
tar -czvf backup.tar.gz /path/to/directory

# Options:
# -c : Create archive
# -z : Compress with gzip
# -v : Verbose
# -f : Specify filename
```

#### 2. Create Different Compression Types

```bash
# Gzip (fast, good compression)
tar -czf archive.tar.gz directory/

# Bzip2 (slower, better compression)
tar -cjf archive.tar.bz2 directory/

# XZ (slowest, best compression)
tar -cJf archive.tar.xz directory/

# No compression (fastest)
tar -cf archive.tar directory/
```

#### 3. Exclude Files While Creating

```bash
# Exclude specific files
tar -czf backup.tar.gz --exclude='*.log' --exclude='*.tmp' /path/to/dir

# Exclude pattern
tar -czf backup.tar.gz --exclude='node_modules' project/

# Exclude from file
echo "*.log" > exclude.txt
echo "*.tmp" >> exclude.txt
tar -czf backup.tar.gz --exclude-from=exclude.txt /path/to/dir
```

### DevSecOps Tar Examples

#### Example 1: Application Deployment

```bash
#!/bin/bash
# Download and extract application

APP_VERSION="8.0.0"
DOWNLOAD_URL="https://archive.apache.org/dist/tomcat/tomcat-8/v${APP_VERSION}-RC1/bin/apache-tomcat-${APP_VERSION}-RC1.tar.gz"
INSTALL_DIR="/opt/tomcat"

# Download
curl -L -o tomcat.tar.gz "$DOWNLOAD_URL"

# Verify download
if [ $? -eq 0 ]; then
    # Extract to installation directory
    mkdir -p "$INSTALL_DIR"
    tar -xzf tomcat.tar.gz -C "$INSTALL_DIR" --strip-components=1

    # Cleanup
    rm tomcat.tar.gz

    echo "Tomcat installed successfully to $INSTALL_DIR"
else
    echo "Download failed"
    exit 1
fi
```

#### Example 2: Backup and Restore

```bash
#!/bin/bash
# Create application backup

BACKUP_DIR="/backup"
APP_DIR="/var/www/myapp"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="$BACKUP_DIR/myapp_backup_$TIMESTAMP.tar.gz"

# Create backup
tar -czf "$BACKUP_FILE" \
    --exclude='*.log' \
    --exclude='tmp/*' \
    --exclude='cache/*' \
    "$APP_DIR"

# Verify backup
if [ $? -eq 0 ]; then
    echo "Backup created: $BACKUP_FILE"

    # Keep only last 7 backups
    ls -t $BACKUP_DIR/myapp_backup_*.tar.gz | tail -n +8 | xargs -r rm
else
    echo "Backup failed"
    exit 1
fi
```

#### Example 3: Remote Backup

```bash
#!/bin/bash
# Stream backup to remote server

APP_DIR="/var/www/application"
REMOTE_SERVER="backup.example.com"
REMOTE_USER="backup"
REMOTE_DIR="/backups"

# Create and transfer backup in one command
tar -czf - "$APP_DIR" | \
    ssh ${REMOTE_USER}@${REMOTE_SERVER} \
    "cat > ${REMOTE_DIR}/backup_$(date +%Y%m%d).tar.gz"

echo "Remote backup completed"
```

### Tar Command Options Reference

| Option               | Description       | Example                                    |
| -------------------- | ----------------- | ------------------------------------------ |
| `-x`                 | Extract files     | `tar -xf archive.tar`                      |
| `-c`                 | Create archive    | `tar -cf archive.tar dir/`                 |
| `-f`                 | Specify filename  | `tar -xf archive.tar`                      |
| `-v`                 | Verbose output    | `tar -xvf archive.tar`                     |
| `-z`                 | Gzip compression  | `tar -czf archive.tar.gz`                  |
| `-j`                 | Bzip2 compression | `tar -cjf archive.tar.bz2`                 |
| `-J`                 | XZ compression    | `tar -cJf archive.tar.xz`                  |
| `-C`                 | Change directory  | `tar -xf file.tar -C /opt`                 |
| `-t`                 | List contents     | `tar -tf archive.tar`                      |
| `--exclude`          | Exclude pattern   | `tar -czf backup.tar.gz --exclude='*.log'` |
| `--strip-components` | Strip directories | `tar -xf file.tar --strip-components=1`    |

---

## Zip/Unzip - ZIP Archive Management {#zip}

### Overview

While tar is native to Unix/Linux, ZIP format is universal across all operating systems (Windows, macOS, Linux). ZIP archives are commonly used for cross-platform distribution.

### Installing Unzip

```bash
# Ubuntu/Debian
sudo apt-get install unzip

# CentOS/RHEL
sudo yum install unzip

# Fedora
sudo dnf install unzip
```

### Unzip - Extract ZIP Archives

#### Basic Syntax

```bash
unzip [OPTIONS] [ARCHIVE.zip]
```

#### Common Operations

```bash
# Basic extraction (current directory)
unzip archive.zip

# Extract to specific directory
unzip archive.zip -d /path/to/destination

# List contents without extracting
unzip -l archive.zip

# Extract quietly (no output)
unzip -q archive.zip

# Overwrite without prompting
unzip -o archive.zip

# Never overwrite files
unzip -n archive.zip

# Extract specific file
unzip archive.zip path/to/file.txt

# Extract with verbose output
unzip -v archive.zip
```

### Zip - Create ZIP Archives

#### Basic Syntax

```bash
zip [OPTIONS] [ARCHIVE.zip] [FILES]
```

#### Common Operations

```bash
# Create zip archive
zip backup.zip file1.txt file2.txt

# Add directory recursively
zip -r backup.zip /path/to/directory

# Update existing archive
zip -u backup.zip newfile.txt

# Delete file from archive
zip -d backup.zip unwanted.txt

# Set compression level (0-9)
zip -9 backup.zip file.txt    # Maximum compression
zip -1 backup.zip file.txt    # Fastest compression

# Exclude pattern
zip -r backup.zip project/ -x '*.log' '*.tmp'

# Encrypt zip file
zip -e -r secure.zip sensitive_data/
```

### DevSecOps Zip/Unzip Examples

#### Example 1: Download and Extract GitHub Repository

```bash
#!/bin/bash
# Download and extract GitHub repository

REPO_URL="https://github.com/roboshop-devops-project/shipping/archive/refs/heads/main.zip"
REPO_NAME="shipping"

# Download repository
curl -L -o ${REPO_NAME}.zip "$REPO_URL"

# Extract
unzip ${REPO_NAME}.zip

# Rename extracted directory (GitHub adds -main suffix)
mv ${REPO_NAME}-main ${REPO_NAME}

# Cleanup
rm ${REPO_NAME}.zip

echo "Repository extracted to ${REPO_NAME}/"
```

#### Example 2: Application Artifact Deployment

```bash
#!/bin/bash
# Deploy application from ZIP artifact

ARTIFACT_URL="https://ci.example.com/artifacts/myapp-${BUILD_NUMBER}.zip"
DEPLOY_DIR="/var/www/myapp"
BACKUP_DIR="/var/backups/myapp"

# Backup existing deployment
if [ -d "$DEPLOY_DIR" ]; then
    TIMESTAMP=$(date +%Y%m%d_%H%M%S)
    mkdir -p "$BACKUP_DIR"
    zip -r "$BACKUP_DIR/backup_$TIMESTAMP.zip" "$DEPLOY_DIR"
fi

# Download artifact
curl -L -o myapp.zip "$ARTIFACT_URL"

# Deploy
mkdir -p "$DEPLOY_DIR"
unzip -o myapp.zip -d "$DEPLOY_DIR"

# Cleanup
rm myapp.zip

echo "Deployment completed"
```

#### Example 3: Backup Script with ZIP

```bash
#!/bin/bash
# Create backup of configuration files

BACKUP_FILE="/backup/config_backup_$(date +%Y%m%d).zip"
CONFIG_DIRS=(
    "/etc/nginx"
    "/etc/apache2"
    "/etc/mysql"
)

# Create backup
zip -r "$BACKUP_FILE" "${CONFIG_DIRS[@]}" \
    -x '*.log' \
    -x '*.pid' \
    -x '*.sock'

# Verify backup
if [ $? -eq 0 ]; then
    echo "Backup created: $BACKUP_FILE"
    unzip -l "$BACKUP_FILE"
else
    echo "Backup failed"
    exit 1
fi
```

### Zip Command Options Reference

| Option | Description             | Example                           |
| ------ | ----------------------- | --------------------------------- |
| `-r`   | Recursive (directories) | `zip -r archive.zip dir/`         |
| `-e`   | Encrypt archive         | `zip -e secure.zip files/`        |
| `-u`   | Update existing archive | `zip -u archive.zip newfile`      |
| `-d`   | Delete from archive     | `zip -d archive.zip oldfile`      |
| `-9`   | Maximum compression     | `zip -9 archive.zip file`         |
| `-1`   | Fastest compression     | `zip -1 archive.zip file`         |
| `-x`   | Exclude files           | `zip -r arch.zip dir/ -x '*.log'` |
| `-q`   | Quiet mode              | `zip -q archive.zip file`         |

### Unzip Command Options Reference

| Option | Description              | Example                   |
| ------ | ------------------------ | ------------------------- |
| `-d`   | Extract to directory     | `unzip file.zip -d /path` |
| `-l`   | List contents            | `unzip -l archive.zip`    |
| `-o`   | Overwrite without prompt | `unzip -o archive.zip`    |
| `-n`   | Never overwrite          | `unzip -n archive.zip`    |
| `-q`   | Quiet mode               | `unzip -q archive.zip`    |
| `-v`   | Verbose                  | `unzip -v archive.zip`    |
| `-t`   | Test archive integrity   | `unzip -t archive.zip`    |

---

## Advanced Download Techniques {#advanced-techniques}

### Parallel Downloads

```bash
#!/bin/bash
# Download multiple files in parallel

URLS=(
    "https://example.com/file1.zip"
    "https://example.com/file2.zip"
    "https://example.com/file3.zip"
)

# Download in parallel
for url in "${URLS[@]}"; do
    curl -L -O "$url" &
done

# Wait for all downloads to complete
wait

echo "All downloads completed"
```

### Download with Checksum Verification

```bash
#!/bin/bash
# Download and verify file integrity

FILE_URL="https://releases.ubuntu.com/22.04/ubuntu-22.04-desktop-amd64.iso"
CHECKSUM_URL="${FILE_URL}.sha256"

# Download file
curl -L -O "$FILE_URL"
FILENAME=$(basename "$FILE_URL")

# Download checksum
curl -L -o "${FILENAME}.sha256" "$CHECKSUM_URL"

# Verify
if sha256sum -c "${FILENAME}.sha256"; then
    echo "✓ Download verified successfully"
else
    echo "✗ Checksum verification failed"
    rm "$FILENAME"
    exit 1
fi
```

### Conditional Download (Only if Newer)

```bash
#!/bin/bash
# Download only if remote file is newer

URL="https://example.com/latest.tar.gz"
LOCAL_FILE="latest.tar.gz"

# Get remote file modification time
REMOTE_TIME=$(curl -sI "$URL" | grep -i "last-modified" | cut -d' ' -f2-)

# Get local file modification time
if [ -f "$LOCAL_FILE" ]; then
    LOCAL_TIME=$(stat -c %y "$LOCAL_FILE")

    # Compare and download if newer
    curl -z "$LOCAL_FILE" -L -o "$LOCAL_FILE" "$URL"
else
    # File doesn't exist, download
    curl -L -o "$LOCAL_FILE" "$URL"
fi
```

### Retry Logic with Exponential Backoff

```bash
#!/bin/bash
# Robust download with retry logic

download_with_retry() {
    local url=$1
    local output=$2
    local max_attempts=5
    local timeout=30
    local attempt=1
    local wait_time=2

    while [ $attempt -le $max_attempts ]; do
        echo "Attempt $attempt of $max_attempts..."

        if curl -L --max-time $timeout -o "$output" "$url"; then
            echo "Download successful"
            return 0
        else
            echo "Download failed, waiting ${wait_time}s before retry..."
            sleep $wait_time

            # Exponential backoff
            wait_time=$((wait_time * 2))
            attempt=$((attempt + 1))
        fi
    done

    echo "Download failed after $max_attempts attempts"
    return 1
}

# Usage
download_with_retry "https://example.com/file.tar.gz" "file.tar.gz"
```

---

## Real-World DevSecOps Scenarios {#real-world-scenarios}

### Scenario 1: Automated Application Deployment

```bash
#!/bin/bash
# deploy-application.sh - Complete deployment script

set -euo pipefail

# Configuration
APP_NAME="myapp"
APP_VERSION="${1:-latest}"
DOWNLOAD_URL="https://releases.example.com/${APP_NAME}-${APP_VERSION}.tar.gz"
INSTALL_DIR="/opt/${APP_NAME}"
BACKUP_DIR="/backup/${APP_NAME}"
LOG_FILE="/var/log/${APP_NAME}-deploy.log"

# Logging function
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

log "Starting deployment of ${APP_NAME} version ${APP_VERSION}"

# Create backup of existing installation
if [ -d "$INSTALL_DIR" ]; then
    log "Creating backup of existing installation"
    BACKUP_FILE="$BACKUP_DIR/backup_$(date +%Y%m%d_%H%M%S).tar.gz"
    mkdir -p "$BACKUP_DIR"
    tar -czf "$BACKUP_FILE" -C "$(dirname $INSTALL_DIR)" "$(basename $INSTALL_DIR)"
    log "Backup created: $BACKUP_FILE"
fi

# Download application
log "Downloading application from $DOWNLOAD_URL"
TMP_DIR=$(mktemp -d)
cd "$TMP_DIR"

if ! curl -L --retry 3 --retry-delay 5 -o "${APP_NAME}.tar.gz" "$DOWNLOAD_URL"; then
    log "ERROR: Download failed"
    exit 1
fi

# Verify download (if checksum available)
if curl -s "${DOWNLOAD_URL}.sha256" -o "${APP_NAME}.tar.gz.sha256"; then
    log "Verifying checksum"
    if ! sha256sum -c "${APP_NAME}.tar.gz.sha256"; then
        log "ERROR: Checksum verification failed"
        exit 1
    fi
    log "Checksum verified"
fi

# Stop application if running
if systemctl is-active --quiet "${APP_NAME}"; then
    log "Stopping ${APP_NAME} service"
    sudo systemctl stop "${APP_NAME}"
fi

# Extract and install
log "Extracting application"
sudo mkdir -p "$INSTALL_DIR"
sudo tar -xzf "${APP_NAME}.tar.gz" -C "$INSTALL_DIR" --strip-components=1

# Set permissions
log "Setting permissions"
sudo chown -R appuser:appuser "$INSTALL_DIR"
sudo chmod -R 755 "$INSTALL_DIR"

# Start application
log "Starting ${APP_NAME} service"
sudo systemctl start "${APP_NAME}"

# Verify service started
sleep 5
if systemctl is-active --quiet "${APP_NAME}"; then
    log "✓ Deployment successful"
else
    log "✗ Service failed to start, rolling back"
    # Rollback logic here
    exit 1
fi

# Cleanup
cd /
rm -rf "$TMP_DIR"

log "Deployment completed successfully"
```

### Scenario 2: Dependency Installation Script

```bash
#!/bin/bash
# install-dependencies.sh - Install multiple software packages

set -euo pipefail

# Define dependencies
declare -A DEPENDENCIES=(
    ["maven"]="https://dlcdn.apache.org/maven/maven-3/3.9.5/binaries/apache-maven-3.9.5-bin.tar.gz"
    ["gradle"]="https://services.gradle.org/distributions/gradle-8.5-bin.zip"
    ["nodejs"]="https://nodejs.org/dist/v20.10.0/node-v20.10.0-linux-x64.tar.gz"
)

INSTALL_BASE="/opt"

install_package() {
    local name=$1
    local url=$2
    local install_dir="${INSTALL_BASE}/${name}"

    echo "Installing $name..."

    # Download
    local filename=$(basename "$url")
    curl -L -o "/tmp/$filename" "$url"

    # Extract based on file type
    mkdir -p "$install_dir"

    if [[ $filename == *.tar.gz ]]; then
        tar -xzf "/tmp/$filename" -C "$install_dir" --strip-components=1
    elif [[ $filename == *.zip ]]; then
        unzip -q "/tmp/$filename" -d "$install_dir"
    fi

    # Cleanup
    rm "/tmp/$filename"

    echo "✓ $name installed to $install_dir"
}

# Install all dependencies
for package in "${!DEPENDENCIES[@]}"; do
    install_package "$package" "${DEPENDENCIES[$package]}"
done

echo "All dependencies installed successfully"
```

### Scenario 3: Docker Image Build with Downloaded Artifacts

```bash
#!/bin/bash
# build-docker-image.sh - Build Docker image with external dependencies

set -euo pipefail

APP_NAME="myapp"
APP_VERSION="2.1.0"
BUILD_DIR="docker-build"

# Prepare build directory
rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"

# Download application
echo "Downloading application artifact..."
curl -L -o "${BUILD_DIR}/${APP_NAME}.jar" \
    "https://nexus.example.com/repository/releases/com/example/${APP_NAME}/${APP_VERSION}/${APP_NAME}-${APP_VERSION}.jar"

# Download dependencies
echo "Downloading dependencies..."
curl -L -o "${BUILD_DIR}/lib.tar.gz" \
    "https://nexus.example.com/repository/releases/com/example/${APP_NAME}-libs/${APP_VERSION}/libs.tar.gz"

cd "$BUILD_DIR"
tar -xzf lib.tar.gz
rm lib.tar.gz

# Create Dockerfile
cat > Dockerfile << 'EOF'
FROM openjdk:17-jre-slim

WORKDIR /app

# Copy application and libraries
COPY *.jar /app/
COPY lib/ /app/lib/

# Set environment
ENV JAVA_OPTS="-Xmx512m -Xms256m"

# Run application
ENTRYPOINT ["java", "-jar", "myapp.jar"]
EOF

# Build image
echo "Building Docker image..."
docker build -t "${APP_NAME}:${APP_VERSION}" .

# Tag as latest
docker tag "${APP_NAME}:${APP_VERSION}" "${APP_NAME}:latest"

echo "✓ Docker image built: ${APP_NAME}:${APP_VERSION}"
```

### Scenario 4: CI/CD Pipeline Script

```bash
#!/bin/bash
# ci-cd-deploy.sh - Complete CI/CD deployment pipeline

set -euo pipefail

PROJECT_NAME="myapp"
ENVIRONMENT="${1:-staging}"
BUILD_NUMBER="${CI_BUILD_NUMBER:-0}"

ARTIFACT_URL="https://ci.example.com/artifacts/${PROJECT_NAME}/build-${BUILD_NUMBER}.zip"
DEPLOY_SERVER="deploy-${ENVIRONMENT}.example.com"
DEPLOY_USER="deployer"
DEPLOY_PATH="/var/www/${PROJECT_NAME}"

echo "=== CI/CD Deployment Pipeline ==="
echo "Project: $PROJECT_NAME"
echo "Environment: $ENVIRONMENT"
echo "Build: $BUILD_NUMBER"

# Step 1: Download artifact
echo "Step 1: Downloading artifact..."
curl -L -o artifact.zip "$ARTIFACT_URL"

# Step 2: Verify artifact
echo "Step 2: Verifying artifact..."
if unzip -t artifact.zip > /dev/null; then
    echo "✓ Artifact verified"
else
    echo "✗ Artifact verification failed"
    exit 1
fi

# Step 3: Extract artifact
echo "Step 3: Extracting artifact..."
rm -rf deploy-temp
mkdir deploy-temp
unzip -q artifact.zip -d deploy-temp

# Step 4: Run tests (if applicable)
echo "Step 4: Running pre-deployment tests..."
# Add your test commands here

# Step 5: Deploy to server
echo "Step 5: Deploying to $ENVIRONMENT..."
rsync -avz --delete deploy-temp/ ${DEPLOY_USER}@${DEPLOY_SERVER}:${DEPLOY_PATH}/

# Step 6: Post-deployment tasks
echo "Step 6: Running post-deployment tasks..."
ssh ${DEPLOY_USER}@${DEPLOY_SERVER} << 'ENDSSH'
    cd /var/www/myapp
    chmod +x bin/*
    systemctl restart myapp
ENDSSH

# Step 7: Health check
echo "Step 7: Performing health check..."
sleep 10
HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" "https://${DEPLOY_SERVER}/health")

if [ "$HTTP_STATUS" -eq 200 ]; then
    echo "✓ Deployment successful"
else
    echo "✗ Health check failed (HTTP $HTTP_STATUS)"
    exit 1
fi

# Cleanup
rm -rf artifact.zip deploy-temp

echo "=== Deployment completed successfully ==="
```

### Scenario 5: Multi-Source Configuration Aggregation

```bash
#!/bin/bash
# aggregate-configs.sh - Download and merge configurations from multiple sources

set -euo pipefail

CONFIG_DIR="/etc/myapp"
TEMP_DIR=$(mktemp -d)

# Configuration sources
SOURCES=(
    "https://config.example.com/base/config.tar.gz"
    "https://config.example.com/env/production.tar.gz"
    "https://config.example.com/secrets/credentials.tar.gz"
)

echo "Aggregating configurations..."

# Download all configurations
for i in "${!SOURCES[@]}"; do
    echo "Downloading source $((i+1))/${#SOURCES[@]}..."
    curl -L -o "${TEMP_DIR}/config_${i}.tar.gz" "${SOURCES[$i]}"
done

# Extract and merge
mkdir -p "${TEMP_DIR}/merged"
for config_file in "${TEMP_DIR}"/config_*.tar.gz; do
    tar -xzf "$config_file" -C "${TEMP_DIR}/merged"
done

# Backup existing configuration
if [ -d "$CONFIG_DIR" ]; then
    BACKUP_FILE="/backup/config_backup_$(date +%Y%m%d_%H%M%S).tar.gz"
    mkdir -p /backup
    tar -czf "$BACKUP_FILE" "$CONFIG_DIR"
    echo "Existing config backed up to $BACKUP_FILE"
fi

# Deploy merged configuration
sudo mkdir -p "$CONFIG_DIR"
sudo cp -r "${TEMP_DIR}/merged/"* "$CONFIG_DIR/"

# Set permissions
sudo chown -R root:appgroup "$CONFIG_DIR"
sudo chmod -R 750 "$CONFIG_DIR"

# Cleanup
rm -rf "$TEMP_DIR"

echo "✓ Configuration aggregation completed"
```

---

## Best Practices {#best-practices}

### Download Best Practices

#### 1. Always Verify Downloads

```bash
# Download with checksum verification
curl -L -o file.tar.gz "$URL"
curl -L -o file.tar.gz.sha256 "${URL}.sha256"
sha256sum -c file.tar.gz.sha256
```

#### 2. Use Secure Protocols

```bash
# Prefer HTTPS over HTTP
curl -L https://example.com/file.zip  # Good
curl -L http://example.com/file.zip   # Avoid if possible
```

#### 3. Handle Errors Gracefully

```bash
# Check exit status
if curl -L -o file.tar.gz "$URL"; then
    echo "Download successful"
else
    echo "Download failed"
    exit 1
fi
```

#### 4. Create Backups Before Extraction

```bash
# Backup before overwriting
if [ -d "/opt/app" ]; then
    tar -czf "/backup/app_$(date +%Y%m%d).tar.gz" /opt/app
fi
```

#### 5. Use Temporary Directories

```bash
# Use temp directory for downloads
TMP_DIR=$(mktemp -d)
cd "$TMP_DIR"
curl -L -o file.tar.gz "$URL"
tar -xzf file.tar.gz
# Process files
cd /
rm -rf "$TMP_DIR"
```

### Archive Best Practices

#### 1. Always List Before Extracting

```bash
# Check contents first
tar -tzf archive.tar.gz | less
unzip -l archive.zip | less
```

#### 2. Extract to Specific Directory

```bash
# Don't pollute current directory
mkdir -p extract-dir
tar -xzf archive.tar.gz -C extract-dir/
```

#### 3. Use --strip-components for Clean Extraction

```bash
# Remove unnecessary parent directories
tar -xzf archive.tar.gz --strip-components=1 -C /opt/app/
```

#### 4. Verify Archive Integrity

```bash
# Test before extracting
tar -tzf archive.tar.gz > /dev/null && echo "Archive OK"
unzip -t archive.zip && echo "Archive OK"
```

### Security Best Practices

#### 1. Validate Sources

```bash
# Only download from trusted sources
# Verify SSL certificates
curl --cacert /path/to/ca-bundle.crt https://example.com/file
```

#### 2. Scan Downloaded Files

```bash
# Scan for malware
clamscan downloaded_file.tar.gz

# Check file type
file downloaded_file.tar.gz
```

#### 3. Set Proper Permissions

```bash
# Extract with safe permissions
tar -xzf archive.tar.gz
chmod -R 755 extracted_dir/
chown -R appuser:appgroup extracted_dir/
```

#### 4. Sanitize Filenames

```bash
# Prevent directory traversal
tar -xzf archive.tar.gz --exclude='../*' --exclude='*/../*'
```

### Performance Best Practices

#### 1. Use Appropriate Compression

```bash
# For speed: gzip
tar -czf archive.tar.gz dir/

# For size: xz
tar -cJf archive.tar.xz dir/

# For balance: bzip2
tar -cjf archive.tar.bz2 dir/
```

#### 2. Parallel Processing

```bash
# Use pigz for parallel gzip
tar -I pigz -cf archive.tar.gz dir/

# Extract with parallel
tar -I pigz -xf archive.tar.gz
```

#### 3. Stream Large Files

```bash
# Stream instead of saving temporarily
curl -L "$URL" | tar -xzf - -C /destination/
```

---

## Troubleshooting {#troubleshooting}

### Common Curl Issues

#### Issue 1: SSL Certificate Errors

**Symptoms:** `SSL certificate problem: unable to get local issuer certificate`

**Solutions:**

```bash
# Option 1: Update CA certificates
sudo update-ca-certificates

# Option 2: Skip verification (INSECURE - only for testing)
curl -k https://example.com/file

# Option 3: Specify CA bundle
curl --cacert /path/to/ca-bundle.crt https://example.com/file
```

#### Issue 2: Connection Timeout

**Symptoms:** `Connection timed out`

**Solutions:**

```bash
# Increase timeout
curl --connect-timeout 30 --max-time 300 https://example.com/file

# Add retry logic
curl --retry 3 --retry-delay 5 https://example.com/file
```

#### Issue 3: 403 Forbidden

**Symptoms:** `403 Forbidden` error

**Solutions:**

```bash
# Add user agent
curl -A "Mozilla/5.0" https://example.com/file

# Add referer
curl -e "https://example.com" https://example.com/download/file
```

### Common Tar Issues

#### Issue 1: Permission Denied

**Symptoms:** `Cannot open: Permission denied`

**Solutions:**

```bash
# Extract with sudo
sudo tar -xzf archive.tar.gz -C /protected/directory

# Change ownership after extraction
sudo tar -xzf archive.tar.gz
sudo chown -R $USER:$USER extracted_dir/
```

#### Issue 2: Disk Space

**Symptoms:** `No space left on device`

**Solutions:**

```bash
# Check available space before extraction
df -h /destination

# Extract to different location with more space
tar -xzf archive.tar.gz -C /tmp/

# Clean up old files
find /tmp -type f -mtime +7 -delete
```

#### Issue 3: Corrupt Archive

**Symptoms:** `gzip: stdin: not in gzip format`

**Solutions:**

```bash
# Verify archive
tar -tzf archive.tar.gz > /dev/null

# Try different compression
tar -xf archive.tar.gz  # Auto-detect

# Re-download if corrupt
rm archive.tar.gz
curl -L -O https://example.com/archive.tar.gz
```

### Common Unzip Issues

#### Issue 1: Filename Encoding

**Symptoms:** Strange characters in filenames

**Solutions:**

```bash
# Specify encoding
unzip -O UTF-8 archive.zip

# Or use system locale
LANG=en_US.UTF-8 unzip archive.zip
```

#### Issue 2: Overwrite Prompt

**Symptoms:** Constantly prompted to overwrite

**Solutions:**

```bash
# Always overwrite
unzip -o archive.zip

# Never overwrite
unzip -n archive.zip

# Update only newer files
unzip -u archive.zip
```

### Debugging Commands

```bash
# Curl verbose output
curl -v https://example.com/file

# Curl with detailed timing
curl -w "@curl-format.txt" https://example.com/file

# Create curl-format.txt:
cat > curl-format.txt << 'EOF'
    time_namelookup:  %{time_namelookup}s\n
       time_connect:  %{time_connect}s\n
    time_appconnect:  %{time_appconnect}s\n
   time_pretransfer:  %{time_pretransfer}s\n
      time_redirect:  %{time_redirect}s\n
 time_starttransfer:  %{time_starttransfer}s\n
                    ----------\n
         time_total:  %{time_total}s\n
EOF

# Tar verbose output
tar -xzvf archive.tar.gz

# Test tar without extracting
tar -tzf archive.tar.gz | head -20
```

---

## Summary

### Quick Reference

**Download Files:**

```bash
curl -L -o filename URL              # Custom filename
curl -O URL                          # Original filename
wget URL                             # Wget download
```

**Extract Archives:**

```bash
tar -xzf file.tar.gz                 # Extract tar.gz
tar -xjf file.tar.bz2                # Extract tar.bz2
unzip file.zip                       # Extract zip
```

**Common Patterns:**

```bash
# Download and extract in one line
curl -L URL | tar -xzf -

# Download with retry
curl --retry 3 -L -O URL

# Extract to specific directory
tar -xzf file.tar.gz -C /opt/app/
```

### Command Comparison

| Task               | Curl | Wget | Tar       | Unzip     |
| ------------------ | ---- | ---- | --------- | --------- |
| Download file      | ✅   | ✅   | ❌        | ❌        |
| Extract archive    | ❌   | ❌   | ✅ (.tar) | ✅ (.zip) |
| API testing        | ✅   | ❌   | ❌        | ❌        |
| Recursive download | ❌   | ✅   | ❌        | ❌        |
| Resume download    | ✅   | ✅   | ❌        | ❌        |

---

**Document Version:** 1.0  
**Last Updated:** December 17, 2025  
**Author:** DevSecOps Documentation Team  
**Target Audience:** Linux Administrators, DevSecOps Engineers, System Administrators
