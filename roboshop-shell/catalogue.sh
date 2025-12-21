curl -sL https://rpm.nodesource.com/setup_lts.x | bash

yum module disable nodejs -y
yum install nodejs -y

cp mongo.repo /etc/yum.repos.d/mongo.repo
cp catalogue.service /etc/systemd/system/catalogue.service

useradd roboshop

mkdir /app 

curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip 
cd /app 
unzip /tmp/catalogue.zip
npm install 

yum install mongodb-org-shell -y

mongo --host MONGODB-SERVER-IPADDRESS </app/schema/catalogue.js

systemctl daemon-reload
systemctl enable catalogue
systemctl restart catalogue