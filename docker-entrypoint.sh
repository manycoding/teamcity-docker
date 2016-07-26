#!/bin/bash
set -e

mkdir -p $TEAMCITY_DATA_PATH/lib/jdbc $TEAMCITY_DATA_PATH/config
if [ ! -f "$TEAMCITY_DATA_PATH/lib/jdbc/postgresql-9.4.1209.jar" ];
then
    echo "Downloading postgress JDBC driver..."
    wget -P $TEAMCITY_DATA_PATH/lib/jdbc https://jdbc.postgresql.org/download/postgresql-9.4.1209.jar
    # Remove possible old one when upgrading...
    rm -f $TEAMCITY_DATA_PATH/lib/jdbc/postgresql-9.3-1103.jdbc41.jar
fi

ln -sf /usr/share/zoneinfo/Europe/Moscow /etc/localtime
git config --global http.sslVerify false

# Install Agent Custom Token Authorize
wget -P $TEAMCITY_DATA_PATH/plugins https://teamcity.jetbrains.com/guestAuth/repository/download/TeamCityPluginsByJetBrains_AgentAutoAuthorize_90x/394696:id/agentMagicAuthorize.zip

export FIREFOX_AGENT=firefox_esr
export FIREFOX_CONTAINER=${FIREFOX_AGENT}_temp

echo -e "agent.authorize.tokens=gantry_crane:'VVyS!w@0cUXf*R!!UVvjPt9#abY7m#*M8vk$SLUGtPsHgH3aVi':1:0,$FIREFOX_AGENT:'kla^Q59hznR8AvT$ziY!Co3wVbH6mQqnfF9ywrnAP5$w&Rkkz@':1:0" > $TEAMCITY_DATA_PATH/config/internal.properties

echo -e "serverUrl=127.0.0.1:8111\nname=gantry_crane\nteamcity.magic.authorizationToken='VVyS!w@0cUXf*R!!UVvjPt9#abY7m#*M8vk$SLUGtPsHgH3aVi'" > /opt/TeamCity/buildAgent/conf/buildAgent.properties

docker rm $FIREFOX_CONTAINER
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -v /etc:/etc spotify/docker-gc
docker run -d --name=$FIREFOX_CONTAINER --link teamcity:teamcity --privileged -e TEAMCITY_SERVER=127.0.0.1:8111 -e AGENT_NAME=$FIREFOX_AGENT manycoding/teamcity-agent-robotframework:latest
docker stop $FIREFOX_CONTAINER

echo "Starting teamcity..."
exec /opt/TeamCity/bin/teamcity-server.sh run &

echo "Starting buildAgent..."
exec /opt/TeamCity/buildAgent/bin/agent.sh run