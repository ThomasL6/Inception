LOGIN = thlefebv
DOMAIN = ${LOGIN}.42.fr
DATA_PATH = /home/${LOGIN}/data
# create env to use it in docker-compose
ENV = LOGIN=${LOGIN} DATA_PATH=${DATA_PATH} DOMAIN=${LOGIN}.42.fr

#commands of docker
all: up

up: setup
	${ENV} docker compose -f ./srcs/docker-compose.yml up -d --build

down:
	${ENV} docker compose -f ./srcs/docker-compose.yml down

start:
	${ENV} docker compose -f ./srcs/docker-compose.yml start

stop:
	${ENV} docker compose -f ./srcs/docker-compose.yml stop

status:
	cd srcs && docker compose ps && cd ..

logs:
	cd srcs && docker compose logs && cd ..

#to verify if the domain exist and to access 
script:
	if ! grep -q "$(DOMAIN)" "/etc/hosts"; then \
		echo "127.0.0.1 $(DOMAIN)" | sudo tee -a /etc/hosts; \
	fi 

setup: script
		sudo mkdir -p /home/${LOGIN}/
		sudo mkdir -p ${DATA_PATH}
		sudo mkdir -p ${DATA_PATH}/mariadb-data
		sudo mkdir -p ${DATA_PATH}/wordpress-data

clean: down
		sudo rm -rf ${DATA_PATH}
	
fclean: clean
		docker system prune	-f -a --volumes 

