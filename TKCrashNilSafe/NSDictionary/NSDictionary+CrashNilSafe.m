//
//  NSDictionary+CrashNilSafe.m
//  NilSafeTest
//
//  Created by mac on 2019/9/27.
//  Copyright © 2019 mac. All rights reserved.
//

#import "NSDictionary+CrashNilSafe.h"
#import <objc/runtime.h>


@implementation NSDictionary (CrashNilSafe)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self TK_exchangeMethod:@selector(initWithObjects:forKeys:count:) withMethod:@selector(tk_initWithObjects:forKeys:count:)];
        [self TK_exchangeClassMethod:@selector(dictionaryWithObjects:forKeys:count:) withMethod:@selector(tk_dictionaryWithObjects:forKeys:count:)];
    });
}

+ (instancetype)tk_dictionaryWithObjects:(const id [])objects forKeys:(const id<NSCopying> [])keys count:(NSUInteger)cnt {

    id safeObjects[cnt];
    id safeKeys[cnt];
    NSUInteger j = 0;
    BOOL isCatch = NO;
    NSString *locStr = @"";
    for (NSUInteger i = 0; i < cnt; i++) {
        id key = keys[i];
        id obj = objects[i];
        if (!key || !obj) {
            isCatch = YES;
            locStr = [NSString stringWithFormat:@"%@k:%@ v:%@\t\t",locStr,key,obj];
            continue;
        }
        safeKeys[j] = key;
        safeObjects[j] = obj;
        j++;
    }
    if (isCatch) {
        NSString *tips = [NSString stringWithFormat:@"⚠️⚠️创建NSDictionary时出现空值nil，请尽快修改！对应的Key-Value：%@",locStr];
        [self noteErrorWithException:nil defaultToDo:tips];
    }
    return [self tk_dictionaryWithObjects:safeObjects forKeys:safeKeys count:j];
}

- (instancetype)tk_initWithObjects:(const id [])objects forKeys:(const id<NSCopying> [])keys count:(NSUInteger)cnt {
    id safeObjects[cnt];
    id safeKeys[cnt];
    NSUInteger j = 0;
    BOOL isCatch = NO;
    NSString *locStr = @"";
    for (NSUInteger i = 0; i < cnt; i++) {
        id key = keys[i];
        id obj = objects[i];
        if (!key || !obj) {
            isCatch = YES;
            locStr = [NSString stringWithFormat:@"%@k:%@ v:%@\t\t",locStr,key,obj];
            continue;
        }
        safeKeys[j] = key;
        safeObjects[j] = obj;
        j++;
    }
    if (isCatch) {
        NSString *tips = [NSString stringWithFormat:@"⚠️⚠️创建NSDictionary时出现空值nil，请尽快修改！对应的Key-Value：%@",locStr];
        [self noteErrorWithException:nil defaultToDo:tips];
    }
    return [self tk_initWithObjects:safeObjects forKeys:safeKeys count:j];
}

@end

@implementation NSMutableDictionary (CrashNilSafe)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = NSClassFromString(@"__NSDictionaryM");
        [class TK_exchangeMethod:@selector(setObject:forKey:) withMethod:@selector(tk_setObject:forKey:)];
        [class TK_exchangeMethod:@selector(setObject:forKeyedSubscript:) withMethod:@selector(tk_setObject:forKeyedSubscript:)];
        [class TK_exchangeMethod:@selector(setValue:forKey:) withMethod:@selector(tk_setValue:forKey:)];
    });
}

- (void)tk_setObject:(id)anObject forKey:(id<NSCopying>)aKey {
    @try {
        [self tk_setObject:anObject forKey:aKey];
    } @catch (NSException *exception) {
        NSString *tips = [NSString stringWithFormat:@"⚠️⚠️NSDictionary ==> setObject:时出现空值nil值，请尽快修改！对应的Key-Value：k:%@ v:%@",anObject,aKey];
        [self noteErrorWithException:exception defaultToDo:tips];
    } @finally {

    }
}

- (void)tk_setObject:(id)obj forKeyedSubscript:(id<NSCopying>)key {
    @try {
        [self tk_setObject:obj forKeyedSubscript:key];
    } @catch (NSException *exception) {
        NSString *tips = [NSString stringWithFormat:@"⚠️⚠️NSDictionary ==> setObject:时出现空值nil值，请尽快修改！对应的Key-Value：k:%@ v:%@",key,obj];
        [self noteErrorWithException:exception defaultToDo:tips];
    } @finally {

    }
}

- (void)tk_removeObjectForKey:(id)aKey
{
    @try {
        [self tk_removeObjectForKey:aKey];
    } @catch (NSException *exception) {
        NSString *tips = [NSString stringWithFormat:@"⚠️⚠️NSDictionary ==> removeObjectForKey时出现空值nil值，请尽快修改！对应的Key：%@",aKey];
        [self noteErrorWithException:exception defaultToDo:tips];
    } @finally {

    }
}

- (void)tk_setValue:(id)value forKey:(NSString *)key
{
    @try {
        [self tk_setValue:value forKey:key];
    } @catch (NSException *exception) {
        NSString *tips = [NSString stringWithFormat:@"⚠️⚠️NSDictionary ==> setValue:时出现空值nil值，请尽快修改！对应的Key-Value：k:%@ v:%@",key,value];
        [self noteErrorWithException:exception defaultToDo:tips];
    } @finally {

    }
}

@end

