//
//  NSObject+CrashNilSafeKVC.m
//  NilSafeTest
//
//  Created by PC on 2021/3/18.
//  Copyright © 2021 mac. All rights reserved.
//

#import "NSObject+CrashNilSafeKVC.h"
#import "TKCrashNilSafe.h"


@implementation NSObject (CrashNilSafeKVC)

/**
 函数交换通用入口
 */
+ (void)TKCrashNilSafe_SwapMethod_KVC
{
    if (!TKCrashNilSafe.share.isEnableInDebug) {
        return;
    }

    [self exchangeObjMethod:@selector(setValue:forUndefinedKey:) withMethod:@selector(TKCrashNilSafe_setValue:forUndefinedKey:)];
    [self exchangeObjMethod:@selector(setNilValueForKey:) withMethod:@selector(TKCrashNilSafe_setNilValueForKey:)];
}

#pragma mark NSObject通用处理
//解决kvc时key为nil的异常
- (void)TKCrashNilSafe_setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSString *reason = [NSString stringWithFormat:@"-[setValue:forUndefinedKey:] ==> error info: object:%@  key:%@  value:%@",self,key,value];
    [self handleErrorWithName:TKCrashNilSafeExceptionNoAbort mark:reason];
}

- (void)TKCrashNilSafe_setNilValueForKey:(NSString *)key
{
    NSString *reason = [NSString stringWithFormat:@"-[setNilValueForKey:] ==> error info: object:%@  key:%@",self,key];
    [self handleErrorWithName:TKCrashNilSafeExceptionNoAbort mark:reason];
}

@end
