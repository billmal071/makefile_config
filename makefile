.PHONY: mongo postgres pg13 sonarqube sonarscanner rabbitmq

mongo:
	docker run --name mongodb -v mongodb-volume:/data/db -p 27017:27017 -d mongo:latest

postgres:
	docker run -d \
		-v pgdata:/var/lib/postgresql/data -p 5432:5432 \
		--name postgresdb -e POSTGRES_PASSWORD=password postgres:14-alpine

pg13:
	docker run -d \
	-e pgdata=/var/lib/postgresql/data \
	-v /home/williams/data:/var/lib/postgresql/data \
	-p 5432:5432 \
	--name postgresdb \
	-e POSTGRES_PASSWORD=password postgres:13-alpine

sonarqube:
	docker run --rm -d --name sonarqube \
		-e SONAR_ES_BOOTSTRAP_CHECKS_DISABLE=true \
		-p 9000:9000 \
		sonarqube:8.9-community

sonarscanner:
	docker run \
    		--rm \
    		-e SONAR_HOST_URL="http://localhost:9000" \
    		-e SONAR_LOGIN="09d15c43fc90bcd09d9b83994c18b209784a10c9" \
    		-v "$(pwd):/usr/src" \
    		sonarsource/sonar-scanner-cli

sonarqube1: docker-compose.sonarqube.yaml
	docker-compose -f docker-compose.sonarqube.yaml up

ml-kubeapp: 
	docker run --rm -it -d --name ml-kube-app -p 8001:80 godofshinobi/ml-app

redis-server:
	docker run --rm -it -d --name redis redis:7.0.5-alpine \
		redis-server --save 60 1 --loglevel warning -p 6379:6379

mssql:
	docker run -d --rm -it -e "ACCEPT_EULA=Y" \
		-e "MSSQL_SA_PASSWORD=Rocket14#" \
   		-p 1433:1433 --name sql1 --hostname sql1 \
   		mcr.microsoft.com/mssql/server:2022-latest

mysql-db:
	docker run -d -it --name mysqldb \
		-v mysql-data:/var/lib/mysql \
		-e MYSQL_ROOT_PASSWORD=password123 \
		-p 3306:3306 \
		mysql:oracle

redis-stack:
	docker run -it --rm -d --name redis-stack-server -v redis-vol:/data -p 6379:6379 redis/redis-stack-server:latest

rabbitmq:
	docker run -it -d --name rabbitmq -p 5672:5672 -p 15672:15672 rabbitmq:management
