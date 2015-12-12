---
layout: post_default
comments: true
title: 在vim状态行显示当前目录 
category: 工具
tags: 
  - vim
---

Vim的使用者都知道使用`set statusline`来自定义Vim的状态行,例如`set statusline=[%f]%y%r%m%*%=[%l/%L:%c,%p%%]`,其中标识符`%f`代表当前活跃文件的文件名。

我时用Vim时常常会打开不同目录下的文件,打开几个文件之后就会忘记启动Vim的工作目录,而我也没有在终端的标题栏显示当前目录(因为命令提示符处有显示),所以我特别希望Vim的状态行能够显示当前目录。

通过`:help statusline`阅读了相关文档,我发现Vim并没有提供一个表示符来表示当前活动目录。但google了之后我发现Vim提供了getcwd()函数获取当前目录。因此我对vim做了如下配置:

{% highlight vim linenos=table %}
"在状态栏显示目录，文件名，所有的行数等等
let CWD = substitute(getcwd(), '^'.$HOME, '~', 'g')
set statusline=[%{CWD}][%f]%y%r%m%*%=[%l/%L:%c,%p%%]
{% endhighlight %}

其中`getcwd()`被用来函数获取当前目录, 然后用`~`替换这个目录中的`$HOME`环境变量,最后显示在状态行上。
