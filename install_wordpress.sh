#!/bin/bash
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
wp config create --dbname=wordpress --dbuser=admin --dbpass=password --dbhost=wordpress.cgwzuzkgdaxy.us-east-1.rds.amazonaws.com --allow-root

# Install WordPress
wp core install --url=54.226.72.43 --title="my-wordpress" --admin_user=admin --admin_password=password --admin_email=hello@gmail.com --allow-root


# Set the appropriate permissions
sudo chown -R apache:apache /var/www/html
sudo chmod -R 755 /var/www/html
sudo systemctl restart httpd.service
