# Rancher 自动安装配置

## 运行示例：
```shell
sh install.sh
```


脚本会首先安装rancher/server镜像，然后根据配置启动服务，并且安装rancher和rancher-compose命令。

安装完之后需要用户登录rancher界面，设置启用本地验证，然后找到"添加主机"一页在命令行中运行对应网页中的docker命令创建添加客户端即可使用。




## 效果图


![安装成功命令行图](https://github.com/Polaris0112/DevOps-Examination/blob/master/Rancher%E8%87%AA%E5%8A%A8%E5%AE%89%E8%A3%85%E9%85%8D%E7%BD%AE/rancher_install_cmd.png)


![Rancher页面创建完成图](https://github.com/Polaris0112/DevOps-Examination/blob/master/Rancher%E8%87%AA%E5%8A%A8%E5%AE%89%E8%A3%85%E9%85%8D%E7%BD%AE/rancher_done_web.png)


![Rancher创建本地用户图](https://github.com/Polaris0112/DevOps-Examination/blob/master/Rancher%E8%87%AA%E5%8A%A8%E5%AE%89%E8%A3%85%E9%85%8D%E7%BD%AE/rancher_set_user_web.png)


![Rancher创建客户端api key图](https://github.com/Polaris0112/DevOps-Examination/blob/master/Rancher%E8%87%AA%E5%8A%A8%E5%AE%89%E8%A3%85%E9%85%8D%E7%BD%AE/rancher_set_client_api_key.png)


![Rancher创建环境api key图](https://github.com/Polaris0112/DevOps-Examination/blob/master/Rancher%E8%87%AA%E5%8A%A8%E5%AE%89%E8%A3%85%E9%85%8D%E7%BD%AE/rancher_set_env_api_key.png)


![Rancher创建客户端](https://github.com/Polaris0112/DevOps-Examination/blob/master/Rancher%E8%87%AA%E5%8A%A8%E5%AE%89%E8%A3%85%E9%85%8D%E7%BD%AE/rancher_client_register.png)


![Rancher创建环境图](https://github.com/Polaris0112/DevOps-Examination/blob/master/Rancher%E8%87%AA%E5%8A%A8%E5%AE%89%E8%A3%85%E9%85%8D%E7%BD%AE/rancher_create_lab_env.png)





## 关于使用scp上传脚本
### 运行示例：
```shell
sh upload.sh
```

使用前需要先配置相关的ip地址、账户、密码等参数，再运行脚本
