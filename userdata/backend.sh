#!/bin/bash
sudo apt update -y

sudo apt install apache2  php php-mysql mysql-client git -y
sudo apt install awscli -y
sudo systemctl enable apache2
systemctl start apache2

git clone -b  lift-and-shift-aws https://github.com/robudexIT/sbtphapp-project-devops.git
cd sbtphapp-project-devops
REGION="us-east-1"

#get the private ip address of the Instance Name=Database
DB_HOST_IP=$(aws --region $REGION ec2 describe-instances --filters "Name=tag:Server,Values=Database" --query 'Reservations[0].Instances[0].PrivateIpAddress' | sed 's/"//g') 


cp -r backend/sbtph_api/ /var/www/html/

if [ "$DB_HOST_IP" -ne "null"]; then
    sudo sed -i "s/[0-9]\+\(\.[0-9]\+\)\{3\}/$DB_HOST_IP/" /var/www/html/sbtph_api/config/database.php
fi

#change ownership to ubuntu user and apache2 group
chown -R ubuntu:ubuntu /var/www/html

cp backend/startup-service/update_db_ip.sh /home/ubuntu/
 #update region in update_db_ip.sh
 sudo sed -i "s/AWS_REGION_HERE/$REGION/" /home/ubuntu/update_db_ip.sh

chown -R ubuntu:ubuntu /home/ubuntu/update_db_ip.sh
chmod +x /home/ubuntu/update_db_ip.sh

cp backend/startup-service/update_db_ip.service /etc/systemd/system/

sudo systemctl daemon-reload
sudo systemctl enable update_db_ip.service
sudo systemctl start update_db_ip.service

cp backend/cron/update_db_ip.crontab /tmp/

# Install the updated crontab
crontab /tmp/update_db_ip.crontab

# Remove the temporary file
rm /tmp/update_db_ip.crontab

cd .. 
sudo rm -rf sbtphapp-project-devops



 
