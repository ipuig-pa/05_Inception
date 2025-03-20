#!/bin/bash

if [ ! -f /run/secrets/wp_db_password ]; then
	echo "No wp_db_password found in secrets"
	exit 1
fi

if [ ! -f /run/secrets/wp_db_root_password ]; then
	echo "No wp_db_root_password found in secrets"
	exit 1
fi

MYSQL_PASSWORD=$(cat /run/secrets/wp_db_password)
MYSQL_ROOT_PASSWORD=$(cat /run/secrets/wp_db_root_password)

if [ ! -d "/var/lib/mysql/mysql" ]; then
	mysql_install_db --user=mysql --datadir=/var/lib/mysql

	service mysql start

	mysql -e "CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};"
	mysql -e "CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"
	mysql -e "GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';"
	mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';"
	mysql -e "FLUSH PRIVILEGES;"

	service mysql stop
fi

exec mysqld_safe
