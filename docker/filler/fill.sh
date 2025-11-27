#!/bin/bash

DB_HOST="db"
DB_USER="root"
DB_PASS="root"
DB_NAME="ServiceDB"
CSV_FILE="/app/data.csv"

# wait for DB
until mariadb -h"$DB_HOST" -u"$DB_USER" -p"$DB_PASS" -e "SELECT 1;" &>/dev/null; do
    sleep 2
done


# creating table
mariadb -h"$DB_HOST" -u"$DB_USER" -p"$DB_PASS" "$DB_NAME" <<EOF
DROP TABLE IF EXISTS data;
CREATE TABLE data (
    name VARCHAR(255),
    age INT
);
EOF

# filling database
mariadb -h"$DB_HOST" -u"$DB_USER" -p"$DB_PASS" --local-infile=1 "$DB_NAME" <<EOF
LOAD DATA LOCAL INFILE '$CSV_FILE'
INTO TABLE data
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(name, age);
EOF