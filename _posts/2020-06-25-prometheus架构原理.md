---
layout:     post
title:      "prometheus--架构原理"
subtitle:   " \"架构原理要牢记！\""
date:       2020-06-25 02:03:00
author:     "yuanmie"
header-img: "img/post-bg-os-metro.jpg"
catalog: true
tags:
    - prometheus
---

> “prometheus on1. ”

prometheus是一个开源的监控系统和时序数据库，Prometheus使用Go语言开发。


# 架构图
![avatar](https://mlog.club/api/img/proxy?url=https%3A%2F%2Fmmbiz.qpic.cn%2Fmmbiz_png%2FicdBCpcEToI9eliaV8MvxvhicN6V3EGVkpTZwxMNJ1r8aoupeBOzP3l7nYHFiahmibNrMIWibnX2Nk7iaFJjKEodg1TRQ%2F640%3Fwx_fmt%3Dpng)

[图片来源](https://mlog.club/article/2966580)

prometheus的组成：prometheus server，job epoerter（prometheus targets），service discovery，pushgateway，web UI，alertmanager

## prometheus server
prometheus server包括：retrieval，storage（tsdb），http server。

Prometheus Server：用于抓取和存储时间序列化数据，从job exporters中去拉去数据。

## retrieval
Retrieval：数据收集中心，收集自动发现的规则(自动发现的规则)，收集监控的指标(job exporter)，然后在传入tsdb中。

## TSDB
TSDB：时间序列数据库，将数据写入：HDD/SSD中

## http server
http server：给一个接口，给alertmanager和grafana接口

## Service discovery
Service discovery：服务自动发现。

主要有2种的服务发现:

* 1.是直接基于k8s的源数据的自动发现：kubernetes_sd
* 2.是基于文件自动发现，把自动发现规则写入file_sd文件中。

二种方式的应用场景：

Kubernetes_sd：服务基于k8s的容器编排容器的容器云监控的自动发现。

File_sd：自动发现应用不在k8s中的自动发现，需要在文件中写入规则。

## exporters
Job exporters（也叫prometheus targets）：要监控那些东西，是由它来拉取，相当于zabbix的agent，主动拉取数据的插件。多用。
 
教程中使用到的：kube-state-metric，node-exporter，cadvisor，blackbox-exporter

作用：

kube-state-metric：收集k8s基本状态信息，多少节点，多少pod，pod更新了多少版。关注于获取k8s各种资源的最新状态，如deployment或者daemonset。资源对象包括daemonset，deployment，job，namespace，node，pvc，pod_container，pod，replicaset，service，statefulset。

Node-exporter：收集k8s运算节点上的基础设施信息，运算节点还有多少内存，磁盘使用量，CPU使用量，网络IO等等（部署在所有运算节点上）。
Prometheus提供的NodeExporter项目可以提取主机节点的关键度量指标，通过Kubernetes的DeamonSet模式可以在各主机节点上部署一个NodeExporter实例，实现对主机性能指标数据的监控。

cadvisor：监控容器内置使用资源的主要工具，收集当前节点上运行的所有容器的资源使用情况，每容器到底耗费了多少资源（内存，CPU）

Blackbox-exporter：判断容器是否存活等。
 
 
## Pushgateway
Pushgateway：被动拉取数据的插件。少用。

## Altermanager
Altermanager：告警发送模块

## Prometheus web UI
Prometheus web UI：界面化，也包含结合Grafana进行数据展示或告警发送

## 其他组件介绍
使用metric-server收集数据给k8s集群内使用，如kubectl,hpa,scheduler等

使用prometheus-operator部署prometheus，存储监控数据

使用kube-state-metrics收集k8s集群内资源对象数据

使用node_exporter收集集群中各节点的数据

使用prometheus收集apiserver，scheduler，controller-manager，kubelet组件数据