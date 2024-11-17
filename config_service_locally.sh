#!/bin/bash

# Install the latest PostgreSQL packages
sudo apt install gnupg postgresql-common apt-transport-https lsb-release wget
# Run the PostgreSQL package setup script
sudo /usr/share/postgresql-common/pgdg/apt.postgresql.org.sh
# Add the TimescaleDB package
echo "deb https://packagecloud.io/timescale/timescaledb/ubuntu/ $(lsb_release -c -s) main" | sudo tee /etc/apt/sources.list.d/timescaledb.list
# Install the TimescaleDB GPG key
wget --quiet -O - https://packagecloud.io/timescale/timescaledb/gpgkey | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/timescaledb.gpg
sudo apt update
# Install TimescaleDB
sudo apt install timescaledb-2-postgresql-16 postgresql-client-16
# Tune your PostgreSQL instance for TimescaleDB
sudo timescaledb-tune
# Restart PostgreSQL
sudo systemctl restart postgresql
# log in to the PostgreSQL instance
sudo -u postgres psql
\password postgres
# create a new database
CREATE DATABASE rates;
# connect to the new database
\c rates
# Add the TimescaleDB extension to your database
CREATE EXTENSION IF NOT EXISTS timescaledb;
# Check that TimescaleDB is installed
SELECT * FROM pg_extension WHERE extname = 'timescaledb';
# or \dx
