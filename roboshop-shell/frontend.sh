yum install nginx -y
cp ./roboshop-shell/nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf

rm -rf /usr/share/nginx/html/*

curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip 

sed -i 's/localhost/frontend.sixdevops.store/g' /usr/share/nginx/html/index.html

cd /usr/share/nginx/html
unzip /tmp/frontend.zip

systemctl enable nginx
systemctl restart nginx