curl -sL https://rpm.nodesource.com/setup_lts.x | bash

yum module disable nodejs -y
yum install nodejs -y

cp cart.service /etc/systemd/system/cart.service

useradd roboshop
mkdir /app 

curl -L -o /tmp/cart.zip https://roboshop-artifacts.s3.amazonaws.com/cart.zip 
cd /app 
unzip /tmp/cart.zip

npm install 

systemctl daemon-reload
systemctl enable cart
systemctl restart cart