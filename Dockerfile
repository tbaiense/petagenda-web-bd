# syntax=docker/dockerfile:1

FROM mysql:9.3.0

ENV MYSQL_ROOT_PASSWORD="PetAgenda_Root"
ENV MYSQL_USER="petagenda"
ENV MYSQL_PASSWORD="PetAgenda_DB_w35J"

WORKDIR /docker-entrypoint-initdb.d

COPY sql/dbo/dbo_schema.sql .
COPY config/grant_all.sh .

WORKDIR /etc/mysql/conf.d

COPY config/config-file.cnf .

