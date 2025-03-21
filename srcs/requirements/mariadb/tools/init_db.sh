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

export DB_PASSWORD=$(cat /run/secrets/db_password)
export DB_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)

envsubst < /usr/local/bin/init.sql > /tmp/init.sql
mv /tmp/init.sql /usr/local/bin/init.sql

echo -e "${YELLOW}Checking if MySQL data directory structure is already set up...${NC}"
if [ ! -d "/var/lib/mysql/mysql" ]; then
	echo -e "${YELLOW}Initializing MySQL data directory...${NC}"
	mysql_install_db --user=mysql --datadir=/var/lib/mysql
fi

echo -e "${YELLOW}Starting MySQL server with initialization...${NC}"
exec mysqld --init-file=/usr/local/bin/init.sql
