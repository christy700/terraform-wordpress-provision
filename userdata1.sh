#!/bin/bash

apt-get update -y
apt-get install nginx -y
apt-get install php7.4 php7.4-mysql php7.4-fpm -y
wget -P /tmp https://wordpress.org/wordpress-5.9.2.tar.gz
cd /tmp
tar -xvzf wordpress-5.9.2.tar.gz
mv wordpress/* /var/www/html/
chown -R www-data:www-data /var/www/html/
rm -rf /tmp/wordpress-5.9.2.tar.gz /tmp/wordpress
