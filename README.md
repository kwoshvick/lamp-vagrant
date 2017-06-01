
# Lamp & Tomcat7  Vagrant Box

### Setup:
* Apache
* Tomcat 7
* PHP 5.5
* Mysql
* Phpmyadmin
* Curl
* Maven
* Java 7
* Ubuntu box - trusty64



### Usage


1. Install [Vagrant](https://www.vagrantup.com/) and [Virtual Box](https://www.virtualbox.org/)

2. Clone the project

3. While in the `vagrant-lamp` folder , do
    ```sh
     $ vagrant up
     ```
4. Place your php projects in the `projects` folder.
5. For .war files for tomcat login then deploy.




**NB**


    - Localhost URL : http://localhost:8081/[project Name]
    - PhpMyadmin URL: http://localhost:8081/phpmyadmin/
    - MYSQL Username : root  
    - MYSQL Password : your_password
    - Tomcat URL: http://localhost:8080/
    - Tomcat Username : root  
    - Tomcat Password : your_password
    - Mysql Port : 3381 (forwarded)
    - Apache Port : 8081 (forwarded)
    - Tomcat Port : 8080 (forwarded)








