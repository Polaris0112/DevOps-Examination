# docker、docker-compose自动安装配置

## 运行示例：
```shell
sh install.sh
```

脚本会先安装docker，然后修改镜像地址为国内源，然后再安装docker-compose，若碰到网络原因导致timeout之类的报错可以重新运行。



## 效果图

![成功运行后命令行图](https://github.com/Polaris0112/DevOps-Examination/blob/master/docker%E3%80%81docker-compose%E8%87%AA%E5%8A%A8%E5%AE%89%E8%A3%85%E9%85%8D%E7%BD%AE/install_docker_and_docker_compose_cmd.png)



![成功运行后网页效果图](https://github.com/Polaris0112/DevOps-Examination/blob/master/docker%E3%80%81docker-compose%E8%87%AA%E5%8A%A8%E5%AE%89%E8%A3%85%E9%85%8D%E7%BD%AE/install_docker_and_docker_compose_result.png)




## 关于使用scp上传脚本
### 运行示例：
```shell
sh upload.sh
```

使用前需要先配置相关的ip地址、账户、密码等参数，再运行脚本
