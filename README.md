# TKCrashNilSafe
### 功能介绍
解决iOS因数据异常，unrecognized selectord等错误而引起的Crash奔溃处理工具。

### 配置
TKCrashNilSafe的功能是处理一些列Crash引起的奔溃问题，引起Crash的原因主要是数据错误，所以并不能正真解决数据错误问题。\
所以：
>
    Relese:模式模式下不用说肯定要开启的。
    
    Debug:模式下建议关闭TKCrashNilSafe功能，这要才可以在开发中解决这些crash问题，手动开启/关闭。
关闭方法：
>
    可在info.plist文件中添加key:"TKCrashNilSafeSwitchDebug"  ==> YES开启，NO关闭    

### 使用说明
默认情况直接导入本框架即可，如果需要其它设置直接导入下列文件，查看其中的说明即可：
```
#import "TKCrashNilSafe.h"
```
可以通过添加通获取到Crash信息：
>
    通知名称:
    kTKCrashNilSafeReceiveNotification    

    对应userInfo.key:
    kTKCrashNilSafeReceiveCrashInfoKey   
处理设置防KVO重复添加，删除引起Crash的safe模式:
>
    typedef NS_ENUM(NSUInteger, TKCrashSafeKVOType)
    {
          TKCrashSafeKVOTypeCache = 0, //使用缓存KVO信息处理Crash问题
          TKCrashSafeKVOTypeTry   = 1, //使用try crash的方式处理KVO Crash问题
          TKCrashSafeKVOTypeOff   = 2, //不使用KVO Crash Safe功能
    };

Crash日志类型，级别越高处理堆栈信息越耗时间:
>
    typedef NS_ENUM(NSUInteger, TKCrashNilSafeLogType){
        TKCrashNilSafeLogTypeOff             = 0, //关闭
        TKCrashNilSafeLogTypeSimple          = 1, //只解析异常信息
        TKCrashNilSafeLogTypeCallStackSimple = 2, //解析异常信息，并且处理堆栈信息定位到Crash位置，Default
        TKCrashNilSafeLogTypeCallStackFull   = 3, //解析异常信息，并且处理堆栈信息定位到Crash位置,并且将精简信息追加到CallStack数据的头部
    };

### 导入
 
全部导入:
>
    pod 'TKCrashNilSafe'

按需导入:
>
    pod 'TKCrashNilSafe/KVC'
    pod 'TKCrashNilSafe/KVO'
    pod 'TKCrashNilSafe/Selector'
    pod 'TKCrashNilSafe/NSArray'
    pod 'TKCrashNilSafe/NSDictionary'
    pod 'TKCrashNilSafe/NSSet'
    pod 'TKCrashNilSafe/NSString'
    pod 'TKCrashNilSafe/NSAttributedString'
    pod 'TKCrashNilSafe/NSJSONSerialization'
    pod 'TKCrashNilSafe/NSData'
    pod 'TKCrashNilSafe/NSCache'
    


### 参考
1. https://github.com/jasenhuang/NSObjectSafe

