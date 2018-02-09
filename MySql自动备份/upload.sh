#!/bin/bash
# Shell script for scp to remote servers

remote_dir=""
remote_ip=""
remote_port=""
remote_user=""
remote_password=""

if [[ -z $remote_dir || -z $remote_ip || -z $remote_user || -z $remote_password ]];then
    echo "Params error."
    exit 1
fi

if [[ -z $remote_port ]];then
    remote_port=22
fi

if [ $(dpkg -l | grep -E '7zip' | wc -l) -eq 0 ];then
    apt-get install expect
fi


## generate expect file
cat > expect_upload.sh << EOF
#!/usr/bin/expect -f

#upload
spawn scp -P $remote_port -r ./* $remote_user@$remote_ip:$remote_dir
set timeout 3
expect {
    "(yes/no)?" {
        send "yes\n"
        expect "password:"
        send "$remote_password\n"
    }
        "password:" {
        send "$remote_password\n"
    }
 }
set timeout 3
send "exit\r"
expect eof

EOF

rm -f expect_upload.sh
