# Cart Service

The Cart microservice is responsible for managing the user's shopping cart in the RoboShop e-commerce portal. It interacts with Redis to store cart data and communicates with the Catalogue service to retrieve product details.

## Installation and Configuration

The developer has specified **Node.js** as the runtime environment. This service requires **Node.js 18** or higher.

### 1. Install Node.js

Enable the Node.js 18 module stream and install the package.

```bash
# Disable default version
dnf module disable nodejs -y

# Enable Node.js 18
dnf module enable nodejs:18 -y

# Install Node.js
dnf install nodejs -y
```

### 2. Configure Application User

Create a non-root user `roboshop` to run the application securely.

```bash
useradd roboshop
```

> **Note:** The `roboshop` user is a system/daemon account used strictly for running the application.

### 3. Setup Application Directory

Create the standard directory structure to host the application code.

```bash
mkdir /app
```

### 4. Download and Extract Code

Download the Cart application artifacts from the central repository and extract them.

```bash
curl -L -o /tmp/cart.zip https://roboshop-artifacts.s3.amazonaws.com/cart.zip
cd /app
unzip /tmp/cart.zip
```

### 5. Install Dependencies

Install the required Node.js libraries specified in `package.json`.

```bash
cd /app
npm install
```

### 6. Configure SystemD Service

Create the systemd service unit file to manage the application process. This service requires configuration to connect to Redis and Catalogue services.

**File:** `/etc/systemd/system/cart.service`

```ini
[Unit]
Description = Cart Service

[Service]
User=roboshop
Environment=REDIS_HOST=<REDIS-SERVER-IP>
Environment=CATALOGUE_HOST=<CATALOGUE-SERVER-IP>
Environment=CATALOGUE_PORT=8080
ExecStart=/bin/node /app/server.js
SyslogIdentifier=cart

[Install]
WantedBy=multi-user.target
```

> **Important:**
>
> - Replace `<REDIS-SERVER-IP>` with the private IP address of the Redis server.
> - Replace `<CATALOGUE-SERVER-IP>` with the private IP address of the Catalogue server.

### 7. Start the Service

Reload the systemd daemon, enable the service to start on boot, and start it immediately.

```bash
systemctl daemon-reload
systemctl enable cart
systemctl start cart
```
