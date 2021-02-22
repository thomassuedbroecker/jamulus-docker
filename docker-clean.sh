#!/bin/bash

docker ps --all
docker rm $(docker ps -a -q)
docker kill $(docker ps -a -q)
docker image list
docker image prune -a -f