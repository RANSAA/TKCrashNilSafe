//
//  TKCrashNilSafe.m
//  NilSafeTest
//
//  Created by PC on 2021/3/18.
//  Copyright © 2021 mac. All rights reserved.
//

#import "TKCrashNilSafe.h"

NSString * const kTKCrashNilSafeReceiveNotification     = @"kTKCrashNilSafeReceiveNotification"; //default
NSString * const kTKCrashNilSafeReceiveCrashInfoKey     = @"kTKCrashNilSafeReceiveCrashInfoKey"; //该标志下的Crash是不用abort中断的

@implementation TKCrashNilSafe

+ (instancetype)share
{
    static TKCrashNilSafe *obj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [super allocWithZone:NULL];
        obj.isEnableInDebug = YES;
        obj.enabledCrashLog = YES;
        obj.isAbortDebug = NO;
        obj.isCrashInitWithNull = NO;
        obj.safeKVOType = TKCrashNilSafeKVOTypeCache;
        obj.crashLogType = TKCrashNilSafeLogTypeCallStackSimple;
    });
    return obj;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    return self.share;
}

- (BOOL)isEnableInDebug
{
#ifdef DEBUG
    return _isEnableInDebug;
#else
    return YES;
#endif
}

- (BOOL)isAbortDebug
{
#ifdef DEBUG
    return _isAbortDebug;
#else
    return NO;
#endif
}

- (BOOL)enabledCrashLog
{
#ifdef DEBUG
    return _enabledCrashLog;
#else
    return NO;
#endif
}


// MARK: - funcation
/** 打印crash信息 */
+ (void)TKCrashNilSafeLog:(NSString *)str
{
    if (TKCrashNilSafe.share.enabledCrashLog) {
        printf("%s\n",[str UTF8String]);
    }
}



// MARK: - 开启TKCrashNilSafe安全交换功能

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
- (void)turnOnCrashNilSafe
{
    if (TKCrashNilSafe.share.isEnableInDebug) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            SEL selector = NSSelectorFromString(@"TKCrashNilSafe_SwapMethod");

            if ([NSArray respondsToSelector:selector]) {
                [NSArray performSelector:selector];
            }
            if ([NSMutableArray respondsToSelector:selector]) {
                [NSMutableArray performSelector:selector];
            }

            if ([NSAttributedString respondsToSelector:selector]) {
                [NSAttributedString performSelector:selector];
            }
            if ([NSMutableAttributedString respondsToSelector:selector]) {
                [NSMutableAttributedString performSelector:selector];
            }

            if ([NSCache respondsToSelector:selector]) {
                [NSCache performSelector:selector];
            }

            if ([NSData respondsToSelector:selector]) {
                [NSData performSelector:selector];
            }
            if ([NSMutableData respondsToSelector:selector]) {
                [NSMutableData performSelector:selector];
            }

            if ([NSDictionary respondsToSelector:selector]) {
                [NSDictionary performSelector:selector];
            }
            if ([NSMutableDictionary respondsToSelector:selector]) {
                [NSMutableDictionary performSelector:selector];
            }

            if ([NSJSONSerialization respondsToSelector:selector]) {
                [NSJSONSerialization performSelector:selector];
            }

            if ([NSMutableSet respondsToSelector:selector]) {
                [NSMutableSet performSelector:selector];
            }
            if ([NSOrderedSet respondsToSelector:selector]) {
                [NSOrderedSet performSelector:selector];
            }
            if ([NSMutableOrderedSet respondsToSelector:selector]) {
                [NSMutableOrderedSet performSelector:selector];
            }

            if ([NSString respondsToSelector:selector]) {
                [NSString performSelector:selector];
            }
            if ([NSMutableString respondsToSelector:selector]) {
                [NSMutableString performSelector:selector];
            }

            SEL selector_kvc = NSSelectorFromString(@"TKCrashNilSafe_SwapMethod_KVC");
            if ([NSObject respondsToSelector:selector_kvc]) {
                [NSObject performSelector:selector_kvc];
            }

            SEL selector_kvo = NSSelectorFromString(@"TKCrashNilSafe_SwapMethod_KVO");
            if ([NSObject respondsToSelector:selector_kvo]) {
                [NSObject performSelector:selector_kvo];
            }

            SEL selector_selector = NSSelectorFromString(@"TKCrashNilSafe_SwapMethod_Selector");
            if ([NSObject respondsToSelector:selector_selector]) {
                [NSObject performSelector:selector_selector];
            }

        });
    }

}

@end
