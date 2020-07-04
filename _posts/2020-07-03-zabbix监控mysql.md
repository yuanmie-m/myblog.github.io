---
layout:     post
title:      zabbix监控mysql
subtitle:   mysql的监控
date:       2020-07-03
author:     yuanmie
header-img: img/post-bg-hacker.jpg
catalog: true
categories: Linux
tags:
    - zabbix
---

> zabbix---第5篇. ”

mysql的监控zabbi有自带的模板，但不能直接使用。

监控mysql的哪些东西？
```shell
MySQL begin operations per second	    MySQL每秒开始运算
MySQL bytes received per second	            每秒接收的MySQL字节数
MySQL bytes sent per second	            每秒发送的MySQL字节数
MySQL commit operations per second	    每秒MySQL提交操作
MySQL delete operations per second	    MySQL每秒删除操作数
MySQL insert operations per second	    MySQL每秒插入操作数
MySQL queries per second	            每秒MySQL查询
MySQL rollback operations per second	    每秒MySQL回滚操作
MySQL select operations per second          MySQL每秒选择操作
MySQL slow queries	                    MySQL慢查询
MySQL status	                            MySQL状态
MySQL update operations per second	    每秒MySQL更新操作
MySQL version	                            MySQL版本
MySQL uptime                                MySQL正常运行时间
```
# 重新配置mysql的配置文件
原来的文件：/etc/zabbix/zabbix_agentd.d/userparameter_mysql.conf

拷贝一份到另外的目录下：

    创建：mkdir -p /opt/zabbix/etc/zabbix_agentd.conf.d/

    cp /etc/zabbix/zabbix_agentd.d/userparameter_mysql.conf  /opt/zabbix/etc/zabbix_agentd.conf.d/

# 设置关联mysql的配置文件

    vim /opt/zabbix/etc/.my.cnf

    [mysql]
    host=192.168.11.36
    user=localhost
    password=
    socket=/var/lib/mysql/mysql.sock
    [mysqladmin]
    host=192.168.11.36
    user=localhost
    password=
    socket=/var/lib/mysql/mysql.sock

    host：写你的数据库IP
    user：我这里写的是localhost，你也可以使用其他的（后面授权数据库，不然zabbix_get不到数据）
    password：空可以不写，有就填上
    # mysql.sock文件通过find / -name mysql.sock找出路径

# 授权数据库
先登录到自己的数据库中：mysql -u root -p

授权并刷新下即可。
    
    mysql> grant all privileges on localhost.* to root@localhost identified by "YOURPASSWORD";
    Query OK, 0 rows affected (0.00 sec)

    mysql> flush privileges;
    Query OK, 0 rows affected (0.00 sec)

使用localhost登录数据库看能不能登录上：mysql -u localhost -p

# 修改userparameter_mysql.conf配置文件
    s@/var/lib/zabbix@/opt/zabbix/etc@g，将/var/lig/zabbix的路径修改为/opt/zabbix/etc

# 添加zabbix_agentd.conf文件的include
    修改vim /etc/zabbix/zabbix_agentd.conf文件添加：Include=/opt/zabbix/etc/zabbix_agentd.conf.d/

# 重启zabbix-agent
    systemctl restart zabbix-agent

# 在server端测试
    [root@zabbix-server ~]# zabbix_get -s 192.168.11.36 -p 10050 -k mysql.ping
    1

    [root@zabbix-server ~]# zabbix_get -s 192.168.11.36 -p 10050 -k mysql.version
    mysql  Ver 14.14 Distrib 5.6.48, for Linux (x86_64) using  EditLine wrapper

    [root@zabbix-server ~]# zabbix_get -s 192.168.11.36 -p 10050 -k mysql.status[Com_select]
    500

    参数：[Com_begin]，[Com_delete]，[Bytes_received]，[Bytes_sent]，[Com_commit]，[Com_insert]，[Questions]，[Com_rollback]，[Com_rollback]


# 配置web页面

添加模板：
![](/img/zabbix-mysql模板添加.png)

查看数据：
![](/img/zabbix-mysql查看数据.png)

# 触发器
数据库的触发器如何配置？
