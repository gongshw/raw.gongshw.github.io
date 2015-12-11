---
layout: post_default
comments: true
title: 一个含有中文的url的编码问题
category: 技术
tags: java url 编码 浏览器 http 中文
---

最近碰到一个需要把含有中文的url进行编码的问题。这个问题看似简单，但是查阅了相关资料之后发现也是有点坑的。

根据网络标准[RFC 1738](http://www.ietf.org/rfc/rfc1738.txt):

 > The characters ";","/", "?", ":", "@", "=" and "&" are the characters which may be reserved for special meaning ... only alphanumerics, the special characters "$-_.+!*'(),", and reserved characters used for their reserved purposes may be used unencoded within a URL.

即只有字母数字、部分特殊字符和保留字可以不经编码出现在URL中。而中文字符,是必须要经过编码才能出现在URL中的。但是问题在于RFC 1738没有规定具体的编码方法, 这个编码方法取决于浏览器和http服务器的约定, 不同的浏览器对于不同来源的url中不同位置的中文字符可能采取不同的编码方法。这篇[博客](http://www.ruanyifeng.com/blog/2010/02/url_encoding.html)对此进行了简略的分析。

但实际上主流浏览器在处理出现在超链接中的含有中文的URL的方法是近乎一致的, 对于下面这个URL的跳转:

> http://www.baidu.com/s?wd=中文测试

chrome和firefoxie都是发送了下面的请求, 即使用*UTF-8*编码后在每一个字节的16进制表示前加上%字符

> GET http://www.baidu.com/s?wd=%E4%B8%AD%E6%96%87%E6%B5%8B%E8%AF%95

而ie则直接将中文字符*GBK*编码后的*二进制数据*放在了请求头中

> GET [http://www.baidu.com/s?wd={0xD6}{0xD0}{0xCE}{0xC4}{0xB2}{0xE2}{0xCA}{0xD4}](http://www.baidu.com/s?wd=中文测试
)

如果http服务器不能同时正确地使用以上两种编码方式对http请求头进行解码, 那么该服务器就不能正确处理用户在浏览器中直接输入的带有中文的URL, 会导致服务器上的应用程序出现乱码问题。

综合考虑以上问题, 我们决定使用chrome和firefoxie浏览器对中文链接的处理方法对URL进行处理, 即对仅对链接中的中文部分使用UTF-8进行[百分号编码](https://zh.wikipedia.org/zh/%E7%99%BE%E5%88%86%E5%8F%B7%E7%BC%96%E7%A0%81)。

下面的java代码实现了这个方法:

{% highlight java linenos=table %}
// 将URL中的非ascii内容进行URL编码
private static String encodeNonAsciiUrl(String url) {
    StringBuilder sb = new StringBuilder();
    for (char c : url.toCharArray()) {
        if (c < 128) {
            // an ascii character
            sb.append(c);
        } else {
            try {
                sb.append(URLEncoder.encode(String.valueOf(c), "UTF-8"));
            } catch (UnsupportedEncodingException e) {
                e.printStackTrace();
                throw new RuntimeException("系统不支持UTF-8编码", e);
            }
        }
    }
    return sb.toString();
}
{% endhighlight %}
