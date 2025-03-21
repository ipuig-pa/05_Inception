FROM debian:bullseye

RUN apt-get update && apt-get install -y\
    mariadb-server \
    gettext-base

COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

RUN mkdir -p /run/mysqld && chown mysql:mysql /run/mysqld

COPY ./tools/init_db.sh /usr/local/bin
RUN chmod +x /usr/local/bin/init_db.sh
COPY ./tools/init.sql /usr/local/bin

EXPOSE 3306

ENTRYPOINT ["init_db.sh"]
