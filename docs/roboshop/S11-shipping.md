# Shipping Service

The Shipping microservice is responsible for calculating shipping costs based on the distance to the delivery location. It is a Java-based application that interacts with the Cart service and a MySQL database.

## Prerequisites

The developer has chosen **Maven** for building this Java application. The requirement is Java 1.8 or higher, which is satisfied by installing Maven (version 3.5+).

### 1. Install Maven

Install Maven, which will automatically ensure a compatible Java version is installed.

```bash
dnf install maven -y
```

## Installation and Configuration

### 1. Configure Application User

Create the standard `roboshop` system user to run the application securely.

```bash
useradd roboshop
```

### 2. Setup Application Directory

Create the directory to host the application artifacts.

```bash
mkdir /app
```

### 3. Download and Extract Code

Download the Shipping application source code.

```bash
curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping.zip
cd /app
unzip /tmp/shipping.zip
```

### 4. Build Application

Since this is a Java application, we need to compile and package it. Download dependencies and build the artifact using Maven.

```bash
cd /app
mvn clean package
mv target/shipping-1.0.jar shipping.jar
```

## Service Management

### 1. Configure SystemD Service

Create the systemd service unit to manage the Shipping application. It requires connections to the Cart service and the MySQL database.

**File:** `/etc/systemd/system/shipping.service`

```ini
[Unit]
Description=Shipping Service

[Service]
User=roboshop
Environment=CART_ENDPOINT=<CART-SERVER-IPADDRESS>:8080
Environment=DB_HOST=<MYSQL-SERVER-IPADDRESS>
ExecStart=/bin/java -jar /app/shipping.jar
SyslogIdentifier=shipping

[Install]
WantedBy=multi-user.target
```

> **Important:**
>
> - Replace `<CART-SERVER-IPADDRESS>` with the IP address of the Cart server.
> - Replace `<MYSQL-SERVER-IPADDRESS>` with the IP address of the MySQL server.

### 2. Start the Service

Reload systemd, enable the service on boot, and start it.

```bash
systemctl daemon-reload
systemctl enable shipping
systemctl start shipping
```

## Database Schema Configuration

The application requires city and distance data to function correctly. This master data must be loaded into the MySQL database.

### 1. Install MySQL Client

Install the MySQL client to connect to the database server.

```bash
dnf install mysql -y
```

### 2. Load Schema

Connect to the remote MySQL server and load the `shipping.sql` file.

```bash
mysql -h <MYSQL-SERVER-IPADDRESS> -uroot -pRoboShop@1 < /app/schema/shipping.sql
```

> **Note:** Ensure you use the correct password (`RoboShop@1` is the default set during MySQL setup) and replace `<MYSQL-SERVER-IPADDRESS>` with the actual database IP.

### 3. Restart Service

Restart the Shipping service to ensure it picks up the newly loaded data and functions correctly.

```bash
systemctl restart shipping
```
