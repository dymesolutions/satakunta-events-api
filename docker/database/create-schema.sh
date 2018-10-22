#!/bin/bash

echo "Creating schema..."
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "linkedevents" < /linkedevents/schema.pgsql
