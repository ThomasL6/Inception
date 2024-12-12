FROM	alpine:3.19

#DL mariadb client and server
RUN	apk update && apk upgrade &&\
	apk add mariadb mariadb-client

#Copy config in a tmp container 
COPY ./conf/configure-mariadb.sh /tmp/configure-mariadb.sh

RUN	chmod +x /tmp/configure-mariadb.sh

#To run the config script when the container starts
ENTRYPOINT	[ "sh", "/tmp/configure-mariadb.sh" ]