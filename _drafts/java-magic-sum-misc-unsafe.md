---
layout: post_default
comments: true
category: java
tags: java
title: "java黑科技: sun.misc.Unsafe"
---

Java是安全性极高的语言，设计上不允许程序员直接操作内存来避免一些错误。但是JRE中有一个特别的类sun.misc.Unsafe为程序员提供了访问和操作内存结构的接口，可以帮助程序员突破一些语言层面的限制实现某些黑科技。本文内容主要翻译自Mykhailo Kozik的[博客](http://mishadoff.com/blog/java-magic-part-4-sun-dot-misc-dot-unsafe/ "Java Magic. Part 4: sun.misc.Unsafe")。

## 获取Unsafe

Unsafe类的构造函数是私有的，我们不能使用new操作符直接创建一个Unsafe对象。不过Unsafe类提供了一个静态的getUnsafe()返回一个Unsafe对象，但如果简单直接地调用Unsafe.getUnsafe()，该方法会抛出一个SecurityException，因为这个方法只能被受信任的代码中被调用。下面是Unsafe.getUnsafe()方法的实现:

{% highlight java linenos=table %}
public static Unsafe getUnsafe() {
    Class cc = sun.reflect.Reflection.getCallerClass(2);
    if (cc.getClassLoader() != null)
        throw new SecurityException("Unsafe");
    return theUnsafe;
}
{% endhighlight %}

java认为被bootstrap classloader加载的类(例如jre中的类)是受信任的。

因此让我们的代码受信任的方法就是使用bootstrap classloader加载我们的类:

{% highlight sh linenos=table %}
java -Xbootclasspath:/usr/jdk1.7.0/jre/lib/rt.jar:. com.gongshw.demo.UnsafeClient
{% endhighlight %}

当然，在知道Unsafe.getUnsafe()的实现之后，我们很容易就可以利用反射“偷出”一个Unsafe对象:

{% highlight java linenos=table %}
Field f = Unsafe.class.getDeclaredField("theUnsafe");
f.setAccessible(true);
Unsafe unsafe = (Unsafe) f.get(null);
{% endhighlight %}

## Unsafe的API

Unsafe类中有超过100个方法, 大致有如下几类:

  - 获取运行时内存信息
    - addressSize
  - 操作对象
  - 操作类
  - 操作数组
  - 底层同步化接口
  - 直接内存操作

## Unsafe的使用场景

### 不调用构造函数构建实例

### 直接修改内存

### 实现sizeOf函数

### 浅拷贝

### 清除内存中的数据

### 多继承

### 动态加载类

### 抛出checked exception

### 快速序列化

### 大数组

### 并发