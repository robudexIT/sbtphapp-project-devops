#!/bin/bash
sudo apt update -y
sudo apt install mariadb-server -y
sudo apt install git -y
sudo systemctl enable mariadb
sudo systemctl start mariadb

git clone -b  lift-and-shift-aws https://github.com/robudexIT/sbtphapp-project-devops.git
cd sbtphapp-project-devops


# Define the configuration file path based on the operating system
CONFIG_FILE="/etc/mysql/mariadb.conf.d/50-server.cnf"  # Modify this if needed for your system

# Set bind-address to 0.0.0.0
sudo sed -i 's/^bind-address\s*=.*$/bind-address = 0.0.0.0/' "$CONFIG_FILE"
sudo systemctl restart mariadb

# MySQL credentials
MYSQL_USER="root"
MYSQL_PASSWORD=""

# Database information
DATABASE_NAME="sbtphapp_db"
SQL_FILE="database/sbtphapp_db.sql"


echo "CREATE DATABASE IF NOT EXISTS $DATABASE_NAME;" >> /tmp/db.setup
echo "CREATE USER 'python'@'%' IDENTIFIED BY 'sbtph@2018';" >> /tmp/db.setup
echo "GRANT ALL PRIVILEGES ON $DATABASE_NAME.* TO 'python'@'%';" >> /tmp/db.setup
echo "FLUSH PRIVILEGES;"  >> /tmp/db.setup
sudo sudo mysql -u root < /tmp/db.setup
sudo rm /tmp/db.setup
 # Restore the database from the SQL file
sudo mysql -u "$MYSQL_USER"  "$DATABASE_NAME" < "$SQL_FILE"

cd .. 
sudo rm -rf sbtphapp-project-devops
