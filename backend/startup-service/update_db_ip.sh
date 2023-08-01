#!/bin/bash

REGION="us-east-1"
#get the private ip address of the Instance Name=Database
AWS_DB_HOST_IP=$(aws --region $REGION ec2 describe-instances --filters "Name=tag:Name,Values=Database" --query 'Reservations[0].Instances[0].PrivateIpAddress' | sed 's/"//g') 

CUR_DB_HOST_IP=$(grep -E -o '([0-9]{1,3}\.){3}[0-9]{1,3}' /var/www/html/sbtph_api/config/database.php)
if [ "$CUR_DB_HOST_IP" = "$AWS_DB_HOST_IP" ];then 
    exit 0
else {    
    sudo sed -i "s/[0-9]\+\(\.[0-9]\+\)\{3\}/$AWS_DB_HOST_IP/" /var/www/html/sbtph_api/config/database.php
    #back the ownership to  ubuntu user and group
    chown -R ubuntu:ubuntu /var/www/html/sbtph_api/config/database.php
    }
fi