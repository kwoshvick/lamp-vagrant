
# Lamp in  vagrant

### Setup:
* Apache
* PHP 5.5
* Mysql
* Phpmyadmin
* Ubuntu box - trusty64



### Procedure


1. Install [Vagrant](https://www.vagrantup.com/) and [Virtual Box](https://www.virtualbox.org/)

2. Clone the project

3. While in the `vagrant-lamp` folder , do
    ```sh
     $ vagrant up
     ```
4. Place your projects in the `projects` folder.




**NB**

    -  MYSQL Username : root  
    -  MYSQL Password : your_password
    - localhost URL : http://localhost:8081/[project Name]
    - phpMyadmin URL: http://localhost:8081/phpmyadmin/
    - Mysql Port : 3381 (forwarded)
    - Apache Port : 8081 (forwarded)
