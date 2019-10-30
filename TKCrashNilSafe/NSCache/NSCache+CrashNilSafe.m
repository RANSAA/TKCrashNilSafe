//
//  NSCache+CrashNilSafe.m
//  NilSafeTest
//
//  Created by mac on 2019/10/15.
//  Copyright © 2019 mac. All rights reserved.
//

#import "NSCache+CrashNilSafe.h"
#import <objc/runtime.h>


@implementation NSCache (CrashNilSafe)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = objc_getClass("NSCache");
        [class TK_exchangeMethod:@selector(setObject:forKey:) withMethod:@selector(tk_setObject:forKey:)];
        [class TK_exchangeMethod:@selector(setObject:forKey:cost:) withMethod:@selector(tk_setObject:forKey:cost:)];
    });
}

- (void)tk_setObject:(id)obj forKey:(id)key
{
    if(key&&obj){
        [self tk_setObject:obj forKey:key];
        return;
    }
    NSString *tips = [NSString stringWithFormat:@"⚠️⚠️NSCache ==> setObject:forKey:错误， obj:%@  key:%@",obj,key];
    [self noteErrorWithException:nil defaultToDo:tips];
}

- (void)tk_setObject:(id)obj forKey:(id)key cost:(NSUInteger)g
{
    if (key && obj) {
        [self tk_setObject:obj forKey:key cost:g];
        return;
    }
    NSString *tips = [NSString stringWithFormat:@"⚠️⚠️NSCache ==> setObject:forKey:cost:错误， obj:%@  key:%@  cost:%ld",obj,key,g];
    [self noteErrorWithException:nil defaultToDo:tips];
}

@end
