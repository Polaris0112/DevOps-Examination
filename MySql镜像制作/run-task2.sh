#!/bin/bash

host=$1
port=$2
user=$3
password=$4

if [[ -z $1 || -z $2 || -z $3 || -z $4 ]];then
    echo "Lack of params."
    exit 1
fi


if [ $(dpkg -l | grep -E 'mysql-client' | wc -l) -eq 0 ];then
    apt-get update -y
    apt-get install -y  mysql-client
fi


mysql -h $host -P $port -u $user -p$password -e "select Host,User,authentication_string from mysql.user limit 1;"

if [ $? -eq 0 ];then
  echo "Mysql Server is running..."
fi
