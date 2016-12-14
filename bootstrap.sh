#!/usr/bin/env bash

#configurations
export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
locale-gen en_US.UTF-8
dpkg-reconfigure locales
export DEBIAN_FRONTEND=noninteractive


# update / upgrade
printf '**************************\n\n'
printf 'Installing updating and upgrading'
printf '**************************\n\n'
echo "Provisioning virtual machine..."
echo "=========================================="
echo "Updating Ubuntu"
sudo apt-get update > /dev/null
sudo apt-get upgrade > /dev/null


printf '**************************\n\n'
printf 'Installing Apache'
printf '**************************\n\n'
#apache set-up
sudo apt-get install apache2 -y > /dev/null


printf '**************************\n\n'
printf 'Installing curl'
printf '**************************\n\n'
#curl
sudo apt-get install curl


# mysql
printf '**************************\n\n'
printf 'Installing mysql'
printf '**************************\n\n'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password your_password'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password your_password'
sudo apt-get -y install mysql-server

#phpmyadmin
printf '**************************\n\n'
printf 'Installing phpmyadmin'
printf '**************************\n\n'
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/dbconfig-install boolean true"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/app-password-confirm password your_password"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/admin-pass password your_password"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/app-pass password your_password"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2"
sudo apt-get -y install phpmyadmin
echo "Include /etc/phpmyadmin/apache.conf " >> /etc/apache2/apache2.conf

#php 5
printf '**************************\n\n'
printf 'Installing php'
printf '**************************\n\n'
echo "Updating PHP repository"
sudo apt-get install python-software-properties -y > /dev/null
sudo add-apt-repository ppa:ondrej/php5-oldstable -y > /dev/null
sudo apt-get update > /dev/null
sudo apt-get install -y php5 > /dev/null
echo "Installing PHP"
sudo apt-get install php5-common php5-dev php5-cli php5-fpm -y > /dev/null
echo "Installing PHP extensions"
sudo apt-get install curl php5-curl php5-gd php5-mcrypt php5-mysql php5-xdebug php5-memcached php5-memcache php5-sqlite php5-json php5-xmlrpc php5-geoip -y > /dev/null
echo "Creating xdebug log directory: /var/log/xdebug"
sudo mkdir /var/log/xdebug > /dev/null
echo "Changing xdebug log directory owner to www-data"
sudo chown www-data:www-data /var/log/xdebug > /dev/null
echo "Installing xdebug"
sudo pecl install xdebug > /dev/null
echo "Configuring xdebug"
sudo cp /var/www/html/config/php.ini /etc/php5/apache2/php.ini > /dev/null
sudo service apache2 restart > /dev/null
echo "Xdebug installation completeted"



# enable mod_rewrite
printf '**************************\n\n'
printf 'Enable rewrite'
printf '**************************\n\n'
sudo a2enmod rewrite

# git
printf '**************************\n\n'
printf 'Installing git'
printf '**************************\n\n'
sudo apt-get install git -y > /dev/null

#updating /etc/
echo "

<VirtualHost *:80>
        # The ServerName directive sets the request scheme, hostname and port t$
        # the server uses to identify itself. This is used when creating
        # redirection URLs. In the context of virtual hosts, the ServerName
        # specifies what hostname must appear in the request's Host: header to
        # match this virtual host. For the default virtual host (this file) this
        # value is not decisive as it is used as a last resort host regardless.
        # However, you must set it for any further virtual host explicitly.
        #ServerName www.example.com

        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/html
         <Directory />
            Options FollowSymLinks
            AllowOverride All
         </Directory>
         <Directory /var/www >
            Options Indexes FollowSymLinks MultiViews
            AllowOverride All
         </Directory>

        # Available loglevels: trace8, ..., trace1, debug, info, notice, warn,
        # error, crit, alert, emerg.
        # It is also possible to configure the loglevel for particular
        # modules, e.g.
        #LogLevel info ssl:warn

        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined

        # For most configuration files from conf-available/, which are
        # enabled or disabled at a global level, it is possible to
        # include a line for only one particular virtual host. For example the
        # following line enables the CGI configuration for this host only
        # after it has been globally disabled with "a2disconf".
        #Include conf-available/serve-cgi-bin.conf
</VirtualHost>



" > /etc/apache2/sites-available/000-default.conf 

# restarting services
printf '**************************\n\n'
printf 'restarting mysql and apache2'
printf '**************************\n\n'
sudo service apache2 restart
sudo service mysql restart

#end
echo "--------------------------Finished provisioning.-------------"
