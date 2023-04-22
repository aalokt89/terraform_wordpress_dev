#!/bin/bash

#template vars
db_username=${db_username}
db_password=${db_password}
db_name=${db_name}
db_host=${db_host}

wp_username=${wp_username}
wp_password=${wp_password}
wp_email=${wp_email}
wp_url=${wp_url}
wp_title=${wp_title}

sudo yum update -y
sudo yum install -y httpd mysql
sudo systemctl start httpd
sudo systemctl enable httpd

sudo amazon-linux-extras install -y php7.4
sudo amazon-linux-extras enable php7.4
sudo yum clean metadata
sudo yum install php-cli php-pdo php-fpm php-json php-mysqlnd

#Change OWNER and permission of directory /var/www
sudo usermod -a -G apache ec2-user
sudo chown -R ec2-user:apache /var/www
sudo find /var/www -type d -exec chmod 2775 {} \;
sudo find /var/www -type f -exec chmod 0664 {} \;

# Download and install the WordPress CLI
sudo curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
sudo chmod +x wp-cli.phar
sudo mv wp-cli.phar /usr/local/bin/wp

# Create the WordPress configuration file
cd /var/www/html
wp core download --allow-root
wp config create --dbname=$db_name --dbuser=$db_username --dbpass=$db_password --dbhost=$db_host --allow-root

# Install WordPress
wp core install --url=$wp_url --title=$wp_title --admin_user=$wp_username --admin_password=$wp_password --admin_email=$wp_email --allow-root


# Set the appropriate permissions
sudo chown -R apache:apache /var/www/html
sudo chmod -R 755 /var/www/html
sudo systemctl restart httpd.service
