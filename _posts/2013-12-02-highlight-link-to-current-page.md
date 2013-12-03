---
layout: post_default
comments: true
title: 高亮导航链接
category: 代码
tags: jQuery 高亮 导航
---
这段代码总要用到,贴在这里备忘:

{% highlight javascript linenos=table %}
$(document).ready(function(){
	var str=location.href.toLowerCase();
	$(".nav li a").each(function() {
		if (str.indexOf(this.href.toLowerCase()) > -1) {
			$("li.active").removeClass("active");
			$(this).parent().addClass("active");
		}
	});
})
{% endhighlight %}
