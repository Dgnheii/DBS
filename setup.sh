#!/bin/bash

# Checking MySQL Service
if systemctl is-active --quiet mysql; then
    echo "MySQL service is already installed."
else
    echo "Installing MySQL service..."
    apt-get install mysql-server -y
fi
                
# Checking Apache Service
if systemctl is-active --quiet apache2; then
    echo "Apache service is already installed."
else
    echo "Installing Apache service..."
    apt-get install apache2 -y
fi

# Checking PHP
if command -v php >/dev/null 2>&1; then
    echo "PHP is already installed."
else
    echo "Installing PHP..."
    apt-get install php -y
fi

# Removing existing web-source folder if it exists
if [ -d "/tmp/web-source" ]; then
    echo "Removing existing web-source folder..."
    rm -rf /tmp/web-source
fi

# Checking Git
if command -v git >/dev/null 2>&1; then
    echo "Git is already installed."
else
    echo "Installing Git..."
    apt-get install git -y
fi

# Cloning Web Source and Copying to Apache Web Folder
echo "Cloning web source code..."
git clone https://github.com/congminh1233/DBS.git /tmp/web-source
                                
echo "Copying web source code to Apache web folder..."
cp -r /tmp/web-source /var/www/html
chmod 777 ../../../var/www/html/web-source/Assignment
echo "Web application setup completed!"

echo "Restarting Apache service..."
service apache2 restart

echo "Restarting MySQL service..."
service mysql restart

#Checking and creating the new user
if mysql -u root -e "SELECT EXISTS(SELECT 1 FROM mysql.user WHERE user = 'new_user' LIMIT 1);" | grep -q 1; then
    echo "Deleting existing 'new_user' user..."
    mysql -u root -e "DROP USER 'new_user'@'localhost';"
fi

# Adding a new user without password to the database
echo "Creating a new database user..."
mysql -u root -e "CREATE USER 'new_user'@'localhost' IDENTIFIED BY '';"
echo "Granting privileges to the new_user user..."
mysql -u root -e "GRANT ALL PRIVILEGES ON . TO 'new_user'@'localhost';"
echo "Flushing privileges..."
mysql -u root -e "FLUSH PRIVILEGES;"

# Displaying the local URL
local_url="http://127.0.0.1/web-source/Assignment"
echo "Web application setup completed!"
echo "You can access the web application at: $local_url"
