# Ngnix 自动安装配置


## 运行示例：
```shell
   ### 运行命令前先确保已经存在rancher命令后者rancher-compose命令，并且rancher服务端正常服务中
   ### 然后从服务端获取rancher客户端api key或者环境api key
   ###  export RANCHER_URL=http://server_ip:8080/
   ###  export RANCHER_ACCESS_KEY=<username_of_environment_api_key>
   ###  export RANCHER_SECRET_KEY=<password_of_environment_api_key>
   ### 上述三条命令是临时配置环境api key，如果需要可以把它们追加到~/.profile或者/etc/profile，使用前先用source命令加载
   ### 如果是使用客户端api key，可以把它们写入run.sh里面17-19行对应参数的值上
   ### 配置完成后运行以下命令即可
   sh run.sh
```

脚本会先判断所需文件和参数是否存在，全部都通过就会调用rancher或者rancher-compose进行部署服务。



## 效果图


![Nginx部署成功命令行图](https://github.com/Polaris0112/DevOps-Examination/blob/master/Ngnix%E8%87%AA%E5%8A%A8%E5%AE%89%E8%A3%85%E9%85%8D%E7%BD%AE/rancher_build_nginx_server_cmd.png)



![Nginx部署成功网页端图](https://github.com/Polaris0112/DevOps-Examination/blob/master/Ngnix%E8%87%AA%E5%8A%A8%E5%AE%89%E8%A3%85%E9%85%8D%E7%BD%AE/rancher_build_nginx_server_result.png)



## 关于使用scp上传脚本
### 运行示例：
```shell
sh upload.sh
```

使用前需要先配置相关的ip地址、账户、密码等参数，再运行脚本

