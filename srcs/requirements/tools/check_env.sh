#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

# Check if .env file exists
if [ $# -ne 1 ]; then
	echo -e "${RED}Error: Please provide the path to the .env file${NC}"
	echo "Usage: $0 path/to/.env"
	exit 1
fi

ENV_FILE=$1

if [ ! -f "$ENV_FILE" ]; then
	echo -e "${RED}Error: $ENV_FILE file not found${NC}"
	exit 1
fi

echo -e "${YELLOW}Checking environment variables...${NC}"

# Load environment variables
source $ENV_FILE

# Check required variables
REQUIRED_VARS=(
	"DOMAIN_NAME"
	"DB_NAME"
	"DB_USER"
	"WP_TITLE"
	"WP_ADMIN_USER"
	"WP_ADMIN_EMAIL"
	"WP_USER"
	"WP_USER_EMAIL"
)

MISSING_VARS=0

for VAR in "${REQUIRED_VARS[@]}"; do
	if [ -z "${!VAR}" ]; then
		echo -e "${RED}Error: $VAR is not set in the .env file${NC}"
		MISSING_VARS=1
	fi
done

if [ $MISSING_VARS -eq 1 ]; then
	echo -e "${RED}Please set all required environment variables in $ENV_FILE${NC}"
	exit 1
fi

# Check WordPress admin username requirements
ADMIN_USER_PATTERN="admin|Admin|administrator|Administrator"
if [[ "${WP_ADMIN_USER}" =~ $ADMIN_USER_PATTERN ]]; then
	echo -e "${RED}Error: WordPress admin username (${WP_ADMIN_USER}) contains forbidden terms: 'admin', 'Admin', 'administrator', or 'Administrator'${NC}"
	echo -e "${RED}Please choose a different admin username${NC}"
	exit 1
fi

echo -e "${GREEN}Environment validation successful!${NC}"
echo -e "${YELLOW}Starting Docker Compose...${NC}"
exit 0
