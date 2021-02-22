# Deploy server to IBM Cloud as Cloud Foundry app

For more details please visit this blog post: [RUN A DOCKER IMAGE AS A CLOUD FOUNDRY APP ON IBM CLOUD](https://suedbroecker.net/2020/05/06/run-docker-image-as-a-cloud-foundry-app-on-ibm-cloud/)


* Additional sources

* https://sourceforge.net/p/llcon/discussion/server/thread/d0f1b09524/?limit=25

### Step 1: Set your variables

```sh
export APPLICATIONNAME="music"
export IMAGENAME="tsuedbroecker/jamulusmusic"
export IMAGETAG="v1"
export PORT="22124"
export HOSTNAME="music-tsuedbroecker"
```

### Step 2: Set target

```sh
ibmcloud target --cf-api api.eu-de.cf.cloud.ibm.com -o thomas.suedbroecker -s dev -g Default
```

### Step 3: Push Dockerimage

```sh
ibmcloud cf push $APPLICATIONNAME --docker-image="$IMAGENAME":"$IMAGETAG" --no-start --no-route
```

### Step 4: Get GUID

```sh
A_GUID=$(ibmcloud cf app $APPLICATIONNAME --guid|awk '/[0-9]/{print $1}') 
echo $A_GUID
```

### Step 5: Set port to GUID

```sh
ibmcloud cf curl /v2/apps/$A_GUID -X PUT -d '{"ports": [22124]}'
```

### Step 6: Create route

```sh
ibmcloud cf create-route dev eu-de.mybluemix.net --hostname $HOSTNAME
```

### Step 7: Map route

```sh
ibmcloud cf map-route $APPLICATIONNAME eu-de.mybluemix.net --hostname $HOSTNAME
```

### Step 8: Map route

```sh
R_GUID=$(ibmcloud cf curl "/v2/routes?q=host:$HOSTNAME" | sed -n 's|.*"guid": "\([^"]*\)".*|\1|p') 
echo $R_GUID
```

### Step 9: Map route

```sh
ibmcloud cf curl /v2/route_mappings -X POST -d '{"app_guid": "'"$A_GUID"'", "route_guid": "'"$R_GUID"'", "app_port": 22124}'
```

### Step 9: Start application

```sh
ibmcloud cf start $APPLICATIONNAME
```