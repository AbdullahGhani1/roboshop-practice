# Functional vs Non-Functional Requirements

In the context of shell scripting and automation:

- **Functional Requirements**: Define the specific tasks the script must perform, such as installing packages, configuring services, and managing users.
- **Non-Functional Requirements**: Define the quality attributes of the script, such as idempotency (running the script multiple times without side effects), error handling, logging, and readability.

clone the repository

```sh
git clone https://github.com/AbdullahGhani1/roboshop-practice.git
```

Navigate to the roboshop directory

```sh
cd roboshop-practice
```

### Frontend Service

```sh
# Install Nginx web server
yum install nginx -y

# Configure Nginx for Roboshop
cp ./roboshop-shell/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf

# Clear existing content and download frontend artifacts
rm -rf /usr/share/nginx/html/*
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip

# Deploy content to the web root
cd /usr/share/nginx/html
unzip /tmp/frontend.zip

# Enable and start the Nginx service
systemctl enable nginx
systemctl restart nginx

```
