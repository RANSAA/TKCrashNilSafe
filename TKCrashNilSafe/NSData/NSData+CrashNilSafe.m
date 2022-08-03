//
//  NSData+CrashNilSafe.m
//  NilSafeTest
//
//  Created by mac on 2019/10/15.
//  Copyright © 2019 mac. All rights reserved.
//

#import "NSData+CrashNilSafe.h"
#import "TKCrashNilSafe.h"
#import <objc/runtime.h>

@implementation NSData (CrashNilSafe)

/**
 函数交换通用入口
 */
+ (void)TKCrashNilSafe_SwapMethod
{
    if (!TKCrashNilSafe.share.isEnableInDebug) {
        return;
    }

    Class class = objc_getClass("_NSPlaceholderData");
    [class exchangeObjMethod:@selector(initWithBase64EncodedData:options:) withMethod:@selector(TKCrashNilSafe_initWithBase64EncodedData:options:)];
    [class exchangeObjMethod:@selector(initWithBase64EncodedString:options:) withMethod:@selector(TKCrashNilSafe_initWithBase64EncodedString:options:)];
}


- (instancetype)TKCrashNilSafe_initWithBase64EncodedData:(NSData *)base64Data options:(NSDataBase64DecodingOptions)options
{
    if (base64Data) {
        if ([base64Data isKindOfClass:NSData.class]) {
            return  [self TKCrashNilSafe_initWithBase64EncodedData:base64Data options:options];
        }else{
            NSString *reason = [NSString stringWithFormat:@"-[%@ initWithBase64EncodedData:options:] ==> The value type added must be NSData; The current type is:%@",self.class,base64Data.class];
            [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
            TKCrashNilSafeInitWithNull
        }
    }else{
        NSString *reason = [NSString stringWithFormat:@"-[%@ initWithBase64EncodedData:options:] ==> base64Data connot nil",self.class];
        [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
        TKCrashNilSafeInitWithNull
    }
}

- (instancetype)TKCrashNilSafe_initWithBase64EncodedString:(NSString *)base64String options:(NSDataBase64DecodingOptions)options
{
    if (base64String) {
        if ([base64String isKindOfClass:NSString.class]) {
            return  [self TKCrashNilSafe_initWithBase64EncodedString:base64String options:options];
        }else{
            NSString *reason = [NSString stringWithFormat:@"-[%@ initWithBase64EncodedString:options:] ==> The value type added must be NSString; The current type is:%@",self.class,base64String.class];
            [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
            TKCrashNilSafeInitWithNull
        }
    }else{
        NSString *reason = [NSString stringWithFormat:@"-[%@ initWithBase64EncodedString:options:] ==> base64String connot nil",self.class];
        [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
        TKCrashNilSafeInitWithNull
    }
}

@end


@implementation NSMutableData (CrashNilSafe)


/**
 函数交换通用入口
 */
+ (void)TKCrashNilSafe_SwapMethod
{
    if (!TKCrashNilSafe.share.isEnableInDebug) {
        return;
    }

    Class class = objc_getClass("NSConcreteMutableData");
    [class exchangeObjMethod:@selector(initWithBase64EncodedData:options:) withMethod:@selector(TKCrashNilSafe_initWithBase64EncodedData:options:)];
    [class exchangeObjMethod:@selector(initWithBase64EncodedString:options:) withMethod:@selector(TKCrashNilSafe_initWithBase64EncodedString:options:)];
}

@end
