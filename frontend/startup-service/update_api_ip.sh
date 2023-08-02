#!/bin/bash

REGION="AWS_REGION_HERE"


#get the public ip address of the Instance Name=Backend
AWS_API_IP=$(aws --region $REGION ec2 describe-instances --filters "Name=tag:Server,Values=Backend" --query 'Reservations[0].Instances[0].PublicIpAddress' | sed 's/"//g') 

#exit if AWS_API_IP is equal to null
if [ "$AWS_API_IP" == "null" ]; then
  exit 0
fi

CHECK_API_IP=$(grep -r -E -o $AWS_API_IP  js/app* | wc -l)

if [ "$CHECK_API_IP" -ne 0 ]; then
  echo "API IP is not change no need to update"
  exit 0
  
else {
   echo "API IP was change update javascript file"
   #find and replace  if app
   find /var/www/html/sbtph_app/js/app* -type f -exec sed -E -i "s/\b([0-9]{1,3}\.){3}[0-9]{1,3}\b/$AWS_API_IP/g" {} +
   #back the ownership to  ubuntu user and group
   sudo chown -R ubuntu:ubuntu /var/www/html/sbtph_app/js/app*
  }
fi


