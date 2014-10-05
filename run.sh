#!/bin/bash

JUG=$(docker ps -q jug)
echo ${JUG}
if [ -z "${JUG}" ]; then
	docker run --name jug -v ${HOME}/src/lucy:/root/workspace busybox true
fi

ECLIPSE=$(docker ps -q eclipse)
if [ -z "${ECLIPSE}" ]; then
	docker run -d --volumes-from=jug -p 49154:22 -p 8080:8080 --name eclipse dgageot/eclipse
else
	docker restart eclipse
fi

DOCKER_IP=$(boot2docker ip 2> /dev/null)

ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -Y -X root@${DOCKER_IP} -p 49154 eclipse/eclipse -data workspace
