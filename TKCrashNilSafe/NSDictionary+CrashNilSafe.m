//
//  NSDictionary+CrashNilSafe.m
//  NilSafeTest
//
//  Created by mac on 2019/9/27.
//  Copyright © 2019 mac. All rights reserved.
//

#import "NSDictionary+CrashNilSafe.h"
#import "NSObject+CrashNilSafe.h"
#import <objc/runtime.h>



@implementation NSDictionary (CrashNilSafe)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self tk_swizzleMethod:@selector(initWithObjects:forKeys:count:) withMethod:@selector(tk_initWithObjects:forKeys:count:)];
        [self tk_swizzleClassMethod:@selector(dictionaryWithObjects:forKeys:count:) withMethod:@selector(tk_dictionaryWithObjects:forKeys:count:)];
    });
}

+ (instancetype)tk_dictionaryWithObjects:(const id [])objects forKeys:(const id<NSCopying> [])keys count:(NSUInteger)cnt {
    id safeObjects[cnt];
    id safeKeys[cnt];
    NSUInteger j = 0;
    for (NSUInteger i = 0; i < cnt; i++) {
        id key = keys[i];
        id obj = objects[i];
        if (!key || !obj) {
            continue;
        }
        safeKeys[j] = key;
        safeObjects[j] = obj;
        j++;
    }
    return [self tk_dictionaryWithObjects:safeObjects forKeys:safeKeys count:j];
}

- (instancetype)tk_initWithObjects:(const id [])objects forKeys:(const id<NSCopying> [])keys count:(NSUInteger)cnt {
    id safeObjects[cnt];
    id safeKeys[cnt];
    NSUInteger j = 0;
    for (NSUInteger i = 0; i < cnt; i++) {
        id key = keys[i];
        id obj = objects[i];
        if (!key || !obj) {
            continue;
        }
        if (!obj) {
            obj = [NSNull null];
        }
        safeKeys[j] = key;
        safeObjects[j] = obj;
        j++;
    }
    return [self tk_initWithObjects:safeObjects forKeys:safeKeys count:j];
}

@end

@implementation NSMutableDictionary (CrashNilSafe)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = NSClassFromString(@"__NSDictionaryM");
        [class tk_swizzleMethod:@selector(setObject:forKey:) withMethod:@selector(tk_setObject:forKey:)];
        [class tk_swizzleMethod:@selector(setObject:forKeyedSubscript:) withMethod:@selector(tk_setObject:forKeyedSubscript:)];
    });
}

- (void)tk_setObject:(id)anObject forKey:(id<NSCopying>)aKey {
    if (!aKey || !anObject) {
        return;
    }
    [self tk_setObject:anObject forKey:aKey];
}

- (void)tk_setObject:(id)obj forKeyedSubscript:(id<NSCopying>)key {
    if (!key || !obj) {
        return;
    }
    [self tk_setObject:obj forKeyedSubscript:key];
}

@end

