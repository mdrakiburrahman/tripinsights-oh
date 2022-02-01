docker network create openhack

# 1. Run SQL Server
docker run -d --network openhack \
    -e 'SA_PASSWORD=P@ssword!' \
    -e 'ACCEPT_EULA=Y' \
    --name 'mydrivingDB' \
    -h 'mydrivingDB' \
    -p 11433:1433 \
    mcr.microsoft.com/mssql/server:2017-latest

# Create Database
docker exec 'mydrivingDB' /opt/mssql-tools/bin/sqlcmd \
-S mydrivingDB -U sa -P 'P@ssword!' -Q "CREATE DATABASE mydrivingDB"

# 2. Data loader
docker login registryvpc6526.azurecr.io \
    --username 'registryvpc6526' \
    --password 'EjRsY4ae2lQM+mmXpqlIEcY6beV3oOd5'

# Pull image
docker pull registryvpc6526.azurecr.io/dataload:1.0

# Run data loader
docker run --network openhack \
    -e SQLFQDN='mydrivingDB' \
    -e SQLUSER='sa' \
    -e SQLPASS='P@ssword!' \
    -e SQLDB='mydrivingDB' \
    registryvpc6526.azurecr.io/dataload:1.0

# 3. Build images
# Image 1: POI App
# Dockerfile: Dockerfile_3
cd ../src/poi
docker build -f Dockerfile_3 -t "tripinsights/poi:1.0" .

SQL_PASSWORD='P@ssword!'
SQL_SERVER='mydrivingDB'

docker run -d \
    --network openhack \
    -p 8080:80 \
    --name poi \
    -e "SQL_SERVER=$SQL_SERVER" \
    -e "SQL_PASSWORD=$SQL_PASSWORD" \
    -e "ASPNETCORE_ENVIRONMENT=Local" \
    -e "SQL_USER=sa" \
    tripinsights/poi:1.0

# Inside container, run:
# curl -i -X GET 'http://localhost:80/api/poi'

# Image 2: Trips
# Dockerfile: Dockerfile_4
cd ../trips
docker build -f Dockerfile_4 -t "tripinsights/trips:1.0" .

# Image 3: Tripviewer
# Dockerfile: Dockerfile_1
cd ../tripviewer
docker build -f Dockerfile_1 -t "tripinsights/tripviewer:1.0" .

# Image 4: User-java
# Dockerfile: Dockerfile_0
cd ../user-java
docker build -f Dockerfile_0 -t "tripinsights/user-java:1.0" .

# Image 5: Userprofile
# Dockerfile: Dockerfile_2
cd ../userprofile
docker build -f Dockerfile_2 -t "tripinsights/userprofile:1.0" .

# 4. Login to ACR
az login -u '...' -p '...'
az acr login --name registryvpc6526

# 5. Push to ACR
# Trips
docker tag tripinsights/trips:1.0 registryvpc6526.azurecr.io/tripinsights/trips:1.0
docker push registryvpc6526.azurecr.io/tripinsights/trips:1.0

# Repeat push for other images