#!/bin/bash
sudo apt update -y

sudo apt install apache2  -y
sudo apt install awscli -y
sudo systemctl enable apache2
systemctl start apache2


#get the public ip address of the Instance Name=Backend
AWS_API_IP="REPLACE WITH BACKENDALB ENDPOINT HERE"
cd /tmp  && git clone -b  lift-and-shift  https://github.com/robudexIT/sbtphapp-project-devops.git



cp -r /tmp/sbtphapp-project-devops/frontend/sbtph_app/ /var/www/html/

#Replace the API endpoint to BackendALB
find /var/www/html/sbtph_app/js/app* -type f -exec sed -E -i "s/\b([0-9]{1,3}\.){3}[0-9]{1,3}\b/$AWS_API_IP/g" {} +

sudo chown -R ubuntu:ubuntu /var/www/html
 
#this code will deal on SPA application 
mv /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/000-default.conf-backup
cp frontend/conf/apache2/000-default.conf /etc/apache2/sites-available/
sudo a2enmod rewrite
sudo systemctl restart apache2



sudo systemctl enable update_api_ip.service
sudo systemctl start update_api_ip.service



cd ..
sudo rm -rf  /tmp/sbtphapp-project-devops


