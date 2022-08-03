//
//  NSJSONSerialization+TKCrashNilSafe.m
//  NilSafeTest
//
//  Created by PC on 2021/3/20.
//  Copyright © 2021 mac. All rights reserved.
//

#import "NSJSONSerialization+TKCrashNilSafe.h"
#import "TKCrashNilSafe.h"
#import <objc/runtime.h>

@implementation NSJSONSerialization (TKCrashNilSafe)


/**
 函数交换通用入口
 */
+ (void)TKCrashNilSafe_SwapMethod
{
    if (!TKCrashNilSafe.share.isEnableInDebug) {
        return;
    }

    [self exchangeClassMethod:@selector(JSONObjectWithData:options:error:) withMethod:@selector(TKCrashNilSafe_JSONObjectWithData:options:error:)];
    [self exchangeClassMethod:@selector(dataWithJSONObject:options:error:) withMethod:@selector(TKCrashNilSafe_dataWithJSONObject:options:error:)];
}



+ (nullable id)TKCrashNilSafe_JSONObjectWithData:(NSData *)data options:(NSJSONReadingOptions)opt error:(NSError *__autoreleasing  _Nullable *)error
{
    if (data) {
        if ([data isKindOfClass:NSData.class]) {
            return [self TKCrashNilSafe_JSONObjectWithData:data options:opt error:error];
        }else{
            NSString *reason = [NSString stringWithFormat:@"+[%@ JSONObjectWithData:options:error:] ==> The value type added must be NSData; The current type is:%@",self.class,data.class];
            [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
            return  nil;
        }
    }else{
        NSString *reason = [NSString stringWithFormat:@"+[%@ JSONObjectWithData:options:error:] ==> data connot nil",self.class];
        [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
        return Nil;
    }
}

+ (nullable NSData*)TKCrashNilSafe_dataWithJSONObject:(id)obj options:(NSJSONWritingOptions)opt error:(NSError *__autoreleasing  _Nullable *)error
{
    if (obj) {
        return [self TKCrashNilSafe_dataWithJSONObject:obj options:opt error:error];
    }else{
        NSString *reason = [NSString stringWithFormat:@"+[%@ dataWithJSONObject:options:error:] ==> object connot nil",self.class];
        [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
        return nil;
    }
}

@end
