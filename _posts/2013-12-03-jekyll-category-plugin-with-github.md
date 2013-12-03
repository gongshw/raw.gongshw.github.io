---
layout: post_default
comments: true
title: 在GitHub上使用Jekyll插件
category: 解决方案
tags: GitHub Jekyll 插件
---
构建这个博客的Jekyll是一个静态网页生成工具，要实现一些额外的功能必须要使用Jekyll插件。

Jekyll插件是由ruby编写的，在Jekyll构建静态网时执行的程序。虽然插件不能改变生成的web站点是静态网页的本质，但能通过强大的模板功能扩展Jekyll的能力。

比如[这篇博客](http://pizn.github.io/2012/02/23/use-category-plugin-for-jekyll-blog.html)提到的category_plugin，可以实现博客的分类功能。

但被广泛使用的Jekyll托管站点GitHub Pages却不支持Jekyll插件。虽然原因可以理解，却使Jekyll生成的博客的可用性大大降低。要使GitHub Pages“支持”Jekyll插件，其实有个很耍小聪明的解决方案：直接部署经过Jekyll+插件构建后的站点到GitHub上。

思路如下
  
  1. 安装本地的[Jekyll](http://jekyllrb.com/)环境。
  
  2. 使用 `jekyll new`命令新建一个jekyll站点目录。
  
  3. 在本地的jekyll站点编写博客。这时可以使用jekyll插件。
  
  4. 使用 `jekyll build`命令生成静态站点。默认的输出目录是_site/
  
  5. 把_site/目录下的文件发布到github。因为这就是一个静态站点不需要GitHub再次利用Jekyll构建，所以在根目录下添加一个内容为空的.nojekyll文件(`touch .nojekyll`)
  
这个过程的4、5两部可以利用脚本实现自动化。我写的脚本如下:

{% highlight sh linenos=table %}
#!/bin/sh
cd ~/raw.gongshw.github.io; 
jekyll build || error_exit "$LINENO: jekyll build failed";
cp -r _site/ ../gongshw.github.io/;
cd ../gongshw.github.io/;
git add .;
git commit -am 'Latest build.';
git push;
{% endhighlight %}

我在~/raw.gongshw.github.io目录存放模板。每次构建后自动复制_site到gongshw.github.io/这个git目录并提交到github.
