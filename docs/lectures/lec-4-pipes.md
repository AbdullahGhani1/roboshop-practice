# Linux Pipes: Quick Reference Guide

## Table of Contents

1. [What are Pipes?](#what-are-pipes)
2. [Basic Pipe Usage](#basic-usage)
3. [Xargs Command](#xargs)
4. [Common Pipe Patterns](#common-patterns)
5. [Real-World Examples](#examples)

---

## What are Pipes? {#what-are-pipes}

Pipes (`|`) send the output of one command as input to another command **without writing to disk**. This enables powerful command chaining for data processing.

### Basic Syntax

```bash
command1 | command2 | command3
```

### How It Works

```
command1 (output) → | → command2 (input) → | → command3 (input)
```

---

## Basic Pipe Usage {#basic-usage}

### Simple Examples

```bash
# Show only lines with 'root' from passwd file
cat /etc/passwd | grep root

# Count number of files in directory
ls | wc -l

# Show top 10 largest files
du -sh * | sort -rh | head -10

# Find processes and filter by name
ps aux | grep nginx

# Show disk usage and sort by size
df -h | sort -k5 -rn
```

### Multiple Pipes

```bash
# Chain multiple commands
cat /var/log/auth.log | grep "Failed password" | awk '{print $11}' | sort | uniq -c

# Complex log analysis
cat access.log | grep "GET" | awk '{print $7}' | sort | uniq -c | sort -rn | head -20
```

---

## Xargs Command {#xargs}

### The Problem

**Not all commands accept piped input:**

```bash
# This DOESN'T work - rm doesn't accept stdin
ls | rm
```

### The Solution: xargs

`xargs` converts piped input into command arguments.

```bash
# This WORKS - xargs passes filenames as arguments
ls | xargs rm
```

### Basic Xargs Syntax

```bash
command1 | xargs command2
```

### Common Xargs Examples

#### 1. Delete Files

```bash
# Create test files
touch file1.txt file2.txt file3.txt

# List files
ls *.txt

# Try to delete with pipe (FAILS)
ls *.txt | rm

# Delete with xargs (WORKS)
ls *.txt | xargs rm

# Verify deletion
ls *.txt
```

#### 2. Find and Delete

```bash
# Find and delete old log files
find /var/log -name "*.log" -mtime +30 | xargs rm

# Find and delete with confirmation
find /tmp -name "*.tmp" -mtime +7 | xargs -p rm
```

#### 3. Process Files in Parallel

```bash
# Compress files in parallel
ls *.txt | xargs -P 4 gzip

# -P 4 runs 4 parallel processes
```

#### 4. Handle Filenames with Spaces

```bash
# Problem: filenames with spaces
touch "my file.txt" "another file.txt"

# Solution: use -0 with find
find . -name "*.txt" -print0 | xargs -0 rm

# Or use -I for custom handling
ls *.txt | xargs -I {} mv {} /backup/
```

#### 5. Execute Command for Each Input

```bash
# Run command for each line
echo -e "file1\nfile2\nfile3" | xargs -I {} echo "Processing: {}"

# Output:
# Processing: file1
# Processing: file2
# Processing: file3
```

### Xargs Options

| Option   | Description             | Example       |
| -------- | ----------------------- | ------------- | -------------------------- |
| `-I {}`  | Replace string          | `ls           | xargs -I {} mv {} backup/` |
| `-n NUM` | Max args per command    | `ls           | xargs -n 1 echo`           |
| `-P NUM` | Run NUM processes       | `ls           | xargs -P 4 gzip`           |
| `-p`     | Prompt before execution | `ls           | xargs -p rm`               |
| `-0`     | Use null delimiter      | `find -print0 | xargs -0 rm`               |
| `-t`     | Print commands          | `ls           | xargs -t rm`               |

---

## Common Pipe Patterns {#common-patterns}

### Pattern 1: Filter → Process → Sort

```bash
# Extract IPs from logs, count occurrences, sort by frequency
cat access.log | grep "GET" | awk '{print $1}' | sort | uniq -c | sort -rn
```

### Pattern 2: Find → Filter → Execute

```bash
# Find PHP files and search for 'password'
find /var/www -name "*.php" | xargs grep -l "password"

# Find large files and show details
find / -size +100M | xargs ls -lh
```

### Pattern 3: Generate List → Process Each

```bash
# Backup all config files
find /etc -name "*.conf" | xargs -I {} cp {} /backup/

# Convert all images to different format
ls *.jpg | xargs -I {} convert {} {}.png
```

### Pattern 4: Monitor → Filter → Alert

```bash
# Monitor logs for errors
tail -f /var/log/app.log | grep --line-buffered "ERROR" | xargs -I {} echo "Alert: {}"
```

---

## Real-World Examples {#examples}

### Example 1: Log Analysis

```bash
# Find failed SSH login attempts
grep "Failed password" /var/log/auth.log | \
  awk '{print $11}' | \
  sort | \
  uniq -c | \
  sort -rn | \
  head -10
```

### Example 2: Disk Cleanup

```bash
# Find and delete old backup files
find /backup -name "*.bak" -mtime +30 | xargs -p rm

# Find large files and show them
find /var -type f -size +100M | xargs ls -lh | sort -k5 -rn
```

### Example 3: Batch File Processing

```bash
# Rename all .txt files to .bak
ls *.txt | xargs -I {} mv {} {}.bak

# Change permissions on all scripts
find . -name "*.sh" | xargs chmod +x

# Search for string in multiple files
find /var/www -name "*.php" | xargs grep -n "TODO"
```

### Example 4: Process Monitoring

```bash
# Find and kill processes by name
ps aux | grep "zombie" | grep -v grep | awk '{print $2}' | xargs kill -9

# Count processes by user
ps aux | grep -v USER | awk '{print $1}' | sort | uniq -c | sort -rn
```

### Example 5: Network Analysis

```bash
# Show active connections by IP
netstat -an | grep ESTABLISHED | awk '{print $5}' | cut -d: -f1 | sort | uniq -c | sort -rn

# Monitor network traffic
tcpdump -nn | grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' | sort | uniq -c
```

### Example 6: Database Operations

```bash
# List databases and backup each
mysql -e "SHOW DATABASES;" | tail -n +2 | xargs -I {} mysqldump {} > {}.sql

# Process CSV files
cat data.csv | grep -v "^#" | awk -F',' '{print $1,$3}' | sort
```

### Example 7: Docker Operations

```bash
# Stop all running containers
docker ps -q | xargs docker stop

# Remove all stopped containers
docker ps -aq -f status=exited | xargs docker rm

# Delete all dangling images
docker images -f "dangling=true" -q | xargs docker rmi
```

### Example 8: Git Operations

```bash
# Show modified files and their line counts
git diff --name-only | xargs wc -l

# Find TODO comments in tracked files
git ls-files | xargs grep -n "TODO"
```

---

## Quick Reference

### Pipe Basics

```bash
cat file | grep pattern              # Filter content
ls | wc -l                           # Count items
ps aux | grep process                # Find process
df -h | sort -k5 -rn                 # Sort disk usage
```

### Xargs Essentials

```bash
ls | xargs rm                        # Delete files
find . -name "*.txt" | xargs cat     # Show all .txt files
echo "file1 file2" | xargs -n 1 echo # Process one at a time
ls | xargs -I {} mv {} backup/       # Move with custom placeholder
find . -name "*.log" | xargs -P 4 gzip # Parallel processing
```

### Common Patterns

```bash
# Find → Filter → Count
command | grep pattern | wc -l

# Extract → Sort → Unique → Count
command | awk '{print $1}' | sort | uniq -c

# Process → Filter → Execute
find pattern | grep filter | xargs command

# Monitor → Filter → Process
tail -f log | grep pattern | xargs action
```

---

## Important Notes

### When Pipes Work

✅ Most commands accept stdin: `grep`, `awk`, `sed`, `wc`, `sort`, `uniq`, `head`, `tail`

### When to Use Xargs

❌ Commands that need arguments: `rm`, `mv`, `cp`, `chmod`, `kill`
✅ Solution: Use `xargs` to convert stdin to arguments

### Best Practices

1. **Test with echo first:**

   ```bash
   ls | xargs echo rm    # Preview
   ls | xargs rm         # Execute
   ```

2. **Use -p for confirmation:**

   ```bash
   find . -name "*.tmp" | xargs -p rm
   ```

3. **Handle spaces in filenames:**

   ```bash
   find . -name "*.txt" -print0 | xargs -0 rm
   ```

4. **Limit parallel processes:**
   ```bash
   ls | xargs -P 4 gzip  # Use 4 cores
   ```

---

## Troubleshooting

### Problem: "Argument list too long"

```bash
# Instead of:
rm *.txt

# Use:
ls *.txt | xargs rm
```

### Problem: Filenames with spaces

```bash
# Instead of:
find . -name "*.txt" | xargs rm

# Use:
find . -name "*.txt" -print0 | xargs -0 rm
```

### Problem: Command not accepting pipe input

```bash
# Solution: Use xargs
ls | xargs rm
```

---

**Document Version:** 1.0  
**Last Updated:** December 17, 2025  
**Target Audience:** Linux Administrators, DevSecOps Engineers
