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
    List<String> names = Arrays.asList("perter","anna","mike","xenia");
    Collections.sort(names,new Comparator<String>(){
      @Override
      public int compare(String a, String b) {
        return b.compareTo(a);
      }
    });
````
静态方法 Collections.sort 接收一个列表和一个comparator参数，
给列表里面的元素排序，经常需要通过创建匿名的comparator方式和传递列表参数的方式排序
#### 1 lambda表达式
- `lambda expressions`能用更简单的语法实现，而不需要创建那么多匿名对象
```java
    Collections.sort(names,(String a, String b) -> {
      return b.compareTo(a);
    });
```
- 还有更简洁的方式：
```java
   Collections.sort(names,(String a, String b) -> b.compareTo(a));
```
- 对于一行的方法体，你可以不需要{}和return,但是还有更加极端简洁的方式
```java
    Collections.sort(names,(a,b) -> b.compareTo(a));
```
- 编译器可以自动识别类型，后面详细说一下lambda expressions   

#### 2 Functional Interfaces 函数接口
- 每个函数接口都至少包含一个抽象方法
- 每个lambda表达式对应一个类型，这个类型是由接口定义的
- 每个lambda表达式对应一个抽象方法
- 默认方法是不需要实现的，可以加到函数接口
```java
      @FunctionalInterface //添加第二个抽象方法，没有这个注解会报错
      interface Converter<F,T>{
        T convert(F from);
      }
```
```java
  Converter<String,Integer> converter = (from) -> Integer.valueOf(from);
  Integer converted = converter.convert("123");
  System.out.println(converted);
```
#### 3 Method and Constructor References
- 上面的例子可以进一步简化，构造静态方法引用的方式

 ```java
    Converter<String,Integer> converter1 = Integer::valueOf;
    Integer converted1 = converter1.convert("123");
    System.out.println(converted);
```
- java8 通过::传递方法引用或者构造器。
- 上面的例子显示怎么引用一个静态方法，
- 但是我们也可以引用对象方法
```java
    class Something {
      String startWith(String s){
        return String.valueOf(s.charAt(0));
      }
    }
    //调用一个类的方法来实现函数接口Converter
    Something something = new Something();
    Converter<String,String> converter2 = something::startWith;
    String converted2 = converter2.convert("java");
    System.out.println(converted);
```
#### 4 Lambda Scopes 作用域
- 获取final的本地变量
```java
    final int num = 1;
    Converter<Integer,String> stringConverter =
        (from) -> String.valueOf(from + num);
    stringConverter.convert(2); //3
```

- 不同于匿名对象，变量num不需要声明为final
```java
    int num2 = 1;
    Converter<Integer,String> stringConverter1 =
        (from -> String.valueOf(from + num2))
    stringConverter.convert(2); //3
```
- 注意：num是隐性的final, 下面的代码编译就会报错
```java
     int num2 = 1;
     Converter<Integer,String> stringConverter1 =
     (from -> String.valueOf(from + num2))
      num = 3;
```
- 下面我们看个例子::是怎么调用构造器的。
- 首先，我们定义个例子有不同的构造方法的

```java
class Person {
    String firstName;
    String lastName;
    Person(){}
    Person(String firstName, String lastName){
      this.firstName = firstName;
      this.lastName = lastName;
    }
  }

  interface PersonFactory<P extends Person>{
    P create(String firstName, String lastName);
  }
```
```java
    PersonFactory<Person> personFactory = Person::new;
    Person person = personFactory.create("perter","parker");
```

- 我们创建了一个引用到Person构造器通过Person::new，编译器会
- 自动选择正确的构造器根据personFactory.create这个方法的参数






