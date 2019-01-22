#!/usr/bin/env bash

_git_username=$1
_git_password=$2
_reinit_repo=$3
_initial_setup=$4

DB_ROOT_PASSWORD='p@$$w0rd'
DB_USERNAME='root'
DB_NAME='hrms'
HTTPD_PORT='3000'

if [ "${_reinit_repo}" == "no" ] || [ "${_initial_setup}" == "yes" ]; then

# update / upgrade
sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get install git
sudo apt-get -y install npm

echo "----- INSTALLING MySQL 5.7 and APACHE WEB SERVER ------";
# # install mysql and give password to installer
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password $DB_ROOT_PASSWORD"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $DB_ROOT_PASSWORD"
sudo apt -y install mysql-server

# # {{{ MYSQL CONFIGURATION START
# # disable this line. This enables mysql to listen not only from localhost
sudo sed -i "s/^bind-address/#bind-address/" /etc/mysql/mysql.conf.d/mysqld.cnf

# # create fullscale user
echo "CREATING PYTHON PROJECT DATABASE $DB_USERNAME WITH PASSWORD $DB_ROOT_PASSWORD";
mysql -u root -p$DB_ROOT_PASSWORD -e "CREATE USER '$DB_USERNAME'@'%' IDENTIFIED BY '$DB_ROOT_PASSWORD';"
mysql -u root -p$DB_ROOT_PASSWORD -e "GRANT ALL PRIVILEGES ON *.* TO '$DB_USERNAME'@'%' IDENTIFIED BY '$DB_ROOT_PASSWORD' WITH GRANT OPTION; FLUSH PRIVILEGES; SET GLOBAL max_connect_errors=10000;"

# # set sql_mode to empty to force allow invalid dates (ZERO Dates value)
echo "sql_mode=" >> /etc/mysql/mysql.conf.d/mysqld.cnf

#
# MYSQL CONFIGURATION END }}}
#

# INSTALL NGINX
sudo apt-get -y install nginx

# INSTALL PIP
sudo apt-get -y install python3-pip
sudo -H pip3 install --upgrade pip

# Create SWAP FILE --DO NOT TOUCH BELOW
/bin/dd if=/dev/zero of=/var/swap.1 bs=1M count=1024
/sbin/mkswap /var/swap.1
/sbin/swapon /var/swap.1

fi

if [ "${_reinit_repo}" == "yes" ] || [ "${_initial_setup}" == "yes" ]; then

# init database
mysql -u $DB_USERNAME -p$DB_ROOT_PASSWORD -e "DROP DATABASE IF EXISTS $DB_NAME; CREATE DATABASE $DB_NAME CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"

# # Clone projects
# echo "GIT CLONING FULLSCALE EMPLOYEE APP...";
# cd /var/www/html && rm -rf fullscale-employee && git clone -b development https://${_git_username}:${_git_password}@github.com/gigabooksite/fullscale-employee.git fullscale-employee
# cd /var/www/html/fullscale-employee && git fetch 
# echo "ENSURING YOUR WORKING COPY IS UPDATED FROM DEVELOPMENT BRANCH...";
# cd /var/www/html/fullscale-employee && git pull origin

# echo "SETTING UP FULLSCALE EMPLOYEE APP...";
# echo "CONFIGURING FULLSCALE EMPLOYEE APP..."
# cd /var/www/html/fullscale-employee && composer install
# cp /var/www/html/fullscale-employee/.env.example /var/www/html/fullscale-employee/.env
# sudo sed -i "s/^DB_DATABASE=homestead/DB_DATABASE=$DB_NAME/" /var/www/html/fullscale-employee/.env
# sudo sed -i "s/^DB_USERNAME=homestead/DB_USERNAME=$DB_USERNAME/" /var/www/html/fullscale-employee/.env
# sudo sed -i "s/^DB_PASSWORD=secret/DB_PASSWORD=$DB_ROOT_PASSWORD/" /var/www/html/fullscale-employee/.env

# # init project
# cd /var/www/html/fullscale-employee && php artisan key:generate
# cd /var/www/html/fullscale-employee && php artisan migrate
# cd /var/www/html/fullscale-employee && php artisan db:seed
# cd /var/www/html/fullscale-employee && php artisan passport:install
# #cd /var/www/html/fullscale-employee && npm install # issue with npm using virtualbox on Windows
# #cd /var/www/html/fullscale-employee && npm run dev # issue with npm using virtualbox on Windows

# echo "=================================================";
# echo "Your FullScale Employee application is set up!";
# echo "It is advisable to run 'vagrant halt' and then 'vagrant up'";
# echo "for newly installed vagrant plugins to take effect.";
# echo "";
# echo "The application is installed inside 'www' directory.";
# echo "";
# echo "You can connect to the database via PORT 3306 with this credential:";
# echo "User: $DB_USERNAME";
# echo "Pass: $DB_ROOT_PASSWORD";
# echo "";
# echo "Check /resources/js/common/oauth/config.js and modify 'client_secret' based on generated key in";
# echo "oauth_clients > Fullscale Password Grant Client > secret table value";
# echo "";
# echo "Go on and try browsing http://fullscale.localhost:$HTTPD_PORT/";
# echo "=================================================";

fi
