//
//  TKCrashNilSafe.h
//  NilSafeTest
//
//  Created by PC on 2021/3/18.
//  Copyright © 2021 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+TKSafeCore.h"

/**
 该文件是TKCrashNilSafe的配置文件，主要提供实现交换函数功能，精简化奔溃信息。
 
提示：
    TKCrashNilSafe的功能是处理一些列Crash引起的奔溃问题，引起Crash的原因主要是数据错误，所以并不能正真解决数据错误问题。
所以：
    Relese模式模式下不用说肯定要开启的。
    Debug模式下建议关闭TKCrashNilSafe功能，这要才可以在开发中解决这些crash问题，手动开启/关闭。
关闭方法：
    可在info.plist文件中添加key:"TKCrashNilSafeSwitchDebug"  ==> YES开启，NO关闭
    
 */

NS_ASSUME_NONNULL_BEGIN


//Crash日志类型，级别越高处理堆栈信息越耗时间
typedef NS_ENUM(NSUInteger, TKCrashNilSafeLogType){
    TKCrashNilSafeLogTypeOff             = 0, //关闭
    TKCrashNilSafeLogTypeSimple          = 1, //只解析异常信息
    TKCrashNilSafeLogTypeCallStackSimple = 2, //解析异常信息，并且处理堆栈信息定位到Crash位置，Default
    TKCrashNilSafeLogTypeCallStackFull   = 3, //解析异常信息，并且处理堆栈信息定位到Crash位置,并且将精简信息追加到CallStack数据的头部
};

//处理设置防KVO重复添加，删除引起Crash的safe模式
typedef NS_ENUM(NSUInteger, TKCrashSafeKVOType)
{
    TKCrashSafeKVOTypeCache = 0, //使用缓存KVO信息处理Crash问题
    TKCrashSafeKVOTypeTry   = 1, //使用try crash的方式处理KVO Crash问题
    TKCrashSafeKVOTypeOff   = 2, //不使用KVO Crash Safe功能
};


//如果要收集异常日志, 请改该通知,提取崩溃信息信息
extern NSString * const kTKCrashNilSafeReceiveNotification;
//用于接收通知中的crash信息的key, ==> userinfo[key]
extern NSString * const kTKCrashNilSafeReceiveCrashInfoKey;



@interface TKCrashNilSafe : NSObject
/**
 功能:从info.plist文件中检测是否开启TKCrachNilSafe
 Relese模式:默认开启，并且不可修改
 Debug 模式:默认开启，可在info.plist文件中添加key:"TKCrashNilSafeSwitchDebug"  ==> YES开启，NO关闭
 */
@property (nonatomic, assign, readonly) BOOL checkCrashNilSafeSwitch;
@property (nonatomic, assign) BOOL isAbortDebug;//在Debug模式下出现Crash时是否开启Abort()进行程序终端，default NO
@property (nonatomic, assign) BOOL enabledCrashLog;//是否在控制台中开启Crash信息, default YES
@property (nonatomic, assign) TKCrashNilSafeLogType crashLogType;//crash日志类型
@property (nonatomic, assign) TKCrashSafeKVOType safeKVOType;//default TKCrashSafeKVOCache

+ (instancetype)share;

@end

NS_ASSUME_NONNULL_END
