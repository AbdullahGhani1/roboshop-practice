# User Service

The User microservice is responsible for handling user logins and registrations in the RoboShop e-commerce portal. It interacts with both MongoDB (for user data) and Redis (for caching).

## Installation and Configuration

The developer has specified **Node.js** as the runtime environment. This service requires **Node.js 18** or higher.

### 1. Install Node.js

We will enable the Node.js 18 module stream and install the package.

```bash
# Disable default version
dnf module disable nodejs -y

# Enable Node.js 18
dnf module enable nodejs:18 -y

# Install Node.js
dnf install nodejs -y
```

> **Note:** Alternatively, you can verify available versions with `yum list all | grep nodejs` or use the NodeSource setup script `curl -sL https://rpm.nodesource.com/setup_lts.x | bash` if the module stream is not available contextually, but `dnf module` is the preferred standard method on RHEL-based systems.

### 2. Configure Application User

Run the application as a non-root user for security.

```bash
useradd roboshop
```

> **Note:** The `roboshop` user is a system/daemon account used strictly for running the application.

### 3. Setup Application Directory

Create the standard directory structure.

```bash
mkdir /app
```

### 4. Download and Extract Code

Download the application artifacts from the central repository and extract them.

```bash
curl -L -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user.zip
cd /app
unzip /tmp/user.zip
```

### 5. Install Dependencies

Install the required Node.js libraries.

```bash
cd /app
npm install
```

### 6. Configure SystemD Service

Create the systemd service unit file to manage the application process. This service requires access to both MongoDB and Redis.

**File:** `/etc/systemd/system/user.service`

```ini
[Unit]
Description = User Service

[Service]
User=roboshop
Environment=MONGO=true
Environment=REDIS_HOST=<REDIS-SERVER-IP>
Environment=MONGO_URL="mongodb://<MONGODB-SERVER-IP-ADDRESS>:27017/users"
ExecStart=/bin/node /app/server.js
SyslogIdentifier=user

[Install]
WantedBy=multi-user.target
```

> **Important:**
>
> - Replace `<REDIS-SERVER-IP>` with the private IP address of the Redis server.
> - Replace `<MONGODB-SERVER-IP-ADDRESS>` with the private IP address of the MongoDB server.

### 7. Start the Service

Reload systemd to pick up the new file, then enable and start the service.

```bash
systemctl daemon-reload
systemctl enable user
systemctl start user
```

we need to load the schema we need to install mongodb client.

To have it installed we can setup MongoDB repo and install mongodb-client

```ini
[mongodb-org-4.2]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/4.2/x86_64/
gpgcheck=0
enabled=1
```

#### Load Schema

Install the shell and load the `user.js` schema file.

```bash
yum install mongodb-org-shell -y
mongo --host <MONGODB-SERVER-IPADDRESS> </app/schema/user.js
```
