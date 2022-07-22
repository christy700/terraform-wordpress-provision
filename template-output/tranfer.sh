#!/bin/bash

rsync --rsync-path="sudo rsync" -avzrp -e "ssh -o StrictHostKeyChecking=no -i /tmp/uberinfra" /tmp/template-output/backend_mysql.sh ubuntu@"172.17.99.166":/tmp/
rsync --rsync-path="sudo rsync" -avzrp -e "ssh -o StrictHostKeyChecking=no -i /tmp/uberinfra" /tmp/template-output/blog.timetrav.online.conf ubuntu@"172.17.45.187":/etc/nginx/sites-enabled/
rsync --rsync-path="sudo rsync" -avzrp -e "ssh -o StrictHostKeyChecking=no -i /tmp/uberinfra" /tmp/template-output/wp-config.php ubuntu@"172.17.45.187":/var/www/html/
sshpass ssh -i /tmp/uberinfra -o StrictHostKeyChecking=no -T ubuntu@"172.17.99.166" 'sudo apt-get install mariadb-server -y ; chmod +x /tmp/backend_mysql.sh ; sh  /tmp/backend_mysql.sh'
sshpass ssh -i /tmp/uberinfra -o StrictHostKeyChecking=no -T ubuntu@"172.17.45.187" 'sudo systemctl restart nginx ; sudo systemctl restart php7.4-fpm'
