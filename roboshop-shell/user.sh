curl -sL https://rpm.nodesource.com/setup_lts.x | bash

yum module disable nodejs -y
yum install nodejs -y

cp mongo.repo /etc/yum.repos.d/mongo.repo
cp user.service /etc/systemd/system/user.service

useradd roboshop

mkdir /app 

curl -L -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user.zip 
cd /app 
unzip /tmp/user.zip

npm install 

yum install mongodb-org-shell -y

mongo --host MONGODB-SERVER-IPADDRESS </app/schema/user.js

systemctl daemon-reload
systemctl enable user
systemctl restart user