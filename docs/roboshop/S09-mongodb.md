# MongoDB Installation and Configuration

The developer has chosen MongoDB as the database for this project. Based on the version information provided [MongoDB 4.x](https://www.mongodb.com/docs/v4.4/tutorial/install-mongodb-on-red-hat/#tabs-11), we will proceed with the installation and configuration.

## 1. Setup MongoDB Repository

Create the repository configuration file to allow `yum` to install MongoDB directly from the official source.

**File Path:** `/etc/yum.repos.d/mongo.repo`

```bash
vim /etc/yum.repos.d/mongo.repo
```

**Content:**

```ini
[mongodb-org-4.2]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/4.2/x86_64/
gpgcheck=0
enabled=1
```

## 2. Install MongoDB

Install the MongoDB organization packages using the following command:

```bash
yum install mongodb-org -y
```

## 3. Start and Enable MongoDB Service

To ensure MongoDB starts automatically on boot and is currently running, execute:

```bash
systemctl enable mongod
systemctl start mongod
```

## 4. Configure Remote Access

By default, MongoDB listens only on `127.0.0.1` (localhost). To allow other servers in the network to access the database, we must update the bind address.

1. Open the configuration file:
   ```bash
   vim /etc/mongod.conf
   ```
2. Locate the `net` section and update `bindIp` from `127.0.0.1` to `0.0.0.0`.

## 5. Restart Service

Restart the MongoDB service to apply the configuration changes:

```bash
systemctl restart mongod
```
