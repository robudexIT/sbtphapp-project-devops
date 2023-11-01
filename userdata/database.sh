#!/bin/bash
sudo apt update -y
sudo apt install mariadb-server -y
sudo apt install git -y
sudo systemctl enable mariadb
sudo systemctl start mariadb

 cd /tmp && git clone -b  lift-and-shift  https://github.com/robudexIT/sbtphapp-project-devops.git









