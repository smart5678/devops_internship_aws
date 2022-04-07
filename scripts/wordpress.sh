#!/bin/bash
sudo amazon-linux-extras install -y epel
echo yum update
sudo yum update -y -q
echo Install httpd, php
sudo yum install -y -q httpd php mysql php-mysqlnd

sudo service httpd start
sudo chkconfig httpd on
sudo usermod -a -G apache ec2-user
sudo chown -R ec2-user:apache /var/www
sudo chmod 2775 /var/www

echo "<?php phpinfo(); ?>" >/var/www/html/phpinfo.php

echo Downloading wordpress
wget -q https://wordpress.org/wordpress-4.0.20.tar.gz

echo Extract archive
tar -xzf wordpress-4.0.20.tar.gz
cp -r wordpress/* /var/www/html
cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php

find /var/www -type d -exec sudo chmod 2775 {} \;
find /var/www -type f -exec sudo chmod 0664 {} \;
