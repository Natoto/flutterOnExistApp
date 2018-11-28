# flutterOnExistApp 现有工程中添加flutter

# 改造官方flutter engine，实现插件化，见[multiflutter分支](https://github.com/Natoto/flutterOnExistApp/tree/multiflutter) 

flutter添加到iOS主工程例子

0.9.4 有更新

Flutter目录里面的App.framework和Flutter.framework指向的是  

Flutter/App.framework  ----->  `myflutter/.ios/Flutter/App.framework`

Flutter/Flutter.framework  ----->  `myflutter/.ios/Flutter/engine/App.framework`


Flutter/flutter_assets  ----->  `myflutter/.ios/Flutter/flutter_assets`

另外移除了podfile里面的
```
    #flutter_application_path = 'myflutter'
    #eval(File.read("#{flutter_application_path}/.ios/Flutter/podhelper.rb"))
```

将`GeneratedPluginRegistrant.h` `GeneratedPluginRegistrant.m` 拷贝到futter目录并引入工程
