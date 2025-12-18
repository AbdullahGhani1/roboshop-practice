# Redis Installation and Configuration

Redis is an in-memory data structure store, used as a database, cache, and message broker. In the RoboShop architecture, it is used for caching to reduce the load on the database and improve API response times.

## Prerequisites

The developer has specified **Redis 6** as the required version for this project.

Redis is offering the repo file as a rpm. Lets install it

```sh
# THis remi repos is not working any more, So ignroe this step and move to next step directly. Run the commands from next step.
yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y
```

## Installation

We will install Redis from the default CentOS/RHEL package streams by enabling the appropriate version.

### 1. Enable Redis 6 Module

Disable the default Redis module and enable version 6.

```bash
yum module disable redis -y
yum module enable redis:6 -y
```

### 2. Install Redis

Install the Redis package:

```bash
yum install redis -y
```

## Configuration

By default, Redis listens only on `127.0.0.1` (localhost). To allow the application services running on other servers to connect to Redis, we need to configure it to listen on all interfaces.

### 1. Update Listen Address

Edit the Redis configuration files to change the bind address from `127.0.0.1` to `0.0.0.0`.

**Files to modify:**

- `/etc/redis.conf`
- `/etc/redis/redis.conf`

```bash
# Update bind address using vim or sed
vim /etc/redis.conf
vim /etc/redis/redis.conf
```

> **Instruction:** Search for the line `bind 127.0.0.1` and change it to `bind 0.0.0.0`.

## Service Management

Start the Redis service and enable it to run on system boot.

```bash
systemctl enable redis
systemctl start redis
```

> **Verification:** You can check the status of the service to ensure it is running without errors:
>
> ```bash
> systemctl status redis
> ```
