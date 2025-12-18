# Move Files & Directories

In Linux, the `mv` command is used for both moving files and directories from one location to another, and for renaming them.

## Renaming/Moving a File

The `mv` command's behavior depends on whether the destination is a new name in the same directory or a path to a different directory.

**Syntax:**
`mv [OPTIONS] <source> <destination>`

- `<source>`: The path to the file or directory you want to move or rename.
- `<destination>`: The new name for the file/directory (if renaming) or the target directory (if moving).

### Renaming a File

If the `<destination>` provided to the `mv` command is a new filename within the same directory as the `<source>`, it will rename the file.

**Example:**
Let's create a file named `notes.txt`:

```bash
touch notes.txt
```

Now, rename `notes.txt` to `note.txt` in the current directory:

```bash
mv notes.txt note.txt
```

**Verification:**
You can use `ls` to see the change:

```bash
ls
# Expected output might include 'note.txt' but not 'notes.txt'
```

### Moving a File to a Different Directory

If the `<destination>` provided to the `mv` command is a path to an existing directory, the source file or directory will be moved into that destination directory, retaining its original name. If the destination path includes a new filename, the item will be moved and renamed.

**Example:**
Let's move `note.txt` to the `/tmp` directory:

```bash
mv note.txt /tmp
```

**Verification:**
Check if the file is now in `/tmp`:

```bash
ls /tmp
# Expected output might include 'note.txt'
```

And confirm it's no longer in the original location:

```bash
ls
# 'note.txt' should no longer be listed here
```

### Moving a Directory

The `mv` command works similarly for directories.

**Example:**
Create a directory and a file inside it:

```bash
mkdir my_project
touch my_project/main.c
```

Now, move `my_project` into `/tmp`:

```bash
mv my_project /tmp
```

**Verification:**

```bash
ls /tmp
# Expected output might include 'my_project'
ls /tmp/my_project
# Expected output: 'main.c'
```

## Useful `mv` Options

- `-i` (interactive): Prompts before overwriting an existing file.
  ```bash
  mv -i file.txt /tmp/file.txt
  # mv: overwrite '/tmp/file.txt'? y
  ```
- `-u` (update): Moves only when the source file is newer than the destination file or when the destination file is missing.
- `-v` (verbose): Explains what is being done.
  ```bash
  mv -v old_name.txt new_name.txt
  # 'old_name.txt' -> 'new_name.txt'
  ```
- `-f` (force): Overwrites existing destination files without prompting. Use with caution.

# Shell CLI Shortcuts

Learning and utilizing command-line interface (CLI) shortcuts can significantly boost your productivity and efficiency when working in a Linux terminal. These shortcuts allow you to navigate, edit, and execute commands much faster, making interaction with the command line a more fluid experience. Consider practicing these as a must to become proficient.

For an in-depth guide on essential CLI shortcuts, refer to this excellent resource:
[Top 10 Linux Command Line Shortcuts You Should Know](https://www.redhat.com/sysadmin/top-10-shortcuts)

# Linux Content Filters & Text Processing Commands: A Comprehensive DevSecOps Guide

## Table of Contents

1. [Introduction](#introduction)
2. [Cat Command - Concatenate and Display](#cat-command)
3. [Head Command - Display Top Lines](#head-command)
4. [Tail Command - Display Bottom Lines](#tail-command)
5. [Grep Command - Pattern Matching](#grep-command)
6. [Awk Command - Text Processing and Column Extraction](#awk-command)
7. [Sed Command - Stream Editor](#sed-command)
8. [Regular Expressions Deep Dive](#regular-expressions)
9. [Advanced Command Combinations](#advanced-combinations)
10. [Real-World DevSecOps Scenarios](#real-world-scenarios)
11. [Performance Considerations](#performance)
12. [Best Practices](#best-practices)

---

## Introduction {#introduction}

Content filtering and text processing are fundamental skills for Linux administrators and DevSecOps professionals. These commands form the backbone of log analysis, configuration management, security auditing, and automated scripting workflows.

**Key Use Cases in DevSecOps:**

- Log analysis and security event correlation
- Configuration file parsing and validation
- System monitoring and alerting
- Automated security scanning and reporting
- Incident response and forensics
- CI/CD pipeline data processing

---

## Cat Command - Concatenate and Display {#cat-command}

### Overview

`cat` (concatenate) is one of the most frequently used commands in Linux. It reads data from files and outputs their content to standard output (stdout). Despite its simplicity, it's incredibly powerful when combined with other commands.

### Basic Syntax

```bash
cat [OPTIONS] [FILE...]
```

### Common Use Cases

#### 1. Display File Contents

```bash
cat /etc/passwd
```

**Output Example:**

```
root:x:0:0:root:/root:/bin/bash
daemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin
bin:x:2:2:bin:/bin:/usr/sbin/nologin
sys:x:3:3:sys:/dev:/usr/sbin/nologin
```

#### 2. Display with Line Numbers

```bash
cat -n /etc/passwd
```

**Output Example:**

```
     1  root:x:0:0:root:/root:/bin/bash
     2  daemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin
     3  bin:x:2:2:bin:/bin:/usr/sbin/nologin
     4  sys:x:3:3:sys:/dev:/usr/sbin/nologin
```

**DevSecOps Use Case:** Essential for log file analysis where line numbers help in tracking error locations.

#### 3. Show Non-Blank Line Numbers Only

```bash
cat -b /var/log/syslog
```

**Output:** Numbers only lines with content, ignoring blank lines.

#### 4. Suppress Repeated Empty Lines

```bash
cat -s application.log
```

**DevSecOps Use Case:** Cleaning up verbose logs before analysis.

#### 5. Show End of Line Characters

```bash
cat -E /etc/hosts
```

**Output Example:**

```
127.0.0.1   localhost$
127.0.1.1   ubuntu-server$
```

The `$` symbol indicates line endings, useful for detecting hidden characters or Windows line endings (`\r\n`).

#### 6. Display Non-Printing Characters

```bash
cat -v suspicious_file.txt
```

**DevSecOps Use Case:** Security analysis to detect hidden control characters or malicious payloads.

#### 7. Show TAB Characters

```bash
cat -T configuration.conf
```

Displays TAB characters as `^I`, useful for configuration file validation.

#### 8. Concatenate Multiple Files

```bash
cat file1.log file2.log file3.log > combined.log
```

#### 9. Append to Existing File

```bash
cat additional_data.txt >> existing_log.txt
```

#### 10. Create New File with Content

```bash
cat > newfile.txt << EOF
Line 1 content
Line 2 content
Line 3 content
EOF
```

### Advanced Cat Usage

#### Numbered Output with Formatting

```bash
cat -n /etc/ssh/sshd_config | grep -v "^#"
```

Shows configuration file with line numbers, excluding comments.

#### Reading from Multiple Sources

```bash
cat /var/log/auth.log /var/log/syslog | grep "Failed password"
```

#### Creating Here Documents

```bash
cat > script.sh << 'END'
#!/bin/bash
echo "Automated security scan"
date
END
```

### Performance Notes

- **Memory Efficient:** `cat` streams data rather than loading entire files into memory
- **Fast:** Optimized for sequential reads
- **Limitation:** Not ideal for very large files (use `less`, `more`, or specialized tools)

### Cat Command Options Reference Table

| Option | Description                     | Use Case                                |
| ------ | ------------------------------- | --------------------------------------- |
| `-n`   | Number all output lines         | Log analysis with line references       |
| `-b`   | Number non-empty lines          | Clean output without blank line numbers |
| `-s`   | Suppress repeated empty lines   | Log file cleanup                        |
| `-E`   | Display $ at end of lines       | Line ending detection                   |
| `-T`   | Display TAB as ^I               | Configuration validation                |
| `-v`   | Display non-printing characters | Security analysis                       |
| `-A`   | Show all (equivalent to -vET)   | Complete character visibility           |

---

## Head Command - Display Top Lines {#head-command}

### Overview

The `head` command displays the first part of files, making it essential for quick file inspection, log monitoring, and data sampling.

### Basic Syntax

```bash
head [OPTIONS] [FILE...]
```

### Common Use Cases

#### 1. Display First 10 Lines (Default)

```bash
head /etc/passwd
```

**Output:**

```
root:x:0:0:root:/root:/bin/bash
daemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin
bin:x:2:2:bin:/bin:/usr/sbin/nologin
sys:x:3:3:sys:/dev:/usr/sbin/nologin
sync:x:4:65534:sync:/bin:/bin/sync
games:x:5:60:games:/usr/games:/usr/sbin/nologin
man:x:6:12:man:/var/cache/man:/usr/sbin/nologin
lp:x:7:7:lp:/var/spool/lpd:/usr/sbin/nologin
mail:x:8:8:mail:/var/mail:/usr/sbin/nologin
news:x:9:9:news:/var/spool/news:/usr/sbin/nologin
```

#### 2. Display Specific Number of Lines

```bash
head -n 5 /etc/passwd
```

**Output:**

```
root:x:0:0:root:/root:/bin/bash
daemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin
bin:x:2:2:bin:/bin:/usr/sbin/nologin
sys:x:3:3:sys:/dev:/usr/sbin/nologin
sync:x:4:65534:sync:/bin:/bin/sync
```

#### 3. Display First N Bytes

```bash
head -c 100 largefile.bin
```

**DevSecOps Use Case:** Quick inspection of binary file headers or magic numbers.

#### 4. Display Multiple Files with Headers

```bash
head -n 3 /etc/hosts /etc/hostname
```

**Output:**

```
==> /etc/hosts <==
127.0.0.1   localhost
127.0.1.1   ubuntu-server
::1         localhost ip6-localhost ip6-loopback

==> /etc/hostname <==
ubuntu-server
```

#### 5. Suppress File Name Headers

```bash
head -q -n 5 /var/log/*.log
```

Useful when processing multiple files programmatically.

#### 6. Display All But Last N Lines

```bash
head -n -5 /var/log/syslog
```

Shows entire file except the last 5 lines.

### Advanced Head Usage

#### Monitoring Log File Start

```bash
head -n 20 /var/log/auth.log | grep "Failed"
```

#### Sampling Large Datasets

```bash
head -n 1000 big_data.csv > sample.csv
```

#### Quick Configuration Check

```bash
head -n 50 /etc/nginx/nginx.conf | grep -v "^#"
```

#### Comparing File Beginnings

```bash
diff <(head -n 20 file1.txt) <(head -n 20 file2.txt)
```

### DevSecOps Scenarios with Head

#### 1. Quick Log Analysis

```bash
head -n 100 /var/log/auth.log | grep "Failed password"
```

#### 2. Configuration File Preview

```bash
head -n 30 /etc/ssh/sshd_config | grep -E "^Port|^PermitRootLogin"
```

#### 3. CSV Header Inspection

```bash
head -n 1 security_scan_results.csv
```

#### 4. Binary File Type Detection

```bash
head -c 4 unknown_file | xxd
```

### Head Command Options Reference

| Option    | Description                        | Example                 |
| --------- | ---------------------------------- | ----------------------- |
| `-n NUM`  | Display first NUM lines            | `head -n 15 file.txt`   |
| `-c NUM`  | Display first NUM bytes            | `head -c 1024 file.bin` |
| `-q`      | Quiet mode (no headers)            | `head -q file1 file2`   |
| `-v`      | Verbose mode (always show headers) | `head -v file.txt`      |
| `-n -NUM` | Show all but last NUM lines        | `head -n -10 file.txt`  |

---

## Tail Command - Display Bottom Lines {#tail-command}

### Overview

The `tail` command displays the last part of files. It's indispensable for real-time log monitoring, troubleshooting, and tracking file changes.

### Basic Syntax

```bash
tail [OPTIONS] [FILE...]
```

### Common Use Cases

#### 1. Display Last 10 Lines (Default)

```bash
tail /etc/passwd
```

**Output:** Shows the last 10 user entries.

#### 2. Display Specific Number of Lines

```bash
tail -n 5 /etc/passwd
```

**Output:**

```
systemd-coredump:x:999:999::/:/usr/sbin/nologin
nginx:x:998:998:Nginx web server:/var/www:/bin/false
mysql:x:997:997:MySQL Server:/var/lib/mysql:/bin/false
redis:x:996:996:Redis Server:/var/lib/redis:/bin/false
abdullah:x:1000:1000:Abdullah,,,:/home/abdullah:/bin/bash
```

#### 3. Follow File Updates in Real-Time

```bash
tail -f /var/log/syslog
```

**DevSecOps Use Case:** Most critical command for live log monitoring.

**Output Behavior:** Continuously displays new lines as they're added to the file.

#### 4. Follow with Retry

```bash
tail -F /var/log/application.log
```

Continues following even if the file is rotated or temporarily unavailable.

#### 5. Display Last N Bytes

```bash
tail -c 500 /var/log/auth.log
```

#### 6. Display from Line N to End

```bash
tail -n +50 /etc/services
```

Shows everything from line 50 onwards.

#### 7. Follow Multiple Files

```bash
tail -f /var/log/nginx/access.log /var/log/nginx/error.log
```

**Output:**

```
==> /var/log/nginx/access.log <==
192.168.1.100 - - [17/Dec/2025:10:30:45 +0500] "GET /api/users HTTP/1.1" 200 1543

==> /var/log/nginx/error.log <==
2025/12/17 10:30:46 [error] 1234#1234: *1 connect() failed
```

### Advanced Tail Usage

#### Real-Time Log Filtering

```bash
tail -f /var/log/auth.log | grep "Failed password"
```

**DevSecOps Use Case:** Live monitoring of authentication failures.

#### Colorized Output

```bash
tail -f /var/log/syslog | grep --color=always "ERROR\|WARNING"
```

#### Following Log Rotation

```bash
tail -F --retry /var/log/app/production.log
```

#### Time-Based Monitoring

```bash
tail -f /var/log/nginx/access.log | while read line; do echo "$(date '+%Y-%m-%d %H:%M:%S') $line"; done
```

#### Multiple File Monitoring with Labels

```bash
tail -f /var/log/{auth.log,syslog,kern.log}
```

### DevSecOps Scenarios with Tail

#### 1. Security Event Monitoring

```bash
tail -f /var/log/auth.log | grep --line-buffered "Failed\|Invalid\|Illegal"
```

#### 2. Application Performance Monitoring

```bash
tail -f /var/log/application.log | grep --line-buffered "ERROR\|Exception"
```

#### 3. Web Server Access Monitoring

```bash
tail -f /var/log/nginx/access.log | awk '{print $1, $7, $9}'
```

#### 4. Database Query Monitoring

```bash
tail -f /var/log/mysql/slow-query.log
```

#### 5. Container Log Streaming

```bash
tail -f /var/lib/docker/containers/*/container.log
```

#### 6. System Resource Monitoring

```bash
tail -f /var/log/syslog | grep --line-buffered "Out of memory\|CPU\|high load"
```

### Advanced Tail Features

#### Following Multiple Logs with Prefix

```bash
tail -f /var/log/*.log 2>/dev/null
```

#### Conditional Following

```bash
tail -f /var/log/app.log | while read line; do
    if echo "$line" | grep -q "CRITICAL"; then
        echo "ALERT: $line" | mail -s "Critical Error" admin@example.com
    fi
done
```

#### Parallel Log Monitoring

```bash
tail -f /var/log/app{1..5}.log
```

### Tail Command Options Reference

| Option      | Description                      | Use Case                 |
| ----------- | -------------------------------- | ------------------------ |
| `-n NUM`    | Display last NUM lines           | `tail -n 20 file.log`    |
| `-c NUM`    | Display last NUM bytes           | `tail -c 1024 file.bin`  |
| `-f`        | Follow file growth               | Real-time log monitoring |
| `-F`        | Follow with retry                | Log rotation handling    |
| `-n +NUM`   | Display from line NUM to end     | Skip header rows         |
| `--pid=PID` | Stop following when PID dies     | Process-bound monitoring |
| `-q`        | Suppress headers                 | Multi-file processing    |
| `-s NUM`    | Sleep NUM seconds between checks | Custom polling interval  |

---

## Grep Command - Pattern Matching {#grep-command}

### Overview

`grep` (Global Regular Expression Print) searches for patterns in files and outputs matching lines. It's the cornerstone of text searching and log analysis in Linux.

### Basic Syntax

```bash
grep [OPTIONS] PATTERN [FILE...]
```

### Common Use Cases

#### 1. Basic Pattern Search

```bash
grep root /etc/passwd
```

**Output:**

```
root:x:0:0:root:/root:/bin/bash
```

#### 2. Case-Insensitive Search

```bash
grep -i "error" /var/log/syslog
```

**Output:** Matches "ERROR", "error", "Error", etc.

#### 3. Display Line Numbers

```bash
grep -n "Failed password" /var/log/auth.log
```

**Output:**

```
145:Dec 17 10:15:32 server sshd[12345]: Failed password for invalid user admin
289:Dec 17 10:20:15 server sshd[12456]: Failed password for root from 192.168.1.100
```

#### 4. Count Matching Lines

```bash
grep -c "ERROR" /var/log/application.log
```

**Output:**

```
47
```

#### 5. Invert Match (Show Non-Matching Lines)

```bash
grep -v "^#" /etc/ssh/sshd_config
```

**DevSecOps Use Case:** Display active configuration by removing comments.

#### 6. Show Only Matching Part

```bash
grep -o "192\.168\.[0-9]\+\.[0-9]\+" /var/log/auth.log
```

**Output:**

```
192.168.1.100
192.168.1.105
192.168.1.100
```

#### 7. Recursive Search

```bash
grep -r "password" /etc/
```

Searches all files under `/etc/` directory.

#### 8. Search with Context Lines

```bash
grep -A 3 -B 2 "Error" /var/log/app.log
```

Shows 2 lines **B**efore and 3 lines **A**fter each match.

**Output Example:**

```
2025-12-17 10:15:30 INFO  Starting process
2025-12-17 10:15:31 INFO  Connecting to database
2025-12-17 10:15:32 ERROR Connection failed: timeout
2025-12-17 10:15:33 ERROR Retrying connection attempt 1
2025-12-17 10:15:34 INFO  Connection established
2025-12-17 10:15:35 INFO  Process resumed
```

#### 9. Match Whole Words Only

```bash
grep -w "root" /etc/passwd
```

Matches "root" but not "rootkit" or "groot".

#### 10. Extended Regular Expressions

```bash
grep -E "error|warning|critical" /var/log/syslog
```

Matches any of the three patterns.

### Advanced Grep Usage

#### Multiple Pattern Search

```bash
grep -e "Failed" -e "Invalid" -e "Illegal" /var/log/auth.log
```

#### Pattern from File

```bash
grep -f suspicious_ips.txt /var/log/nginx/access.log
```

#### Exclude Specific Patterns

```bash
grep "ERROR" /var/log/app.log | grep -v "DEBUG"
```

#### Quiet Mode for Scripts

```bash
if grep -q "root" /etc/passwd; then
    echo "Root user exists"
fi
```

#### List Files with Matches

```bash
grep -l "TODO" *.js
```

**Output:**

```
app.js
utils.js
config.js
```

#### List Files Without Matches

```bash
grep -L "test" *.py
```

#### Show Filename with Matches

```bash
grep -H "password" /etc/*.conf
```

**Output:**

```
/etc/mysql/my.cnf:password=secret123
/etc/app.conf:admin_password=changeme
```

### Regular Expression Patterns with Grep

#### Match Beginning of Line

```bash
grep "^root" /etc/passwd
```

Matches lines starting with "root".

#### Match End of Line

```bash
grep "bash$" /etc/passwd
```

Matches lines ending with "bash".

#### Match Any Character

```bash
grep "r..t" /etc/passwd
```

Matches "root", "rust", "rift", etc.

#### Match Character Classes

```bash
grep "[Ee]rror" /var/log/syslog
```

Matches "Error" or "error".

#### Match Character Ranges

```bash
grep "[0-9]" /etc/passwd
```

Matches lines containing any digit.

#### Match Repetitions

```bash
grep "lo*g" /var/log/syslog
```

Matches "lg", "log", "loog", "loooog", etc.

#### Match One or More

```bash
grep -E "10+" /var/log/app.log
```

Matches "10", "100", "1000", etc.

#### Match Optional Character

```bash
grep -E "colou?r" /var/log/app.log
```

Matches both "color" and "colour".

### DevSecOps Scenarios with Grep

#### 1. Failed SSH Login Detection

```bash
grep "Failed password" /var/log/auth.log | awk '{print $11}' | sort | uniq -c | sort -rn
```

**Output:**

```
     25 192.168.1.100
     12 192.168.1.105
      5 192.168.1.200
```

#### 2. Security Audit - Find SUID Files

```bash
find / -perm -4000 2>/dev/null | grep -v "^/proc"
```

#### 3. Configuration Vulnerability Scan

```bash
grep -r "password\s*=\s*" /etc/*.conf 2>/dev/null
```

#### 4. Log Analysis for SQL Injection Attempts

```bash
grep -i "union.*select\|exec.*xp_\|drop.*table" /var/log/nginx/access.log
```

#### 5. Network Interface Analysis

```bash
ip a | grep -E "inet\s" | awk '{print $2}'
```

#### 6. Process Monitoring

```bash
ps aux | grep -E "cpu|memory" | grep -v grep
```

#### 7. Certificate Expiry Check

```bash
grep -r "CERTIFICATE" /etc/ssl/certs/ | grep -i "notAfter"
```

### Grep Command Options Reference

| Option   | Description             | Example                          |
| -------- | ----------------------- | -------------------------------- | -------------- |
| `-i`     | Ignore case             | `grep -i error file.log`         |
| `-v`     | Invert match            | `grep -v "^#" config.txt`        |
| `-n`     | Show line numbers       | `grep -n "pattern" file.txt`     |
| `-c`     | Count matches           | `grep -c "error" log.txt`        |
| `-l`     | List filenames only     | `grep -l "TODO" *.js`            |
| `-L`     | List non-matching files | `grep -L "test" *.py`            |
| `-r`     | Recursive search        | `grep -r "password" /etc/`       |
| `-w`     | Match whole words       | `grep -w "root" /etc/passwd`     |
| `-o`     | Show only matched part  | `grep -o "[0-9]\+" file.txt`     |
| `-A NUM` | Show NUM lines after    | `grep -A 3 "error" log.txt`      |
| `-B NUM` | Show NUM lines before   | `grep -B 2 "error" log.txt`      |
| `-C NUM` | Show NUM lines around   | `grep -C 2 "error" log.txt`      |
| `-E`     | Extended regex          | `grep -E "cat                    | dog" file.txt` |
| `-P`     | Perl regex              | `grep -P "\d{3}-\d{4}" file.txt` |
| `-q`     | Quiet mode              | `grep -q "pattern" file.txt`     |
| `-H`     | Show filename           | `grep -H "pattern" *.txt`        |
| `-h`     | Hide filename           | `grep -h "pattern" *.txt`        |

---

## Awk Command - Text Processing and Column Extraction {#awk-command}

### Overview

`awk` is a powerful programming language designed for text processing and data extraction. It excels at working with structured data, especially column-based formats.

### Basic Syntax

```bash
awk [OPTIONS] 'pattern {action}' [FILE...]
```

### Core Concepts

**Built-in Variables:**

- `$0` - Entire line
- `$1, $2, $3...` - Individual fields/columns
- `NF` - Number of fields in current line
- `NR` - Current line number
- `FS` - Field separator (input)
- `OFS` - Output field separator
- `RS` - Record separator (input)
- `ORS` - Output record separator

### Common Use Cases

#### 1. Print Specific Column

```bash
awk -F : '{print $1}' /etc/passwd
```

**Output:**

```
root
daemon
bin
sys
sync
```

#### 2. Print Multiple Columns

```bash
awk -F : '{print $1,$3}' /etc/passwd
```

**Output:**

```
root 0
daemon 1
bin 2
sys 3
```

#### 3. Print with Custom Separator

```bash
awk -F : '{print $1,$3}' OFS=":" /etc/passwd
```

**Output:**

```
root:0
daemon:1
bin:2
```

#### 4. Print with Custom Text

```bash
awk -F : '{print "Username: " $1 " | UID: " $3}' /etc/passwd
```

**Output:**

```
Username: root | UID: 0
Username: daemon | UID: 1
Username: bin | UID: 2
```

#### 5. Print Last Column

```bash
awk -F : '{print $NF}' /etc/passwd
```

**Output:**

```
/bin/bash
/usr/sbin/nologin
/usr/sbin/nologin
```

#### 6. Print Line Numbers

```bash
awk '{print NR, $0}' /etc/hosts
```

**Output:**

```
1 127.0.0.1   localhost
2 127.0.1.1   ubuntu-server
3 192.168.1.10   dbserver
```

#### 7. Conditional Processing

```bash
awk -F : '$3 >= 1000 {print $1, $3}' /etc/passwd
```

**Output:** Shows users with UID >= 1000 (regular users)

```
abdullah 1000
nobody 65534
```

### Pattern Matching in Awk

#### Match Specific Pattern

```bash
awk '/root/ {print $0}' /etc/passwd
```

Prints lines containing "root".

#### Match with Field Condition

```bash
awk -F : '$1 == "root" {print $0}' /etc/passwd
```

#### Regex Pattern Matching

```bash
awk '$0 ~ /[0-9]+/ {print}' /var/log/syslog
```

#### Inverse Pattern Match

```bash
awk '!/^#/ {print}' /etc/ssh/sshd_config
```

Prints lines NOT starting with `#`.

### Mathematical Operations

#### Sum Column Values

```bash
awk '{sum += $3} END {print "Total:", sum}' numbers.txt
```

#### Calculate Average

```bash
awk '{sum += $2; count++} END {print "Average:", sum/count}' data.txt
```

#### Find Maximum Value

```bash
awk 'BEGIN {max=0} {if ($3 > max) max=$3} END {print "Max:", max}' data.txt
```

### Advanced Awk Usage

#### BEGIN and END Blocks

```bash
awk 'BEGIN {print "=== User Report ==="}
     {print $1}
     END {print "=== Total Users:", NR, "==="}' /etc/passwd
```

#### Multiple Conditions

```bash
awk -F : '$3 >= 1000 && $7 == "/bin/bash" {print $1}' /etc/passwd
```

#### String Manipulation

```bash
awk '{print toupper($1)}' usernames.txt
```

#### Field Manipulation

```bash
awk -F : '{$7="/bin/zsh"; print}' OFS=":" /etc/passwd
```

#### Multi-Line Processing

```bash
awk '/start/,/end/ {print}' logfile.txt
```

Prints lines between "start" and "end" patterns.

### DevSecOps Scenarios with Awk

#### 1. Log Analysis - Extract IP Addresses

```bash
awk '{print $1}' /var/log/nginx/access.log | sort | uniq -c | sort -rn | head -10
```

**Output:**

```
    450 192.168.1.100
    325 192.168.1.105
    210 192.168.1.200
```

#### 2. Memory Usage Analysis

```bash
free -m | awk 'NR==2 {print "Used: " $3 "MB | Free: " $4 "MB | Total: " $2 "MB"}'
```

**Output:**

```
Used: 2048MB | Free: 1024MB | Total: 4096MB
```

#### 3. Disk Usage Report

```bash
df -h | awk 'NR>1 {print $5 "\t" $6}' | sort -rn
```

**Output:**

```
85%     /var
45%     /home
12%     /
```

#### 4. Process Monitoring

```bash
ps aux | awk '$3 > 10.0 {print $2, $3, $11}'
```

Shows processes using more than 10% CPU.

#### 5. Network Connection Analysis

```bash
netstat -an | awk '/ESTABLISHED/ {print $5}' | cut -d: -f1 | sort | uniq -c | sort -rn
```

#### 6. CSV Processing

```bash
awk -F',' 'NR>1 {sum[$2] += $3} END {for (user in sum) print user, sum[user]}' sales.csv
```

#### 7. Log Time-Based Filtering

```bash
awk '$1 >= "10:00" && $1 <= "12:00" {print}' /var/log/application.log
```

#### 8. Configuration File Parsing

```bash
awk -F'=' '/^[^#]/ {print $1 ":" $2}' /etc/config.conf
```

#### 9. Failed Login Summary

```bash
awk '/Failed password/ {print $11}' /var/log/auth.log | sort | uniq -c | sort -rn
```

#### 10. Apache Log Analysis

```bash
awk '{print $7}' /var/log/apache2/access.log | sort | uniq -c | sort -rn | head -20
```

Shows top 20 most accessed URLs.

### Complex Awk Scripts

#### Multi-Stage Processing

```bash
awk 'BEGIN {FS=":"; OFS="\t"}
     NR>1 {
         if ($3 >= 1000) {
             users++;
             print $1, $3, $6
         }
     }
     END {
         print "\nTotal regular users:", users
     }' /etc/passwd
```

#### Data Validation

```bash
awk -F',' '{
    if (NF != 5) {
        print "Line", NR, "has invalid number of fields"
    } else if ($3 !~ /^[0-9]+$/) {
        print "Line", NR, "has invalid numeric value"
    } else {
        print "OK:", $0
    }
}' data.csv
```

#### JSON-like Output Generation

```bash
awk -F: 'BEGIN {print "["}
         {printf "  {\"user\":\"%s\", \"uid\":%s}", $1, $3;
          if (NR != NF) printf ",\n"}
         END {print "\n]"}' /etc/passwd
```

### Awk Functions

#### String Functions

```bash
awk '{print length($1), toupper($1), tolower($1)}' file.txt
```

#### Substring Extraction

```bash
awk '{print substr($1, 1, 5)}' file.txt
```

#### String Replacement

```bash
awk '{gsub(/old/, "new"); print}' file.txt
```

#### Split String into Array

```bash
awk -F: '{split($5, name, ","); print name[1]}' /etc/passwd
```

### Awk Command Options Reference

| Option          | Description             | Example                               |
| --------------- | ----------------------- | ------------------------------------- |
| `-F 'sep'`      | Set field separator     | `awk -F: '{print $1}' /etc/passwd`    |
| `-v var=value`  | Set variable            | `awk -v count=0 '{count++}' file`     |
| `-f script.awk` | Read program from file  | `awk -f process.awk data.txt`         |
| `OFS='sep'`     | Output field separator  | `awk 'BEGIN {OFS=","} {print $1,$2}'` |
| `ORS='sep'`     | Output record separator | `awk 'BEGIN {ORS=";"} {print}'`       |

---

## Sed Command - Stream Editor {#sed-command}

### Overview

`sed` (Stream Editor) performs text transformations on input streams. It's particularly powerful for search-and-replace operations, line deletions, and insertions.

### Basic Syntax

```bash
sed [OPTIONS] 'command' [FILE...]
```

### Common Use Cases

#### 1. Simple Substitution

```bash
sed 's/old/new/' file.txt
```

Replaces first occurrence of "old" with "new" on each line.

#### 2. Global Substitution

```bash
sed 's/old/new/g' file.txt
```

Replaces all occurrences on each line.

#### 3. In-Place Editing

```bash
sed -i 's/old/new/g' file.txt
```

**Warning:** Modifies file directly. Use `-i.bak` to create backup.

#### 4. Delete Lines

```bash
sed '/pattern/d' file.txt
```

Deletes lines matching pattern.

#### 5. Delete Specific Line Numbers

```bash
sed '5d' file.txt          # Delete line 5
sed '5,10d' file.txt       # Delete lines 5-10
sed '5,$d' file.txt        # Delete from line 5 to end
```

#### 6. Print Specific Lines

```bash
sed -n '10,20p' file.txt
```

Prints only lines 10-20.

#### 7. Insert Line Before Pattern

```bash
sed '/pattern/i\New line to insert' file.txt
```

#### 8. Append Line After Pattern

```bash
sed '/pattern/a\New line to append' file.txt
```

#### 9. Replace Entire Line

```bash
sed '/pattern/c\Complete new line' file.txt
```

#### 10. Multiple Commands

```bash
sed -e 's/foo/bar/g' -e 's/hello/world/g' file.txt
```

### Advanced Sed Usage

#### Case-Insensitive Replacement

```bash
sed 's/error/ERROR/gi' file.txt
```

#### Replacement with Special Characters

```bash
sed 's|/old/path|/new/path|g' file.txt
```

Using `|` as delimiter to avoid escaping `/`.

#### Backreferences

```bash
sed 's/\([0-9]\+\)/Number: \1/g' file.txt
```

**Output:** "45" becomes "Number: 45"

#### Multiple Pattern Matching

```bash
sed '/pattern1/,/pattern2/d' file.txt
```

Deletes lines from pattern1 to pattern2.

#### Conditional Replacement

```bash
sed '/^#/!s/old/new/g' file.txt
```

Replace only in non-comment lines.

### DevSecOps Scenarios with Sed

#### 1. Configuration File Updates

```bash
sed -i 's/^Port 22$/Port 2222/' /etc/ssh/sshd_config
```

#### 2. Log Sanitization

```bash
sed 's/password=[^&]*/password=REDACTED/g' access.log
```

#### 3. Remove Comments and Blank Lines

```bash
sed '/^#/d; /^$/d' config.conf
```

#### 4. Add Timestamp to Log Entries

```bash
sed "s/^/$(date '+%Y-%m-%d %H:%M:%S') /" app.log
```

#### 5. Extract Configuration Values

```bash
sed -n 's/^DATABASE_URL=//p' .env
```

#### 6. CSV Data Cleaning

```bash
sed 's/\r$//' windows_file.csv  # Remove Windows line endings
```

#### 7. Bulk File Renaming

```bash
for file in *.txt; do
    mv "$file" "$(echo "$file" | sed 's/\.txt$/.log/')"
done
```

### Sed Command Options Reference

| Option   | Description                 | Example                        |
| -------- | --------------------------- | ------------------------------ |
| `-n`     | Suppress automatic printing | `sed -n '10p' file.txt`        |
| `-e`     | Add multiple commands       | `sed -e 's/a/b/' -e 's/c/d/'`  |
| `-i`     | Edit files in-place         | `sed -i 's/old/new/' file.txt` |
| `-i.bak` | Edit in-place with backup   | `sed -i.bak 's/old/new/' file` |
| `-r`     | Extended regex              | `sed -r 's/[0-9]+/NUM/' file`  |
| `-E`     | Extended regex (BSD/macOS)  | `sed -E 's/[0-9]+/NUM/' file`  |

---

## Regular Expressions Deep Dive {#regular-expressions}

### Basic Regular Expression Syntax

#### Character Matching

| Symbol | Meaning                  | Example   | Matches                    |
| ------ | ------------------------ | --------- | -------------------------- |
| `.`    | Any single character     | `a.c`     | "abc", "a1c", "a c"        |
| `^`    | Start of line            | `^root`   | Lines starting with "root" |
| `$`    | End of line              | `bash$`   | Lines ending with "bash"   |
| `*`    | Zero or more of previous | `ab*c`    | "ac", "abc", "abbc"        |
| `+`    | One or more of previous  | `ab+c`    | "abc", "abbc" (not "ac")   |
| `?`    | Zero or one of previous  | `colou?r` | "color", "colour"          |
| `\`    | Escape special character | `\.`      | Literal dot character      |

#### Character Classes

```bash
[abc]        # Matches a, b, or c
[^abc]       # Matches anything except a, b, or c
[a-z]        # Matches any lowercase letter
[A-Z]        # Matches any uppercase letter
[0-9]        # Matches any digit
[a-zA-Z0-9]  # Matches alphanumeric characters
```

#### Predefined Character Classes (Extended Regex)

```bash
\d    # Digit [0-9]
\D    # Non-digit [^0-9]
\w    # Word character [a-zA-Z0-9_]
\W    # Non-word character
\s    # Whitespace [ \t\n\r\f]
\S    # Non-whitespace
```

### Quantifiers

#### Interval Expressions

```bash
{n}      # Exactly n occurrences
{n,}     # At least n occurrences
{n,m}    # Between n and m occurrences
```

**Examples:**

```bash
grep -E '[0-9]{3}' file.txt           # Exactly 3 digits
grep -E '[0-9]{3,}' file.txt          # 3 or more digits
grep -E '[0-9]{3,5}' file.txt         # Between 3 and 5 digits
```

### Grouping and Alternation

#### Grouping

```bash
grep -E '(ab)+' file.txt              # Matches "ab", "abab", "ababab"
```

#### Alternation

```bash
grep -E 'cat|dog|bird' file.txt       # Matches any of the three words
```

#### Combining

```bash
grep -E '(error|warning|critical):' /var/log/syslog
```

### Anchors and Boundaries

```bash
^pattern     # Match at start of line
pattern$     # Match at end of line
\bword\b     # Word boundary
\Bword\B     # Not a word boundary
```

**Examples:**

```bash
grep -E '^\[ERROR\]' app.log          # Lines starting with [ERROR]
grep -E 'failed$' status.log          # Lines ending with "failed"
grep -E '\broot\b' /etc/passwd        # Exact word "root"
```

### Practical Regular Expression Examples

#### 1. IP Address Matching

```bash
grep -E '\b([0-9]{1,3}\.){3}[0-9]{1,3}\b' /var/log/auth.log
```

#### 2. Email Validation

```bash
grep -E '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$' emails.txt
```

#### 3. Date Matching (YYYY-MM-DD)

```bash
grep -E '[0-9]{4}-[0-9]{2}-[0-9]{2}' logfile.txt
```

#### 4. Phone Number (Various Formats)

```bash
grep -E '\b[0-9]{3}[-.]?[0-9]{3}[-.]?[0-9]{4}\b' contacts.txt
```

#### 5. URL Matching

```bash
grep -E 'https?://[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}(/[^[:space:]]*)?'
```

#### 6. Credit Card Number Pattern

```bash
grep -E '\b[0-9]{4}[- ]?[0-9]{4}[- ]?[0-9]{4}[- ]?[0-9]{4}\b' transactions.txt
```

#### 7. MAC Address

```bash
grep -E '([0-9A-Fa-f]{2}:){5}[0-9A-Fa-f]{2}' network.log
```

#### 8. IPv6 Address (Simplified)

```bash
grep -E '([0-9a-fA-F]{0,4}:){7}[0-9a-fA-F]{0,4}' config.txt
```

### Brace Expressions and Ranges

#### Numeric Ranges

```bash
grep -E '^(19|20)[0-9]{2}' years.txt        # Years 1900-2099
echo {1..10}                                # Generates 1 2 3 4 5 6 7 8 9 10
echo {a..z}                                 # Generates a b c ... z
```

#### Character Sets

```bash
grep '[[:alpha:]]' file.txt                 # Alphabetic characters
grep '[[:digit:]]' file.txt                 # Digits
grep '[[:alnum:]]' file.txt                 # Alphanumeric
grep '[[:space:]]' file.txt                 # Whitespace
grep '[[:punct:]]' file.txt                 # Punctuation
```

### DevSecOps Regular Expression Patterns

#### 1. Detect SQL Injection Attempts

```bash
grep -E -i '(union.*select|exec.*xp_|drop.*table|insert.*into)' /var/log/nginx/access.log
```

#### 2. Find Potential XSS Attempts

```bash
grep -E -i '<script|javascript:|onerror=' web_traffic.log
```

#### 3. Identify Sensitive Data Exposure

```bash
grep -E '(password|api[_-]?key|secret|token)\s*[=:]\s*[^ ]+' /var/www/html/*.php
```

#### 4. SSH Brute Force Detection

```bash
grep -E 'Failed password.*from [0-9.]+' /var/log/auth.log | \
    grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}' | \
    sort | uniq -c | sort -rn
```

#### 5. Error Code Pattern Matching

```bash
grep -E 'HTTP/[0-9.]+ (4[0-9]{2}|5[0-9]{2})' /var/log/nginx/access.log
```

#### 6. Port Scan Detection

```bash
grep -E 'SYN.*[0-9]+\s+port\s+[0-9]+' /var/log/firewall.log
```

---

## Advanced Command Combinations {#advanced-combinations}

### Piping Multiple Commands

#### 1. Log Analysis Pipeline

```bash
cat /var/log/auth.log | \
    grep "Failed password" | \
    awk '{print $11}' | \
    sort | \
    uniq -c | \
    sort -rn | \
    head -10
```

#### 2. System Resource Monitoring

```bash
ps aux | \
    grep -v grep | \
    awk '{print $3, $4, $11}' | \
    sort -k1 -rn | \
    head -20
```

#### 3. Network Traffic Analysis

```bash
tcpdump -nn -r capture.pcap | \
    grep -E 'IP [0-9.]+.*>[0-9.]+' | \
    awk '{print $3}' | \
    cut -d. -f1-4 | \
    sort | \
    uniq -c | \
    sort -rn
```

### Complex Data Processing

#### 4. Apache Log Analysis

```bash
cat /var/log/apache2/access.log | \
    awk '{print $1,$7,$9}' | \
    grep " 404 " | \
    awk '{print $2}' | \
    sort | \
    uniq -c | \
    sort -rn | \
    head -20
```

#### 5. User Activity Report

```bash
last | \
    grep -v "^$" | \
    awk '{print $1}' | \
    sort | \
    uniq -c | \
    sort -rn
```

#### 6. Disk Usage by Directory

```bash
du -h /var | \
    grep "^[0-9.]*G" | \
    sort -rh | \
    head -20
```

### Security Analysis Pipelines

#### 7. Failed Login Geographic Analysis

```bash
grep "Failed password" /var/log/auth.log | \
    grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}' | \
    while read ip; do
        echo -n "$ip - "
        geoiplookup $ip | cut -d: -f2
    done | \
    sort | \
    uniq -c | \
    sort -rn
```

#### 8. Port Usage Analysis

```bash
netstat -tuln | \
    grep LISTEN | \
    awk '{print $4}' | \
    sed 's/.*://' | \
    sort -n | \
    uniq -c
```

#### 9. File Permission Audit

```bash
find /etc -type f -perm /o+w 2>/dev/null | \
    while read file; do
        ls -l "$file" | awk '{print $1, $3, $4, $NF}'
    done
```

---

## Real-World DevSecOps Scenarios {#real-world-scenarios}

### Scenario 1: Security Incident Response

#### Detect Suspicious Login Patterns

```bash
#!/bin/bash
# Monitor failed SSH attempts and block IPs with more than 5 failures

grep "Failed password" /var/log/auth.log | \
    awk '{print $11}' | \
    sort | \
    uniq -c | \
    sort -rn | \
    while read count ip; do
        if [ "$count" -gt 5 ]; then
            echo "Blocking IP: $ip (Failed attempts: $count)"
            iptables -A INPUT -s $ip -j DROP
        fi
    done
```

### Scenario 2: Application Performance Monitoring

#### Analyze Response Times

```bash
#!/bin/bash
# Extract and analyze API response times from Nginx logs

cat /var/log/nginx/access.log | \
    awk '{print $NF}' | \
    awk 'BEGIN {
        sum=0; count=0; max=0; min=999999
    }
    {
        sum+=$1; count++
        if($1>max) max=$1
        if($1<min) min=$1
    }
    END {
        print "Average Response Time:", sum/count, "seconds"
        print "Max Response Time:", max, "seconds"
        print "Min Response Time:", min, "seconds"
    }'
```

### Scenario 3: Configuration Compliance Audit

#### Check SSH Configuration

```bash
#!/bin/bash
# Verify SSH security configurations

echo "=== SSH Security Audit ==="

# Check PermitRootLogin
root_login=$(grep "^PermitRootLogin" /etc/ssh/sshd_config | awk '{print $2}')
if [ "$root_login" = "no" ]; then
    echo "[PASS] Root login is disabled"
else
    echo "[FAIL] Root login is enabled: $root_login"
fi

# Check PasswordAuthentication
pass_auth=$(grep "^PasswordAuthentication" /etc/ssh/sshd_config | awk '{print $2}')
if [ "$pass_auth" = "no" ]; then
    echo "[PASS] Password authentication is disabled"
else
    echo "[WARN] Password authentication is enabled"
fi

# Check Port
port=$(grep "^Port" /etc/ssh/sshd_config | awk '{print $2}')
if [ "$port" != "22" ]; then
    echo "[PASS] SSH port changed from default: $port"
else
    echo "[WARN] SSH running on default port 22"
fi
```

### Scenario 4: Log Aggregation and Analysis

#### Centralized Error Reporting

```bash
#!/bin/bash
# Aggregate errors from multiple log files

echo "=== System-Wide Error Report ==="
echo "Generated: $(date)"
echo

for log in /var/log/{syslog,auth.log,nginx/error.log,mysql/error.log}; do
    if [ -f "$log" ]; then
        echo "=== $(basename $log) ==="
        grep -i "error\|critical\|emergency" "$log" | tail -n 10
        echo
    fi
done
```

### Scenario 5: Database Query Optimization

#### Analyze Slow Queries

```bash
#!/bin/bash
# Parse MySQL slow query log

awk '/Query_time/ {
    query_time=$3
    getline
    getline
    print query_time, $0
}' /var/log/mysql/slow-query.log | \
    sort -k1 -rn | \
    head -20
```

### Scenario 6: Container Log Analysis

#### Docker Container Monitoring

```bash
#!/bin/bash
# Monitor Docker container logs for errors

for container in $(docker ps -q); do
    name=$(docker inspect --format='{{.Name}}' $container | sed 's/^.//')
    echo "=== Container: $name ==="
    docker logs --tail 100 $container 2>&1 | \
        grep -E "ERROR|FATAL|Exception" | \
        tail -n 5
    echo
done
```

### Scenario 7: Compliance Reporting

#### Generate PCI-DSS Compliance Report

```bash
#!/bin/bash
# Basic PCI-DSS compliance check

echo "=== PCI-DSS Compliance Check ==="
echo

# Check for unencrypted passwords in configs
echo "1. Checking for plaintext passwords..."
if grep -r "password\s*=\s*[^$]" /etc/*.conf 2>/dev/null | grep -v "#"; then
    echo "[FAIL] Plaintext passwords found"
else
    echo "[PASS] No plaintext passwords in configs"
fi

# Check SSL/TLS configuration
echo "2. Checking SSL/TLS settings..."
if grep -q "TLSv1.2\|TLSv1.3" /etc/nginx/nginx.conf 2>/dev/null; then
    echo "[PASS] Strong TLS versions configured"
else
    echo "[WARN] Review TLS configuration"
fi

# Check file permissions
echo "3. Checking sensitive file permissions..."
find /etc/ssl -type f -perm /o+r 2>/dev/null
```

---

## Performance Considerations {#performance}

### Command Performance Comparison

| Command     | Best For              | Performance | Memory Usage |
| ----------- | --------------------- | ----------- | ------------ |
| `cat`       | Small to medium files | Fast        | Low          |
| `grep`      | Pattern matching      | Very Fast   | Low          |
| `awk`       | Column processing     | Fast        | Medium       |
| `sed`       | Line-based editing    | Fast        | Low          |
| `head/tail` | Partial file reading  | Very Fast   | Very Low     |

### Optimization Tips

#### 1. Use grep -F for Fixed Strings

```bash
# Slower (regex matching)
grep "exact_string" large_file.log

# Faster (fixed string matching)
grep -F "exact_string" large_file.log
```

#### 2. Limit grep Context

```bash
# Instead of grepping entire file
grep "pattern" huge_file.log

# Grep only recent data
tail -n 10000 huge_file.log | grep "pattern"
```

#### 3. Use awk Instead of Multiple greps

```bash
# Slower
cat file.log | grep "pattern1" | grep "pattern2" | grep "pattern3"

# Faster
awk '/pattern1/ && /pattern2/ && /pattern3/' file.log
```

#### 4. Parallel Processing

```bash
# Process multiple files in parallel
find /var/log -name "*.log" -print0 | \
    xargs -0 -P 4 grep -l "ERROR"
```

#### 5. Binary vs Text Mode

```bash
# Binary mode (faster for large files)
grep -a "pattern" large_binary_file

# Text mode (default)
grep "pattern" text_file
```

---

## Best Practices {#best-practices}

### 1. Always Quote Variables

```bash
# Bad
grep $PATTERN $FILE

# Good
grep "$PATTERN" "$FILE"
```

### 2. Use -r for Recursive Operations Safely

```bash
# Include error handling
grep -r "pattern" /etc/ 2>/dev/null
```

### 3. Test Regular Expressions

```bash
# Test regex before applying to production
echo "test string" | grep -E "your_regex_pattern"
```

### 4. Create Backups Before In-Place Editing

```bash
# Always create backup
sed -i.bak 's/old/new/g' important_file.conf
```

### 5. Use Appropriate Field Separators

```bash
# Explicit field separator
awk -F':' '{print $1}' /etc/passwd
```

### 6. Log Processing Best Practices

```bash
# Always handle log rotation
tail -F /var/log/app.log  # Follows even after rotation

# Compress old logs
gzip /var/log/old_*.log
```

### 7. Security Considerations

```bash
# Never log sensitive data
grep "password" /etc/*.conf 2>&1 | sed 's/password=.*/password=REDACTED/'

# Restrict permissions
chmod 600 sensitive_report.txt
```

### 8. Documentation and Comments

```bash
#!/bin/bash
# Purpose: Security audit script
# Author: DevSecOps Team
# Last Modified: 2025-12-17

# Extract failed login attempts from last 24 hours
grep "Failed password" /var/log/auth.log | \
    awk '{print $11}' | \  # Extract IP address
    sort | \                # Sort IPs
    uniq -c | \            # Count occurrences
    sort -rn               # Sort by count
```

### 9. Error Handling in Scripts

```bash
#!/bin/bash
set -euo pipefail  # Exit on error, undefined variables, pipe failures

if ! grep -q "pattern" file.txt; then
    echo "Pattern not found" >&2
    exit 1
fi
```

### 10. Monitoring and Alerting

```bash
#!/bin/bash
# Send alert if error count exceeds threshold

ERROR_COUNT=$(grep -c "ERROR" /var/log/app.log)
THRESHOLD=100

if [ "$ERROR_COUNT" -gt "$THRESHOLD" ]; then
    echo "ERROR: $ERROR_COUNT errors detected" | \
        mail -s "Alert: High Error Rate" admin@example.com
fi
```

---

## Conclusion

These Linux text processing commands form the foundation of effective system administration and DevSecOps practices. Mastering them enables:

- **Efficient log analysis** for security incident response
- **Automated configuration management** and compliance checking
- **Performance monitoring** and optimization
- **Data extraction and reporting** for business intelligence
- **Security auditing** and vulnerability detection

### Next Steps for Mastery

1. **Practice daily** with real log files and configurations
2. **Create custom scripts** for recurring tasks
3. **Study advanced regex** patterns for complex matching
4. **Combine commands** creatively to solve unique problems
5. **Document your solutions** for team knowledge sharing
6. **Optimize performance** for large-scale data processing
7. **Integrate with monitoring tools** (Prometheus, Grafana, ELK stack)

### Additional Resources

- GNU Grep Manual: `man grep`
- GNU Awk Manual: `man awk`
- GNU Sed Manual: `man sed`
- Regular Expression testing: https://regex101.com
- Linux Command Line: https://linuxcommand.org

---

**Document Version:** 1.0  
**Last Updated:** December 17, 2025  
**Author:** DevSecOps Documentation Team
