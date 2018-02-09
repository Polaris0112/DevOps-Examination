#!/bin/bash
# shell script for building mysql 5.x lastest mirror and run mysql service
# run as root
# created by cjj
# time : 2018-02-07

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


mirror_name="dev-ops/mysql-custom"

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

## into dir where to build custom mirror
cd ${DIR}/0/
docker build -t ${mirror_name}:5.7 .

if [[ $(docker images |grep -E "${mirror_name}"|wc -l) -eq 1 ]];then
  echo "Build image complete."
  cd ${DIR}/2/mysql/
  sed -i 's#^.*image:.*$#  image:  '${mirror_name}':5.7#g' ${DIR}/2/mysql/docker-compose.yml
  ## whether file and directory is exists
  if [[ -d "docker-compose.yml" || -d "rancher-compose.yml" ]];then
    echo "Missing file docker-compose.yml or rancher-compose.yml."
    exit 1
  fi

  if [[ -d "${DIR}/2/mysql/data/" || -d "${DIR}/2/mysql/log/" || -d "${DIR}/2/mysql/my.conf" ]];then
    mkdir -p ${DIR}/2/mysql/data
    mkdir -p ${DIR}/2/mysql/log
    echo "[mysqld]
datadir=/var/lib/mysql
socket=/var/lib/mysql/mysql.sock
# Disabling symbolic-links is recommended to prevent assorted security risks
symbolic-links=0
# Settings user and group are ignored when systemd is used.
# If you need to run mysqld under a different user or group,
# customize your systemd unit file for mariadb according to the
# instructions in http://fedoraproject.org/wiki/Systemd

[mysqld_safe]
log-error=/var/log/mysql/mysqld.log
pid-file=/var/run/mysql/mysql.pid

" > ${DIR}/2/mysql/my.cnf
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
  
  echo "Build mysql service done."

else
  echo "Build failed."

fi
