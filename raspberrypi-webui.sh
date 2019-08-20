#!/bin/bash
sudo apt -y update -qq > /dev/null
sudo apt -y upgrade -y -qq > /dev/null
sudo apt-get -y install git apache2 -qq > /dev/null
sudo chown -R pi:www-data /var/www/html/  > /dev/null
sudo chmod -R 770 /var/www/html/ > /dev/null
ip="$(hostname -I | awk '{ print $1 }')"
echo -e "apache installed: http://$ip"
sudo apt-get -y install php php-mbstring php-ssh2 -qq > /dev/null
sudo rm /var/www/html/index.html
echo "<?php phpinfo ();?>" > /var/www/html/index.php
echo "php installed "
sudo apt -y install mysql-server php-mysql -qq > /dev/null
sudo apt -y install phpmyadmin -qq > /dev/null
echo "phpmyadmin installed  http://$ip/phpmyadmin"
cd
git clone git://git.drogon.net/wiringPi
cd wiringPi
git pull origin
./build
cd /var/www/html
sudo git clone https://github.com/gumslone/GumCP.git
cd 
echo -e "GumCP installed: http://$ip"
echo "installation succeeded"