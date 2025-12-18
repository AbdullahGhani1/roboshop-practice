# Catalogue Service

The Catalogue microservice serves the list of items displayed in the RoboShop application. It is a Node.js application responsible for product data management.

## Installation and Configuration

The developer has selected **Node.js** for this microservice. While the default system repositories may offer older versions (e.g., Node.js 10), this application requires **Node.js 18** or higher.

Setup NodeJS repos. Vendor is providing a script to setup the repos.

### 1. Install Node.js

Enable the Node.js 18 module stream and install the package.

check any node install

```sh
yum list all | grep nodejs
```

```sh
curl -sL https://rpm.nodesource.com/setup_lts.x | bash
```

```bash
# Disable default version
yum module disable nodejs -y

# Enable Node.js 18
yum module enable nodejs:18 -y

# Install Node.js
yum install nodejs -y
node -v
# v24.12.0
```

### 2. Configure Application User

For security reasons, run the application as a non-root user. We will create a dedicated user named `roboshop`.

```bash
useradd roboshop
```

> **Note:** Just like in the previous steps, `roboshop` is a system account used specifically for running the service.

### 3. Setup Application Directory

Create a standard directory to host the application artifacts.

```bash
mkdir /app
```

### 4. Download and Extract Code

Download the application archive and extract it into the application directory.

```bash
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip
cd /app
unzip /tmp/catalogue.zip
```

### 5. Install Dependencies

Install the Node.js dependencies specified in the project.

```bash
cd /app
npm install
```

### 6. Configure SystemD Service

Create a systemd service unit to manage the Catalogue application.

**File:** `/etc/systemd/system/catalogue.service`

```ini
[Unit]
Description = Catalogue Service

[Service]
User=roboshop
Environment=MONGO=true
Environment=MONGO_URL="mongodb://<MONGODB-SERVER-IPADDRESS>:27017/catalogue"
ExecStart=/bin/node /app/server.js
SyslogIdentifier=catalogue

[Install]
WantedBy=multi-user.target
```

> **Important:** Replace `<MONGODB-SERVER-IPADDRESS>` with the private IP address of the MongoDB server.

### 7. Start the Service

Reload the systemd daemon to register the new service, then enable and start it.

```bash
systemctl daemon-reload
systemctl enable catalogue
systemctl start catalogue
```

optional you can check logs

```bash
systemctl restart catalogue ; tail -f /var/log/messages
```

### 8. Load Data Schema

The application requires a product schema and master data to be loaded into MongoDB.

#### Setup MongoDB Repo

To connect to the database and load the schema, we need the MongoDB client (shell). Configure the repository first:

**File:** `/etc/yum.repos.d/mongo.repo`

```ini
[mongodb-org-4.2]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/4.2/x86_64/
gpgcheck=0
enabled=1
```

#### Install Client and Load Schema

Install the shell and load the `catalogue.js` schema file.

```bash
yum install mongodb-org-shell -y
mongo --host <MONGODB-SERVER-IPADDRESS> </app/schema/catalogue.js
```

> **Verify:** Ensure `<MONGODB-SERVER-IPADDRESS>` matches the MongoDB instance IP.

### 9. Update Frontend Configuration

Finally, update the Frontend reverse proxy configuration to point to this Catalogue service.

Edit `/etc/nginx/default.d/roboshop.conf` on the Frontend server and replace `localhost` (or the placeholder) with the IP address of this Catalogue server in the `/api/catalogue/` location block.
