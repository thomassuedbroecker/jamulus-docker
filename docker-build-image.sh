#!/bin/bash

export MYIMAGENAME="tsuedbroecker/jamulusmusic"
export MYTAG="v1"
export CONTAINERNAME="music"

docker build -t "$MYIMAGENAME":"$MYTAG" .
docker run -it --name "$CONTAINERNAME" "$MYIMAGENAME":"$MYTAG"
docker push "$MYIMAGENAME":"$MYTAG"


