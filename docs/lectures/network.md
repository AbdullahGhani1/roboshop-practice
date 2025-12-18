# Network & Security Terminal Commands: Advanced DevSecOps Guide

## Table of Contents

1. [Network Information & Configuration](#network-info)
2. [Network Connectivity Testing](#connectivity)
3. [DNS & Name Resolution](#dns)
4. [Port Scanning & Service Detection](#port-scanning)
5. [Network Traffic Analysis](#traffic-analysis)
6. [Firewall Management](#firewall)
7. [SSL/TLS & Certificates](#ssl-tls)
8. [Network Security Monitoring](#security-monitoring)
9. [VPN & Tunneling](#vpn-tunneling)
10. [Network Troubleshooting Scripts](#troubleshooting-scripts)
11. [Security Hardening Scripts](#security-scripts)
12. [Advanced Bash Scripts](#advanced-scripts)

---

## Network Information & Configuration {#network-info}

### IP Address Management

#### View Network Interfaces

```bash
# Modern method (ip command)
ip addr show
ip a

# Show specific interface
ip addr show eth0

# Legacy method (deprecated but still used)
ifconfig
ifconfig eth0
```

**Output Example:**

```
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP
    inet 192.168.1.100/24 brd 192.168.1.255 scope global eth0
    inet6 fe80::a00:27ff:fe4e:66a1/64 scope link
```

#### Configure IP Address

```bash
# Assign IP address
sudo ip addr add 192.168.1.100/24 dev eth0

# Remove IP address
sudo ip addr del 192.168.1.100/24 dev eth0

# Bring interface up
sudo ip link set eth0 up

# Bring interface down
sudo ip link set eth0 down
```

#### View Routing Table

```bash
# Modern method
ip route show
ip r

# Show default gateway
ip route | grep default

# Legacy method
route -n
netstat -rn
```

#### Add/Delete Routes

```bash
# Add default gateway
sudo ip route add default via 192.168.1.1

# Add specific route
sudo ip route add 10.0.0.0/8 via 192.168.1.254

# Delete route
sudo ip route del 10.0.0.0/8

# Add route to specific interface
sudo ip route add 172.16.0.0/16 dev eth1
```

### Network Interface Statistics

```bash
# Show interface statistics
ip -s link
ip -s link show eth0

# Detailed statistics
watch -n 1 'ip -s link show eth0'

# Network traffic statistics
netstat -i
ifconfig eth0
```

### MAC Address Management

```bash
# Show MAC addresses
ip link show
ip link show eth0 | grep ether

# Change MAC address (temporary)
sudo ip link set dev eth0 down
sudo ip link set dev eth0 address 00:11:22:33:44:55
sudo ip link set dev eth0 up

# Random MAC address
sudo macchanger -r eth0
```

### Network Configuration Files

```bash
# Ubuntu/Debian (netplan)
cat /etc/netplan/*.yaml

# CentOS/RHEL
cat /etc/sysconfig/network-scripts/ifcfg-eth0

# DNS configuration
cat /etc/resolv.conf

# Hosts file
cat /etc/hosts

# Network interfaces
cat /etc/network/interfaces
```

### Advanced Network Information Script

```bash
#!/bin/bash
# network-info.sh - Comprehensive network information

echo "=== Network Information Report ==="
echo "Generated: $(date)"
echo

echo "=== Network Interfaces ==="
ip -br addr show
echo

echo "=== Routing Table ==="
ip route show
echo

echo "=== DNS Servers ==="
cat /etc/resolv.conf | grep nameserver
echo

echo "=== Active Connections ==="
ss -tuln | head -20
echo

echo "=== Network Statistics ==="
ip -s link
```

---

## Network Connectivity Testing {#connectivity}

### Ping - ICMP Testing

```bash
# Basic ping
ping google.com

# Ping with count
ping -c 4 google.com

# Ping with interval
ping -i 0.2 google.com

# Ping with packet size
ping -s 1000 google.com

# Ping with timeout
ping -W 2 google.com

# Flood ping (requires root)
sudo ping -f 192.168.1.1

# IPv6 ping
ping6 google.com
```

### Advanced Ping Script

```bash
#!/bin/bash
# multi-ping.sh - Ping multiple hosts

HOSTS=(
    "google.com"
    "8.8.8.8"
    "cloudflare.com"
    "github.com"
)

echo "=== Network Connectivity Test ==="
echo "Testing ${#HOSTS[@]} hosts..."
echo

for host in "${HOSTS[@]}"; do
    if ping -c 2 -W 2 "$host" &>/dev/null; then
        echo "✓ $host - REACHABLE"
    else
        echo "✗ $host - UNREACHABLE"
    fi
done
```

### Traceroute - Path Discovery

```bash
# Basic traceroute
traceroute google.com

# Traceroute with ICMP
sudo traceroute -I google.com

# Traceroute with TCP
sudo traceroute -T -p 80 google.com

# Traceroute with UDP (default)
traceroute -U google.com

# Maximum hops
traceroute -m 15 google.com

# Bypass routing table
traceroute -r 192.168.1.1

# MTR (continuous traceroute)
mtr google.com
mtr -n google.com  # No DNS resolution
```

### TCP Connectivity Testing

```bash
# Test specific port (telnet)
telnet google.com 80

# Test with netcat
nc -zv google.com 80
nc -zv 192.168.1.100 22

# Test port range
nc -zv 192.168.1.100 20-25

# Test with timeout
timeout 5 bash -c "</dev/tcp/google.com/80" && echo "Port 80 open"

# Test multiple ports
for port in 22 80 443 3306; do
    timeout 1 bash -c "</dev/tcp/192.168.1.100/$port" 2>/dev/null && echo "Port $port: OPEN" || echo "Port $port: CLOSED"
done
```

### Connection Testing Script

```bash
#!/bin/bash
# test-connectivity.sh - Comprehensive connectivity test

TARGET="${1:-google.com}"
PORTS=(22 80 443 3306 5432 8080)

echo "=== Connectivity Test for $TARGET ==="
echo

# ICMP test
echo "1. ICMP Connectivity:"
if ping -c 2 -W 2 "$TARGET" &>/dev/null; then
    echo "   ✓ Host is reachable"

    # Latency
    LATENCY=$(ping -c 5 "$TARGET" 2>/dev/null | tail -1 | awk '{print $4}' | cut -d '/' -f 2)
    echo "   Average latency: ${LATENCY}ms"
else
    echo "   ✗ Host is unreachable"
fi
echo

# DNS resolution
echo "2. DNS Resolution:"
IP=$(dig +short "$TARGET" | head -1)
if [ -n "$IP" ]; then
    echo "   ✓ Resolved to: $IP"
else
    echo "   ✗ DNS resolution failed"
fi
echo

# Port scanning
echo "3. Port Status:"
for port in "${PORTS[@]}"; do
    if timeout 1 bash -c "</dev/tcp/$TARGET/$port" 2>/dev/null; then
        echo "   ✓ Port $port: OPEN"
    else
        echo "   ✗ Port $port: CLOSED/FILTERED"
    fi
done
```

---

## DNS & Name Resolution {#dns}

### Basic DNS Queries

```bash
# Query DNS records
nslookup google.com

# Specific DNS server
nslookup google.com 8.8.8.8

# Reverse DNS lookup
nslookup 8.8.8.8

# Query specific record type
nslookup -type=mx google.com
nslookup -type=ns google.com
```

### Dig - Advanced DNS Tool

```bash
# Basic query
dig google.com

# Short answer only
dig +short google.com

# Query specific record type
dig google.com A
dig google.com MX
dig google.com NS
dig google.com TXT
dig google.com AAAA

# Query specific DNS server
dig @8.8.8.8 google.com

# Trace DNS resolution path
dig +trace google.com

# Reverse DNS lookup
dig -x 8.8.8.8

# Query all records
dig google.com ANY

# Show query time
dig google.com | grep "Query time"
```

### Host Command

```bash
# Basic lookup
host google.com

# Specific record type
host -t MX google.com
host -t NS google.com
host -t TXT google.com

# Reverse lookup
host 8.8.8.8

# Verbose output
host -v google.com

# Use specific DNS server
host google.com 8.8.8.8
```

### DNS Troubleshooting Script

```bash
#!/bin/bash
# dns-check.sh - Comprehensive DNS analysis

DOMAIN="${1:-google.com}"
DNS_SERVERS=("8.8.8.8" "1.1.1.1" "8.8.4.4")

echo "=== DNS Analysis for $DOMAIN ==="
echo

# Check each DNS server
for dns in "${DNS_SERVERS[@]}"; do
    echo "Testing DNS Server: $dns"

    # Query A record
    RESULT=$(dig @$dns +short "$DOMAIN" A 2>/dev/null | head -1)
    if [ -n "$RESULT" ]; then
        echo "  ✓ A Record: $RESULT"
    else
        echo "  ✗ A Record: Failed"
    fi

    # Query time
    QUERY_TIME=$(dig @$dns "$DOMAIN" 2>/dev/null | grep "Query time" | awk '{print $4}')
    echo "  Query Time: ${QUERY_TIME}ms"
    echo
done

# Additional record types
echo "Record Types:"
for type in A AAAA MX NS TXT; do
    echo "  $type:"
    dig +short "$DOMAIN" "$type" | sed 's/^/    /'
done
```

### DNS Cache Management

```bash
# Flush DNS cache (Ubuntu)
sudo systemd-resolve --flush-caches

# Check DNS cache statistics
sudo systemd-resolve --statistics

# Flush DNS cache (macOS)
sudo dscacheutil -flushcache
sudo killall -HUP mDNSResponder

# View resolved DNS entries
systemd-resolve --status

# Test with specific DNS
dig @8.8.8.8 example.com +noall +answer
```

---

## Port Scanning & Service Detection {#port-scanning}

### Netstat - Network Statistics

```bash
# Show all listening ports
netstat -tuln

# Show all connections
netstat -tun

# Show with process information
sudo netstat -tulnp

# Show statistics
netstat -s

# Show routing table
netstat -rn

# Show interface statistics
netstat -i

# Continuous monitoring
watch -n 2 'netstat -tuln'
```

### SS - Socket Statistics (Modern)

```bash
# Show all listening TCP/UDP ports
ss -tuln

# Show with process information
sudo ss -tulnp

# Show established connections
ss -tun state established

# Show listening sockets
ss -tl

# Show UDP sockets
ss -u

# Show statistics
ss -s

# Filter by port
ss -tuln sport = :80
ss -tuln dport = :443

# Show specific state
ss state time-wait
ss state syn-sent
```

### Nmap - Network Mapper

```bash
# Install nmap
sudo apt install nmap -y  # Ubuntu
sudo yum install nmap -y  # CentOS

# Basic scan
nmap 192.168.1.1

# Scan multiple hosts
nmap 192.168.1.1-10
nmap 192.168.1.0/24

# Scan specific ports
nmap -p 22,80,443 192.168.1.1

# Scan port range
nmap -p 1-1000 192.168.1.1

# Scan all ports
nmap -p- 192.168.1.1

# TCP SYN scan (stealth)
sudo nmap -sS 192.168.1.1

# TCP connect scan
nmap -sT 192.168.1.1

# UDP scan
sudo nmap -sU 192.168.1.1

# Service version detection
nmap -sV 192.168.1.1

# OS detection
sudo nmap -O 192.168.1.1

# Aggressive scan
sudo nmap -A 192.168.1.1

# Fast scan (top 100 ports)
nmap -F 192.168.1.1

# Timing templates
nmap -T4 192.168.1.1  # Faster
nmap -T2 192.168.1.1  # Slower, more polite

# Output to file
nmap -oN scan.txt 192.168.1.1
nmap -oX scan.xml 192.168.1.1

# Scan and output all formats
nmap -oA myscan 192.168.1.1
```

### Port Scanning Script

```bash
#!/bin/bash
# port-scanner.sh - Advanced port scanner

TARGET="${1:-192.168.1.1}"
START_PORT="${2:-1}"
END_PORT="${3:-1024}"

echo "=== Port Scanner ==="
echo "Target: $TARGET"
echo "Port Range: $START_PORT-$END_PORT"
echo "Scanning..."
echo

OPEN_PORTS=()

for ((port=$START_PORT; port<=$END_PORT; port++)); do
    # Show progress every 100 ports
    if (( port % 100 == 0 )); then
        echo "Scanned: $port/$END_PORT"
    fi

    # Test port
    if timeout 0.1 bash -c ">/dev/tcp/$TARGET/$port" 2>/dev/null; then
        OPEN_PORTS+=($port)

        # Try to identify service
        SERVICE=$(grep -w "$port/tcp" /etc/services | head -1 | awk '{print $1}')
        echo "✓ Port $port OPEN - $SERVICE"
    fi
done

echo
echo "=== Summary ==="
echo "Total open ports: ${#OPEN_PORTS[@]}"
echo "Open ports: ${OPEN_PORTS[*]}"
```

### Service Detection Script

```bash
#!/bin/bash
# service-detect.sh - Detect services on open ports

TARGET="$1"
COMMON_PORTS=(21 22 23 25 53 80 110 143 443 445 3306 3389 5432 5900 8080)

echo "=== Service Detection for $TARGET ==="
echo

for port in "${COMMON_PORTS[@]}"; do
    if timeout 1 bash -c ">/dev/tcp/$TARGET/$port" 2>/dev/null; then
        # Port is open, try banner grabbing
        echo "Port $port: OPEN"

        case $port in
            22)  echo "  Service: SSH"
                 timeout 2 bash -c "exec 3<>/dev/tcp/$TARGET/$port && cat <&3" 2>/dev/null | head -1
                 ;;
            80)  echo "  Service: HTTP"
                 echo "GET / HTTP/1.0\r\n\r\n" | timeout 2 nc -q 1 "$TARGET" "$port" | head -5
                 ;;
            443) echo "  Service: HTTPS"
                 ;;
            3306) echo "  Service: MySQL"
                  ;;
            5432) echo "  Service: PostgreSQL"
                  ;;
            *) echo "  Service: Unknown"
               ;;
        esac
        echo
    fi
done
```

---

## Network Traffic Analysis {#traffic-analysis}

### TCPDump - Packet Capture

```bash
# Capture on interface
sudo tcpdump -i eth0

# Capture with count
sudo tcpdump -i eth0 -c 100

# Capture to file
sudo tcpdump -i eth0 -w capture.pcap

# Read from file
tcpdump -r capture.pcap

# Capture specific host
sudo tcpdump -i eth0 host 192.168.1.100

# Capture specific port
sudo tcpdump -i eth0 port 80

# Capture specific protocol
sudo tcpdump -i eth0 tcp
sudo tcpdump -i eth0 udp
sudo tcpdump -i eth0 icmp

# Capture with detailed output
sudo tcpdump -i eth0 -v
sudo tcpdump -i eth0 -vv
sudo tcpdump -i eth0 -vvv

# Show packet contents in ASCII
sudo tcpdump -i eth0 -A

# Show packet contents in hex
sudo tcpdump -i eth0 -X

# Capture specific network
sudo tcpdump -i eth0 net 192.168.1.0/24

# Capture source/destination
sudo tcpdump -i eth0 src 192.168.1.100
sudo tcpdump -i eth0 dst 192.168.1.100

# Complex filters
sudo tcpdump -i eth0 'tcp port 80 and (src 192.168.1.100 or dst 192.168.1.100)'

# Capture HTTP traffic
sudo tcpdump -i eth0 -A 'tcp port 80 and (((ip[2:2] - ((ip[0]&0xf)<<2)) - ((tcp[12]&0xf0)>>2)) != 0)'

# Capture DNS queries
sudo tcpdump -i eth0 -n port 53
```

### Traffic Analysis Script

```bash
#!/bin/bash
# traffic-monitor.sh - Real-time traffic analysis

INTERFACE="${1:-eth0}"
DURATION="${2:-60}"

echo "=== Network Traffic Monitor ==="
echo "Interface: $INTERFACE"
echo "Duration: ${DURATION}s"
echo

CAPTURE_FILE="/tmp/capture_$(date +%s).pcap"

# Capture traffic
echo "Capturing traffic..."
sudo timeout "$DURATION" tcpdump -i "$INTERFACE" -w "$CAPTURE_FILE" -q 2>/dev/null

# Analyze capture
echo "Analyzing..."
echo

echo "=== Top Talkers (by packets) ==="
tcpdump -r "$CAPTURE_FILE" -n 2>/dev/null | \
    awk '{print $3}' | \
    cut -d. -f1-4 | \
    sort | \
    uniq -c | \
    sort -rn | \
    head -10

echo
echo "=== Protocol Distribution ==="
tcpdump -r "$CAPTURE_FILE" -n 2>/dev/null | \
    awk '{print $NF}' | \
    sort | \
    uniq -c | \
    sort -rn | \
    head -10

echo
echo "=== Top Ports ==="
tcpdump -r "$CAPTURE_FILE" -n 2>/dev/null | \
    grep -oE ':[0-9]+' | \
    cut -d: -f2 | \
    sort | \
    uniq -c | \
    sort -rn | \
    head -10

# Cleanup
rm -f "$CAPTURE_FILE"
```

### Bandwidth Monitoring

```bash
# Install iftop
sudo apt install iftop -y

# Monitor bandwidth
sudo iftop -i eth0

# Monitor specific network
sudo iftop -i eth0 -f "net 192.168.1.0/24"

# Monitor specific port
sudo iftop -i eth0 -f "port 80"

# Batch mode (for scripts)
sudo iftop -i eth0 -t -s 10

# Install nethogs (per-process bandwidth)
sudo apt install nethogs -y

# Monitor per-process
sudo nethogs eth0

# Install vnstat (traffic statistics)
sudo apt install vnstat -y

# Show statistics
vnstat -i eth0
vnstat -h  # Hourly
vnstat -d  # Daily
vnstat -m  # Monthly
```

---

## Firewall Management {#firewall}

### UFW (Uncomplicated Firewall) - Ubuntu

```bash
# Enable firewall
sudo ufw enable

# Disable firewall
sudo ufw disable

# Check status
sudo ufw status
sudo ufw status verbose
sudo ufw status numbered

# Allow port
sudo ufw allow 22
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp

# Allow from specific IP
sudo ufw allow from 192.168.1.100

# Allow from subnet
sudo ufw allow from 192.168.1.0/24

# Allow specific port from IP
sudo ufw allow from 192.168.1.100 to any port 22

# Allow service
sudo ufw allow ssh
sudo ufw allow http
sudo ufw allow https

# Deny port
sudo ufw deny 23
sudo ufw deny 3306/tcp

# Delete rule
sudo ufw delete allow 80

# Delete rule by number
sudo ufw status numbered
sudo ufw delete 2

# Reset firewall
sudo ufw reset

# Default policies
sudo ufw default deny incoming
sudo ufw default allow outgoing

# Logging
sudo ufw logging on
sudo ufw logging off
```

### Firewalld - CentOS/RHEL

```bash
# Start firewalld
sudo systemctl start firewalld
sudo systemctl enable firewalld

# Check status
sudo firewall-cmd --state
sudo firewall-cmd --list-all

# List zones
sudo firewall-cmd --get-zones
sudo firewall-cmd --get-active-zones

# Add service
sudo firewall-cmd --add-service=http
sudo firewall-cmd --add-service=https
sudo firewall-cmd --add-service=ssh

# Add port
sudo firewall-cmd --add-port=8080/tcp
sudo firewall-cmd --add-port=3000-3100/tcp

# Make changes permanent
sudo firewall-cmd --add-service=http --permanent
sudo firewall-cmd --reload

# Remove service/port
sudo firewall-cmd --remove-service=http
sudo firewall-cmd --remove-port=8080/tcp

# Rich rules
sudo firewall-cmd --add-rich-rule='rule family="ipv4" source address="192.168.1.0/24" accept'

# Block IP
sudo firewall-cmd --add-rich-rule='rule family="ipv4" source address="1.2.3.4" reject'

# List rules
sudo firewall-cmd --list-services
sudo firewall-cmd --list-ports
sudo firewall-cmd --list-rich-rules
```

### IPTables - Advanced Firewall

```bash
# List rules
sudo iptables -L
sudo iptables -L -v
sudo iptables -L -n
sudo iptables -L --line-numbers

# List with numeric output (faster)
sudo iptables -L -n -v

# Allow incoming SSH
sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT

# Allow incoming HTTP/HTTPS
sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 443 -j ACCEPT

# Allow from specific IP
sudo iptables -A INPUT -s 192.168.1.100 -j ACCEPT

# Allow from subnet
sudo iptables -A INPUT -s 192.168.1.0/24 -j ACCEPT

# Block IP
sudo iptables -A INPUT -s 1.2.3.4 -j DROP

# Block port
sudo iptables -A INPUT -p tcp --dport 23 -j DROP

# Allow established connections
sudo iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# Allow loopback
sudo iptables -A INPUT -i lo -j ACCEPT

# Default policies
sudo iptables -P INPUT DROP
sudo iptables -P FORWARD DROP
sudo iptables -P OUTPUT ACCEPT

# Delete rule by number
sudo iptables -D INPUT 3

# Delete all rules
sudo iptables -F

# Save rules (Ubuntu)
sudo iptables-save > /etc/iptables/rules.v4

# Restore rules
sudo iptables-restore < /etc/iptables/rules.v4

# Port forwarding
sudo iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-port 8080
```

### Firewall Security Script

```bash
#!/bin/bash
# firewall-secure.sh - Secure firewall configuration

echo "=== Configuring Secure Firewall ==="

# Flush existing rules
sudo iptables -F
sudo iptables -X
sudo iptables -t nat -F
sudo iptables -t nat -X
sudo iptables -t mangle -F
sudo iptables -t mangle -X

# Default policies
sudo iptables -P INPUT DROP
sudo iptables -P FORWARD DROP
sudo iptables -P OUTPUT ACCEPT

# Allow loopback
sudo iptables -A INPUT -i lo -j ACCEPT
sudo iptables -A OUTPUT -o lo -j ACCEPT

# Allow established connections
sudo iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# Allow SSH (change port if not 22)
sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT

# Allow HTTP/HTTPS
sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 443 -j ACCEPT

# Allow ping (ICMP)
sudo iptables -A INPUT -p icmp --icmp-type echo-request -j ACCEPT

# Rate limit SSH connections (prevent brute force)
sudo iptables -A INPUT -p tcp --dport 22 -m state --state NEW -m recent --set
sudo iptables -A INPUT -p tcp --dport 22 -m state --state NEW -m recent --update --seconds 60 --hitcount 4 -j DROP

# Log dropped packets
sudo iptables -A INPUT -m limit --limit 5/min -j LOG --log-prefix "iptables denied: " --log-level 7

# Save rules
sudo iptables-save > /etc/iptables/rules.v4

echo "✓ Firewall configured"
echo "Active rules:"
sudo iptables -L -n
```

---

## SSL/TLS & Certificates {#ssl-tls}

### OpenSSL Commands

```bash
# Check OpenSSL version
openssl version

# Generate private key
openssl genrsa -out private.key 2048

# Generate private key with encryption
openssl genrsa -aes256 -out private.key 2048

# Generate public key
openssl rsa -in private.key -pubout -out public.key

# Generate CSR (Certificate Signing Request)
openssl req -new -key private.key -out request.csr

# Generate self-signed certificate
openssl req -x509 -new -nodes -key private.key -sha256 -days 365 -out certificate.crt

# View certificate details
openssl x509 -in certificate.crt -text -noout

# View certificate dates
openssl x509 -in certificate.crt -noout -dates

# View certificate subject
openssl x509 -in certificate.crt -noout -subject

# View certificate issuer
openssl x509 -in certificate.crt -noout -issuer

# Verify certificate
openssl verify certificate.crt

# Test SSL/TLS connection
openssl s_client -connect google.com:443

# Show certificate chain
openssl s_client -connect google.com:443 -showcerts

# Test specific SSL/TLS version
openssl s_client -connect google.com:443 -tls1_2
openssl s_client -connect google.com:443 -tls1_3

# Check certificate expiration
echo | openssl s_client -connect google.com:443 2>/dev/null | openssl x509 -noout -dates

# Convert certificate formats
openssl x509 -in cert.crt -out cert.pem -outform PEM
openssl x509 -in cert.pem -out cert.der -outform DER

# Create PKCS12 file
openssl pkcs12 -export -out certificate.pfx -inkey private.key -in certificate.crt
```

### SSL/TLS Testing Script

```bash
#!/bin/bash
# ssl-check.sh - Comprehensive SSL/TLS analysis

DOMAIN="${1}"
PORT="${2:-443}"

if [ -z "$DOMAIN" ]; then
    echo "Usage: $0 <domain> [port]"
    exit 1
fi

echo "=== SSL/TLS Analysis for $DOMAIN:$PORT ==="
echo

# Test connection
echo "1. Connection Test:"
if timeout 5 openssl s_client -connect "$DOMAIN:$PORT" </dev/null &>/dev/null; then
    echo "   ✓ SSL/TLS connection successful"
else
    echo "   ✗ SSL/TLS connection failed"
    exit 1
fi
echo

# Certificate details
echo "2. Certificate Information:"
CERT_INFO=$(echo | openssl s_client -connect "$DOMAIN:$PORT" 2>/dev/null | openssl x509 -noout -subject -dates -issuer 2>/dev/null)
echo "$CERT_INFO" | sed 's/^/   /'
echo

# Certificate expiration
echo "3. Certificate Expiration:"
EXPIRY=$(echo | openssl s_client -connect "$DOMAIN:$PORT" 2>/dev/null | openssl x509 -noout -enddate 2>/dev/null | cut -d= -f2)
EXPIRY_EPOCH=$(date -d "$EXPIRY" +%s 2>/dev/null)
NOW_EPOCH=$(date +%s)
DAYS_LEFT=$(( ($EXPIRY_EPOCH - $NOW_EPOCH) / 86400 ))

if [ "$DAYS_LEFT" -lt 0 ]; then
    echo "   ✗ Certificate EXPIRED $((DAYS_LEFT * -1)) days ago"
elif [ "$DAYS_LEFT" -lt 30 ]; then
    echo "   ⚠ Certificate expires in $DAYS_LEFT days"
else
    echo "   ✓ Certificate valid for $DAYS_LEFT days"
fi
echo

# Supported protocols
echo "4. Supported SSL/TLS Protocols:"
for version in ssl3 tls1 tls1_1 tls1_2 tls1_3; do
    if timeout 2 openssl s_client -connect "$DOMAIN:$PORT" -"$version" </dev/null &>/dev/null; then
        echo "   ✓ $version: SUPPORTED"
    else
        echo "   ✗ $version: NOT SUPPORTED"
    fi
done
echo

# Certificate chain
echo "5. Certificate Chain:"
echo | openssl s_client -connect "$DOMAIN:$PORT" -showcerts 2>/dev/null | \
    grep -E "s:|i:" | \
    sed 's/^/   /'
```

### Certificate Monitoring Script

```bash
#!/bin/bash
# cert-monitor.sh - Monitor certificate expiration

DOMAINS=(
    "google.com:443"
    "github.com:443"
    "example.com:443"
)

WARN_DAYS=30
CRITICAL_DAYS=7

echo "=== Certificate Expiration Monitor ==="
echo "Generated: $(date)"
echo

for domain_port in "${DOMAINS[@]}"; do
    DOMAIN=$(echo "$domain_port" | cut -d: -f1)
    PORT=$(echo "$domain_port" | cut -d: -f2)

    echo "Checking: $DOMAIN:$PORT"

    # Get expiration date
    EXPIRY=$(echo | timeout 5 openssl s_client -connect "$domain_port" 2>/dev/null | \
             openssl x509 -noout -enddate 2>/dev/null | cut -d= -f2)

    if [ -z "$EXPIRY" ]; then
        echo "  ✗ Unable to retrieve certificate"
        continue
    fi

    # Calculate days left
    EXPIRY_EPOCH=$(date -d "$EXPIRY" +%s 2>/dev/null)
    NOW_EPOCH=$(date +%s)
    DAYS_LEFT=$(( ($EXPIRY_EPOCH - $NOW_EPOCH) / 86400 ))

    # Alert based on days left
    if [ "$DAYS_LEFT" -lt 0 ]; then
        echo "  🔴 EXPIRED $((DAYS_LEFT * -1)) days ago"
    elif [ "$DAYS_LEFT" -lt "$CRITICAL_DAYS" ]; then
        echo "  🔴 CRITICAL: Expires in $DAYS_LEFT days"
    elif [ "$DAYS_LEFT" -lt "$WARN_DAYS" ]; then
        echo "  🟡 WARNING: Expires in $DAYS_LEFT days"
    else
        echo "  ✓ OK: Valid for $DAYS_LEFT days"
    fi
    echo "  Expires: $EXPIRY"
    echo
done
```

---

## Network Security Monitoring {#security-monitoring}

### Log Monitoring

```bash
# Monitor auth logs for failed logins
sudo tail -f /var/log/auth.log | grep "Failed password"

# Monitor Apache access logs
sudo tail -f /var/log/apache2/access.log

# Monitor Nginx access logs
sudo tail -f /var/log/nginx/access.log

# Monitor system logs
sudo tail -f /var/log/syslog

# Monitor all logs
sudo tail -f /var/log/*.log
```

### Failed Login Monitoring Script

```bash
#!/bin/bash
# monitor-failed-logins.sh - Monitor and alert on failed logins

LOG_FILE="/var/log/auth.log"
THRESHOLD=5
CHECK_INTERVAL=60

echo "=== Failed Login Monitor ==="
echo "Threshold: $THRESHOLD attempts"
echo "Monitoring $LOG_FILE..."
echo

while true; do
    # Get failed logins from last minute
    FAILED_IPS=$(grep "Failed password" "$LOG_FILE" | \
                 grep "$(date '+%b %e %H:%M' -d '1 minute ago')" | \
                 awk '{print $11}' | \
                 sort | \
                 uniq -c | \
                 sort -rn)

    # Check if any IP exceeds threshold
    while IFS= read -r line; do
        COUNT=$(echo "$line" | awk '{print $1}')
        IP=$(echo "$line" | awk '{print $2}')

        if [ "$COUNT" -ge "$THRESHOLD" ]; then
            echo "[ALERT] $(date) - IP $IP: $COUNT failed login attempts"

            # Optional: Block IP
            # sudo ufw deny from "$IP"
        fi
    done <<< "$FAILED_IPS"

    sleep "$CHECK_INTERVAL"
done
```

### Network Intrusion Detection

```bash
#!/bin/bash
# ids-monitor.sh - Simple Intrusion Detection System

INTERFACE="eth0"
SUSPICIOUS_PORTS=(23 3389 1433 1521 3306)

echo "=== Network Intrusion Detection ==="
echo "Monitoring interface: $INTERFACE"
echo "Suspicious ports: ${SUSPICIOUS_PORTS[*]}"
echo

# Monitor for port scans
sudo tcpdump -i "$INTERFACE" -n -l 2>/dev/null | \
while read line; do
    for port in "${SUSPICIOUS_PORTS[@]}"; do
        if echo "$line" | grep -q ".$port"; then
            SRC_IP=$(echo "$line" | awk '{print $3}' | cut -d. -f1-4)
            echo "[ALERT] $(date) - Suspicious traffic to port $port from $SRC_IP"
        fi
    done
done
```

### Security Audit Script

```bash
#!/bin/bash
# security-audit.sh - System security audit

echo "=== Security Audit Report ==="
echo "Generated: $(date)"
echo "Hostname: $(hostname)"
echo

echo "=== 1. User Accounts ==="
echo "Root accounts:"
awk -F: '$3 == 0 {print $1}' /etc/passwd
echo

echo "Accounts with empty passwords:"
sudo awk -F: '($2 == "") {print $1}' /etc/shadow
echo

echo "=== 2. Network Services ==="
echo "Listening ports:"
sudo ss -tulnp | grep LISTEN
echo

echo "=== 3. Firewall Status ==="
if command -v ufw &>/dev/null; then
    sudo ufw status
elif command -v firewall-cmd &>/dev/null; then
    sudo firewall-cmd --list-all
else
    echo "No firewall detected"
fi
echo

echo "=== 4. Failed Login Attempts (Last 24h) ==="
sudo grep "Failed password" /var/log/auth.log 2>/dev/null | \
    tail -100 | \
    awk '{print $11}' | \
    sort | \
    uniq -c | \
    sort -rn | \
    head -10
echo

echo "=== 5. World-Writable Files ==="
find / -type f -perm -002 2>/dev/null | head -20
echo

echo "=== 6. SUID/SGID Files ==="
find / -type f \( -perm -4000 -o -perm -2000 \) 2>/dev/null | head -20
echo

echo "=== 7. Cron Jobs ==="
for user in $(cut -f1 -d: /etc/passwd); do
    crontab -u "$user" -l 2>/dev/null | grep -v "^#" && echo "User: $user"
done
echo

echo "=== Audit Complete ==="
```

---

## VPN & Tunneling {#vpn-tunneling}

### SSH Tunneling

```bash
# Local port forwarding
ssh -L 8080:localhost:80 user@remote-server

# Remote port forwarding
ssh -R 8080:localhost:80 user@remote-server

# Dynamic port forwarding (SOCKS proxy)
ssh -D 9090 user@remote-server

# Tunnel with background
ssh -fNL 8080:localhost:80 user@remote-server

# Multiple tunnels
ssh -L 8080:localhost:80 -L 3306:localhost:3306 user@remote-server
```

### SSH Tunnel Script

```bash
#!/bin/bash
# ssh-tunnel.sh - Manage SSH tunnels

REMOTE_HOST="remote-server.com"
REMOTE_USER="username"
LOCAL_PORT=8080
REMOTE_PORT=80

create_tunnel() {
    echo "Creating SSH tunnel..."
    ssh -fNL "$LOCAL_PORT:localhost:$REMOTE_PORT" "$REMOTE_USER@$REMOTE_HOST"

    if [ $? -eq 0 ]; then
        echo "✓ Tunnel created: localhost:$LOCAL_PORT -> $REMOTE_HOST:$REMOTE_PORT"
    else
        echo "✗ Failed to create tunnel"
        exit 1
    fi
}

check_tunnel() {
    if pgrep -f "ssh.*$LOCAL_PORT:localhost:$REMOTE_PORT" > /dev/null; then
        echo "✓ Tunnel is active"
        return 0
    else
        echo "✗ Tunnel is not active"
        return 1
    fi
}

stop_tunnel() {
    echo "Stopping SSH tunnel..."
    pkill -f "ssh.*$LOCAL_PORT:localhost:$REMOTE_PORT"
    echo "✓ Tunnel stopped"
}

case "$1" in
    start)
        create_tunnel
        ;;
    stop)
        stop_tunnel
        ;;
    status)
        check_tunnel
        ;;
    restart)
        stop_tunnel
        sleep 2
        create_tunnel
        ;;
    *)
        echo "Usage: $0 {start|stop|status|restart}"
        exit 1
        ;;
esac
```

### OpenVPN Management

```bash
# Connect to VPN
sudo openvpn --config client.ovpn

# Connect in background
sudo openvpn --config client.ovpn --daemon

# Check VPN status
sudo systemctl status openvpn@client

# Start VPN service
sudo systemctl start openvpn@client

# Stop VPN service
sudo systemctl stop openvpn@client

# View VPN logs
sudo journalctl -u openvpn@client -f
```

### WireGuard VPN

```bash
# Install WireGuard
sudo apt install wireguard -y

# Generate keys
wg genkey | tee privatekey | wg pubkey > publickey

# Start WireGuard
sudo wg-quick up wg0

# Stop WireGuard
sudo wg-quick down wg0

# Check status
sudo wg show

# View configuration
sudo cat /etc/wireguard/wg0.conf
```

---

## Network Troubleshooting Scripts {#troubleshooting-scripts}

### Comprehensive Network Diagnostic

```bash
#!/bin/bash
# netdiag.sh - Comprehensive network diagnostics

echo "==================================="
echo " NETWORK DIAGNOSTIC TOOL"
echo "==================================="
echo "Hostname: $(hostname)"
echo "Date: $(date)"
echo

# 1. Network Interfaces
echo "=== 1. NETWORK INTERFACES ==="
ip -br addr show
echo

# 2. Routing
echo "=== 2. ROUTING TABLE ==="
ip route show
echo

# 3. DNS
echo "=== 3. DNS CONFIGURATION ==="
cat /etc/resolv.conf | grep nameserver
echo

# 4. Connectivity
echo "=== 4. CONNECTIVITY TEST ==="
HOSTS=("8.8.8.8" "google.com" "github.com")
for host in "${HOSTS[@]}"; do
    if ping -c 2 -W 2 "$host" &>/dev/null; then
        RTT=$(ping -c 1 "$host" 2>/dev/null | tail -1 | awk '{print $4}' | cut -d '/' -f 2)
        echo "  ✓ $host - RTT: ${RTT}ms"
    else
        echo "  ✗ $host - UNREACHABLE"
    fi
done
echo

# 5. Listening Ports
echo "=== 5. LISTENING PORTS ==="
sudo ss -tulnp | grep LISTEN | head -20
echo

# 6. Active Connections
echo "=== 6. ACTIVE CONNECTIONS ==="
ss -tun | grep ESTAB | wc -l
echo "Total established connections: $(ss -tun | grep ESTAB | wc -l)"
echo

# 7. Firewall Status
echo "=== 7. FIREWALL STATUS ==="
if command -v ufw &>/dev/null; then
    sudo ufw status | head -10
elif command -v firewall-cmd &>/dev/null; then
    sudo firewall-cmd --state
else
    echo "No firewall detected"
fi
echo

# 8. Network Statistics
echo "=== 8. NETWORK STATISTICS ==="
netstat -s | grep -E "packets received|packets sent" | head -5
echo

echo "=== DIAGNOSTIC COMPLETE ==="
```

### Network Performance Test

```bash
#!/bin/bash
# netperf.sh - Network performance testing

TARGET="${1:-google.com}"
COUNT=100

echo "=== Network Performance Test ==="
echo "Target: $TARGET"
echo "Packets: $COUNT"
echo

# Latency test
echo "=== Latency Test ==="
ping -c "$COUNT" "$TARGET" | tail -3
echo

# Packet loss
echo "=== Packet Loss ==="
LOSS=$(ping -c "$COUNT" "$TARGET" | grep -oP '\d+(?=% packet loss)')
if [ "$LOSS" -eq 0 ]; then
    echo "✓ No packet loss"
elif [ "$LOSS" -lt 5 ]; then
    echo "⚠ Acceptable packet loss: ${LOSS}%"
else
    echo "✗ High packet loss: ${LOSS}%"
fi
echo

# Path analysis
echo "=== Path Analysis ==="
traceroute -m 15 "$TARGET" 2>/dev/null | head -10
echo

echo "=== Test Complete ==="
```

---

## Security Hardening Scripts {#security-scripts}

### SSH Hardening

```bash
#!/bin/bash
# ssh-harden.sh - Secure SSH configuration

SSHD_CONFIG="/etc/ssh/sshd_config"
BACKUP_FILE="/etc/ssh/sshd_config.backup.$(date +%Y%m%d)"

echo "=== SSH Security Hardening ==="

# Backup original config
sudo cp "$SSHD_CONFIG" "$BACKUP_FILE"
echo "✓ Config backed up to: $BACKUP_FILE"

# Apply security settings
echo "Applying security configurations..."

# Disable root login
sudo sed -i 's/^#*PermitRootLogin.*/PermitRootLogin no/' "$SSHD_CONFIG"

# Disable password authentication
sudo sed -i 's/^#*PasswordAuthentication.*/PasswordAuthentication no/' "$SSHD_CONFIG"

# Disable empty passwords
sudo sed -i 's/^#*PermitEmptyPasswords.*/PermitEmptyPasswords no/' "$SSHD_CONFIG"

# Disable X11 forwarding
sudo sed -i 's/^#*X11Forwarding.*/X11Forwarding no/' "$SSHD_CONFIG"

# Set max auth tries
sudo sed -i 's/^#*MaxAuthTries.*/MaxAuthTries 3/' "$SSHD_CONFIG"

# Change default port (optional)
# sudo sed -i 's/^#*Port.*/Port 2222/' "$SSHD_CONFIG"

# Enable public key authentication
sudo sed -i 's/^#*PubkeyAuthentication.*/PubkeyAuthentication yes/' "$SSHD_CONFIG"

# Set allowed users (customize)
# echo "AllowUsers your_username" | sudo tee -a "$SSHD_CONFIG"

# Test configuration
echo "Testing SSH configuration..."
sudo sshd -t

if [ $? -eq 0 ]; then
    echo "✓ Configuration is valid"

    # Restart SSH service
    echo "Restarting SSH service..."
    sudo systemctl restart sshd

    echo "✓ SSH hardening complete"
    echo
    echo "Changes applied:"
    echo "  - Root login: disabled"
    echo "  - Password authentication: disabled"
    echo "  - Max auth tries: 3"
    echo "  - X11 forwarding: disabled"
else
    echo "✗ Configuration has errors"
    echo "Restoring backup..."
    sudo cp "$BACKUP_FILE" "$SSHD_CONFIG"
    exit 1
fi
```

### System Hardening

```bash
#!/bin/bash
# system-harden.sh - Comprehensive system hardening

echo "=== System Security Hardening ==="
echo

# 1. Kernel parameters
echo "1. Configuring kernel security parameters..."
cat >> /etc/sysctl.conf << 'EOF'
# Security hardening
net.ipv4.conf.all.accept_redirects = 0
net.ipv4.conf.all.send_redirects = 0
net.ipv4.conf.all.accept_source_route = 0
net.ipv4.tcp_syncookies = 1
net.ipv4.icmp_echo_ignore_broadcasts = 1
net.ipv4.icmp_ignore_bogus_error_responses = 1
net.ipv4.conf.all.log_martians = 1
kernel.dmesg_restrict = 1
kernel.kptr_restrict = 2
EOF

sudo sysctl -p
echo "✓ Kernel parameters configured"
echo

# 2. Disable unused services
echo "2. Disabling unused services..."
SERVICES=("avahi-daemon" "cups" "bluetooth")
for service in "${SERVICES[@]}"; do
    if systemctl is-active --quiet "$service"; then
        sudo systemctl stop "$service"
        sudo systemctl disable "$service"
        echo "  Disabled: $service"
    fi
done
echo

# 3. Set password policies
echo "3. Configuring password policies..."
sudo sed -i 's/^PASS_MAX_DAYS.*/PASS_MAX_DAYS 90/' /etc/login.defs
sudo sed -i 's/^PASS_MIN_DAYS.*/PASS_MIN_DAYS 7/' /etc/login.defs
sudo sed -i 's/^PASS_WARN_AGE.*/PASS_WARN_AGE 14/' /etc/login.defs
echo "✓ Password policies configured"
echo

# 4. Configure automatic updates
echo "4. Enabling automatic security updates..."
sudo apt install unattended-upgrades -y
sudo dpkg-reconfigure -plow unattended-upgrades
echo "✓ Automatic updates enabled"
echo

# 5. Install security tools
echo "5. Installing security tools..."
sudo apt install -y fail2ban aide rkhunter
echo "✓ Security tools installed"
echo

echo "=== Hardening Complete ==="
```

### Port Security Scanner

```bash
#!/bin/bash
# port-security-scan.sh - Identify security risks

echo "=== Port Security Scanner ==="
echo

# Scan for common vulnerable ports
DANGEROUS_PORTS=(23 21 445 3389 1433 1521 5900)

echo "Scanning for dangerous open ports..."
echo

for port in "${DANGEROUS_PORTS[@]}"; do
    if sudo ss -tuln | grep -q ":$port "; then
        case $port in
            23)  echo "🔴 CRITICAL: Telnet (port 23) is open - Unencrypted protocol"
                 ;;
            21)  echo "🟡 WARNING: FTP (port 21) is open - Consider using SFTP"
                 ;;
            445) echo "🟡 WARNING: SMB (port 445) is open - Potential security risk"
                 ;;
            3389) echo "🟡 WARNING: RDP (port 3389) is open - Ensure strong authentication"
                  ;;
            1433) echo "🟡 WARNING: MS SQL (port 1433) is open - Should not be exposed"
                  ;;
            1521) echo "🟡 WARNING: Oracle DB (port 1521) is open - Should not be exposed"
                  ;;
            5900) echo "🟡 WARNING: VNC (port 5900) is open - Weak encryption"
                  ;;
        esac
    fi
done

# Check for services running as root
echo
echo "Checking for services running as root..."
SERVICES=$(sudo ss -tulnp | grep -v "root" | awk '{print $NF}' | sort -u)
echo "$SERVICES"

echo
echo "=== Scan Complete ==="
```

---

## Advanced Bash Scripts {#advanced-scripts}

### Network Monitoring Dashboard

```bash
#!/bin/bash
# netdash.sh - Real-time network monitoring dashboard

INTERFACE="${1:-eth0}"
REFRESH=2

while true; do
    clear
    echo "================================================"
    echo "  NETWORK MONITORING DASHBOARD"
    echo "  Interface: $INTERFACE | Refresh: ${REFRESH}s"
    echo "================================================"
    echo

    # Interface status
    echo "=== INTERFACE STATUS ==="
    ip -br addr show "$INTERFACE"
    echo

    # Bandwidth
    echo "=== BANDWIDTH (Last ${REFRESH}s) ==="
    RX1=$(cat /sys/class/net/"$INTERFACE"/statistics/rx_bytes)
    TX1=$(cat /sys/class/net/"$INTERFACE"/statistics/tx_bytes)
    sleep "$REFRESH"
    RX2=$(cat /sys/class/net/"$INTERFACE"/statistics/rx_bytes)
    TX2=$(cat /sys/class/net/"$INTERFACE"/statistics/tx_bytes)

    RX_RATE=$(( (RX2 - RX1) / REFRESH / 1024 ))
    TX_RATE=$(( (TX2 - TX1) / REFRESH / 1024 ))

    echo "  Download: ${RX_RATE} KB/s"
    echo "  Upload:   ${TX_RATE} KB/s"
    echo

    # Connections
    echo "=== ACTIVE CONNECTIONS ==="
    TOTAL=$(ss -tun | grep -c ESTAB)
    echo "  Total: $TOTAL"
    echo

    # Top connections
    echo "=== TOP CONNECTIONS ==="
    ss -tun | grep ESTAB | awk '{print $5}' | cut -d: -f1 | sort | uniq -c | sort -rn | head -5
    echo

    # Listening ports
    echo "=== LISTENING PORTS ==="
    sudo ss -tulnp | grep LISTEN | awk '{print $5, $NF}' | head -10

    sleep 1
done
```

### Automated Security Scanner

```bash
#!/bin/bash
# security-scanner.sh - Automated security vulnerability scanner

REPORT_FILE="/var/log/security-scan-$(date +%Y%m%d-%H%M%S).log"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$REPORT_FILE"
}

log "=== SECURITY VULNERABILITY SCAN ==="
log "Hostname: $(hostname)"
log ""

# 1. Check for open ports
log "=== 1. PORT SCAN ==="
OPEN_PORTS=$(sudo ss -tuln | grep LISTEN | wc -l)
log "Total listening ports: $OPEN_PORTS"

# Check for dangerous ports
DANGEROUS=(23 21 445 3389 1433)
for port in "${DANGEROUS[@]}"; do
    if sudo ss -tuln | grep -q ":$port "; then
        log "⚠ WARNING: Dangerous port $port is open"
    fi
done
log ""

# 2. Check for weak passwords
log "=== 2. PASSWORD SECURITY ==="
EMPTY_PASS=$(sudo awk -F: '($2 == "") {print $1}' /etc/shadow)
if [ -n "$EMPTY_PASS" ]; then
    log "🔴 CRITICAL: Accounts with empty passwords found:"
    log "$EMPTY_PASS"
else
    log "✓ No accounts with empty passwords"
fi
log ""

# 3. Check file permissions
log "=== 3. FILE PERMISSIONS ==="
WORLD_WRITABLE=$(find /etc -type f -perm -002 2>/dev/null | wc -l)
if [ "$WORLD_WRITABLE" -gt 0 ]; then
    log "⚠ WARNING: $WORLD_WRITABLE world-writable files in /etc"
else
    log "✓ No world-writable files in /etc"
fi
log ""

# 4. Check SUID/SGID files
log "=== 4. SUID/SGID FILES ==="
SUID_COUNT=$(find / -type f \( -perm -4000 -o -perm -2000 \) 2>/dev/null | wc -l)
log "Total SUID/SGID files: $SUID_COUNT"
log ""

# 5. Check failed login attempts
log "=== 5. FAILED LOGINS (Last 24h) ==="
FAILED=$(sudo grep "Failed password" /var/log/auth.log 2>/dev/null | wc -l)
log "Total failed attempts: $FAILED"
if [ "$FAILED" -gt 50 ]; then
    log "⚠ WARNING: High number of failed login attempts"
    log "Top offenders:"
    sudo grep "Failed password" /var/log/auth.log 2>/dev/null | \
        awk '{print $11}' | sort | uniq -c | sort -rn | head -5 | \
        while read line; do log "  $line"; done
fi
log ""

# 6. Check for rootkits
log "=== 6. ROOTKIT SCAN ==="
if command -v rkhunter &>/dev/null; then
    sudo rkhunter --check --skip-keypress --report-warnings-only | tee -a "$REPORT_FILE"
else
    log "rkhunter not installed - skipping"
fi
log ""

# 7. Check firewall status
log "=== 7. FIREWALL STATUS ==="
if command -v ufw &>/dev/null; then
    STATUS=$(sudo ufw status | head -1)
    log "$STATUS"
elif command -v firewall-cmd &>/dev/null; then
    STATUS=$(sudo firewall-cmd --state)
    log "Firewalld: $STATUS"
else
    log "⚠ WARNING: No firewall detected"
fi
log ""

# 8. Check for updates
log "=== 8. SYSTEM UPDATES ==="
if command -v apt &>/dev/null; then
    UPDATES=$(apt list --upgradable 2>/dev/null | grep -c upgradable)
    log "Available updates: $UPDATES"
    if [ "$UPDATES" -gt 0 ]; then
        log "⚠ System updates available"
    fi
fi
log ""

log "=== SCAN COMPLETE ==="
log "Report saved to: $REPORT_FILE"

echo
echo "Report generated: $REPORT_FILE"
```

### Network Load Balancer Health Check

```bash
#!/bin/bash
# lb-health-check.sh - Load balancer backend health checker

BACKENDS=(
    "backend1.example.com:80"
    "backend2.example.com:80"
    "backend3.example.com:80"
)

HEALTH_CHECK_URL="/health"
TIMEOUT=5
CHECK_INTERVAL=30

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

check_backend() {
    local backend=$1
    local host=$(echo "$backend" | cut -d: -f1)
    local port=$(echo "$backend" | cut -d: -f2)

    # HTTP health check
    HTTP_CODE=$(timeout "$TIMEOUT" curl -s -o /dev/null -w "%{http_code}" "http://${host}:${port}${HEALTH_CHECK_URL}")

    if [ "$HTTP_CODE" = "200" ]; then
        log "✓ $backend - HEALTHY (HTTP $HTTP_CODE)"
        return 0
    else
        log "✗ $backend - UNHEALTHY (HTTP $HTTP_CODE)"

        # Optional: Remove from load balancer
        # remove_from_pool "$backend"

        return 1
    fi
}

log "=== Load Balancer Health Check Started ==="

while true; do
    log "Checking backends..."

    HEALTHY=0
    TOTAL=${#BACKENDS[@]}

    for backend in "${BACKENDS[@]}"; do
        if check_backend "$backend"; then
            ((HEALTHY++))
        fi
    done

    log "Status: $HEALTHY/$TOTAL backends healthy"

    if [ "$HEALTHY" -eq 0 ]; then
        log "🔴 CRITICAL: All backends are down!"
        # Send alert
        # send_alert "All backends down"
    elif [ "$HEALTHY" -lt "$TOTAL" ]; then
        log "⚠ WARNING: Some backends are down"
    fi

    log "---"
    sleep "$CHECK_INTERVAL"
done
```

---

## Quick Command Reference

### Network Info

```bash
ip addr show                      # Show IP addresses
ip route show                     # Show routing table
ss -tuln                          # Show listening ports
netstat -rn                       # Show routing table (legacy)
```

### Connectivity

```bash
ping -c 4 host                    # Test connectivity
traceroute host                   # Trace route
mtr host                          # Continuous traceroute
nc -zv host port                  # Test port
```

### DNS

```bash
dig domain                        # DNS lookup
nslookup domain                   # DNS lookup (legacy)
host domain                       # DNS lookup
dig +trace domain                 # Trace DNS resolution
```

### Port Scanning

```bash
nmap host                         # Basic scan
nmap -p 1-1000 host              # Port range scan
nmap -sV host                     # Service detection
sudo nmap -O host                 # OS detection
```

### Traffic Analysis

```bash
sudo tcpdump -i eth0              # Capture packets
sudo tcpdump -i eth0 port 80      # Capture HTTP
iftop -i eth0                     # Bandwidth monitor
nethogs eth0                      # Per-process bandwidth
```

### Firewall

```bash
sudo ufw status                   # UFW status
sudo firewall-cmd --list-all      # Firewalld status
sudo iptables -L                  # IPTables rules
```

### SSL/TLS

```bash
openssl s_client -connect host:443  # Test SSL
openssl x509 -in cert.crt -text     # View certificate
```

---

**Document Version:** 1.0  
**Last Updated:** December 17, 2025  
**Author:** Network & Security Team  
**Target Audience:** Advanced DevSecOps Engineers, Network Administrators, Security Specialists
