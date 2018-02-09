# docker、docker-compose自动安装配置

## 运行示例：
```shell
sh install.sh
```

脚本会先安装docker，然后修改镜像地址为国内源，然后再安装docker-compose，若碰到网络原因导致timeout之类的报错可以重新运行。






## 关于使用scp上传脚本
### 运行示例：
```shell
sh upload.sh
```

使用前需要先配置相关的ip地址、账户、密码等参数，再运行脚本
