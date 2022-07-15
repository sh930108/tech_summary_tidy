#### 常用工具

java新特性
```
## list去重
1. 通过HashSet剔除重复元素
HashSet h = new HashSet(list);  
list.clear();  
list.addAll(h);

2. 用JDK1.8 Stream中对List进行去重：list.stream().distinct();
   
```









