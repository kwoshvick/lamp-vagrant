#!/usr/bin/env bash

#configurations
export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
locale-gen en_US.UTF-8
dpkg-reconfigure locales
export DEBIAN_FRONTEND=noninteractive

TOMCAT_VERSION="8.5.11"



# update / upgrade
printf '**************************\n\n'
printf 'Installing updating and upgrading'
printf '**************************\n\n'
echo "Provisioning virtual machine..."
echo "=========================================="
echo "Updating Ubuntu"
sudo apt-get update > /dev/null
sudo apt-get upgrade > /dev/null


# printf '**************************\n\n'
# printf 'Installing Apache'
# printf '**************************\n\n'
# #apache set-up
# sudo apt-get install apache2 -y > /dev/null


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


printf '**************************\n\n'
printf 'Installing JDK, JRE , oracle-java7'
printf '**************************\n\n'
sudo apt-get install default-jdk -y > /dev/null
sudo apt-get install openjdk-7-jre -y > /dev/null
sudo apt-get install openjdk-7-jre -y > /dev/null
sudo apt-get install python-software-properties -y > /dev/null
sudo add-apt-repository ppa:webupd8team/java -y > /dev/null
sudo apt-get update -y > /dev/null
echo "oracle-java7-installer shared/accepted-oracle-license-v1-1 select true" | sudo debconf-set-selections
sudo apt-get install -y oracle-java7-installer
# sudo echo 'JAVA_HOME="/usr/lib/jvm/java-7-openjdk-amd64"' >> /etc/environment# source /etc/environment

echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee /etc/apt/sources.list.d/webupd8team-java.list
echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee -a /etc/apt/sources.list.d/webupd8team-java.list
ls /etc/apt/sources.list.d/
cat /etc/apt/sources.list.d/webupd8team-java.list
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886
apt-get -y update
apt-get -y upgrade
echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections
apt-get -y install oracle-java8-installer



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



#installing unzip
printf '**************************\n\n'
printf 'Installing unzip'
printf '**************************\n\n'
sudo apt install unzip


printf '**************************\n\n'
printf 'Downloading Tomcat 9'
printf '**************************\n\n'
cd /tmp
wget www-eu.apache.org/dist/tomcat/tomcat-8/v8.5.11/bin/apache-tomcat-8.5.11.zip



printf '**************************\n\n'
printf 'Extracting and Putting tomcat-8 in /opt'
printf '**************************\n\n'
sudo unzip apache-tomcat-$TOMCAT_VERSION.zip
sudo mv apache-tomcat-$TOMCAT_VERSION /opt/tomcat

printf '**************************\n\n'
printf 'Tomcat user'
printf '**************************\n\n'
sudo groupadd tomcat
sudo useradd -s /bin/false -g tomcat -d /opt/tomcat tomcat
cd /opt/tomcat
sudo chgrp -R tomcat /opt/tomcat
sudo chmod -R g+r conf/
sudo chmod g+x conf
sudo chown -R tomcat webapps/ work/ temp/ logs/
sudo chmod -R +x /opt/tomcat



echo "
description "Tomcat Server"

  start on runlevel [2345]
  stop on runlevel [!2345]
  respawn
  respawn limit 10 5

  setuid tomcat
  setgid tomcat

  env JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-amd64/jre
  env CATALINA_HOME=/opt/tomcat

  # Modify these options as needed
  env JAVA_OPTS="-Djava.awt.headless=true -Djava.security.egd=file:/dev/./urandom"
  env CATALINA_OPTS="-Xms512M -Xmx1024M -server -XX:+UseParallelGC"

  exec $CATALINA_HOME/bin/catalina.sh run

  # cleanup temp directory after stop
  post-stop script
    rm -rf $CATALINA_HOME/temp/*
  end script

" >> /etc/systemd/system/tomcat.service

sudo initctl reload-configuration
sudo initctl start tomcat




# restarting services
printf '**************************\n\n'
printf 'restarting mysql and apache2'
printf '**************************\n\n'
sudo service apache2 restart
sudo service mysql restart
sudo service tomcat restart

#end
echo "--------------------------Finished provisioning.-------------"
