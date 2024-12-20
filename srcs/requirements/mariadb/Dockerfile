FROM debian:buster

RUN apt update -y
RUN apt upgrade -y
RUN apt install vim -y
RUN apt-get install mariadb-server -y
RUN apt-get install procps -y

COPY conf/fichier.cnf	/etc/mysql/mariadb.conf.d/fichier.cnf
COPY ./tools/init_mysql.sh /app/init_mysql.sh
RUN chmod +x /app/init_mysql.sh

EXPOSE 3306

ENTRYPOINT ["sh", "-c", "/app/init_mysql.sh"]
