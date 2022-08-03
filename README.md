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
    //v1.1
    可在info.plist文件中添加key:"TKCrashNilSafeSwitchDebug"  ==> YES开启，NO关闭    
    
    //v1.2+
    TKCrashNilSafe.share.isEnableInDebug   ==> YES开启，NO关闭

### 使用说明
1. 第一步导入：
```
#import "TKCrashNilSafe.h"
```
2. 使用：
```
v1.1：直接导入本框架即可
```
```
v1.2+：需要手动开启相关功能
开启TKCrashNilSafe安全交换功能
[TKCrashNilSafe.share turnOnCrashNilSafe]

说明：如果某个类不需要实现安全函数交换功能，可以再执行一次交换函数操作来还原。
 例如：禁用NSArray的的安全交换功能，可执行一次如下操作：
 SEL selector = NSSelectorFromString(@"TKCrashNilSafe_SwapMethod");
 if ([NSArray respondsToSelector:selector]) {
     [NSArray performSelector:selector];
 }


 //KVC，KVO，Selector三种类型的交换函数入口稍有不同：
 //KVC
 SEL selector_kvc = NSSelectorFromString(@"TKCrashNilSafe_SwapMethod_KVC");
 //KVO
 SEL selector_kvo = NSSelectorFromString(@"TKCrashNilSafe_SwapMethod_KVO");
 //Selector
 SEL selector_selector = NSSelectorFromString(@"TKCrashNilSafe_SwapMethod_Selector");

 if ([NSObject respondsToSelector:selector_XXX]) {
     [NSObject performSelector:selector_XXX];
 }
```




默认情况直接导入本框架即可，如果需要其它设置直接导入下列文件，查看其中的说明即可：
```
#import "TKCrashNilSafe.h"
```
可以通过添加通获取到Crash信息：
>
    Crash信息通知名称:
    kTKCrashNilSafeReceiveNotification    

    Notification中对应userInfo.key:
    kTKCrashNilSafeReceiveCrashInfoKey   
处理防止KVO重复添加、删除引起Crash时的safe处理模式:
>
    typedef NS_ENUM(NSUInteger, TKCrashNilSafeKVOType)
    {
        TKCrashNilSafeKVOTypeCache = 0, //使用缓存KVO信息处理Crash问题, Default
        TKCrashNilSafeKVOTypeTry   = 1, //使用try crash的方式处理KVO Crash问题
        TKCrashNilSafeKVOTypeOff   = 2, //不使用KVO Crash Safe功能
    };

Crash日志信息类型:
>
    typedef NS_ENUM(NSUInteger, TKCrashNilSafeLogType){
        TKCrashNilSafeLogTypeOff             = 0, //关闭
        TKCrashNilSafeLogTypeSimple          = 1, //只解析异常信息
        TKCrashNilSafeLogTypeCallStackSimple = 2, //解析异常信息，并且处理堆栈信息定位到Crash位置，Default
        TKCrashNilSafeLogTypeCallStackFull   = 3, //解析异常信息，并且处理堆栈信息定位到Crash位置,并且将精简信息追加到CallStack数据的头部
        TKCrashNilSafeLogTypeCallStackOriginal = 4 //未处理的原始Crash堆栈信息
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
    


### 支持的类型
```
NSObject+KVC
NSObject+KVO
NSObject+Selector
NSString
NSMutableString
NSAttributedString
NSMutableAttributedString
NSArray
NSMutableArray
NSDictionary
NSMutableDictionary
NSData
NSMutableData
NSMutableSet
NSOrderedSet
NSMutableOrderedSet
NSJSONSerialization
NSCache

```




### 其它
[NSObjectSafe](https://github.com/jasenhuang/NSObjectSafe)\
[AvoidCrash](https://github.com/chenfanfang/AvoidCrash)

