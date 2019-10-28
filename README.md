# TKCrashNilSafe
### 简介
防止NSArray，NSDictionary，,KVO重复移出，unrecognized selectord等错误操作引起的奔溃问题
\
通过添加通知：kCrashNilSafeNotification可以获取异常信息（取值：crashInfo）
\
### 用法
直接使用：
\
> pod 'TKCrashNilSafe'
\
导入项目中即可。
\
\
也可以按照需求模块引入，使用
> pod 'TKCrashNilSafe/xxxx'

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



