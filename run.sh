#!/bin/bash


if [ -z "$(docker ps -aq jug)" ]; then
	SOURCES="${HOME}/src/lucy"

	echo "Start a volume for the sources in [$SOURCES]"
	docker run --name jug -v $SOURCES:/root/workspace busybox true
fi

if [ -z "$(docker ps -q eclipse)" ]; then
	docker run -d --volumes-from=jug -p 49154:22 -p 8080:8080 --name eclipse dgageot/eclipse
else
	docker restart eclipse
fi

sleep 1

if [[ ! "${DOCKER_HOST}" =~ ^tcp://(.*):(.*)$ ]]; then
	echo "Invalid DOCKER_HOST env variable"
	exit
else
	DOCKER_IP=${BASH_REMATCH[1]}
fi

ssh -o StrictHostKeyChecking=no \
		-o UserKnownHostsFile=/dev/null \
		-Y -X root@${DOCKER_IP} \
		-p 49154 \
		eclipse/eclipse -data workspace
