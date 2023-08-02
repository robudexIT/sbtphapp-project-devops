#!/bin/bash
sudo apt update -y

sudo apt install apache2  -y
sudo apt install awscli -y
sudo systemctl enable apache2
systemctl start apache2
REGION="us-east-1"

#get the public ip address of the Instance Name=Backend
AWS_API_IP=$(aws --region $REGION ec2 describe-instances --filters "Name=tag:Server,Values=Backend" --query 'Reservations[0].Instances[0].PublicIpAddress' | sed 's/"//g') 

git clone -b  lift-and-shift-aws https://github.com/robudexIT/sbtphapp-project-devops.git
cd sbtphapp-project-devops

cd sbtphapp-project-devops


cp -r frontend/sbtph_app/ /var/www/html/
cp frontend/startup-service/update_api_ip.service /etc/systemd/system/
cp frontend/startup-service/update_api_ip.sh /home/ubuntu/
cp frontend/cron/update_api_ip.crontab /tmp/

if [ "$AWS_API_IP" -ne "null" ]; then
    find /var/www/html/sbtph_app/js/app* -type f -exec sed -E -i "s/\b([0-9]{1,3}\.){3}[0-9]{1,3}\b/$AWS_API_IP/g" {} +
fi
sudo chown -R ubuntu:ubuntu /var/www/html
 
#this code will deal on SPA application 
mv /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/000-default.conf-backup
cp frontend/conf/apache2/000-default.conf /etc/apache2/sites-available/
sudo a2enmod rewrite
sudo systemctl restart apache2


sudo sed -i "s/AWS_REGION_HERE/$REGION/" /home/ubuntu/update_api_ip.sh
sudo chmod +x /home/ubuntu/update_api_ip.sh
sudo chown ubuntu:ubuntu /home/ubuntu/update_api_ip.sh

sudo systemctl daemon-reload
sudo systemctl enable update_api_ip.service
sudo systemctl start update_api_ip.service

# Install the updated crontab
crontab /tmp/update_api_ip.crontab

# Remove the temporary file
rm /tmp/update_db_api.crontab


cd ..
sudo rm -rf  sbtphapp-project-devops


