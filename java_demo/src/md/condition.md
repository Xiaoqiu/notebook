#### 概况

在java.util.concurrent包中，有两个很特殊的工具类，
Condition和ReentrantLock，使用过的人都知道，
ReentrantLock（重入锁）是jdk的concurrent包提供的一种独占锁的实现。
它继承自Dong Lea的 AbstractQueuedSynchronizer（同步器），
确切的说是ReentrantLock的一个内部类继承了AbstractQueuedSynchronizer，
ReentrantLock只不过是代理了该类的一些方法，可能有人会问为什么要使用内部类在包装一层？ 
我想是安全的关系，因为AbstractQueuedSynchronizer中有很多方法，还实现了共享锁，
Condition(稍候再细说)等功能，如果直接使ReentrantLock继承它，
则很容易出现AbstractQueuedSynchronizer中的API被无用的情况。

#### Condition工具类的实现
ReentrantLock和Condition的使用方式通常是这样的：
```java
public static void main(String[] args) {
    final ReentrantLock reentrantLock = new ReentrantLock();
    final Condition condition = reentrantLock.newCondition();
 
    Thread thread = new Thread((Runnable) () -> {
            try {
                reentrantLock.lock();
                System.out.println("我要等一个新信号" + this);
                condition.wait();
            }
            catch (InterruptedException e) {
                e.printStackTrace();
            }
            System.out.println("拿到一个信号！！" + this);
            reentrantLock.unlock();
    }, "waitThread1");
 
    thread.start();
     
    Thread thread1 = new Thread((Runnable) () -> {
            reentrantLock.lock();
            System.out.println("我拿到锁了");
            try {
                Thread.sleep(3000);
            }
            catch (InterruptedException e) {
                e.printStackTrace();
            }
            condition.signalAll();
            System.out.println("我发了一个信号！！");
            reentrantLock.unlock();
    }, "signalThread");
     
    thread1.start();
}
```
运行后，结果如下：
```java
我要等一个新信号lock.ReentrantLockTest$1@a62fc3
我拿到锁了
我发了一个信号！！
拿到一个信号！！
```
可以看到，
Condition的执行方式，是当在线程1中调用await方法后，线程1将释放锁，并且将自己沉睡，等待唤醒，

线程2获取到锁后，开始做事，完毕后，调用Condition的signal方法，唤醒线程1，线程1恢复执行。

以上说明Condition是一个多线程间协调通信的工具类，使得某个，或者某些线程一起等待某个条件（Condition）,
只有当该条件具备( signal 或者 signalAll方法被带调用)时 ，这些等待线程才会被唤醒，从而重新争夺锁。

那，它是怎么实现的呢？

首先还是要明白，reentrantLock.newCondition() 返回的是Condition的一个实现，
该类在AbstractQueuedSynchronizer中被实现，叫做newCondition()
```java
public Condition newCondition()   { return sync.newCondition(); }
```

它可以访问AbstractQueuedSynchronizer中的方法和其余内部类
（AbstractQueuedSynchronizer是个抽象类，至于他怎么能访问，这里有个很奇妙的点，后面我专门用demo说明 ）

现在，我们一起来看下Condition类的实现，还是从上面的demo入手，

为了方便书写，我将AbstractQueuedSynchronizer缩写为AQS

当await被调用时，代码如下：
```java
public final void await() throws InterruptedException {
    if (Thread.interrupted())
        throw new InterruptedException();
    Node node = addConditionWaiter(); // 将当前线程包装下后，
                                      // 添加到Condition自己维护的一个链表中。
    int savedState = fullyRelease(node);// 释放当前线程占有的锁，从demo中看到，
                                        // 调用await前，当前线程是占有锁的
 
    int interruptMode = 0;
    while (!isOnSyncQueue(node)) {// 释放完毕后，遍历AQS的队列，看当前节点是否在队列中，
        // 不在 说明它还没有竞争锁的资格，所以继续将自己沉睡。
        // 直到它被加入到队列中，聪明的你可能猜到了，
        // 没有错，在singal的时候加入不就可以了？
        LockSupport.park(this);
        if ((interruptMode = checkInterruptWhileWaiting(node)) != 0)
            break;
    }
    // 被唤醒后，重新开始正式竞争锁，同样，如果竞争不到还是会将自己沉睡，等待唤醒重新开始竞争。
    if (acquireQueued(node, savedState) && interruptMode != THROW_IE)
        interruptMode = REINTERRUPT;
    if (node.nextWaiter != null)
        unlinkCancelledWaiters();
    if (interruptMode != 0)
        reportInterruptAfterWait(interruptMode);
}
```




















