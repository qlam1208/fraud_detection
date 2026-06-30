#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
    CREATE USER mlflow WITH PASSWORD 'mlflow';
    CREATE DATABASE mlflow;
    ALTER DATABASE mlflow OWNER TO mlflow;
EOSQL
