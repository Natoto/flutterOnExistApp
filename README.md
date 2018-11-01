# 插件化方案个分支multiflutter

流程

1. 在现有iOS工程基础上添加flutter

2. 将编译产物Flutter.framework.zip至于工程Resource目录下

3. 在执行build脚本之后，添加自己的脚本，将Flutter.framework.zip解压出来，并替换掉之前编译的产物Flutter.framework

4. 结束


---
为什么要替换Flutter.framework

0.9.4版本存在内存泄漏问题，打开了就不支持释放
不支持动态化方案
不支持动态下发脚本代码
