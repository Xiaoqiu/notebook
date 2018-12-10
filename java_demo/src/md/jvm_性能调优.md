# JVM内存模型，垃圾回收算法介绍
## 根据Java虚拟机规范，JVM将内存划分为：
+ -- 年轻代(New) ：年轻代用来存放JVM刚分配的Java对象
    + -- Eden : Eden用来存放JVM刚分配的对象
    + Survivor1
    + Survivor2 ：两个Survivor空间一样大，当Eden中的对象经过垃圾回收没有被回收掉时，会在两个Survivor之间来回Copy，当满足某个条件，比如Copy次数，就会被Copy到Tenured。显然，Survivor只是增加了对象在年轻代中的逗留时间，增加了被垃圾回收的可能性。
+ -- 年老代(Tenured)： 年轻代中经过垃圾回收没有回收掉的对象将被Copy到年老代
+ -- 永久代(Perm) ：永久代存放Class、Method元信息（运行时方法区），其大小跟项目的规模、类、方法的量有关，一般设置为128M就足够，设置原则是预留30%的空间。

其中New和Tenured属于堆内存，堆内存会从JVM启动参数（-Xmx:3G）指定的内存中分配，Perm不属于堆内存，有虚拟机直接分配，但可以通过-XX:PermSize -XX:MaxPermSize 等参数调整其大小。
## 垃圾回收算法
### 垃圾回收算法可以分为三类，都基于标记-清除（复制）算法：
#### 1.Serial算法（单线程）
#### 2.并行算法：
   + 并行算法是用多线程进行垃圾回收，回收期间会暂停程序的执行 JVM会根据机器的硬件配置对每个内存代选择适合的回收算法，比如，如果机器多于1个核，会对年轻代选择并行算法，关于选择细节请参考JVM调优文档。
#### 3.并发算法：
   + 而并发算法，也是多线程回收，但期间不停止应用执行。并发算法适用于交互性高的一些程序。经过观察，并发算法会减少年轻代的大小，其实就是使用了一个大的年老代，这反过来跟并行算法相比吞吐量相对较低。
### 何时执行垃圾回收动作：
   + 当年轻代内存满时，会引发一次普通GC，该GC仅回收年轻代。需要强调的时，年轻代满是指Eden代满，Survivor满不会引发GC
   + 当年老代满时会引发Full GC，Full GC将会同时回收年轻代、年老代
   + 当永久代满时也会引发Full GC，会导致Class、Method元信息的卸载

### 何时会抛出OutOfMemoryException
   + JVM98%的时间都花费在内存回收而且每次回收的内存小于2%，满足这两个条件将触发OutOfMemoryException，这将会留给系统一个微小的间隙以做一些Down之前的操作，比如手动打印Heap Dump。
   
# JVM性能调优步骤   

## 1.设定目标
1）降低Full GC的执行频率？
2）降低Full GC的消耗时间？
3）降低Full GC所造成的应用停顿时间？
4）降低Minor GC执行频率？
5）降低Minor GC消耗时间？
例如某系统的GC调优目标：降低Full GC执行频率的同时，尽可能降低minor GC的执行频率、消耗时间以及GC对应用造成的停顿时间。
## 2.尝试调优
1、衡量工具
1）打印GC日志信息：-XX:+PrintGCDetails –XX:+PrintGCApplicationStoppedTime -Xloggc: {文件名}  -XX:+PrintGCTimeStamps
2）jmap：（由于每个版本jvm的默认值可能会有改变，建议还是用jmap首先观察下目前每个代的内存大小、GC方式） ?
3）运行状况监测工具：jstat、jvisualvm、sar 、gclogviewer

2、应收集的信息
1）minor gc的执行频率；full gc的执行频率，每次GC耗时多少？
2）高峰期什么状况？
3）minor gc回收的效果如何？survivor的消耗状况如何，每次有多少对象会进入老生代？
4）full gc回收的效果如何？（简单的memory leak判断方法）
5）系统的load、cpu消耗、qps or tps、响应时间

>QPS每秒查询率：是对一个特定的查询服务器在规定时间内所处理流量多少的衡量标准。在因特网上，作为域名服务器的机器性能经常用每秒查询率来衡量。对应fetches/sec，即每秒的响应请求数，也即是最大吞吐能力。
 TPS(Transaction Per Second)：每秒钟系统能够处理的交易或事务的数量。
 
## 3.衡量调优
注意Java RMI的定时GC触发机制，可通过：-XX:+DisableExplicitGC来禁止或通过 -Dsun.rmi.dgc.server.gcInterval=3600000来控制触发的时间。

1）降低Full GC执行频率 – 通常瓶颈
老生代本身占用的内存空间就一直偏高，所以只要稍微放点对象到老生代，就full GC了；
通常原因：系统缓存的东西太多；
例如：使用oracle 10g驱动时preparedstatement cache太大；
查找办法：现执行Dump然后再进行MAT分析；

（1）Minor GC后总是有对象不断的进入老生代，导致老生代不断的满
通常原因：Survivor太小了
系统表现：系统响应太慢、请求量太大、每次请求分配的内存太多、分配的对象太大...
查找办法：分析两次minor GC之间到底哪些地方分配了内存；
利用jstat观察Survivor的消耗状况，-XX:PrintHeapAtGC，输出GC前后的详细信息；
对于系统响应慢可以采用系统优化，不是GC优化的内容；

（2）老生代的内存占用一直偏高
调优方法：① 扩大老生代的大小（减少新生代的大小或调大heap的 大小）；
减少new注意对minor gc的影响并且同时有可能造成full gc还是严重；
调大heap注意full gc的时间的延长，cpu够强悍嘛，os是32 bit的吗？
② 程序优化（去掉一些不必要的缓存）

（3）Minor GC后总是有对象不断的进入老生代
前提：这些进入老生代的对象在full GC时大部分都会被回收
调优方法：
① 降低Minor GC的执行频率；
② 让对象尽量在Minor GC中就被回收掉：增大Eden区、增大survivor、增大TenuringThreshold；注意这些可能会造成minor gc执行频繁；
③ 切换成CMS GC：老生代还没有满就回收掉，从而降低Full GC触发的可能性；
④ 程序优化：提升响应速度、降低每次请求分配的内存、

（4）降低单次Full GC的执行时间
通常原因：老生代太大了...
调优方法：1）是并行GC吗？   2）升级CPU  3）减小Heap或老生代

（5）降低Minor GC执行频率
通常原因：每次请求分配的内存多、请求量大
通常办法：1）扩大heap、扩大新生代、扩大eden。注意点：降低每次请求分配的内存；横向增加机器的数量分担请求的数量。

（6）降低Minor GC执行时间
通常原因：新生代太大了，响应速度太慢了，导致每次Minor GC时存活的对象多
通常办法：1）减小点新生代吧；2）增加CPU的数量、升级CPU的配置；加快系统的响应速度

## 4.细微调整
首先需要了解以下情况：

① 当响应速度下降到多少或请求量上涨到多少时，系统会宕掉？

② 参数调整后系统多久会执行一次Minor GC，多久会执行一次Full GC，高峰期会如何？

需要计算的量：

①每次请求平均需要分配多少内存？系统的平均响应时间是多少呢？请求量是多少、多常时间执行一次Minor GC、Full GC？

②现有参数下，应该是多久一次Minor GC、Full GC，对比真实状况，做一定的调整；

必杀技：提升响应速度、降低每次请求分配的内存？

# JVM性能调优方式
## 1. 线程池调优：解决用户响应时间长的问题
+ 大多数JVM6上的应用采用的线程池都是JDK自带的线程池，之所以把成熟的Java线程池进行罗嗦说明，是因为该线程池的行为与我们想象的有点出入。Java线程池有几个重要的配置参数：

> corePoolSize：核心线程数（最新线程数）
  maximumPoolSize：最大线程数，超过这个数量的任务会被拒绝，用户可以通过RejectedExecutionHandler接口自定义处理方式
  keepAliveTime：线程保持活动的时间
  workQueue：工作队列，存放执行的任务

+ Java线程池需要传入一个Queue参数（workQueue）用来存放执行的任务，而对Queue的不同选择，线程池有完全不同的行为：

> SynchronousQueue： 一个无容量的等待队列，一个线程的insert操作必须等待另一线程的remove操作，采用这个Queue线程池将会为每个任务分配一个新线程
  LinkedBlockingQueue ： 无界队列，采用该Queue，线程池将忽略 maximumPoolSize参数，仅用corePoolSize的线程处理所有的任务，未处理的任务便在LinkedBlockingQueue中排队
  ArrayBlockingQueue： 有界队列，在有界队列和 maximumPoolSize的作用下，程序将很难被调优：更大的Queue和小的maximumPoolSize将导致CPU的低负载；小的Queue和大的池，Queue就没起动应有的作用。

+ 其实我们的要求很简单，希望线程池能跟连接池一样，能设置最小线程数、最大线程数，当最小数<任务<最大数时，应该分配新的线程处理；当任务>最大数时，应该等待有空闲线程再处理该任务。

+ 但线程池的设计思路是，任务应该放到Queue中，当Queue放不下时再考虑用新线程处理，如果Queue满且无法派生新线程，就拒绝该任务。设计导致“先放等执行”、“放不下再执行”、“拒绝不等待”。所以，根据不同的Queue参数，要提高吞吐量不能一味地增大maximumPoolSize。

+ 当然，要达到我们的目标，必须对线程池进行一定的封装，幸运的是ThreadPoolExecutor中留了足够的自定义接口以帮助我们达到目标。我们封装的方式是：

+ 以SynchronousQueue作为参数，使maximumPoolSize发挥作用，以防止线程被无限制的分配，同时可以通过提高maximumPoolSize来提高系统吞吐量
自定义一个RejectedExecutionHandler，当线程数超过maximumPoolSize时进行处理，处理方式为隔一段时间检查线程池是否可以执行新Task，如果可以把拒绝的Task重新放入到线程池，检查的时间依赖keepAliveTime的大小。

## 2. JAVA连接池调优
在使用org.apache.commons.dbcp.BasicDataSource的时候，因为之前采用了默认配置，所以当访问量大时，通过JMX观察到很多Tomcat线程都阻塞在BasicDataSource使用的Apache ObjectPool的锁上，直接原因当时是因为BasicDataSource连接池的最大连接数设置的太小，默认的BasicDataSource配置，仅使用8个最大连接。

我还观察到一个问题，当较长的时间不访问系统，比如2天，DB上的MySQL会断掉所以的连接，导致连接池中缓存的连接不能用。为了解决这些问题，我们充分研究了BasicDataSource，发现了一些优化的点：
   
   - Mysql默认支持100个链接，所以每个连接池的配置要根据集群中的机器数进行，如有2台服务器，可每个设置为60
   - initialSize：参数是一直打开的连接数
   - minEvictableIdleTimeMillis：该参数设置每个连接的空闲时间，超过这个时间连接将被关闭
   - timeBetweenEvictionRunsMillis：后台线程的运行周期，用来检测过期连接
   - maxActive：最大能分配的连接数
   - maxIdle：最大空闲数，当连接使用完毕后发现连接数大于maxIdle，连接将被直接关闭。只有initialSize < x < maxIdle的连接将被定期检测是否超期。这个参数主要用来在峰值访问时提高吞吐量。
   - initialSize是如何保持的？经过研究代码发现，BasicDataSource会关闭所有超期的连接，然后再打开initialSize数量的连接，这个特性与minEvictableIdleTimeMillis、timeBetweenEvictionRunsMillis一起保证了所有超期的initialSize连接都会被重新连接，从而避免了Mysql长时间无动作会断掉连接的问题。

## 3. JVM启动参数：调整各代的内存比例和垃圾回收算法，提高吞吐量
在JVM启动参数中，可以设置跟内存、垃圾回收相关的一些参数设置，默认情况不做任何设置JVM会工作的很好，但对一些配置很好的Server和具体的应用必须仔细调优才能获得最佳性能。通过设置我们希望达到一些目标：

+ GC的时间足够的小
+ GC的次数足够的少
+ 发生Full GC的周期足够的长
  
前两个目前是相悖的，要想GC时间小必须要一个更小的堆，要保证GC次数足够少，必须保证一个更大的堆，我们只能取其平衡。

1. 针对JVM堆的设置一般，可以通过-Xms -Xmx限定其最小、最大值，为了防止垃圾收集器在最小、最大之间收缩堆而产生额外的时间，我们通常把最大、最小设置为相同的值

2. 年轻代和年老代将根据默认的比例（1：2）分配堆内存，可以通过调整二者之间的比率NewRadio来调整二者之间的大小，也可以针对回收代，比如年轻代，通过 -XX:newSize -XX:MaxNewSize来设置其绝对大小。同样，为了防止年轻代的堆收缩，我们通常会把-XX:newSize -XX:MaxNewSize设置为同样大小

3. 年轻代和年老代设置多大才算合理？这个我问题毫无疑问是没有答案的，否则也就不会有调优。我们观察一下二者大小变化有哪些影响
更大的年轻代必然导致更小的年老代，大的年轻代会延长普通GC的周期，但会增加每次GC的时间；小的年老代会导致更频繁的Full GC
更小的年轻代必然导致更大年老代，小的年轻代会导致普通GC很频繁，但每次的GC时间会更短；大的年老代会减少Full GC的频率
如何选择应该依赖应用程序对象生命周期的分布情况：如果应用存在大量的临时对象，应该选择更大的年轻代；如果存在相对较多的持久对象，年老代应该适当增大。但很多应用都没有这样明显的特性，在抉择时应该根据以下两点：
   - （A）本着Full GC尽量少的原则，让年老代尽量缓存常用对象，JVM的默认比例1：2也是这个道理 
   -（B）通过观察应用一段时间，看其他在峰值时年老代会占多少内存，在不影响Full GC的前提下，根据实际情况加大年轻代，比如可以把比例控制在1：1。但应该给年老代至少预留1/3的增长空间

4. 在配置较好的机器上（比如多核、大内存），可以为年老代选择并行收集算法： -XX:+UseParallelOldGC ，默认为Serial收集

5. 线程堆栈的设置：每个线程默认会开启1M的堆栈，用于存放栈帧、调用参数、局部变量等，对大多数应用而言这个默认值太了，一般256K就足用。理论上，在内存不变的情况下，减少每个线程的堆栈，可以产生更多的线程，但这实际上还受限于操作系统。

6. 可以通过下面的参数打Heap Dump信息
-XX:HeapDumpPath
-XX:+PrintGCDetails
-XX:+PrintGCTimeStamps
-Xloggc:/usr/aaa/dump/heap_trace.txt
    
通过下面参数可以控制OutOfMemoryError时打印堆的信息
-XX:+HeapDumpOnOutOfMemoryError
 请看一下一个时间的Java参数配置：（服务器：Linux 64Bit，8Core×16G）

 JAVA_OPTS="$JAVA_OPTS -server -Xms3G -Xmx3G -Xss256k -XX:PermSize=128m -XX:MaxPermSize=128m -XX:+UseParallelOldGC -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=/usr/aaa/dump -XX:+PrintGCDetails -XX:+PrintGCTimeStamps -Xloggc:/usr/aaa/dump/heap_trace.txt -XX:NewSize=1G -XX:MaxNewSize=1G"

经过观察该配置非常稳定，每次普通GC的时间在10ms左右，Full GC基本不发生，或隔很长很长的时间才发生一次

通过分析dump文件可以发现，每个1小时都会发生一次Full GC，经过多方求证，只要在JVM中开启了JMX服务，JMX将会1小时执行一次Full GC以清除引用，关于这点请参考附件文档。
## 4. 程序算法：改进程序逻辑算法提高性能
# JVM调优例子

现象：1、系统响应速度大概为100ms；2、当系统QPS增长到40时，机器每隔5秒就执行一次minor gc，每隔3分钟就执行一次full gc，并且很快就一直full GC了；4、每次Full gc后旧生代大概会消耗400M，有点多了。

 解决方案：解决Full GC次数过多的问题

（1）降低响应时间或请求次数，这个需要重构，比较麻烦；——这个是终极方法，往往能够顺利的解决问题，因为大部分的问题均是由程序自身造成的。

（2）减少老生代内存的消耗，比较靠谱；——可以通过分析Dump文件（jmap dump），并利用MAT查找内存消耗的原因，从而发现程序中造成老生代内存消耗的原因。

（3）减少每次请求的内存的消耗，貌似比较靠谱；——这个是海市蜃楼，没有太好的办法。

（4）降低GC造成的应用暂停的时间——可以采用CMS GS垃圾回收器。参数设置如下：

 -Xms1536m -Xmx1536m -Xmn700m -XX:SurvivorRatio=7 -XX:+UseConcMarkSweepGC -XX:+UseCMSCompactAtFullCollection

 -XX:CMSMaxAbortablePrecleanTime=1000 -XX:+CMSClassUnloadingEnabled -XX:+UseCMSInitiatingOccupancyOnly -XX:+DisableExplicitGC

（5）减少每次minor gc晋升到old的对象。可选方法：1） 调大新生代。2）调大Survivor。3）调大TenuringThreshold。

  调大Survivor：当前采用PS GC，Survivor space会被动态调整。由于调整幅度很小，导致了经常有对象直接转移到了老生代；于是禁止Survivor区的动态调整了，-XX:-UseAdaptiveSizePolicy，并计算Survivor Space需要的大小，于是继续观察，并做微调…。最终将Full GC推迟到2小时1次。