#!/bin/bash
sudo apt update -y

sudo apt install apache2  php php-mysql mysql-client git -y
sudo apt install awscli -y
sudo systemctl enable apache2
sudo systemctl start apache2

cd /tmp && git clone -b  lift-and-shift https://github.com/robudexIT/sbtphapp-project-devops.git
cd /tmp/sbtphapp-project-devops

DB_HOST_IP=primarydbinstance.ctgivagolcpv.us-east-1.rds.amazonaws.com
SBTPHAPP_USER=admin
SBTPHAPP_PWD=iospK9xzsIHTzW3ejJzx
cp -r /tmp/sbtphapp-project-devops/backend/sbtph_api/ /var/www/html/

sudo sed -i "s/[0-9]\+\(\.[0-9]\+\)\{3\}/$DB_HOST_IP/" /var/www/html/sbtph_api/config/database.php
sudo sed -i "s/SBTPHAPP_USER_HERE/$SBTPHAPP_USER/" /var/www/html/sbtph_api/config/database.php
sudo sed -i "s/SBTPHAPP_PWD_HERE/$SBTPHAPP_PWD/" /var/www/html/sbtph_api/config/database.php


#change ownership to ubuntu user and apache2 group
chown -R ubuntu:ubuntu /var/www/html

sudo systemctl restart apache2
cd .. 
sudo rm -rf /tmp/sbtphapp-project-devops


