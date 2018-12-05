
package lock;
/**
 * @author kate
 * @create 2018/12/2
 * @since 1.0.0
 */

/**
 * 修饰代码块，只作用于调用对象
 * @author huangxiaoqiu
 * @since 1.0.0
 */
public class SyncThread implements Runnable {

  private int count;

  public SyncThread() {
    count = 0;
  }

  @Override
  public void run() {
    synchronized (this) {
      for (int i = 0; i < 5; i++) {
        try {
          System.out.println(Thread.currentThread().getName() + ":" + (count++));
          Thread.sleep(100);
        } catch (InterruptedException e) {
          e.printStackTrace();
        }
      }
    }
  }

  public int getCount() {
    return count;
  }

  public static void main(String[] args){
    SyncThread syncThread = new SyncThread();
    //Thread thread1 = new Thread(syncThread, "SyncThread1");
    //Thread thread2 = new Thread(syncThread, "SyncThread2");


    Thread thread1 = new Thread(new SyncThread(), "SyncThread1");
    Thread thread2 = new Thread(new SyncThread(), "SyncThread2");


    thread1.start();
    thread2.start();

  }
}