---
layout:     post
title:      zabbix监控web
subtitle:   web页面的监控
date:       2020-07-03
author:     yuanmie
header-img: img/post-bg-hacker.jpg
catalog: true
categories: Linux
tags:
    - zabbix
---

> zabbix---第6篇. ”

Web的应用监控，以tomcat为例，监控网站curl是否返回200的案例。

# 先要有tomcat
确保tomcat能正常访问

# web检测
添加web场景
![](/img/zabbix-监控web.png)

创建web场景及相关配置
![](/img/zabbix-监控web.png)

![](/img/zabbix-监控web的步骤配置.png)

# 设置触发器
配置触发器
![](/img/zabbix-监控web配置触发器.png)

{zabbix-agent-36:web.test.rspcode[tomcat web monitor,tomcat index].last()}<>200

# 配置图形
![](/img/zabbix-监控web配置图形.png)

# 查看数据
![](/img/zabbix-监控web查看数据.png)