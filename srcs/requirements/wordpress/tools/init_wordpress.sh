#!/bin/bash

if [ ! -f /run/secrets/db_password ]; then
	echo "Error: No db_password found in secrets"
	exit 1
fi
if [ ! -f /run/secrets/wp_admin_password ]; then
	echo "Error: No wp_admin_password found in secrets"
	exit 1
fi
if [ ! -f /run/secrets/wp_user_password ]; then
	echo "Error: No wp_user_password found in secrets"
	exit 1
fi

DB_PASSWORD=$(cat /run/secrets/db_password)
WP_ADMIN_PASSWORD=$(cat /run/secrets/wp_admin_password)
WP_USER_PASSWORD=$(cat /run/secrets/wp_user_password)

while ! mysqladmin ping -h mariadb --silent; do
	echo "Waiting for MariaDB..."
	sleep 1
done

mkdir -p /run/php

if [ ! -f "/var/www/html/wp-config.php" ]; then
	echo "WordPress not found, downloading..."
	wp core download	--allow-root

	echo "Creating wp-config.php..."
	wp config create	--dbname=${DB_NAME} \
						--dbuser=${DB_USER} \
						--dbpass=${DB_PASSWORD} \
						--dbhost=mariadb \
						--allow-root

	echo "Installing WordPress..."
	wp core install		--url=${DOMAIN_NAME} \
						--title=${WP_TITLE} \
						--admin_user=${WP_ADMIN_USER} \
						--admin_password=${WP_ADMIN_PASSWORD} \
						--admin_email=${WP_ADMIN_EMAIL} \
						--allow-root

	echo "Creating additional user..."
	wp user create ${WP_USER} ${WP_USER_EMAIL} \
						--user_pass=${WP_USER_PASSWORD} \
						--role=author \
						--allow-root
	echo "WordPress setup completed!"
fi

echo "Starting PHP-FPM..."
exec php-fpm7.4 -F
