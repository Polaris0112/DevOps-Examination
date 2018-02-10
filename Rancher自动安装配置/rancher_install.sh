#!/bin/bash
# install Rancher Compose and Rancher CLI
# run as root
# created by cjj
# time : 2018-02-04 
# run example : `sh rancher_install.sh`

set -e

download_rancher()
{
  echo "Begin to pull rancher mirror."

  # pull rancher/server:stable mirror
  docker pull rancher/server:stable
  docker pull rancher/healthcheck:v0.3.3
  docker pull rancher/net:v0.13.7
  docker pull rancher/net:holder
  docker pull rancher/metadata:v0.9.5
  docker pull rancher/network-manager:v0.7.19
  docker pull rancher/scheduler:v0.8.3

  echo "Pull mirror done."
}


download_rancher_compose()
{
  echo "Begin to download rancher-compose."

  apt-get install wget
  # check if exists
  if [ -e './rancher-compose-linux-amd64-v0.12.5.tar.gz' ];then
    tar zxf rancher-compose-linux-amd64-v0.12.5.tar.gz
  else
    wget https://releases.rancher.com/compose/v0.12.5/rancher-compose-linux-amd64-v0.12.5.tar.gz
  fi

  # extract tar
  tar zxf rancher-compose-linux-amd64-v0.12.5.tar.gz

  # mv rancher-compose to /usr/local/bin
  mv ./rancher-compose-v0.12.5/rancher-compose  /usr/local/bin/rancher-compose
 
  # remove file
  rm -rf rancher-compose-linux-amd64-v0.12.5.tar.gz rancher-compose-v0.12.5

  echo "Install rancher-compose done."
}


download_rancher_cli()
{
  echo "Begin to download rancher-CLI."

  apt-get install wget
  # check if exists
  if [ -e './rancher-linux-amd64-v0.6.7.tar.gz' ];then
    tar zxf rancher-linux-amd64-v0.6.7.tar.gz
  else
    wget https://releases.rancher.com/cli/v0.6.7/rancher-linux-amd64-v0.6.7.tar.gz
  fi

  # extract tar
  tar zxf rancher-linux-amd64-v0.6.7.tar.gz

  # mv rancher-compose to /usr/local/bin
  mv ./rancher-v0.6.7/rancher  /usr/local/bin/rancher
  
  # remove files
  rm -rf rancher-linux-amd64-v0.6.7.tar.gz rancher-v0.6.7

  echo "Install rancher-cli done."
}

download_rancher
download_rancher_compose
download_rancher_cli

# start up rancher by docker-compose
/usr/local/bin/docker-compose up -d
