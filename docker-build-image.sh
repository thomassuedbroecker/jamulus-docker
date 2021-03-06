#!/bin/bash

export MYIMAGENAME="tsuedbroecker/jamulusmusic"
export MYTAG="v2"
export CONTAINERNAME="music"
export DOCKER_USER=
export DOCKER_PASSWORD=

docker login -u "$DOCKER_USER" -p "$DOCKER_PASSWORD"
docker build -t "$MYIMAGENAME":"$MYTAG" .
docker run -it --name "$CONTAINERNAME" "$MYIMAGENAME":"$MYTAG"
docker push "$MYIMAGENAME":"$MYTAG"


