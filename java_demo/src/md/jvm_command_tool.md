# JVM性能调优监控工具jps、jstack、jmap、jhat、jstat、hprof使用详解

# 1. jps(Java Virtual Machine Process Status Tool)      

# 2. jstack

# 3. jmap（Memory Map）和jhat（Java Heap Analysis Tool）

# 4. jstat（JVM统计监测工具）

# 5. hprof（Heap/CPU Profiling Tool）
hprof能够展现CPU使用率，统计堆内存使用情况。
语法格式：
```bash

```
完整的命令选项如下：
```bash

```
来几个官方指南上的实例。
 CPU Usage Sampling Profiling(cpu=samples)的例子：
 ```bash
java -agentlib:hprof=cpu=sample,interval=20,depth=3 Hello
```

 上面每隔20毫秒采样CPU消耗信息，堆栈深度为3，生成的profile文件名称是java.hprof.txt，在当前目录。
 CPU Usage Times Profiling(cpu=times)的例子，它相对于CPU Usage Sampling Profile能够获得更加细粒度的CPU消耗信息，能够细到每个方法调用的开始和结束，它的实现使用了字节码注入技术（BCI）：
 ```bash
javac -J-agentlib:hprof=cpu=times Hello.java
```
 Heap Allocation Profiling(heap=sites)的例子：
 
 ```bash
javac -J-agentlib:hprof=heap=sites Hello.java
```
Heap Dump(heap=dump)的例子，它比上面的Heap Allocation Profiling能生成更详细的Heap Dump信息：

```bash
javac -J-agentlib:hprof=heap=dump Hello.java
```
虽然在JVM启动参数中加入-Xrunprof:heap=sites参数可以生成CPU/Heap Profile文件，但对JVM性能影响非常大，不建议在线上服务器环境使用。

 # 参考
 - jconsole: https://docs.oracle.com/javase/1.5.0/docs/guide/management/jconsole.html
 - Troubleshooting Guide for Java SE 6 with HotSpot VM : https://www.oracle.com/technetwork/java/javase/tsg-vm-149989.pdf
 - Java VisualVM : https://docs.oracle.com/javase/7/docs/technotes/guides/visualvm/
 - Monitoring and Managing Java SE 6 Platform Applications: https://www.oracle.com/technetwork/articles/javase/monitoring-141801.html