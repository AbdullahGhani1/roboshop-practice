# RabbitMQ Installation and Configuration

RabbitMQ is a message broker used by various components of the RoboShop application for asynchronous communication.

## Installation

RabbitMQ requires Erlang as a dependency. We will set up the repositories for both Erlang and RabbitMQ using scripts provided by PackageCloud.

### 1. Configure YUM Repositories

Run the following commands to configure the YUM repositories for Erlang and RabbitMQ Server.

```bash
# Configure Erlang repository
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash

# Configure RabbitMQ repository
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash
```

### 2. Install RabbitMQ Server

Install the RabbitMQ server package.

```bash
dnf install rabbitmq-server -y
```

## Service Management

Start the RabbitMQ service and enable it to run on system boot.

```bash
systemctl enable rabbitmq-server
systemctl start rabbitmq-server
```

## Configuration

### 1. Create Application User

RabbitMQ comes with a default `guest` user, but this user is restricted to localhost connections. We need to create a dedicated user for the application to specific permissions.

Create a user named `roboshop` with the password `roboshop123`.

```bash
rabbitmqctl add_user roboshop roboshop123
```

### 2. Set Permissions

Grant the `roboshop` user full permissions (configure, write, read) on the default virtual host `/`.

```bash
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"
```
