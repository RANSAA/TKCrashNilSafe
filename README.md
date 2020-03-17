# TKCrashNilSafe
### 简介
防止NSArray，NSDictionary，,KVO重复移出，unrecognized selectord等错误操作引起的奔溃问题。
\
\
PS:
\
   该项目能够捕获大部分的异常信息，并且可以进行放置程序崩溃，与腾讯的Bugly不同，Bugly是收集奔溃信息，但不会进行处理。而当前项目回进行补救处理，但是并不是最优的方法，只是起到一个程序出错时，简单的异常处理。正确的做法是，需要用户根据这些提示信息进行修改！
\
\
如何获取异常信息：
\
            通过添加通知：kTKCrashNilSafeCheckNotification即可获取异常信息，提取通知信息中的：error 字段即可获取。
            \
            

### 用法
>直接使用：
\
> pod 'TKCrashNilSafe'
\
导入项目中即可。
\
也可以按照需求模块引入，使用:
\
> pod 'TKCrashNilSafe/xxxx'
>
>

### KVO
在使用KVO防Crash时，稍微注意下，即处理重复添加keyPath时，有多重模式。
\
可以根据需求修改类型，文件：NSObject+CrashNilSafe.h
```

/**
KVO重复添加处理控制宏，可以根据需求设置对应模式
0:不处理重复添加
1:处理重复添加，只校验observer和keyPath --该项为默认
2:处理重复添加，检查所有：observer，keyPath，options，context（手动管理KVO信息）
**/

#define kCrashNilSafeCheckKVOAddType    1

```

### 注意：
容器类通过initWithObjects:count:创建对象时，不能完全避免Carch，用户可以在使用之前，先进行条件判断。



