#!/bin/bash

apt-get update -y
apt-get install mariadb-server -y
sed -i "s/.*bind-address.*/bind-address = 0.0.0.0/"  /etc/mysql/mariadb.conf.d/50-server.cnf
systemctl restart mariadb

