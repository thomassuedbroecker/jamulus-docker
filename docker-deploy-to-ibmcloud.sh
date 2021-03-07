#!/bin/bash

export APPLICATIONNAME="music"
export IMAGENAME="tsuedbroecker/jamulusmusic"
export IMAGETAG="v2"
export PORT="22124"
export HOSTNAME="musictsuedbroecker"

ibmcloud login
ibmcloud cf install -f
ibmcloud target --cf-api api.eu-de.cf.cloud.ibm.com
ibmcloud target -o thomas.suedbroecker -s dev -g Default
ibmcloud cf push $APPLICATIONNAME --docker-image="$IMAGENAME":"$IMAGETAG" --no-start --no-route
A_GUID=$(ibmcloud cf app $APPLICATIONNAME --guid|awk '/[0-9]/{print $1}') 
echo $A_GUID
ibmcloud cf curl /v2/apps/$A_GUID -X PUT -d '{"ports": [22124]}'
ibmcloud cf create-route dev eu-de.mybluemix.net --hostname $HOSTNAME
ibmcloud cf map-route $APPLICATIONNAME eu-de.mybluemix.net --hostname $HOSTNAME
R_GUID=$(ibmcloud cf curl "/v2/routes?q=host:$HOSTNAME" | sed -n 's|.*"guid": "\([^"]*\)".*|\1|p') 
echo $R_GUID
ibmcloud cf curl /v2/route_mappings -X POST -d '{"app_guid": "'"$A_GUID"'", "route_guid": "'"$R_GUID"'", "app_port": 22124}'
ibmcloud cf start $APPLICATIONNAME