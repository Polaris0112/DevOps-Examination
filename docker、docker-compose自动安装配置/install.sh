#!/bin/bash
# shell script for installing docker and docker-compose
# run as root
# created by cjj
# time : 2018-02-04
# just run `sh install.sh`  then install docker and docker-compose automatically

set -e

install_docker()
{
  # begin install docker
  echo "Begin install docker..."

  # if exists, then remove old version
  if [ $(dpkg -l | grep -E 'docker|docker-engine|docker.io' | wc -l) -ne 0 ];then
      umount /var/lib/docker/plugins
      rm -rf /var/lib/docker
      apt-get remove -y docker-ce docker docker-engine docker.io
      apt autoremove -y
  fi

  # refresh repo
  apt-get update -y
  apt-get install -y apt-transport-https ca-certificates curl software-properties-common

  # get apt-key
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
  
  # add repo
  add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
  apt-get update -y
  apt-cache policy docker-engine
  apt-get upgrade -y
   
  # install docker-ce
  apt-get install -y docker-ce
  
  # set docker service auto start
  systemctl enable docker
  systemctl start docker

  # for cn user change mirror
  echo '{
    "registry-mirrors":["https://docker.mirrors.ustc.edu.cn"]
}
' > /etc/docker/daemon.json
  systemctl daemon-reload
  systemctl restart docker


  # print result
  echo "Install docker done."
}


install_docker_compose() 
{
  # print beginning
  echo "Begin install docker-compose..."

  # download docker-compose
  curl -L https://github.com/docker/compose/releases/download/1.18.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
  
  # change mod
  chmod +x /usr/local/bin/docker-compose

  # print result
  echo "Install docker-compose done."
}


install_docker
install_docker_compose


