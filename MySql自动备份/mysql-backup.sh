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
backup_path=""

if [ -z $backup_path ];then
    echo "Lack of bakcup path setting."
    exit 1
fi

## set mysql user, password, dbs, tables, logs
db_name=""
db_user=""
db_password=""
table_name=""
log_path=""

if [[ -z $db_name || -z $db_user || -z $db_password || -z $table_name || -z $log_path]];then
    echo "Lack of db related setting."
    exit 1
fi


## commit to git url
git_uri=""

if [ -z $git_url ];then
    echo "Lack of git url."
    exit 1
fi


## set compress format (only zip/tar/7z/rar)
compress_format=""

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


## set role of logpath
chown -R mysqlbackup:mysqlbackup $backup_path

## create dir base on timestamp and backup db/tables and log
mkdir -p ${logpath}/${timedate}-${timestamp}
mysqldump -u${db_user} -p${db_password} --databases ${db_name} --tables ${table_name} > ${logpath}/${timedate}-${timestamp}
cp ${log_path} ${logpath}/${timedate}-${timestamp}

## chose one of compress format
if [[ "$compress_format" == "zip" ]];then
    if [ $(dpkg -l | grep -E 'zip' | wc -l) -eq 0 ];then
        apt-get install -y zip unzip
    fi
    ## compress
    cd ${logpath}
    zip -r ${timedate}-${timestamp}.zip ${timedate}-${timestamp}
    
    ## test unzip
    zip -T ${timedate}-${timestamp}.zip
    if [ $? -eq 0 ];then
        echo "zip file is fine."
        compress_filename="${timedate}-${timestamp}.zip"
        rm -rf ${log_path} ${logpath}/${timedate}-${timestamp}
    fi

elif [[ "$compress_format" == "tar" ]];
    if [ $(dpkg -l | grep -E 'tar' | wc -l) -eq 0 ];then
        apt-get install -y tar
    fi
    ## compress
    cd ${logpath}
    tar -zcf ${timedate}-${timestamp}.tar.gz ${timedate}-${timestamp}
    
    ## test unzip
    tar -jtf ${timedate}-${timestamp}.tar.gz
    if [ $? -eq 0 ];then
        echo "tar.gz file is fine."
        compress_filename="${timedate}-${timestamp}.tar.gz"
        rm -rf ${log_path} ${logpath}/${timedate}-${timestamp}
    fi

elif [[ "$compress_format" == "7z" ]];
    if [ $(dpkg -l | grep -E '7zip' | wc -l) -eq 0 ];then
        apt-get install -y p7zip-full p7zip
    fi
    ## compress
    cd ${logpath}
    7z a -t7z -r ${timedate}-${timestamp}.7z  ${timedate}-${timestamp}

    ## test unzip
    7z t ${timedate}-${timestamp}.7z
    if [ $? -eq 0 ];then
        echo "tar.gz file is fine."
        compress_filename="${timedate}-${timestamp}.7z"
        rm -rf ${log_path} ${logpath}/${timedate}-${timestamp}
    fi

elif [[ "$compress_format" == "rar" ]];
    if [ $(dpkg -l | grep -E 'unrar' | wc -l) -eq 0 ];then
        apt-get install -y unrar rar
    fi
    ## compress
    cd ${logpath}
    rar a ${timedate}-${timestamp}.rar  ${timedate}-${timestamp}

    ## test rar
    rar t ${timedate}-${timestamp}.rar
    if [ $? -eq 0 ];then
        echo "tar.gz file is fine."
        compress_filename="${timedate}-${timestamp}.rar"
        rm -rf ${log_path} ${logpath}/${timedate}-${timestamp}
    fi

else
    echo "Compress format error."
    exit 1
fi


## commit to setting git
cd ${logpath}
git init
git add ${compress_filename}
git commit -m "commit backup $timestamp"
git branch $timestamp
git checkout $timestamp
git remote add origin $git_uri
git push origin $timestamp


