FROM mdillon/postgis

WORKDIR /linkedevents
COPY ./schema.pgsql schema.pgsql
COPY ./create-schema.sh /docker-entrypoint-initdb.d/

