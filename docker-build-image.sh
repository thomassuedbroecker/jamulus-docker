#!/bin/bash

export MYIMAGENAME="tsuedbroecker/jamulusmusic"
export MYTAG="v2"
export CONTAINERNAME="music"
export DOCKER_USER=tsuedbroecker
export DOCKER_PASSWORD=1qaY.xsw2

docker login -u "$DOCKER_USER" -p "$DOCKER_PASSWORD"
docker build -t "$MYIMAGENAME":"$MYTAG" .
docker run -it --name "$CONTAINERNAME" "$MYIMAGENAME":"$MYTAG"
docker push "$MYIMAGENAME":"$MYTAG"
# docker rm $(docker ps -a -q)
# docker kill $(docker ps -a -q)


