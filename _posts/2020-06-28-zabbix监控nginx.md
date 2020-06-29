---
layout:     post
title:      zabbix监控nginx
subtitle:   nginx的监控
date:       2020-06-27
author:     yuanmie
header-img: img/post-bg-nginx.jpg
catalog: true
categories: Linux
tags:
    - zabbix
---

> zabbix---第3篇. ”

做nginx监控之前先搞明白nginx_status：
![](/img/nginx_status.png)

    Activeconnections:对后端发起的活动连接数；

    server accepts 76：nginx 总共处理了76个连接；

    handled：成功创建了76次握手；

    requests：总共处理了107请求。

    Reading：nginx读取客户端的header数；

    Writing: nginx 返回给客户端的header数；

    Waiting: nginx 请求处理完成，正在等待下一请求指令的连接。

    在访问效率很高，请求很快被处理完毕的情况下，Waiting 数比较多是正常的。如果 reading + writing 数较多，则说明并发访问量很大，正在处理过程中

zabbix监控nginx3步搞定。

    1.修改nginx.conf配置文件

    2.自定义监控项并测试

    3.导入模板/自己写也可以

# 修改nginx.conf文件
在被监控的主机上，配置nginx.conf，添加如下内容：
```shell
        location /nginx_status {
          stub_status on;
          access_log off;
        }
```
![](/img/nginx_config节点上.png)

加载nginx：nginx -s reload

浏览器访问：https://IP/nginx_status
![](/img/nginx_status.png)

# 自定义监控项并测试
在zabbix的agent节点上：

1.在/etc/zabbix/scripts目录下创建脚本：nginx_monitor.sh（脚本我放在我github的shell目录下）

赋与执行权限：chmod +x nginx_monitor.sh

2.在/etc/zabbix/zabbix_agentd.d/目录下创建配置文件：nginx_monitor.conf

    UserParameter=nginx_status[*],/etc/zabbix/scripts/nginx_monitor.sh $1

3.重启agent：systemctl restart zabbix-agent



在zabbix的服务端测试：

    [root@zabbix-server cloudalert]#  zabbix_get -s 192.168.11.35 -k nginx_status[active]
    1

    [root@zabbix-server cloudalert]#  zabbix_get -s 192.168.11.35 -k nginx_status[reading]
    0

    [root@zabbix-server cloudalert]#  zabbix_get -s 192.168.11.35 -k nginx_status[writing]
    1
    
    [root@zabbix-server cloudalert]#  zabbix_get -s 192.168.11.35 -k nginx_status[waiting]
    0

    [root@zabbix-server cloudalert]#  zabbix_get -s 192.168.11.35 -k nginx_status[accepts]
    76


    [root@zabbix-server cloudalert]#  zabbix_get -s 192.168.11.35 -k nginx_status[handled]
    76

    [root@zabbix-server cloudalert]#  zabbix_get -s 192.168.11.35 -k nginx_status[requests]
    107


# 导入模板/自己写也可以
创建nginx status模板：
![](/img/nginx_config创建模板.png)

创建nginx status监控项：
![](/img/nginx_status创建监控项.png)

监控项内容：
![](/img/nginx_status监控项内容.png)
根据nginx_monitor.sh脚本，里面有7项内容。依次完成如下配置：
![](/img/nginx_status7项监控项.png)

配置监控项图形：
![](/img/nginx_status图形.png)

添加完图形之后，就算完成了，可以去查看数据，刚添加好，需要等几分钟。

成功数据如下：
![](/img/nginx_status成功.png)