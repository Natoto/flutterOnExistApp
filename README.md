 
# flutterOnExistApp 现有工程中添加flutter

##热更方案，实现插件化demo (需要flutter 1.0)，见[multiflutter分支](https://github.com/Natoto/flutterOnExistApp/tree/multiflutter) 

##修复版本产物 下载地址 https://github.com/Natoto/fixFlutterEngine 

### 进度实时更新qq群聊【flutter移动开发】：217429001

flutter添加到iOS主工程例子 

# 默认目前只支持arm64版本，其他版本请联系群主单独构建

更新日志：

* 5.21 1.5.4 hot-fix版内存引用修复
* 5.21 1.2 demo更新使用前执行 `pre_ci_build.sh`
* 3.4   解决1.2 flutter 内存问题
* 12.28 更新1.0版本内存问题，产物在 https://github.com/Natoto/fixFlutterEngine 
* 11.28 更新了methodchannel的循环引用
* 最新版本0.11.9官方号称解决了循环引用，然而在多插件情况下，还是有泄漏

---
流程

1. 下载对应的flutter版本 flutter.io， 1.5的flutter对应1.5的engine

2. 在现有iOS工程基础上添加flutter,参考本demo例子

3. 将编译产物Flutter.framework.zip， 在工程Resource目录下

4. 在执行build脚本之后，添加自己的脚本，将Flutter.framework.zip解压出来，并替换掉之前编译的产物Flutter.framework

5. 重新执行`flutter packages get` `flutter build ios --debug` 

6. 使用真机调试

---
为什么要替换Flutter.framework,本版本解决了以下问题

* 官方版本存在内存泄漏问题，打开了就不支持释放
* 不支持动态化方案
* 不支持动态下发脚本代码（flutter ios热更新）

### flutter engine构建产物下载地址
https://github.com/Natoto/fixFlutterEngine 



### 教程见 [《手把手教你编译Flutter engine》](https://juejin.im/post/5c24acd5f265da6164141236)