# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: thlefebv <thlefebv@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2024/12/17 11:39:00 by thlefebv          #+#    #+#              #
#    Updated: 2024/12/17 16:28:42 by thlefebv         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

all:	build
	sudo mkdir -p /home/thlefebv/data
	sudo mkdir -p /home/thlefebv/data/wordpress
	sudo mkdir -p /home/thlefebv/data/database
	sudo mkdir -p /home/thlefebv/data/mariadb
	sudo chmod 777 /etc/hosts
	sudo chmod 777 /home
	sudo sh -c echo "127.0.0.1 thlefebv.42.fr" >> /etc/hosts
	sudo sh -c echo "127.0.0.1 www.thlefebv.42.fr" >> /etc/hosts
	cd srcs/ && sudo docker compose up -d

build:
	cd srcs/ && sudo docker compose build

stop: 
	sudo docker compose -f srcs/docker-compose.yml stop

clean:
	sudo docker compose -f srcs/docker-compose.yml down -v

fclean:
	$(stop)
	$(clean)
	sudo docker system prune --force --volumes --all 
	sudo rm -rf ~/data

verif:
	sudo docker system df

re: stop fclean all
	
.PHONY: build stop clean fclean re all verif
