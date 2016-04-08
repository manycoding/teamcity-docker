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

# Install Agent Custom Token Authorize
wget -P $TEAMCITY_DATA_PATH/plugins https://teamcity.jetbrains.com/guestAuth/repository/download/TeamCityPluginsByJetBrains_AgentAutoAuthorize_90x/394696:id/agentMagicAuthorize.zip

echo -e "agent.authorize.tokens=gantry_crane:'VVyS!w@0cUXf*R!!UVvjPt9#abY7m#*M8vk$SLUGtPsHgH3aVi':1:0,firefox_esr:'kla^Q59hznR8AvT$ziY!Co3wVbH6mQqnfF9ywrnAP5$w&Rkkz@'1:1:1" > $TEAMCITY_DATA_PATH/config/internal.properties

echo -e "serverUrl=127.0.0.1:8111\nname=gantry_crane\nteamcity.magic.authorizationToken='VVyS!w@0cUXf*R!!UVvjPt9#abY7m#*M8vk$SLUGtPsHgH3aVi'" > /opt/TeamCity/buildAgent/conf/buildAgent.properties

echo "Starting teamcity..."
exec /opt/TeamCity/bin/teamcity-server.sh run

echo "Starting buildAgent..."
exec /opt/TeamCity/buildAgent/bin/agent.sh run &