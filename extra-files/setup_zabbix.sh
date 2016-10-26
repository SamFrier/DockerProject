#!/bin/bash

if [ -e /var/www/html/zabbix/index.php ]
  then
    echo "Zabbix is already installed."
    exit
fi

echo "Starting Zabbix installation..."

#apt-get update && install -y libmysqld-dev

# Set up database
service mysql start
mysql -h $MYSQL_PORT_3306_TCP_ADDR -u root < setup_zabbix_db.sql
cd /zabbix-3.2.1/database/mysql/
mysql -h $MYSQL_PORT_3306_TCP_ADDR -u zabbix -pzabbix zabbix < schema.sql
mysql -h $MYSQL_PORT_3306_TCP_ADDR -u zabbix -pzabbix zabbix < images.sql
mysql -h $MYSQL_PORT_3306_TCP_ADDR -u zabbix -pzabbix zabbix < data.sql

# Install Zabbix
cd /zabbix-3.2.1/
apt-get install -y gcc make
./configure --enable-server --with-mysql
make install
zabbix_server

# Configure Zabbix
sed -i 's/# ListenPort=10051/# ListenPort=10051\n\nListenPort=10051/g' \
/usr/local/etc/zabbix_server.conf
sed -i 's/# DBPassword=/# DBPassword=\n\nDBPassword=zabbix/g' \
/usr/local/etc/zabbix_server.conf
sed -i 's/# DBHost=localhost/# DBHost=localhost=\n\nDBHost=$MYSQL_PORT_3306_TCP_ADDR/g' \
/usr/local/etc/zabbix_server.conf

# Set up Apache
apt-get install -y apache2 apache2-doc apache2-utils
sed -i 's/keepAlive On/KeepAlive Off/g' /etc/apache2/apache2.conf

# Set up PHP
apt-get install -y libapache2-mod-php php-mcrypt php-mysql php-mbstring php-bcmath php-gd php-xml
a2dissite 000-default.conf
service apache2 restart && service apache2 reload
apt-get install -y php
mkdir /var/www/html/zabbix
cd /zabbix-3.2.1/frontends/php/
cp -a . /var/www/html/zabbix
cd /zabbix-3.2.1/
sed -i 's/max_size = 8/max_size = 16/g' /etc/php/7.0/apache2/php.ini
sed -i 's/on_time = 30/on_time = 300/g' /etc/php/7.0/apache2/php.ini
sed -i 's/max_input_time = 6/max_input_time = 300/g' /etc/php/7.0/apache2/php.ini
sed -i 's/;date.timezone =/date.timezone = UTC/g' /etc/php/7.0/apache2/php.ini
cp /zabbix.conf.php /var/www/html/zabbix/conf
chmod -R 775 /var/www
service apache2 restart

echo "Zabbix install script finished."
