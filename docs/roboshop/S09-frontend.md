# 01-Frontend

The frontend service in RoboShop is responsible for serving web content via Nginx. As the application consists of static content, a web server is required. Nginx has been selected to fulfill this role.

## Installation and Configuration

### 1. Install Nginx

Install the Nginx web server package:

```bash
yum install nginx -y
```

### 2. Manage Nginx Service

Enable and start the Nginx service to ensure it runs on boot:

```bash
systemctl enable nginx
systemctl start nginx
```

> **Verification:** Access the server's IP address in a web browser to ensure the default Nginx page is displayed.

### 3. Clear Default Content

Remove the default files served by Nginx to prepare for the application content:

```bash
rm -rf /usr/share/nginx/html/*
```

### 4. Download Frontend Artifacts

Download the frontend application content to the temporary directory:

```bash
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip
```

### 5. Extract Frontend Content

Navigate to the Nginx web root and extract the downloaded artifacts:

```bash
cd /usr/share/nginx/html
unzip /tmp/frontend.zip
```

> **Verification:** Refresh the browser to ensure the RoboShop web application content is now visible.

### 6. Configure Nginx Reverse Proxy

Create the reverse proxy configuration file to handle backend service requests:

```bash
vim /etc/nginx/default.d/roboshop.conf
```

Add the following content:

```nginx
proxy_http_version 1.1;
location /images/ {
  expires 5s;
  root   /usr/share/nginx/html;
  try_files $uri /images/placeholder.jpg;
}
location /api/catalogue/ { proxy_pass http://localhost:8080/; }
location /api/user/ { proxy_pass http://localhost:8080/; }
location /api/cart/ { proxy_pass http://localhost:8080/; }
location /api/shipping/ { proxy_pass http://localhost:8080/; }
location /api/payment/ { proxy_pass http://localhost:8080/; }
location /health {
  stub_status on;
  access_log off;
}
```

> **Note:** Ensure you replace `localhost` with the actual IP address of those component servers. The word `localhost` is used to avoid configuration failures if the services are not yet reachable.

### 7. Restart Nginx Service

Restart the Nginx service to apply the configuration changes:

```bash
systemctl restart nginx
```

nginx version installed:

```bash
nginx -v
# nginx version: nginx/1.14.1
```
