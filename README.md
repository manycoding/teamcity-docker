JetBrains TeamCity docker image
===============
[![](https://badge.imagelayers.io/manycoding/teamcity:latest.svg)](https://imagelayers.io/?images=manycoding/teamcity:latest 'Get your own badge on imagelayers.io')

Distributed Build Management and Continuous Integration Server

This image contains a buildAgent which is capable of running other containers (by sharing docker.sock with a host machine). The included buildAgent is automatically authorized upon its start by Agent Custom Token Authorize plugin.

Each TeamCity installation runs under a Professional Server license including 3 build agents. This license is provided for free with any downloaded TeamCity binary and gives you full access to all product features with no time limit. The only restriction is a maximum of 20 build configurations.

By pulling this image you accept the [JetBrains license agreement for TeamCity (Commercial License)] (https://www.jetbrains.com/teamcity/buy/license.html)

The image also can use (optionally) an external postgress database instead of the internal database of teamcity. (recommended for production usage)

How to use this image with postgres?
---------------

```
POSTGRES_PASSWORD=mysecretpassword
SETUP_TEAMCITY_SQL="create role teamcity with login password 'teamcity';create database teamcity owner teamcity;"

# Start an official docker postgres instance
docker run --name postgres_teamcity -e POSTGRES_PASSWORD=$POSTGRES_PASSWORD -d postgres
# Create the database using psql
docker run -it --link postgres_teamcity:postgres --rm -e "SETUP_TEAMCITY_SQL=$SETUP_TEAMCITY_SQL" -e "PGPASSWORD=$POSTGRES_PASSWORD" postgres bash -c 'exec echo $SETUP_TEAMCITY_SQL |psql -h "$POSTGRES_PORT_5432_TCP_ADDR" -p "$POSTGRES_PORT_5432_TCP_PORT" -U postgres'
```
Then you can start the teamcity image, linked to the postgres image
```
docker run --name teamcity --privileged --link postgres_teamcity:postgres -v /home/toaster/Data/teamcity:/var/lib/teamcity -v /var/run/docker.sock:/var/run/docker.sock -p 8111:8111 manycoding/teamcity:latest
```
At the installation screen of teamcity as host for postgress you can specify `postgres`

How to upgrade to a new version?
----------------
1. `docker pull manycoding/teamcity:latest`
2. `docker stop teamcity && docker rename teamcity teamcity_old`
3. `docker run --name teamcity --privileged --link postgres_teamcity:postgres -v /home/toaster/Data/teamcity:/var/lib/teamcity -v /var/run/docker.sock:/var/run/docker.sock -p 8111:8111 manycoding/teamcity:latest`
