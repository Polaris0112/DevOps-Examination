# MySql 自动备份

## 运行示例：
```shell
sh mysql-backup.sh
```

按照文件头注释中的行数找到对应的参数配置

所有配置包括有：

**crontab相关**

`minute`:配置crontab的分钟频率

`hour`:配置crontab的小时频率

`day`:配置crontab的日频率

`month`:配置crontab的月频率

`week`:配置crontab的周频率



**备份路径设置**

`backup_path`:配置备份路径（绝对路径）



**mysql数据库相关**

`db_name`:mysql备份数据库名

`db_user`:mysql备份数据库用户

`db_password`:mysql备份数据库用户对应密码

`table_name`:mysql备份数据库表名

`log_path`:需要备份的日志文件路径（绝对路径）



**git地址**

`git_uri`:备份文件需要提交到的git仓库地址


**指定压缩格式**

`compress_format`:指定压缩格式（填入zip/tar/7z/rar决定）



然后直接运行`sh mysql-backup.sh`自动把改命令加入到crontab并且执行备份mysql指定库和表和日志文件并打包提交到指定的分支上的git仓库。



## 关于使用scp上传脚本
### 运行示例：
```shell
sh upload.sh
```

使用前需要先配置相关的ip地址、账户、密码等参数，再运行脚本

