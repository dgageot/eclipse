#!/bin/bash

# In the real life, we dont rm the sources volume each time.
# But it makes the demo more reproductible.
#
SOURCES="${HOME}/src/lucy"
echo "Start a volume for the sources in [$SOURCES]"
docker rm -f jug >/dev/null 2>&1
docker run --name jug -v $SOURCES:/root/workspace busybox true

docker rm -f eclipse >/dev/null 2>&1
echo "Start sshd container"
docker run -d --volumes-from=jug -p 49154:22 -p 8080:8080 --name eclipse dgageot/eclipse

sleep 1

if [[ ! "${DOCKER_HOST}" =~ ^tcp://(.*):(.*)$ ]]; then
	echo "Invalid DOCKER_HOST env variable"
	exit
else
	DOCKER_IP=${BASH_REMATCH[1]}
fi

echo "ssh to launch eclipse"
ssh -o StrictHostKeyChecking=no \
		-o UserKnownHostsFile=/dev/null \
		-Y -X root@${DOCKER_IP} \
		-p 49154 \
		eclipse/eclipse -data workspace
