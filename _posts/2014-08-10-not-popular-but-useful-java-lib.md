---
layout: post_default
comments: true
title: 一些冷门但是实用的java类库
category: 代码
tags: Java 类库
---
题目中的“冷门”是严格定义的: 冷门是指该项目的主要版本在maven中心仓库被其他项目依赖的次数不超过10次。

这些库可能不像apache commons或者google guava这样大名鼎鼎、功能全面，但是可以方便的解决一些开发应用时常常遇到的问题。贴在下面备忘。

1. subethasmtp: 一个可编程的基于SMTP协议的邮件服务器。严格来说这是一个框架而不是类库。
2. zt-zip: 接口友善的zip压缩/解压库。在这个库帮助下，大部分的压缩/解压任务都可以使用一行代码实现。
3. [prettytime](http://ocpsoft.org/prettytime/ "prettytime"): 格式化时间为“xxx时间之前”的库。开发网站时很有用。
