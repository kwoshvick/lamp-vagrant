#!/usr/bin/env bash

# credentials
$PASSWORD = 'password'

# update / upgrade
sudo apt-get update
sudo apt-get -y upgrade


#apache set-up
sudo apt-get install -y apache2
ln -fs /vagrant /var/www/html
# if ! [ -L /var/www/html ]; then
#   rm -rf /var/www/html
#   ln -fs /vagrant /var/www/html
# fi

#curl
sudo apt-get install curl

# mysql
debconf-set-selections <<< "mysql-server mysql-server/root_password password $PASSWORD"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $PASSWORD"
sudo apt-get install -y mysql-server

#phpmyadmin
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/dbconfig-install boolean true"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/app-password-confirm password $PASSWORD"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/admin-pass password $PASSWORD"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/app-pass password $PASSWORD"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2"
sudo apt-get -y install phpmyadmin
echo "Include /etc/phpmyadmin/apache.conf " >> /etc/apache2/apache2.conf

# php 5
sudo apt-get install php5 php5-cli libapache2-mod-php5 php5-mcrypt

# enable mod_rewrite
sudo a2enmod rewrite

# git
sudo apt-get -y install git

# restarting services
sudo service apache2 restart
sudo service mysql restart
