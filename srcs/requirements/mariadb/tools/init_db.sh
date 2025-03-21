#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

echo -e "${YELLOW}Checking passwords...${NC}"

if [ ! -f /run/secrets/db_password ]; then
	echo "${RED}Error: No db_password found in secrets${NC}"
	exit 1
fi

if [ ! -f /run/secrets/db_root_password ]; then
	echo "${RED}Error: No db_root_password found in secrets${NC}"
	exit 1
fi

DB_PASSWORD=$(cat /run/secrets/db_password)
DB_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)

echo -e "${YELLOW}Checking if MySQL data directory structure is already set up...${NC}"
if [ ! -d "/var/lib/mysql/mysql" ]; then
	echo -e "${YELLOW}Initializing MySQL data directory...${NC}"
	mysql_install_db --user=mysql --datadir=/var/lib/mysql

	service mysql start

	echo -e "${YELLOW}Creating database and users...${NC}"
	mysql -e "CREATE DATABASE IF NOT EXISTS ${DB_NAME};"
	mysql -e "CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';"
	mysql -e "GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'%';"
	mysql -e "FLUSH PRIVILEGES;"
	mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASSWORD}';"
	mysql -e "FLUSH PRIVILEGES;"

	service mysql stop
fi

echo -e "${YELLOW}Starting MySQL server...${NC}"
exec mysqld_safe
