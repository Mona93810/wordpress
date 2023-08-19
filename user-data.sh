#!/bin/bash

# Update package lists
sudo apt update

# Install Nginx
sudo apt install -y nginx

# Install MySQL
sudo apt install -y mysql-server

# Install Expect for MySQL secure installation
sudo apt-get install -y expect

# Secure MySQL installation using Expect
sudo expect <<EOF
spawn mysql_secure_installation
expect "VALIDATE PASSWORD COMPONENT can be used to test passwords\r\nand improve security. It checks the strength of password\r\nand allows the users to set only those passwords which are\r\nsecure enough. Would you like to setup VALIDATE PASSWORD component?"
send "n\r"
expect "Remove anonymous users? (Press y|Y for Yes, any other key for No) :"
send "y\r"
expect "Disallow root login remotely? (Press y|Y for Yes, any other key for No) :"
send "n\r"
expect "Remove test database and access to it? (Press y|Y for Yes, any other key for No) :"
send "n\r"
expect "Reload privilege tables now? (Press y|Y for Yes, any other key for No) :"
send "y\r"
EOF

# Install PHP and dependencies
sudo apt install -y php-fpm php-mysql

# Download and extract WordPress
wget https://wordpress.org/latest.tar.gz
tar -xzvf latest.tar.gz
sudo mv wordpress /var/www/html/wordpress

# MySQL commands to create WordPress database and user
sudo mysql -u root <<EOF
CREATE DATABASE wordpress_db;
CREATE USER 'wordpress_user'@'localhost' IDENTIFIED BY 'Mona@1234';
GRANT ALL PRIVILEGES ON wordpress_db.* TO 'wordpress_user'@'localhost';
FLUSH PRIVILEGES;
EOF

# Create a WordPress configuration
sudo cp /var/www/html/wordpress/wp-config-sample.php /var/www/html/wordpress/wp-config.php
# Here you might want to use sed to modify the wp-config.php file with the right DB details
sudo sed -i "s/database_name_here/wordpress_db/g" /var/www/html/wordpress/wp-config.php
sudo sed -i "s/username_here/wordpress_user/g" /var/www/html/wordpress/wp-config.php
sudo sed -i "s/password_here/Mona@1234/g" /var/www/html/wordpress/wp-config.php

# Configure Nginx for WordPress
sudo tee /etc/nginx/sites-available/wordpress <<EOF
server {
    listen 80;
    server_name wordpresstask.ddns.net;
    root /var/www/html/wordpress;

    location / { 
        try_files \$uri \$uri/ /index.php?\$args;
        index index.php;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php8.1-fpm.sock;
    }
}
EOF

# Enable the Nginx configuration
sudo ln -s /etc/nginx/sites-available/wordpress /etc/nginx/sites-enabled/
sudo rm /etc/nginx/sites-enabled/default
sudo nginx -t
sudo systemctl restart nginx

# Install Certbot for Let's Encrypt (if not already installed)
sudo apt-get install -y certbot python3-certbot-nginx

# Request a certificate for the domain, agreeing to the Terms of Service and providing an email address
sudo certbot --nginx -d wordpresstask.ddns.net --agree-tos --email monabommakanti@gmail.com --no-eff-email
