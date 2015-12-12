---
layout: post_default
comments: true
title: 解决OS X El Capitan下Terminal启动慢的问题
category: 工具
tags: "OS X" "El Capitan" Terminal Shell
---

升级最新版的OS X El Capitan有一段时间了，总体来说与Yosemite区别不大。不过升级之后系统自带的Terminal启动极慢(每次启动大约要10秒左右)。这显然是不能接受的.

google了之后发现可能是系统日志导致的问题。执行`sudo rm -rf  /private/var/log/asl/*.asl`删除相关文件后Terminal确实恢复了以往的启动速度。

但是这显然只是个短期的解决方案，因为这些日志很快就会重新生成继续拖慢Terminal的启动。

Terminal使用/usr/bin/login命令使用户登录，但这个命令默认情况下会显示用户上次登录时间。为了获取用户上次的登录时间，login命令需要读取asl文件。当asl文件很大时就会拖慢Terminal的启动速度。因此要彻底解决Terminal启动慢的问题，可以从两个方面入手

  - 定时清理ASL文件
  - 不让login命令显示上次登录时间

定时清理ASL可以通过crontab实现，而不让login命令显示上次登录时间的方法是修改Terminal的偏好设置-> 描述文件-> shell选项卡中的运行命令为`login -pfq 用户名`，如下图

![设置示例](/img/2015-12-11-osx-slow-termial.png)

这样Terminal又可以恢复以往的启动速度了。
