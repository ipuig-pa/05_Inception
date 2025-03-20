#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

if [ ! -f /run/secrets/wp_db_password ]; then
	echo "${RED}Error: No wp_db_password found in secrets${NC}"
	exit 1
fi
if [ ! -f /run/secrets/wp_user_password ]; then
	echo "${RED}Error: No wp_user_password found in secrets${NC}"
	exit 1
fi
if [ ! -f /run/secrets/wp_admin_password ]; then
	echo "${RED}Error: No wp_admin_password found in secrets${NC}"
	exit 1
fi

WP_DB_PASSWORD = $(cat /run/secrets/wp_db_password)
WP_ADMIN_PASSWORD = $(cat /run/secrets/wp_admin_password)

while ! mysqladmin ping -h mariadb --silent; do
	echo "${YELLOW}Waiting for MariaDB...${NC}"
	sleep 1
done

mkdir -p /run/php

if [ ! -f "/var/www/html/wp-config.php" ]; then
	echo "${YELLOW}WordPress not found, downloading...${NC}"
	wp core download	--allow-root

	echo "${YELLOW}Creating wp-config.php...${NC}"
	wp config create	--dbname=${MYSQL_DATABASE} \
				--dbuser=${MYSQL_USER} \
				--dbpass=${MYSQL_PASSWORD} \
				--dbhost=mariadb \
				--allow-root

	echo "${YELLOW}Installing WordPress...${NC}"
	wp core install	--url=${DOMAIN_NAME} \
			--title=${WP_TITLE} \
			--admin_user=${WP_ADMIN_USER} \
			--admin_password=${WP_ADMIN_PASSWORD} \
			--admin_email=${WP_ADMIN_EMAIL} \
			--allow-root

	echo "${YELLOW}Creating additional user...${NC}"
	wp user create ${WP_USER} ${WP_USER_EMAIL} \
			--user_pass=${WP_USER_PASSWORD} \
			--role=author \
			--allow-root
	echo "${YELLOW}WordPress setup completed!${NC}"
fi

echo "${YELLOW}Starting PHP-FPM..."
exec php-fpm7.4 -F
