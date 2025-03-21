NAME = inception
DOCKER_COMPOSE_FILE = srcs/docker-compose.yml
DATA_PATH = /home/$(USER)/data

CHECK_ENV_SCRIPT = srcs/requirements/tools/check_env.sh
ENV_FILE = srcs/.env

all: check setup build up

check:
	@chmod +x $(CHECK_ENV_SCRIPT)
	@./$(CHECK_ENV_SCRIPT) $(ENV_FILE)

setup:
	@mkdir -p $(DATA_PATH)/database
	@mkdir -p $(DATA_PATH)/website

build:
	@docker-compose -f $(DOCKER_COMPOSE_FILE) build

up:
	@docker-compose -f $(DOCKER_COMPOSE_FILE) up -d

down:
	@docker-compose -f $(DOCKER_COMPOSE_FILE) down

clean: down
	@docker system prune -a

fclean: clean
	@sudo rm -rf $(DATA_PATH)

re: fclean all

.PHONY: all check setup build up down clean fclean re