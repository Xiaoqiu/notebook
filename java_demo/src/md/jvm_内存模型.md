# JVM内存模型
## 1、程序计数器
描述：程序计数器是一块较小的内存空间，可以看作是当前线程所执行的字节码的行号指示器。分支、循环、跳转、异常处理、线程恢复等基础功能都需要依赖这个计数器来完成。
1）在线程创建时创建

2）当前线程所执行的字节码的行号指示器

3）执行本地方法时，PC的值为undefined

4）每条线程都需要有一个独立的程序计数器，各条线程之间的计数器互不影响，独立存储，我们称这类内存区域为`线程私有`的内存

5)此内存区域是唯一一个在Java 虚拟机规范中没有规定任何OutOfMemoryError情况的区域

## 2、虚拟机栈
描述：线程私有，它的生命周期与线程相同。虚拟机栈描述的是Java 方法执行的内存模型：每个方法被执行的时候都会同时创建一个栈帧（Stack Frame）用于存储局部变量表、操作栈、动态链接、方法出口等信息。
设置大小：-Xss2M

1）`线程私有`，生命周期和线程相同

2）栈由一系列帧组成（因此Java栈也叫做帧栈）

3）帧保存方法参数，方法的局部变量、操作数栈、`常量池`，指针

4）每一次方法调用创建一个帧，并压栈

## 3、方法区
描述：方法区在一个jvm实例的内部，类型信息被存储在一个称为方法区的内存逻辑区中。类型信息是由类加载器在类加载时从类文件中提取出来的。`类(静态)变量`也存储在方法区中。

简单说方法区用来存储类型的元数据信息

设置大小：-XX:PermSize=10M -XX:MaxPermSize=10M

1)保存装载的类信息

2) 存储`常量池`

3) `存储static变量`，方法信息(方法名,返回类型,参数列表,方法的修饰符)

4) 通常和`永久区(Perm)`关联在一起可以通过-XX:PermSize和-XX:MaxPermSize参数限制方法区的大小

5)方法区是`线程安全的`。由于所有的`线程共享`方法区，所以，方法区里的数据访问必须被设计成线程安全的

6)  方法区也可被垃圾收集，当某个类不在被使用(不可触及)时，JVM将卸载这个类，进行垃圾收集

## 4、方法区内：运行时常量池
描述：运行时常量池是方法区的一部分.Class文件中除了有类的版本，字段，方法，接口等描述信息外还有一项信息是`常量池`，用于存放编译期生成的各种字面量和符号引用，这部分内容将在类加载后进入方法区运行时常量池中存放

运行时常量池相对于Class 文件常量池的另外一个重要特征是具备动态性，Java 语

言并不要求常量一定只能在编译期产生，也就是并非预置入Class 文件中常量池的内容

才能进入方法区运行时常量池，运行期间也可能将新的常量放入池中，这种特性被开发

人员利用得比较多的便是`String 类的intern() 方法`。


## 5、堆(heap)内存
描述:堆是Java 虚拟机所管理的内存中最大的一块。Java 堆是被所有`线程共享`的一块内存区域，在虚拟机启动时创建。此内存区域的唯一目的就是存放对象实例，几乎所有的对象实例都在这里分配内存

设置大小：Xms2g -Xmx2g -Xmn1g-Xss128k

-Xms2G 虚拟机内存最小2G

-Xms2G 虚拟机内存最大2G

-Xmn1G 年轻代内存1G

-Xss128 每个线程堆栈大小

1)  Java 堆是被所有线程共享的

2)  存放对象实例，几乎所有对象的实例都在这里分配内存

3）堆是垃圾收集器管理的主要区域，因此很多时候也被称做“GC 堆”。

4)堆的大小可以通过-Xms(最小值)和-Xmx(最大值)参数设置，-Xms为JVM启动时申请的最小内存，默认为操作系统物理内存的1/64但小于1G，-Xmx为JVM可申请的最大内存，默认为物理内存的1/4但小于1G

5)  默认当空余堆内存小于40%时，JVM会增大Heap到-Xmx指定的大小，可通过-XX:MinHeapFreeRation=来指定这个比列；当空余堆内存大于70%时，JVM会减小heap的大小到-Xms指定的大小，可通过XX:MaxHeapFreeRation=来指定这个比列

6)  从内存回收的角度看，由于现在收集器基本都是采用的分代收集算法，所以Java 堆中还可以细分为：新生代和老年代


新生代：程序新创建的对象都是从新生代分配内存，新生代由Eden Space和两块相同大小的Survivor Space(通常又称S0和S1或From和To)构成，可通过-Xmn参数来指定新生代的大小，也可以通过-XX:SurvivorRation来调整Eden Space及SurvivorSpace的大小

.
+ -- 新生代
  + -- Eden Space
  + -- Survivor Space (S0/From)
  + -- Survivor Space (S1/To)
     
+ -- 老年代

老年代：用于存放经过多次新生代GC仍然存活的对象，例如缓存对象，新建的对象也有可能直接进入老年代，主要有两种情况：

   1、大对象，可通过启动参数设置-XX:PretenureSizeThreshold=1024(单位为字节，默认为0)来代表超过多大时就不在新生代分配，而是直接在老年代分配。
    
   2、大的数组对象，且数组中无引用外部对象。
   
   
老年代所占的内存大小为-Xmx对应的值减去-Xmn对应的值。

## 6、本地方法栈
描述：本地方法栈（Native MethodStacks）与虚拟机栈所发挥的作用是非常相似的，其区别不过是虚拟机栈为虚拟机执行Java 方法（也就是字节码）服务，而本地方法栈则是为虚拟机使用到的`Native 方法服务`。虚拟机规范中对本地方法栈中的方法使用的语言、使用方式与数据结构并没有强制规定，因此具体的虚拟机可以自由实现本地方法栈。

## 7、堆外内存：直接内存
   - NIO的Buffer提供了一个可以不经过JVM内存直接访问系统物理内存的类——DirectBuffer。 
   - DirectBuffer类继承自ByteBuffer，但和普通的ByteBuffer不同，普通的ByteBuffer仍在JVM堆上分配内存，其最大内存受到最大堆内存的限制；
   - DirectBuffer直接分配在物理内存中，并不占用堆空间，其可申请的最大内存受操作系统限制。
   - 直接内存的读写操作比普通Buffer快，但它的创建、销毁比普通Buffer慢。
   - 直接内存使用于需要大内存空间且频繁访问的场合，不适用于频繁申请释放内存的场合。
 
（Note：DirectBuffer并没有真正向OS申请分配内存，其最终还是通过调用`Unsafe的allocateMemory()`来进行内存分配。
不过JVM对Direct Memory可申请的大小也有限制，可用-XX:MaxDirectMemorySize=1M设置，这部分内存`不受JVM垃圾回收管理`。）

   ### 直接内存（堆外内存）与堆内存比较
   1、 直接内存申请空间耗费更高的性能，当频繁申请到一定量时尤为明显

   2、直接内存IO读写的性能要优于普通的堆内存，在多次读写操作的情况下差异明显
   ### 代码验证：
```java
        package com.xnccs.cn.share;
        
        import java.nio.ByteBuffer;
        
        
        /**
        * 直接内存 与  堆内存的比较
        */
        public class ByteBufferCompare {
        
        
        public static void main(String[] args) {
        allocateCompare();   //分配比较
        operateCompare();    //读写比较
        }
        
        /**
        * 直接内存 和 堆内存的 分配空间比较
        * 
        * 结论： 在数据量提升时，直接内存相比非直接内的申请，有很严重的性能问题
        * 
        */
        public static void allocateCompare(){
        int time = 10000000;    //操作次数                           
        
        
        long st = System.currentTimeMillis();
        for (int i = 0; i < time; i++) {
        
            //ByteBuffer.allocate(int capacity)   分配一个新的字节缓冲区。
            ByteBuffer buffer = ByteBuffer.allocate(2);      //非直接内存分配申请     
        }
        long et = System.currentTimeMillis();
        
        System.out.println("在进行"+time+"次分配操作时，堆内存 分配耗时:" + (et-st) +"ms" );
        
        long st_heap = System.currentTimeMillis();
        for (int i = 0; i < time; i++) {
            //ByteBuffer.allocateDirect(int capacity) 分配新的直接字节缓冲区。
            ByteBuffer buffer = ByteBuffer.allocateDirect(2); //直接内存分配申请
        }
        long et_direct = System.currentTimeMillis();
        
        System.out.println("在进行"+time+"次分配操作时，直接内存 分配耗时:" + (et_direct-st_heap) +"ms" );
        
        }
        
        /**
        * 直接内存 和 堆内存的 读写性能比较
        * 
        * 结论：直接内存在直接的IO 操作上，在频繁的读写时 会有显著的性能提升
        * 
        */
        public static void operateCompare(){
        int time = 1000000000;
        
        ByteBuffer buffer = ByteBuffer.allocate(2*time);  
        long st = System.currentTimeMillis();
        for (int i = 0; i < time; i++) {
        
            //  putChar(char value) 用来写入 char 值的相对 put 方法
            buffer.putChar('a');
        }
        buffer.flip();
        for (int i = 0; i < time; i++) {
            buffer.getChar();
        }
        long et = System.currentTimeMillis();
        
        System.out.println("在进行"+time+"次读写操作时，非直接内存读写耗时：" + (et-st) +"ms");
        
        ByteBuffer buffer_d = ByteBuffer.allocateDirect(2*time);
        long st_direct = System.currentTimeMillis();
        for (int i = 0; i < time; i++) {
        
            //  putChar(char value) 用来写入 char 值的相对 put 方法
            buffer_d.putChar('a');
        }
        buffer_d.flip();
        for (int i = 0; i < time; i++) {
            buffer_d.getChar();
        }
        long et_direct = System.currentTimeMillis();
        
        System.out.println("在进行"+time+"次读写操作时，直接内存读写耗时:" + (et_direct - st_direct) +"ms");
        }
        }
```

   输出：
```bash
    在进行10000000次分配操作时，堆内存 分配耗时:12ms 
    在进行10000000次分配操作时，直接内存 分配耗时:8233ms 
    在进行1000000000次读写操作时，非直接内存读写耗时：4055ms 
    在进行1000000000次读写操作时，直接内存读写耗时:745ms

```
   可以自己设置不同的time 值进行比较

   ### 从数据流的角度，来看
   - 非直接内存作用链: 本地IO –>直接内存–>非直接内存–>直接内存–>本地IO 
   - 直接内存作用链: 本地IO–>直接内存–>本地IO
   
   ### 直接内存使用场景
   - 有很大的数据需要存储，它的生命周期很长
   - 适合频繁的IO操作，例如网络并发场景

# JVM核心参数设置
## 初始堆大小： -Xms
   - 默认值是物理内存的1/64(<1GB)
   - 空余堆内存小于40%时，JVM会增大堆到-Xmx的最大限制
   - 此值可以设置与-Xmx相同，以避免每次垃圾回收完成后JVM重新分配内存。
   - 整改堆的大小=年轻代大小 + 年老代大小 + 持久代大小
   - 增大年轻代后，将减少年老代大小.
   
## 最大堆大小： -Xmx
   - 默认值：物理内存的1/4(<1GB)
   - 空余堆内存大于70%，JVM会减少直到-Xms的最小限制
   
## 年轻代大小：-Xmn
   - 整改堆的大小=年轻代大小 + 年老代大小 + 持久代大小增大年轻代后，将减少年老代大小，此值对系统的性能影响较大，
   - 官方推荐配置：堆的3/8
   
## 设置年轻代大小： -XX:NewSize
   - 设置年轻代的初始值大小
   - 建议设置为整个堆大小的1/3或者1/4
   
## 年轻代最大值: -XX:MaxNewSize
   - 设置年轻代的最大值大小
   - 建议设置为整个堆大小的1/3或者1/4
## 持久代的初始值： -XX:PermSize

## 设置持久代最大值: -XX:MaxPermSize

## 每个线程的栈大小: -Xss
   - 在相同物理内存下，减小这个值能生成更多的线程。但是操作系统对一个进程内的线程数还是有限制的，不能无限生成，经验值在3000~5000左右

## 线程栈大小：-XX:ThreadStackSize

# 代码示例
## 堆溢出测试：
```java
package com.yhj.jvm.memory.heap;
import java.util.ArrayList;
import java.util.List;
/**
 * @Described：堆溢出测试
 * @VM args:-verbose:gc -Xms20M -Xmx20M -XX:+PrintGCDetails
 * @FileNmae com.yhj.jvm.memory.heap.HeapOutOfMemory.java
 */
public class HeapOutOfMemory {
    public static void main(String[] args) {
       List<TestCase> cases = new ArrayList<TestCase>();
       while(true){
           cases.add(new TestCase());
       }
    }
}
```
Java 堆内存的OutOfMemoryError异常是实际应用中最常见的内存溢出异常情况。出现Java 堆内
存溢出时，异常堆栈信息“java.lang.OutOfMemoryError”会跟着进一步提示“Java heap

space”。

要解决这个区域的异常，一般的手段是首先通过内存映像分析工具（如Eclipse

Memory Analyzer）对dump 出来的堆转储快照进行分析，重点是确认内存中的对象是

否是必要的，也就是要先分清楚到底是出现了内存泄漏（Memory Leak）还是内存溢

出（Memory Overflow）。图2-5 显示了使用Eclipse Memory Analyzer 打开的堆转储快

照文件。

如果是内存泄漏，可进一步通过工具查看泄漏对象到GC Roots 的引用链。于是就

能找到泄漏对象是通过怎样的路径与GC Roots 相关联并导致垃圾收集器无法自动回收

它们的。掌握了泄漏对象的类型信息，以及GC Roots 引用链的信息，就可以比较准确

地定位出泄漏代码的位置。

如果不存在泄漏，换句话说就是内存中的对象确实都还必须存活着，那就应当检查

虚拟机的堆参数（-Xmx 与-Xms），与机器物理内存对比看是否还可以调大，从代码上

检查是否存在某些对象生命周期过长、持有状态时间过长的情况，尝试减少程序运行期

的内存消耗。

以上是处理Java 堆内存问题的简略思路，处理这些问题所需要的知识、工具与经验

在后面的几次分享中我会做一些额外的分析。

## java栈溢出
```java
package com.yhj.jvm.memory.stack;
/**
 * @Described：栈层级不足探究
 * @VM args:-Xss128k
 * @FileNmae com.yhj.jvm.memory.stack.StackOverFlow.java
 */
public class StackOverFlow {
    private int i ;
    public void plus() {
       i++;
       plus();
    }
    public static void main(String[] args) {
       StackOverFlow stackOverFlow = new StackOverFlow();
       try {
           stackOverFlow.plus();
       } catch (Exception e) {
           System.out.println("Exception:stack length:"+stackOverFlow.i);
           e.printStackTrace();
       } catch (Error e) {
           System.out.println("Error:stack length:"+stackOverFlow.i);
           e.printStackTrace();
       }
    }
}
```
## 常量池溢出（常量池都有哪些信息，我们在后续的JVM类文件结构中详细描述）
```java
package com.yhj.jvm.memory.constant;
import java.util.ArrayList;
import java.util.List;
/**
 * @Described：常量池内存溢出探究
 * @VM args : -XX:PermSize=10M -XX:MaxPermSize=10M
 * @FileNmae com.yhj.jvm.memory.constant.ConstantOutOfMemory.java
 */
public class ConstantOutOfMemory {
    public static void main(String[] args) throws Exception {
       try {
           List<String> strings = new ArrayList<String>();
           int i = 0;
           while(true){
              strings.add(String.valueOf(i++).intern());
           }
       } catch (Exception e) {
           e.printStackTrace();
           throw e;
       }
    }
}
```

## 方法区溢出
```java
package com.yhj.jvm.memory.methodArea;
import java.lang.reflect.Method;
import net.sf.cglib.proxy.Enhancer;
import net.sf.cglib.proxy.MethodInterceptor;
import net.sf.cglib.proxy.MethodProxy;
/**
 * @Described：方法区溢出测试
 * 使用技术 CBlib
 * @VM args : -XX:PermSize=10M -XX:MaxPermSize=10M
 * @FileNmae com.yhj.jvm.memory.methodArea.MethodAreaOutOfMemory.java
 */
public class MethodAreaOutOfMemory {
    public static void main(String[] args) {
       while(true){
           Enhancer enhancer = new Enhancer();
           enhancer.setSuperclass(TestCase.class);
           enhancer.setUseCache(false);
           enhancer.setCallback(new MethodInterceptor() {
              @Override
              public Object intercept(Object arg0, Method arg1, Object[] arg2,
                     MethodProxy arg3) throws Throwable {
                  return arg3.invokeSuper(arg0, arg2);
              }
           });
           enhancer.create();
       }
    }
}
```
## 直接内存溢出
```java
package com.yhj.jvm.memory.directoryMemory;
import java.lang.reflect.Field;
import sun.misc.Unsafe;
/**
 * @Described：直接内存溢出测试
 * @VM args: -Xmx20M -XX:MaxDirectMemorySize=10M
 * @FileNmae com.yhj.jvm.memory.directoryMemory.DirectoryMemoryOutOfmemory.java
 */
public class DirectoryMemoryOutOfmemory {
    private static final int ONE_MB = 1024*1024;
    private static int count = 1;
    public static void main(String[] args) {
       try {
           Field field = Unsafe.class.getDeclaredField("theUnsafe");
           field.setAccessible(true);
           Unsafe unsafe = (Unsafe) field.get(null);
           while (true) {
              unsafe.allocateMemory(ONE_MB);
              count++;
           }
       } catch (Exception e) {
           System.out.println("Exception:instance created "+count);
           e.printStackTrace();
       } catch (Error e) {
           System.out.println("Error:instance created "+count);
           e.printStackTrace();
       }
    }
}
```
