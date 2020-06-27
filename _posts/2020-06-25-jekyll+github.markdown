---
layout:     post
title:      "jekyll+github的博客实现"
subtitle:   " \"开始第一篇\""
date:       2020-06-25 02:03:00
author:     "yuanmie"
header-img: "img/post-bg-2015.jpg"
catalog: true
tags:
    - jekyll
---

> “start. ”

使用jekyll+github部署自己的博客，并使用自定义域名访问。

# jekyll+github搭建
环境：
```shell
[root@new-centos7 _posts]# cat /etc/redhat-release

CentOS Linux release 7.5.1804 (Core)
```

## 安装Ruby

安装方法有很多种。

1.直接安装即可：
```shell
yum install ruby -y

rvm install 2.7.0 --disable-binary
```

2.源码包安装，去[官网](https://www.ruby-lang.org/zh_cn/)下载。

然后解压，编译：./config && make && make install，默认安装在/usr/local目录下

查看ruby版本：ruby -v

设置ruby默认版本：rvm use 2.7.0 --default

## 配置.bash_profile环境

不搞这一步后面就有坑了，后面报错，可以先提前解决。

.bash_profile在vim ~/.bash_profile下

步骤如下：
```shell
yum install git -y

git clone https://github.com/Linuxbrew/brew.git ~/.linuxbrew（下载看个人网速）

git clone https://github.com/Linuxbrew/homebrew-core ~/.linuxbrew/Library/Taps/homebrew（很久）

vim /root/.bash_profile，添加下面内容：

* export PATH="$HOME/.linuxbrew/bin:$PATH"
* export MANPATH="$HOME/.linuxbrew/share/man:$MANPATH"
* export INFOPATH="$HOME/.linuxbrew/share/info:$INFOPATH"

重新加载：source bash_profile
```
# 安装rvm
```shell
gpg2 --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB

curl -sSL https://get.rvm.io | bash -s stable
```

注意，这一步报错：curl: (7) Failed connect to raw.githubusercontent.com:443; 拒绝连接

解决：

vim /etc/hosts添加如下内容即可
```shell
199.232.68.133 raw.githubusercontent.com
```
解析域名，可[参考](https://blog.csdn.net/xt_123456/article/details/105884220?utm_medium=distribute.pc_relevant.none-task-blog-baidujs-1)

加载配置：
* source ~/.bashrc
* source ~/.bash_profile

修改 RVM 下载 Ruby 的源，到 Ruby China 的镜像:

echo "ruby_url=https://cache.ruby-china.com/pub/ruby" > ~/.rvm/user/db（报错也没事，后面用gem完成）

加载脚本：source /etc/profile.d/rvm.sh

检查一下是否安装正确：

rvm -v

rvm 1.22.17 (stable) by Wayne E. Seguin [https://rvm.io/]

## 安装gem

[gem官网](https://rubygems.org/releases)，可以在上面看到你所安装的软件，依赖软件的版本。

(建议安装2.7.0)
```shell
rvm requirements

rvm install 2.3.0

rvm install 2.7.0 --disable-binary（推荐）

设置ruby默认版本：rvm use 2.7.0 --default

检查：ruby -v，gem -v
```
## 安装bundler
```shell
gem install bundler
```
## 安装rails
```shell
gem install rails

检查：rails -v
```
## 安装jekyll
```shell
gem install jekyll
 
检查：jekyll -v
```
---
## 大功告成！
---

## 启动jekyll，指定一个IP

先创建一个blog，命令：jekyll new myblog

(用模板就先：bundle install)

然后进入到myblog目录下执行：bundle exec jekyll serve --watch --host=192.168.11.30

浏览器访问：192.168.11.30:40009

运行之后，它会加载自带的简单的配置文件。后面会下载一个做好的模板。


## 让git和jekyll交互

git的使用：

[参考](https://segmentfault.com/a/1190000013705747)

在git上创建一个learn仓库

在github上创建你的账号之后，到系统的/root/myblog目录下拉取仓库
```shell
[root@new-centos7 myblog]# git clone https://github.com/yuanmie-m/learn.git
```
之后本地会多一个learn的目录

在learn内创建一个index.html文件，随便写一个内容
```shell
[root@new-centos7 learn]# git add --all

[root@new-centos7 learn]# git commit -m "initial commit"


添加邮箱：qq和163都可以，建议使用163

[root@new-centos7 learn]# git config --global user.email "yuanmie_m@163.com"

输入git的账号：

[root@new-centos7 learn]# git config --global user.name "yuanmie-m"

然后在commit

[root@new-centos7 learn]# git commit -m "initial commit"

[root@new-centos7 learn]# ll


push代码到github上，就可以在github上看到index文件了

[root@new-centos7 learn]# git push -u origin master
```
## 使用jekyll模板来创建你的博客

下载一个模板，[网站](http://jekyllthemes.org/)

下载一个模板2步将这个模板应用起来：

* 1.bundle install
* 2.bundle exec jekyll serve --watch --host=192.168.11.30

将文件夹上传到/root目录，之后在安装相关插件：
```shell
[root@new-centos7 airspace-jekyll-master]# bundle install

运行：

[root@new-centos7 airspace-jekyll-master]# bundle exec jekyll serve --watch --host=192.168.11.30
```
浏览器访问：192.168.11.30:4000

将你的代码上传到github之后，也可以用github直接域名访问：https://{GitHub用户名}.github.io

# github的限制
Github Pages 并不是无限存储和无限流量的静态站点服务，一些限制如下：
内容存储不能超过1GB。
每个月100GB流量带宽。
每小时编译构建次数不超过10次。（在线修改重新编译并未发现这个限制）
更多参看官方说明：
[usage-limits](https://link.zhihu.com/?target=https%3A//help.github.com/articles/what-is-github-pages/%23usage-limits)



# 安装过程中出现的问题
1.from /usr/local/rvm/gems/ruby-2.7.0/gems/bundler-2.1.4/lib/bundler/errors.rb:3:in `<top (required)>'
解决：重新安装：rvm install 2.3.0
设置ruby版本：rvm use 2.7.0 --default
这里使用2.3.0了不报错，后面执行还是报错，要先安装下面的：jekyll-paginate。

2.Could not find gem 'jekyll-paginate' in any of the gem sources listed in your Gemfile
解决：
gem install jekyll-sitemap
这里的坑，要安装jekyll-sitemap就要使用ruby-2.7.0，使用ruby-2.7.0编译bundler install就报错，最后的解决版本：先使用ruby-2.7.0去安装好 jekyll-sitemap，然后在设置ruby-2.3.0去编译bundler install，最后就可以使用bundler exec jekyll server了。。。。
使用ruby-2.7.0编译bundler install就报错，不用ruby-2.7.0，那么jekyll-sitemap就按照不了。


3.error: RPC failed; result=18, HTTP code = 2009.00 KiB/s
解决：
git config --global http.postBuffer 1024288000
git config --list


# github page自定义域名
2步完成，先总结在细说。
1.先要有一个自己的域名，买好域名之后，配置DNS域名解析。
2.添加一个CNAMD文件，里面写你的域名。
## 自己域名配置
1.买域名
先要有一个自己的域名，我去阿里云上面注册的，域名有很多类型，每个域名都有它的适合用途。
就可以选择自己的，在搜索栏输入自己想的名字，即可查看。
买好域名之后，各种身份认证，实名认证，我这里从提交到完成，不到半个小时，很快！

2.域名解析

买好域名之后，配置DNS域名解析。后面在域名解析检测一下。
进入域名列表。
添加域名（刚开始添加域名，DNS服务器状态不是正常的）：
之后点进去，配置域名解析。
添加记录，主要是2条记录，记录值：是你的：仓库名.github.io

添加好之后等。等到域名解析变为正常才行。可以使用阿里云上面的工具，检测是不是正常。

同时也可以在你的博客系统上面检测。

## 使用阿里云免费SSL证书实现全站HTTPS化
购买免费ssl证书，直接在阿里云搜：DigiCert 免费版 SSL。
然后认证即可。

## github上设置
1）添加一个CNAMD文件（大写，无后缀名）
里面写你的域名，例如我的：yuanmie.co
本地写好上传CNAMD文件。

2）在setting中配置
https://yuanmie-m.github.io/test.github.io/.

（后面可以保存一个https:）

然后配置：

浏览器访问：yuanmie.co就是访问https://yuanmie-m.github.io/test.github.io了