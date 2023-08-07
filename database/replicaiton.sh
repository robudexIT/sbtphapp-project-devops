#!/bin/bash

# Set variables for replication
server_ip_remote_peer=""
replication_user_remote_peer=""
your_password=""
file_from_server_remote_peer=""
position_from_server_remote_peer=




# Connect to MySQL and execute CHANGE MASTER TO statement
mysql  -e "
STOP SLAVE;

CHANGE MASTER TO 
    MASTER_HOST='$server_ip_remote_peer',
    MASTER_USER='$replication_user_remote_peer',
    MASTER_PASSWORD='$your_password',
    MASTER_LOG_FILE='$file_from_server_remote_peer',
    MASTER_LOG_POS='$position_from_server_remote_peer',
  

START SLAVE;
"




  