# MySql 镜像制作

## 文件结构解释

`0`:该文件夹中包括了制作Mysql Community Server 5.7 latest 版本的镜像、为运行该数据库服务创建必要的用户组和用户，并对其需要访问的目录、文件、其他服务等进行必要的授权，不直接使用root账户运行mysql的Dockerfile及其需要的入口文件。

### 创建自定义Mysql镜像命令
```
  ### 进入目录后运行
  docker built -t=mysql:custom-5.7-latest .
```


`1`:该文件夹中包含了docker-compose.yml定义了MySql 运行时的服务名称、端口、cnf 配置文件、/data 目录、/logs 目录的映射路径、MySql root用户的初始化密码、用于启动和运行MySql数据库服务的操作系统用户等参数。

### 运行命令示例
```shell
  ### 进入目录后运行
  docker-compose up -d
```


`2/mysql/`:该文件夹包含了使用rancher部署mysql的一套流程和所需要的文件和文件夹。


### 运行命令示例
```shell
  ### 提示：进行操作之前确保环境已经存在rancher或者rancher-compose命令
  ### 并且存在rancher服务端，配置对应的客户端api key或者environment api key作为环境变量
  ### 进入目录后运行
  #### 若使用环境api key的话请运行：
  rancher-compose up 
  #### 若使用客户端api key的话请运行：
  rancher --url <RANCHER_URL> --access-key <RANCHER_ACCESS_KEY> --secret-key <RANCHER_SECRET_KEY> up
  ### 运行后会提示一系列问题设置对应服务的参数，已经预设了缺省值，也可以自定义值，然后按回车进入下一步
```




`run-task1.sh`：实现自动根据上述Dockerfile构建Docker容器镜像文件、自动判断构建状态，若构建成功，自动根据docker-compose.yml、rancher-compose.yml部署并运行MySql服务。
### 运行命令示例
```shell
   sh run-task1.sh
   ### 运行后会自动拉取镜像构建自定义Mysql镜像并命名为dev-ops/mysql-custom,tag名为5.7
   ### 检测构建成功后，需要设置mysql数据库的初始化参数：root密码，创建mysql库、用户、密码
```


`run-task2.sh`：测试该MySql服务是否正常运行
### 运行命令示例
```shell
   ### 按照指定的顺序填入mysql相关信息参数，需要使用数据库管理员账号，返回的是用户表其中一条信息
   ### 能返回则说明服务正常使用
   sh run-task2.sh <mysql_host> <mysql_port> <mysql_user> <mysql_password>
   
```




## 效果图

![任务1成功命令行截图](https://github.com/Polaris0112/DevOps-Examination/blob/master/MySql%E9%95%9C%E5%83%8F%E5%88%B6%E4%BD%9C/rancher_mysql_service_cmd.png)


![任务1成功网页端显示](https://github.com/Polaris0112/DevOps-Examination/blob/master/MySql%E9%95%9C%E5%83%8F%E5%88%B6%E4%BD%9C/rancher_mysql_reuslt.png)


![任务2检查数据库服务启动图](https://github.com/Polaris0112/DevOps-Examination/blob/master/MySql%E9%95%9C%E5%83%8F%E5%88%B6%E4%BD%9C/rancher_check_mysql_is_running.png)






## 关于使用scp上传脚本
### 运行示例：
```shell
sh upload.sh
```

使用前需要先配置相关的ip地址、账户、密码等参数，再运行脚本

