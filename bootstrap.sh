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
sudo apt-get install curl -y > /dev/null


# mysql
printf '**************************\n\n'
printf 'Installing mysql'
printf '**************************\n\n'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password your_password'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password your_password'
sudo apt-get install mysql-server -y > /dev/null

#phpmyadmin
printf '**************************\n\n'
printf 'Installing phpmyadmin'
printf '**************************\n\n'
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/dbconfig-install boolean true"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/app-password-confirm password your_password"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/admin-pass password your_password"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/app-pass password your_password"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2"
sudo apt-get install phpmyadmin php-mbstring php-gettext -y > /dev/null
sudo phpenmod mbstring


#php 7
printf '**************************\n\n'
printf 'Installing php'
printf '**************************\n\n'
sudo apt install php libapache2-mod-php php-mysql -y > /dev/null
echo "Installing PHP extensions"
sudo apt-get install php-common php-dev php-cli php-fpm php-curl php-gd php-xdebug php-memcached php-memcache php-json php-xmlrpc php-geoip -y > /dev/null
sudo service apache2 restart > /dev/null




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

#updating /etc/apache2/sites-available/000-default.conf
printf '**************************\n\n'
printf 'Updating /etc/apache2/sites-available/000-default.conf'
printf '**************************\n\n'
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
