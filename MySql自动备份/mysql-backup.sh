#!/bin/bash
# Shell Script for MySQL dump and compress and push to git
# run as root
# created by cjj
# time : 2018-02-07
#### run script please edit following:
####     crontab setting( 22-26 line) 
####     backup location( 35 line)
####     mysql setting( 43-47 line)
####     git uri setting( 56 line)
####     compress format( 65 line)
####
#### then run  `sh mysql-backup.sh`


timestamp=$(date +%s)
timedate=$(date -d @${timestamp} "+%Y-%m-%d" )
DIR="$( cd "$( dirname "$0"  )" && pwd  )"


## set crontab time
minute="*"
hour="*"
day="*"
month="*"
week="*"

egrep "${DIR}/$0" /etc/crontab >& /dev/null
if [ $? -ne 0 ];then
    sed -i  '/'$0'/'d /etc/crontab
    echo "$minute $hour $day $month $week  mysqlbackup /bin/bash ${DIR}/$0" >> /etc/crontab
fi


## set backup location
backup_path="/root/backup"

if [ -z $backup_path ];then
    echo "Lack of bakcup path setting."
    exit 1
fi

## set mysql host, port, user, password, dbs, tables, logs
db_host="192.168.0.107"
db_port=3306
db_name="mysql"
db_user="root"
db_password="adminadmin"
table_name="user"
log_path="/root/mysql/2/mysql/log/mysqld.log"

if [[ -z $db_name || -z $db_user || -z $db_password || -z $table_name || -z $log_path ]];then
    echo "Lack of db related setting."
    exit 1
fi

## commit to git url
git_uri="git@gitlab.rd.175game.com:cjj0596/Test.git"
git_user="cjj0596"
git_email="cjj0596@175game.com"

if [ -z $git_uri ];then
    echo "Lack of git uri."
    exit 1
fi

## set compress format (only zip/tar/7z/rar)
compress_format="zip"

if [ -z $compress_format ];then
    echo "Lack of compress format (zip/tar/7z/rar)."
    exit 1
fi


## create user for backup mysql
group="mysqlbackup"
user="mysqlbackup"

## create group if not exists  
egrep "^$group" /etc/group >& /dev/null  
if [ $? -ne 0 ];then
    groupadd $group  
fi  
  
## create user if not exists  
egrep "^$user" /etc/passwd >& /dev/null  
if [ $? -ne 0 ];then
    useradd -g $group $user  
fi  


## set role of backup path
chown -R mysqlbackup:mysqlbackup $backup_path

## create dir base on timestamp and backup db/tables and log
mkdir -p ${backup_path}/${timedate}-${timestamp}/
mysqldump -h ${db_host} -P ${db_port} -u${db_user} -p${db_password} --databases ${db_name} --tables ${table_name} > ${backup_path}/${timedate}-${timestamp}/dump.sql
cp ${log_path} ${backup_path}/${timedate}-${timestamp}/

## chose one of compress format
if [[ "$compress_format" == "zip" ]];then
    if [ $(dpkg -l | grep -E 'zip' | wc -l) -eq 0 ];then
        apt-get install -y zip unzip
    fi
    ## compress
    cd ${backup_path}/${timedate}-${timestamp}
    zip -r ${timedate}-${timestamp}.zip ${backup_path}/${timedate}-${timestamp}
    
    ## test unzip
    zip -T ${timedate}-${timestamp}.zip
    if [ $? -eq 0 ];then
        echo "zip file is fine."
        compress_filename="${timedate}-${timestamp}.zip"
        #rm -rf ${backup_path}/${timedate}-${timestamp}
    fi

elif [[ "$compress_format" == "tar" ]];then
    if [ $(dpkg -l | grep -E 'tar' | wc -l) -eq 0 ];then
        apt-get install -y tar
    fi
    ## compress
    cd ${backup_path}/${timedate}-${timestamp}
    tar -zcf ${timedate}-${timestamp}.tar.gz ${backup_path}/${timedate}-${timestamp}
    
    ## test unzip
    tar -tf ${timedate}-${timestamp}.tar.gz
    if [ $? -eq 0 ];then
        echo "tar.gz file is fine."
        compress_filename="${timedate}-${timestamp}.tar.gz"
        #rm -rf ${backup_path}/${timedate}-${timestamp}
    fi

elif [[ "$compress_format" == "7z" ]];then
    if [ $(dpkg -l | grep -E '7zip' | wc -l) -eq 0 ];then
        apt-get install -y p7zip-full p7zip
    fi
    ## compress
    cd ${backup_path}/${timedate}-${timestamp}
    7z a -t7z -r ${timedate}-${timestamp}.7z  ${backup_path}/${timedate}-${timestamp}

    ## test unzip
    7z t ${timedate}-${timestamp}.7z
    if [ $? -eq 0 ];then
        echo "tar.gz file is fine."
        compress_filename="${timedate}-${timestamp}.7z"
        #rm -rf ${backup_path}/${timedate}-${timestamp}
    fi

elif [[ "$compress_format" == "rar" ]];then
    if [ $(dpkg -l | grep -E 'unrar' | wc -l) -eq 0 ];then
        apt-get install -y unrar rar
    fi
    ## compress
    cd ${backup_path}/${timedate}-${timestamp}
    rar a ${timedate}-${timestamp}.rar  ${backup_path}/${timedate}-${timestamp}

    ## test rar
    rar t ${timedate}-${timestamp}.rar
    if [ $? -eq 0 ];then
        echo "tar.gz file is fine."
        compress_filename="${timedate}-${timestamp}.rar"
        #rm -rf ${backup_path}/${timedate}-${timestamp}
    fi

else
    echo "Compress format error."
    exit 1
fi


## commit to setting git
cd ${backup_path}/${timedate}-${timestamp}
git config --global user.email "$git_email"
git config --global user.name "$git_user"

git init
git add ${compress_filename}
git commit -m "commit backup $timestamp"
git branch $timestamp
git checkout $timestamp
git remote add origin $git_uri
git push origin $timestamp


