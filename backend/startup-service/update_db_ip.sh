#!/bin/bash

#get the private ip address of the Instance Name=Database
DB_HOST_IP=$(aws --region us-east-1 ec2 describe-instances --filters "Name=tag:Name,Values=Database" --query 'Reservations[0].Instances[0].PrivateIpAddress' | sed 's/"//g') 

sudo sed -i "s/[0-9]\+\(\.[0-9]\+\)\{3\}/$DB_HOST_IP/" /var/www/html/sbtph_api/config/database.php

#back the ownership to  ubuntu user and apache2 group
chown -R ubuntu:ubuntu /var/www/html/sbtph_api/config/database.php