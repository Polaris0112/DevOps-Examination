#!/bin/bash
# shell script for installing lastest nginx mirror and run rancher to apply nginx service
# run as root
# created by cjj
# time : 2018-02-06

set -e

DIR="$( cd "$( dirname "$0"  )" && pwd  )"
##### if use enviroment key, please add it into ~/.profile as the format as below
##### export RANCHER_URL=http://server_ip:8080/
##### export RANCHER_ACCESS_KEY=<username_of_environment_api_key>
##### export RANCHER_SECRET_KEY=<password_of_environment_api_key> 
source ~/.profile

##### if use rancher CLI to run rancher-compose, please config below params
url=""
accesskey=""
secretkey=""
###########################################################################


## download lastest nginx mirror
#docker pull nginx

## whether params is exists

if [[ -z $RANCHER_URL && -z $url ]];then
  echo "Lack of rancher_url."
  exit 1
fi

if [[ -z $RANCHER_ACCESS_KEY && -z $accesskey ]];then
  echo "Lack of rancher_accesskey."
  exit 1
fi

if [[ -z $RANCHER_SECRET_KEY && -z $secretkey ]];then
  echo "Lack of rancher_secretkey."
  exit 1
fi
    

## whether file and directory is exists
if [[ -d "docker-compose.yml" || -d "rancher-compose.yml" ]];then
  echo "Missing file docker-compose.yml or rancher-compose.yml."
  exit 1
fi

if [[ -d "${DIR}/www/" || -d "${DIR}/conf.d/" || -d "${DIR}/log/" ]];then
  mkdir -p ${DIR}/www
  mkdir -p ${DIR}/conf.d
  mkdir -p ${DIR}/log
fi


## run with rancher-CLI
if [[ $url && $accesskey && $secretkey ]];then
  rancher --url $url --access-key $accesskey --secret-key $secretkey up -d
elif [[ $RANCHER_URL && $RANCHER_ACCESS_KEY && $RANCHER_SECRET_KEY ]];then
  rancher-compose up -d
else
  echo "Params error, maybe lack of some params. Exiting..."
  exit 1
fi
  
echo "Build nginx service done."


