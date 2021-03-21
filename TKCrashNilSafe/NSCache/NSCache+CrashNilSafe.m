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

+ (void)load
{
    if (TKCrashNilSafe.share.checkCrashNilSafeSwitch) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            Class class = objc_getClass("NSCache");
            [class exchangeObjMethod:@selector(setObject:forKey:) withMethod:@selector(safe_setObject:forKey:)];
            [class exchangeObjMethod:@selector(setObject:forKey:cost:) withMethod:@selector(safe_setObject:forKey:cost:)];
        });
    }
}

- (void)safe_setObject:(id)obj forKey:(id)key
{
    if(key && obj){
        [self safe_setObject:obj forKey:key];
    }else{
        NSString *reason = [NSString stringWithFormat:@"-[%@ setObject:forKey:] ==>  nil argument",self.class];
        [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
    }
}

- (void)safe_setObject:(id)obj forKey:(id)key cost:(NSUInteger)g
{
    if (key && obj) {
        [self safe_setObject:obj forKey:key cost:g];
    }else{
        NSString *reason = [NSString stringWithFormat:@"-[%@ setObject:forKey:cost:] ==>  nil argument",self.class];
        [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
    }
}

@end
