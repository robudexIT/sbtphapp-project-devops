#!/bin/bash
sudo update -y
sudo apt install mariadb-server -y
sudo systemctl enable mariadb
sudo systemctl start mariadb

# Define the configuration file path based on the operating system
CONFIG_FILE="/etc/mysql/mariadb.conf.d/50-server.cnf"  # Modify this if needed for your system

# Set bind-address to 0.0.0.0
sed -i 's/^bind-address\s*=.*$/bind-address = 0.0.0.0/' "$CONFIG_FILE"
sudo systemctl restart mariadb

# MySQL credentials
MYSQL_USER="root"
MYSQL_PASSWORD=""

# Database information
DATABASE_NAME="sbtphapp_db"
SQL_FILE="../database/sbtphapp_db.sql"

# Create the database
mysql -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" -e "CREATE DATABASE IF NOT EXISTS $DATABASE_NAME;"

# Restore the database from the SQL file
mysql -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" "$DATABASE_NAME" < "$SQL_FILE"

# Create the new user
mysql -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" -e "CREATE USER 'python'@'%' IDENTIFIED BY 'sbtph@2018';"

# Grant privileges to the new user on the specified database
mysql -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" -e "GRANT ALL PRIVILEGES ON $DATABASE_NAME.* TO 'python'@'%';"

# Flush privileges to apply the changes
mysql -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" -e "FLUSH PRIVILEGES;"
