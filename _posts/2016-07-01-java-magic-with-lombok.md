---
layout: post_default
comments: true
category: java
tags: java
title: "谁说Java没有奇技淫巧之lombok"
---

总的来说Java是一种很“正”的语言，静态类型，大量的checked exception，只有极少的语法糖，程序员在日常开发中很难写出花来。但在另一个角度上，由于Java “代码-字节码-jvm虚拟机” 的机制，Java又是一种灵活的，可扩展的语言。本文介绍的lombok技术就是一种基于Annotation Processor的技术，可以自动生成一些工程上必要，但写起来又冗长无聊的代码（严格来说是字节码）。

lombok被发布为一个jar包，提供了一系列标注用于修饰你的代码，下面的代码片段是一个完整的使用lombok修饰的Java代码的例子。

{% highlight java linenos=table %}
import lombok.Getter;
import lombok.Setter;

public class LombokDemo {
    private static class DemoClass {
        @Getter
        @Setter
        private String field;
    }

    public static void main(String[] args) {
        DemoClass demoObject = new DemoClass();
        demoObject.setField("lombok"); // 编译时生成setField方法
        System.out.print(demoObject.getField()); // 编译时生成getField方法
    }
}
{% endhighlight %}

按理说上述代码会编译失败，因为DemoClass类并没有setField和getField这两个方法，但实际上在编译时，lombok的jar包内的Annotation Processor会被调用，根据lombok标注，操作抽象语法树，添加field成员变量的读取和写入方法，最终生成一个包含setField和getField这两个方法的字节码文件(.class文件)。

我们使用@Getter和@Setter标注修饰了DemoClass的私有字段field，编译后上述代码等价于：

{% highlight java linenos=table %}
import lombok.Getter;
import lombok.Setter;

public class LombokDemo {
    private static class DemoClass {
        private String field;

        public String getField() {
            return this.field;
        }

        public void setField(String field) {
            this.field = field;
        }
    }


    public static void main(String[] args) {
        DemoClass demoObject = new DemoClass();
        demoObject.setField("lombok");
        System.out.print(demoObject.getField());
    }
}
{% endhighlight %}

除了自动生成成员变量访问方法外，lombok还支持自动生成toString、equals、hashCode等方法，以及其他一些实用的模板代码。下面是一个常用的lombok标注列表：

*@Data*

@Data标注是最常用的lombok标注，标注在类上，等价于同时使用@ToString、@EqualsAndHashCode这2个标注修饰了该类，并且为所有的成员变量添加的@Getter和@Setter标注。

{% highlight java linenos=table %}
import lombok.Data;

@Data
public class DemoClass {
    private String field;
}
{% endhighlight %}

等价于：

{% highlight java linenos=table %}
public class DemoClass {
    private String field;

    public String getField() {
        return this.field;
    }

    public void setField(String field) {
        this.field = field;
    }

    public boolean equals(Object o) {
        if(o == this) {
            return true;
        } else if(!(o instanceof DemoClass)) {
            return false;
        } else {
            DemoClass other = (DemoClass)o;
            if(!other.canEqual(this)) {
                return false;
            } else {
                String this$field = this.getField();
                String other$field = other.getField();
                if(this$field == null) {
                    if(other$field != null) {
                        return false;
                    }
                } else if(!this$field.equals(other$field)) {
                    return false;
                }

                return true;
            }
        }
    }

    protected boolean canEqual(Object other) {
        return other instanceof DemoClass;
    }

    public int hashCode() {
        boolean PRIME = true;
        byte result = 1;
        String $field = this.getField();
        int result1 = result * 59 + ($field == null?43:$field.hashCode());
        return result1;
    }

    public String toString() {
        return "DemoClass(field=" + this.getField() + ")";
    }
}
{% endhighlight %}

*@NonNull*

@NonNull可以被用来修饰成员变量和方法的参数。当@NonNull和@Setter同时修饰成员变量时，生成的写入方法将会检查参数是否非空，并在参数为空时抛出NullPointException。当@NonNull修饰一个方法的参数时，会在方法执行时添加检查参数是否为空的代码。

{% highlight java linenos=table %}
import lombok.Getter;
import lombok.NonNull;
import lombok.Setter;

public class DemoClass {
    @Getter
    @Setter
    @NonNull
    private String field;

    public void hello(@NonNull Object word) {
        System.out.print(word);
    }
}
{% endhighlight %}

等价于:

{% highlight java linenos=table %}
import lombok.NonNull;

public class DemoClass {
    @NonNull
    private String field;

    public void hello(@NonNull Object word) {
        if(word == null) {
            throw new NullPointerException("word");
        } else {
            System.out.print(word);
        }
    }

    @NonNull
    public String getField() {
        return this.field;
    }

    public void setField(@NonNull String field) {
        if(field == null) {
            throw new NullPointerException("field");
        } else {
            this.field = field;
        }
    }
}

{% endhighlight %}

*@AllArgsConstructor、@NoArgsConstructor、@RequiredArgsConstructor*

@AllArgsConstructor用于生成包含所有成员变量的构造函数、@NoArgsConstructor用于生成无参构造函数、@RequiredArgsConstructor用于生成包含final和@NonNull成员变量的构造函数。

*@Builder*

用于生成builder模式的工厂类，该工厂类使用链式调用创建一个目标类的实例。

{% highlight java linenos=table %}
import lombok.Builder;

@Builder
class Example<T> {
    private T foo;
    private final String bar;
}
{% endhighlight %}

等价于：

{% highlight java linenos=table %}
class Example<T> {
    private T foo;
    private final String bar;

    private Example(T foo, String bar) {
        this.foo = foo;
        this.bar = bar;
    }

    public static <T> ExampleBuilder<T> builder() {
        return new ExampleBuilder<T>();
    }

    public static class ExampleBuilder<T> {
        private T foo;
        private String bar;

        private ExampleBuilder() {}

        public ExampleBuilder foo(T foo) {
            this.foo = foo;
            return this;
        }

        public ExampleBuilder bar(String bar) {
            this.bar = bar;
            return this;
        }

        public Example build() {
            return new Example(foo, bar);
        }
    }
}
{% endhighlight %}

*@SneakyThrows*

在被@SneakyThrows标注的方法中，如果调用了会抛出checked exception的方法，可以不捕获也不声明向上层抛出，编译器就仿佛视该异常是一个RuntimeException。

{% highlight java linenos=table %}
@SneakyThrows(UnsupportedEncodingException.class)
public void utf8ToString(byte[]bytes){
    return new String(bytes,"UTF-8");
}
{% endhighlight %}

上述代码可以被编译，而不是得到一个Error。@SneakyThrows标注在处理一些几乎不会被抛出的checked exception时很有用。

*@val*

受够了Java的冗长的类型声明？@val标注可以帮你完成类型推断（仅仅对局部变量）！

使用"val"作为局部变量的类型声明, lombok将会根据初始化该变量的表达式推断实际的类型。例如`val x = 10.0;`将会被推断为`double`类型，而`val y = new ArrayList<String>();`将会被推断为`ArrayList<String>`。

@val是lombok中唯一改变了Java语法结构的标注，个人认为需要谨慎使用。

*@CommonsLog、@Log、@Log4j、@Log4j2、@Slf4j、@XSlf4j*

这些标注用于为被标注的类生成一个log对象用于日志，每个标注对应了一种常用的日志库。

例如@Slf4j对应了`org.slf4j.Logger`，

{% highlight java linenos=table %}
@Slf4j
    public class LogExample {
}
{% endhighlight %}

等价于：

{% highlight java linenos=table %}
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class LogExample {
    private static final Logger log = LoggerFactory.getLogger(LogExample.class);
}
{% endhighlight %}

*IDE支持*

主流的Java IDE（IDEA、eclipse）都有插件支持lombok，避免IDE的一些错误提示。

*那么，代价是什么呢？*

lombok极大地减少了项目组“模板代码”的量，让开发者可以专注于业务逻辑，但代价是破坏了字节码和源代码的对应关系，可能会为调试和发布带来一些（极少的）不便。

delombok工具就是为了解决这个问题，用于生产处理过的等价Java源代码，关于delombok的更多信息，见[官方文档](https://projectlombok.org/features/delombok.html)

*参考*

更多信息，可以参考lombok的[官方站点](https://projectlombok.org)。