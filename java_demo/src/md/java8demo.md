#### JAVA8 教程

#### 默认方法
```java
    interface Formula {
      double calculate(int a);
      default double sqrt(int a){
        return Math.sqrt(a);
      }
    }
    

```
使用:只需要实现抽象方法，默认方法可以被直接调用
```java
    Formula formula = new Formula(){
      @Override
      public double calculate(int a){
        return sqrt(a * 100);
      }
    }
    formula.calculate(100) //100.0
    formula.sqrt(16) //4.0
```
#### Lambda expressions
使用旧版本Java来给一个列表排序：
````java
    List<String> names = Arrays.asList("peter","anna","mike","xenia")
    Co
````