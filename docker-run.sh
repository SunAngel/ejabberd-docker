#!/bin/sh
#Run seafile docker container with host folder as a volume

#Default volume path on host.
VOLUME_PATH="/home/docker/ejabberd"
#Container hostname
CONTAINER_HOSTNAME="ejabberd.domain.com"
#Container name
CONTAINER_NAME="ejabberd"
#Restart policy
RESTART_POLICY="unless-stopped"
#Some extra arguments. Like -d ant -ti
EXTRA_ARGS="-d -ti"
#docker command. You can use "sudo docker" if you need so
DOCKER="docker"
#Extra args to docker command. Like using remote dockerd or something else
DOCKER_ARGS=""

#You can change default values by adding them to config file
CONFIG_FILE="~/.docker-sunx-ejabberd"
[ -f "$CONFIG_FILE" ] && . $CONFIG_FILE

[ ! -z "$CONTAINER_HOSTNAME" ] && CONTAINER_HOSTNAME="--hostname=$CONTAINER_HOSTNAME"
[ ! -z "$CONTAINER_NAME" ]     && CONTAINER_NAME="--name=$CONTAINER_NAME"
[ ! -z "$RESTART_POLICY" ]     && RESTART_POLICY="--restart=$RESTART_POLICY"

$DOCKER $DOCKER_ARGS run \
	-v $VOLUME_PATH:/home/ejabberd \
	-p 58334:58334 -p 5280:5280 \
	-p 127.0.0.1:7777:7777 -p 5222:5222 \
	-p 5223:5223 -p 5288:5288 \
	-p 4369:4369 -p 5300:5300 \
	-p 5269:5269 \
	$CONTAINER_HOSTNAME \
	$CONTAINER_NAME \
	$RESTART_POLICY \
	$EXTRA_ARGS \
	sunx/ejabberd
