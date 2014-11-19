#!/bin/bash

# In the real life, we should start a volume container
# But it makes the demo more reproductible.
#
SOURCES="${HOME}/src/lucy"
echo "Start sshd container"
docker rm -f eclipse >/dev/null 2>&1
docker run -d -v $SOURCES:/root/workspace -v $HOME/.m2:/root/.m2 -p 49154:22 -p 8080:8080 --name eclipse dgageot/eclipse

sleep 1

if [[ ! "${DOCKER_HOST}" =~ ^tcp://(.*):(.*)$ ]]; then
	echo "Invalid DOCKER_HOST env variable"
	exit
else
	DOCKER_IP=${BASH_REMATCH[1]}
fi

echo "Ssh the container to launch Eclipse"
ssh -o StrictHostKeyChecking=no \
		-o UserKnownHostsFile=/dev/null \
		-Y -X root@${DOCKER_IP} \
		-p 49154 \
		eclipse/eclipse -data workspace
