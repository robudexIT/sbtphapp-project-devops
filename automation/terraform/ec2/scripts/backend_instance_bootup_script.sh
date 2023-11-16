#!/bin/bash -xe
sudo apt update -y

sudo apt install apache2  php php-mysql mysql-client git -y
sudo apt install awscli -y
sudo systemctl enable apache2
sudo systemctl start apache2

cd /tmp && git clone -b  lift-and-shift-high-availability https://github.com/robudexIT/sbtphapp-project-devops.git
cd /tmp/sbtphapp-project-devops


DB_HOST_IP=${db_host_ip}
SBTPHAPP_USER=${mysql_app_user}
SBTPHAPP_PWD=${mysql_app_pwd}
DBName="sbtphapp_db"

check_query="SELECT SCHEMA_NAME FROM information_schema.SCHEMATA WHERE SCHEMA_NAME = '$DBName'"
result=$(mysql -u "$SBTPHAPP_USER" -h "$DB_HOST_IP" -p"$SBTPHAPP_PWD" -e "$check_query"  -sN)


if [ -n "$result" ]; then
# Database already exists, so exit
echo "Database '$DBName' already exists. Exiting the script."

else

# Database doesn't exist, so create it
create_query="CREATE DATABASE $DBName"
mysql -u "$SBTPHAPP_USER" -h "$DB_HOST_IP" -p"$SBTPHAPP_PWD" -e "$create_query"

echo "Database '$DBName' has been created." 
# Restore the database from the backup file
mysql -u "$SBTPHAPP_USER" -h "$DB_HOST_IP" -p"$SBTPHAPP_PWD" "$DBName" < "/tmp/sbtphapp-project-devops/database/sbtphapp_db.sql"

echo "Database '$DBName' has been restored."
fi

cp -r /tmp/sbtphapp-project-devops/backend/sbtph_api/ /var/www/html/

sudo sed -i "s/[0-9]\+\(\.[0-9]\+\)\{3\}/$DB_HOST_IP/" /var/www/html/sbtph_api/config/database.php
sudo sed -i "s/SBTPHAPP_USER_HERE/$SBTPHAPP_USER/" /var/www/html/sbtph_api/config/database.php
sudo sed -i "s/SBTPHAPP_PWD_HERE/$SBTPHAPP_PWD/" /var/www/html/sbtph_api/config/database.php


#change ownership to ubuntu user and apache2 group
chown -R ubuntu:ubuntu /var/www/html

sudo systemctl restart apache2
cd .. 
sudo rm -rf /tmp/sbtphapp-project-devops
