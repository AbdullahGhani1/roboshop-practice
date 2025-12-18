# MySQL Installation and Configuration

The developer has chosen MySQL as the database for the shipping service. We need to install and configure it on the server.

## Prerequisites

The application specifically requires **MySQL 5.7**. Since CentOS 8 comes with MySQL 8 by default, we must disable the default module and configure the repository for version 5.7.

## Installation

### 1. Disable MySQL 8

Disable the default MySQL 8 module stream:

```bash
dnf module disable mysql -y
```

### 2. Setup MySQL 5.7 Repository

Create a new repository file to point to the MySQL 5.7 community server.

**File:** `/etc/yum.repos.d/mysql.repo`

```bash
vim /etc/yum.repos.d/mysql.repo
```

**Content:**

```ini
[mysql]
name=MySQL 5.7 Community Server
baseurl=http://repo.mysql.com/yum/mysql-5.7-community/el/7/$basearch/
enabled=1
gpgcheck=0
```

### 3. Install MySQL Server

Now install the community server package:

```bash
dnf install mysql-community-server -y
```

## Service Management

Start the MySQL service and enable it to run on boot.

```bash
systemctl enable mysqld
systemctl start mysqld
```

## Configuration

### 1. Change Root Password

The default installation requires setting a root password to start using the database. Run the secure installation script to set the new password.

**New Password:** `RoboShop@1` (or your preferred secure password)

```bash
mysql_secure_installation --set-root-pass RoboShop@1
```

> **Verification:** You can verify the new password by logging into the MySQL shell:
>
> ```bash
> mysql -uroot -pRoboShop@1
> ```
