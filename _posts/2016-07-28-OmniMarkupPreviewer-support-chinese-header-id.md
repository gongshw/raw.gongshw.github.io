---
layout: post_default
comments: true
category: 工具
tags: 
    - "markdown"
    - "python"
    - "sublime"
    - "OmniMarkupPreviewer"
title: "使Sublime Text 3的OmniMarkupPreviewer插件支持中文页内链接"
---

最近在使用使Sublime Text 3的OmniMarkupPreviewer插件进行一波文档编写工作。

总体来说OmniMarkupPreviewer插件体验良好，但是却碰到一个比较棘手的问题。

OmniMarkupPreviewer使用了Python Markdown作为渲染核心，可以启用Python Markdown的多种扩展. 我启用了其中的toc扩展，可以自动为文档生成目录，并且通过页内页内链接跳转到文档的各级标题处。当然要实现这一点，除了自动生成目录外，toc扩展还需要为各级标题按照标题内容添加id属性。

我一看，真吼啊，各级标题都有了id，我不就可以方便的在文档内部使用页内链接实现引用，极大的方便了与读者吗。我原来的预期是这样的:

{% highlight text linenos=table %}
# 我是标题

## 我是第一个二级标题

请参考[本文档的这一部分](#我是第二个二级标题)

## 我是第二个二级标题

一些正文
{% endhighlight %}

这样可以从`请参考[本文档的这一部分]`这句话链到`我是第二个二级标题`这一节, 然而现实情况却是Python Markdown按标题内容生成的标题的id时, 把非ASCII字符都给过滤了, 生成的html差不多长这样:

{% highlight html linenos=table %}
<h1 id="_1">我是标题</h1>
<h2 id="_2">我是第一个二级标题</h2>
<p>请参考<a href="#我是第二个二级标题">本文档的这一部分</a></p>
<h2 id="_3">我是第二个二级标题</h2>
<p>一些正文</p>
{% endhighlight %}

因为把中文过滤掉之后, 所有标题都是空字符串, 所以Python Markdown在标题的id后面加上了自增序列。

这样我写的那个页内链接看起来就很傻了，要是按照Python Markdown的逻辑, 我的页内链接也改成`#_3`的话，又很不便于维护, 毕竟随便改动点内容就可能导致标题的id发生变化, 所以我就在找一个办法能让Python Markdown生成中文的标题id, 或者说UrlEncoded的中文id.

通过阅读Python Markdown扩展TOC的源代码, 我知道了TOC是是用了Python Markdown的另一个扩展HeaderID生成标题的id的，这个扩展被安装在`Sublime Text 3\Packages\OmniMarkupPreviewer\OmniMarkupLib\Renderers\libs\markdown\extensions`目录下。

然后阅读`headerid.py`的源代码我们发现了这个方法

{% highlight python linenos=table %}
def slugify(value, separator):
    """ Slugify a string, to make it URL friendly. """
    value = unicodedata.normalize('NFKD', value).encode('ascii', 'ignore')
    value = re.sub('[^\w\s-]', '', value.decode('ascii')).strip().lower()
    return re.sub('[%s\s]+' % separator, separator, value)
{% endhighlight %}

显然个方法过滤了标题中的非ASCII，然后用连字符连接了标题中的空格, 我也不用太关心这里的实现细节，简单粗暴地的把该方法改为:

{% highlight python linenos=table %}
def slugify(value, separator):
    """ Slugify a string, to make it URL friendly. """
    #value = unicodedata.normalize('NFKD', value).encode('ascii', 'ignore')
    #value = re.sub('[^\w\s-]', '', value.decode('ascii')).strip().lower()
    #return re.sub('[%s\s]+' % separator, separator, value)

    # urllib.parse is for python 3. use urllib instead if you use python 2
    from urllib.parse import quote 
    return quote(value)
{% endhighlight %}

Sublime Text 3使用了python 3, 所以我用urllib.parse包的quote方法把标题进行了了url编码。如果你是用的是Sublime Text 2, 可能需要python 2的urllib包中的相关方法。

修改之后，我的文档中的页内链接终于能正常跳转到标题了，而且TOC扩展的行为也没有收到影响。

HeaderID扩展本身提供了配置选项用使用者可以传入自己的slugify方法，可惜的是我没有找到OmniMarkupPreviewer暴露出的相关接口，不得不通过修改源代码的方式实现这个功能。