#!/bin/bash
set -e

mkdir -p $TEAMCITY_DATA_PATH/lib/jdbc $TEAMCITY_DATA_PATH/config
if [ ! -f "$TEAMCITY_DATA_PATH/lib/jdbc/postgresql-9.3-1103.jdbc41.jar" ];
then
    echo "Downloading postgress JDBC driver..."
    wget -P $TEAMCITY_DATA_PATH/lib/jdbc http://jdbc.postgresql.org/download/postgresql-9.3-1103.jdbc41.jar
fi

ln -sf /usr/share/zoneinfo/Europe/Moscow /etc/localtime
git config --global http.sslVerify false

echo "Starting teamcity..."
exec /opt/TeamCity/bin/teamcity-server.sh run