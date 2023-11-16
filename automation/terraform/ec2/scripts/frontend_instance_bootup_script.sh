#!/bin/bash
sudo apt update -y

sudo apt install apache2  php php-mysql mysql-client git -y
sudo apt install awscli -y
sudo systemctl enable apache2
sudo systemctl start apache2

cd /tmp && git clone -b  lift-and-shift https://github.com/robudexIT/sbtphapp-project-devops.git
#get the public ip address of the BackendALBDNSName
AWS_API_IP=${backend_api_https}


cp -r /tmp/sbtphapp-project-devops/frontend/sbtph_app/ /var/www/html/


#find /var/www/html/sbtph_app/js/app* -type f -exec sed -E -i "s/\b([0-9]{1,3}\.){3}[0-9]{1,3}\b/$AWS_API_IP/g" {} +
find /var/www/html/sbtph_app/js/app* -type f -exec sed -E -i "s#\bhttp://([0-9]{1,3}\.){3}[0-9]{1,3}\b#$AWS_API_IP#g" {} +


sudo chown -R ubuntu:ubuntu /var/www/html

#this code will deal on SPA application 
mv /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/000-default.conf-backup
cp  /tmp/sbtphapp-project-devops/frontend/conf/apache2/000-default.conf /etc/apache2/sites-available/
sudo a2enmod rewrite
sudo systemctl restart apache2

sudo rm -rf  /tmp/sbtphapp-project-devops 