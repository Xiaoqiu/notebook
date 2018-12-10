#### LockSupport
LockSupport看名字叫锁支持，这个玩意的功能跟wait和notify很像，
它也是可以阻塞一个线程，然后又可以恢复一个线程，不过有个比较大的区别就是，
wait让线程阻塞前，必获取到同步锁。而LockSupport这个哥们比较牛逼，
随时随地随便阻塞当前线程，你给它一个线程它就敢让那个线程阻塞。

它是通过park()方法阻塞当前线程的，park的意思就是停车咯，
然后恢复线程就是用unpark(Thread thread)方法。看下面的例子你就懂了

```java
import java.util.concurrent.locks.LockSupport;

public class Demo {

    public static void main(String[] args) {
        Person person = new Person();
        Thread thread = new Thread(new Runnable() {
            @Override
            public void run() {
                person.walk();
            }
        },"Jason");
        thread.start();

        try {
            Thread.sleep(3000);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        System.out.println("三秒过去，我解救"+thread.getName());
        LockSupport.unpark(thread);//解除该线程阻塞
    }
}

class Person {

    public void walk() {
        Thread currentThread = Thread.currentThread();
        System.out.println(currentThread.getName() + "在走。。。。前面有人挡住了");
        LockSupport.park();//阻塞当前线程
        System.out.println(currentThread.getName() + "又可以走了");
    }
}
```
输出结果：
```java
Jason在走。。。。前面有人挡住了
三秒过去，我解救Jason
Jason又可以走了
```

还有一点比较奇葩的是，LockSupport的unpark(Thread thread)方法
可以在park()方法前执行，如下面代码执行是没有问题的
```java
import java.util.concurrent.locks.LockSupport;

public class Demo {

    public static void main(String[] args) {
        Thread mainThread = Thread.currentThread();

        System.out.println("unpark...");
        LockSupport.unpark(mainThread);

        System.out.println("park 1");
        LockSupport.park();

    }
}

```
但是如果再加多一次park()程序就不会执行下去了，主线程被阻塞

```java
import java.util.concurrent.locks.LockSupport;

public class Demo {

    public static void main(String[] args) {
        Thread mainThread = Thread.currentThread();

        System.out.println("unpark...");
        LockSupport.unpark(mainThread);

        System.out.println("park 1");
        LockSupport.park();

        System.out.println("park 2");
        LockSupport.park();
    }
}
```
这个我就要解释一下这个两个方法的猫腻了，在LockSupport中有一个叫许可(permit)的概念，
unpark方法就是给线程发许可。

而park会有两种情况

1. 如果一个线程没有许可，那么它在调用park方法时就会被阻塞，
直到有其它线程调用unpark方法给它发许可或者过时（调用parkNanos(long nanos)，
类似wait(long timeout)）才会解除阻塞。

2. 如果一个线程有许可的话（像上上个例子），那么它在调用park方法时就会收回它那个许可，
但是不会被阻塞（像是交出过路费就给你过路一样）。但是当它再次调用park方法时，
因为许可已经被用掉了（没路费了），于是又成了第一种情况。

需要注意的一点是，一个线程一个时刻最多只能有一个许可，
即使你多次调用unpark方法它也只能有一个许可，不行看下面代码，照样是执行不下去的

```java
import java.util.concurrent.locks.LockSupport;

public class Demo {

    public static void main(String[] args) {
        Thread mainThread = Thread.currentThread();

        System.out.println("unpark...1");
        LockSupport.unpark(mainThread);
        System.out.println("unpark...2");
        LockSupport.unpark(mainThread);

        System.out.println("park 1");
        LockSupport.park();

        System.out.println("park 2");
        LockSupport.park();
    }
}
```

























