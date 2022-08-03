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
    TKCrashNilSafe.share.isEnableInDebug   ==> YES开启，NO关闭
    
 */

NS_ASSUME_NONNULL_BEGIN


#define TKCrashNilSafeInitWithNull \
if (TKCrashNilSafe.share.isCrashInitWithNull) { \
    return  nil; \
}else{ \
    return [self init];\
}


/**
 Crash日志信息类型
 */
typedef NS_ENUM(NSUInteger, TKCrashNilSafeLogType){
    TKCrashNilSafeLogTypeOff             = 0, //关闭
    TKCrashNilSafeLogTypeSimple          = 1, //只解析异常信息
    TKCrashNilSafeLogTypeCallStackSimple = 2, //解析异常信息，并且处理堆栈信息定位到Crash位置，Default
    TKCrashNilSafeLogTypeCallStackFull   = 3, //解析异常信息，并且处理堆栈信息定位到Crash位置,并且将精简信息追加到CallStack数据的头部
    TKCrashNilSafeLogTypeCallStackOriginal = 4 //未处理的原始Crash堆栈信息
};


/**
 处理防止KVO重复添加、删除引起Crash时的safe处理模式。
 */
typedef NS_ENUM(NSUInteger, TKCrashNilSafeKVOType)
{
    TKCrashNilSafeKVOTypeCache = 0, //使用缓存KVO信息处理Crash问题, Default
    TKCrashNilSafeKVOTypeTry   = 1, //使用try crash的方式处理KVO Crash问题
    TKCrashNilSafeKVOTypeOff   = 2, //不使用KVO Crash Safe功能
};


//如果要收集异常日志, 请改该通知,提取崩溃信息信息
extern NSString * const kTKCrashNilSafeReceiveNotification;
//用于接收通知中的crash信息的key, ==> userinfo[key]
extern NSString * const kTKCrashNilSafeReceiveCrashInfoKey;



@interface TKCrashNilSafe : NSObject

/**
 在Debug模式下是否开启TKCrachNilSafe安全功能。默认YES。
 如果设置为NO,则在Debug模式下整个框架将无效。
 注意：需要在turnOnCrashNilSafe(函数交换之前)之前设置，才会生效。
 */
@property (nonatomic, assign) BOOL isEnableInDebug;
@property (nonatomic, assign) BOOL isAbortDebug;//在Debug模式下出现Crash时是否开启Abort()进行程序终端，default NO
@property (nonatomic, assign) BOOL enabledCrashLog;//是否在控制台中开启Crash信息, default YES
@property (nonatomic, assign) TKCrashNilSafeLogType crashLogType;//crash日志类型
@property (nonatomic, assign) TKCrashNilSafeKVOType safeKVOType;//default TKCrashNilSafeKVOCache
/**
 对象在使用initWithXX初始化方法出现crash时，返回null还是返回[self init]初始化的对象（即： 直接使用init初始化的空对象）.
 YES: return nil //会有内存泄露风险
 NO: return [self init]  //default
 */
@property (nonatomic, assign) BOOL isCrashInitWithNull;


+ (instancetype)share;
/** 打印crash信息 */
+ (void)TKCrashNilSafeLog:(NSString *)str;

/**
 开启TKCrashNilSafe安全交换功能。
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
 */
- (void)turnOnCrashNilSafe;

@end

NS_ASSUME_NONNULL_END
