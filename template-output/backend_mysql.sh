#!/bin/bash


sudo systemctl restart mariadb
sudo mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY 'mysqlpass123';"
sudo mysql -u root -p"mysqlpass123" -e "FLUSH PRIVILEGES;"
sudo mysql -u root -p"mysqlpass123" -e "create database wordpressdb"
sudo mysql -u root -p"mysqlpass123" -e "create user 'wordpressuser'@'%' IDENTIFIED BY 'wordpress123';"
sudo mysql -u root -p"mysqlpass123" -e "grant all on wordpressdb.* TO 'wordpressuser'@'%';"
sudo mysql -u root -p"mysqlpass123" -e "FLUSH PRIVILEGES;"
