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
        obj = [[TKCrashNilSafe alloc] init];
        obj.safeKVOType = TKCrashSafeKVOTypeCache;
        obj.enabledCrashLog = YES;
        obj.isAbortDebug = NO;
        obj.crashLogType = TKCrashNilSafeLogTypeCallStackSimple;
    });
    return obj;
}


- (BOOL)checkCrashNilSafeSwitch
{
    static dispatch_once_t onceToken;
    static BOOL isEnabled = YES;
    dispatch_once(&onceToken, ^{
#ifdef DEBUG
        NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
        NSString *value = info[@"TKCrashNilSafeSwitchDebug"];
        if (value) {
            isEnabled = [value boolValue];
        }
#else
        isEnabled = YES;
#endif
    });
    return  isEnabled;
}

- (BOOL)isAbortDebug
{
#ifdef DEBUG
    return _isAbortDebug;
#else
    return NO;
#endif
}

@end
