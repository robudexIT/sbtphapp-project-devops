#!/bin/bash
sudo apt update -y

sudo apt install apache2  php php-mysql mysql-client git -y
sudo systemctl enable apache2
systemctl start apache2


#get the private ip address of the Instance Name=Database
export DB_HOST_IP=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=Database" --query 'Reservations[0].Instances[0].PrivateIpAddress' | sed 's/"//g') 




