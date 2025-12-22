yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y

yum module disable redis -y
yum module enable redis:6 -y

yum install redis -y

# Update listen address from 127.0.0.1 to 0.0.0.0 in /etc/redis.conf & /etc/redis/redis.conf
sed -i 's/127.0.0.1/0.0.0.0/g' /etc/redis.conf

systemctl enable redis 
systemctl restart redis 