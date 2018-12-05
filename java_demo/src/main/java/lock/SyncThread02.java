package lock;
/**
 * @author kate
 * @create 2018/12/3
 * @since 1.0.0
 */

/**
 * 修饰静态方法,作用于这个类的所有对象
 *
 *
 * @author huangxiaoqiu
 * @since 1.0.0
 */
public class SyncThread02 implements Runnable {
  private static int count;

  public SyncThread02() {
    count = 0;
  }

  public synchronized static void method() {
    for (int i = 0; i < 5; i ++) {
      try {
        System.out.println(Thread.currentThread().getName() + ":" + (count++));
        Thread.sleep(100);
      } catch (InterruptedException e) {
        e.printStackTrace();
      }
    }
  }

  @Override
  public  void run() {
    method();
  }

  public static void main (String[] args){
    SyncThread02 syncThread1 = new SyncThread02();
    SyncThread02 syncThread2 = new SyncThread02();
    Thread thread1 = new Thread(syncThread1, "SyncThread1");
    Thread thread2 = new Thread(syncThread2, "SyncThread2");
    thread1.start();
    thread2.start();
  }
}