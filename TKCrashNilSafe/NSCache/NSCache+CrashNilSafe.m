//
//  NSCache+CrashNilSafe.m
//  NilSafeTest
//
//  Created by mac on 2019/10/15.
//  Copyright © 2019 mac. All rights reserved.
//

#import "NSCache+CrashNilSafe.h"
#import <objc/runtime.h>
#import "TKCrashNilSafe.h"



@implementation NSCache (CrashNilSafe)


/**
 函数交换通用入口
 */
+ (void)TKCrashNilSafe_SwapMethod
{
    if (!TKCrashNilSafe.share.isEnableInDebug) {
        return;
    }

    Class class = objc_getClass("NSCache");
    [class exchangeObjMethod:@selector(setObject:forKey:) withMethod:@selector(TKCrashNilSafe_setObject:forKey:)];
    [class exchangeObjMethod:@selector(setObject:forKey:cost:) withMethod:@selector(TKCrashNilSafe_setObject:forKey:cost:)];
}

- (void)TKCrashNilSafe_setObject:(id)obj forKey:(id)key
{
    if(key && obj){
        [self TKCrashNilSafe_setObject:obj forKey:key];
    }else{
        NSString *reason = [NSString stringWithFormat:@"-[%@ setObject:forKey:] ==>  nil argument",self.class];
        [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
    }
}

- (void)TKCrashNilSafe_setObject:(id)obj forKey:(id)key cost:(NSUInteger)g
{
    if (key && obj) {
        [self TKCrashNilSafe_setObject:obj forKey:key cost:g];
    }else{
        NSString *reason = [NSString stringWithFormat:@"-[%@ setObject:forKey:cost:] ==>  nil argument",self.class];
        [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
    }
}

@end
