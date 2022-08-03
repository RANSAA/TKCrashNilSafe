//
//  NSDictionary+CrashNilSafe.m
//  NilSafeTest
//
//  Created by mac on 2019/9/27.
//  Copyright © 2019 mac. All rights reserved.
//

#import "NSDictionary+CrashNilSafe.h"
#import <objc/runtime.h>
#import "TKCrashNilSafe.h"


@implementation NSDictionary (CrashNilSafe)


/**
 函数交换通用入口
 */
+ (void)TKCrashNilSafe_SwapMethod
{
    if (!TKCrashNilSafe.share.isEnableInDebug) {
        return;
    }

    //次数少
    [self exchangeClassMethod:@selector(dictionaryWithObjects:forKeys:count:) withMethod:@selector(TKCrashNilSafe_dictionaryWithObjects:forKeys:count:)];
    [self exchangeClassMethod:@selector(dictionaryWithObject:forKey:) withMethod:@selector(TKCrashNilSafe_dictionaryWithObject:forKey:)];

    [self exchangeObjMethod:@selector(initWithObjects:forKeys:) withMethod:@selector(TKCrashNilSafe_initWithObjects:forKeys:)];

    Class cls0 = objc_getClass("__NSPlaceholderDictionary");
    [cls0 exchangeObjMethod:@selector(initWithDictionary:copyItems:) withMethod:@selector(TKCrashNilSafe_initWithDictionary:copyItems:)];
    //与相同对应的类方法会造成重复问题-del
    //[cls0 exchangeObjMethod:@selector(initWithObjects:forKeys:count:) withMethod:@selector(TKCrashNilSafe_initWithObjects:forKeys:count:)];

    Class cls1 = objc_getClass("__NSDictionaryI");
    [cls1 exchangeObjMethod:@selector(setValue:forKey:) withMethod:@selector(TKCrashNilSafe_setValue:forKey:)];
}


//优
+ (instancetype)TKCrashNilSafe_dictionaryWithObjects:(const id [])objects forKeys:(const id<NSCopying> [])keys count:(NSUInteger)cnt {
    id safeObjects[cnt];
    id safeKeys[cnt];
    NSUInteger safeCount = 0;
    BOOL crash = NO;
    NSString *locStr = @"";
    for (NSUInteger i = 0; i < cnt; i++) {
        id key = keys[i];
        id obj = objects[i];
        if (!key || !obj) {
            crash = YES;
            locStr = [NSString stringWithFormat:@"%@k:%@ v:%@\t",locStr,key,obj];
            continue;
        }
        safeKeys[safeCount] = key;
        safeObjects[safeCount] = obj;
        safeCount++;
    }
    if (crash) {
        NSString *reason = [NSString stringWithFormat:@"+[%@ dictionaryWithObjects:forKeys:count:] ==> error key-value info: %@",self.class,locStr];
        [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
    }
    return [self TKCrashNilSafe_dictionaryWithObjects:safeObjects forKeys:safeKeys count:safeCount];
}

#pragma mark //重复-需要删除该方法
- (instancetype)TKCrashNilSafe_initWithObjects:(const id [])objects forKeys:(const id<NSCopying> [])keys count:(NSUInteger)cnt {
    id safeObjects[cnt];
    id safeKeys[cnt];
    NSUInteger safeCount = 0;
    BOOL crash = NO;
    NSString *locStr = @"";
    for (NSUInteger i = 0; i < cnt; i++) {
        id key = keys[i];
        id obj = objects[i];
        if (!key || !obj) {
            crash = YES;
            locStr = [NSString stringWithFormat:@"%@k:%@ v:%@\t\t",locStr,key,obj];
            continue;
        }
        safeKeys[safeCount] = key;
        safeObjects[safeCount] = obj;
        safeCount++;
    }
    if (crash) {
        NSString *reason = [NSString stringWithFormat:@"-[%@ initWithObjects:forKeys:count:] ==> error key-value info: %@",self.class,locStr];
        [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
    }
    return [self TKCrashNilSafe_initWithObjects:safeObjects forKeys:safeKeys count:safeCount];
}


+ (instancetype)TKCrashNilSafe_dictionaryWithObject:(id)object forKey:(id<NSCopying>)key
{
    id dic;
    @try {
        dic = [self TKCrashNilSafe_dictionaryWithObject:object forKey:key];
    } @catch (NSException *exception) {
        [self handleErrorWithName:exception.name mark:exception.reason];
    } @finally {
        return  dic;
    }
}


- (instancetype)TKCrashNilSafe_initWithObjects:(NSArray *)objects forKeys:(NSArray<id<NSCopying>> *)keys
{
    id dic;
    @try {
        dic = [self TKCrashNilSafe_initWithObjects:objects forKeys:keys];
    } @catch (NSException *exception) {
        [self handleErrorWithName:exception.name mark:exception.reason];
    } @finally {
        return dic;
    }
}


- (instancetype)TKCrashNilSafe_initWithDictionary:(NSDictionary *)otherDictionary copyItems:(BOOL)flag
{
    id dic;
    @try {
        dic = [self TKCrashNilSafe_initWithDictionary:otherDictionary copyItems:flag];
    } @catch (NSException *exception) {
        [self handleErrorWithName:exception.name mark:exception.reason];
    } @finally {
        return dic;
    }
}


- (void)TKCrashNilSafe_setValue:(id)value forKey:(NSString *)key
{
    if (key) {
        [self TKCrashNilSafe_setValue:value forKey:key];
    }else{
        NSString *reason = [NSString stringWithFormat:@"-[%@ setValue:forKey:] ==> key can't nil ",self.class];
        [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
    }
}

@end




@implementation NSMutableDictionary (CrashNilSafe)


/**
 函数交换通用入口
 */
+ (void)TKCrashNilSafe_SwapMethod
{
    if (!TKCrashNilSafe.share.isEnableInDebug) {
        return;
    }

    Class class = NSClassFromString(@"__NSDictionaryM");
    [class exchangeObjMethod:@selector(setValue:forKey:) withMethod:@selector(TKCrashNilSafe_setValue:forKey:)];
    [class exchangeObjMethod:@selector(setObject:forKey:) withMethod:@selector(TKCrashNilSafe_setObject:forKey:)];
    [class exchangeObjMethod:@selector(setObject:forKeyedSubscript:) withMethod:@selector(TKCrashNilSafe_setObject:forKeyedSubscript:)];
    [class exchangeObjMethod:@selector(removeObjectForKey:) withMethod:@selector(TKCrashNilSafe_removeObjectForKey:)];
    [class exchangeObjMethod:@selector(removeObjectsForKeys:) withMethod:@selector(TKCrashNilSafe_removeObjectsForKeys:)];

    [self exchangeObjMethod:@selector(addEntriesFromDictionary:) withMethod:@selector(TKCrashNilSafe_addEntriesFromDictionary:)];
    [self exchangeObjMethod:@selector(setDictionary:) withMethod:@selector(TKCrashNilSafe_setDictionary:)];
}


//key-> nonull object->nonull
- (void)TKCrashNilSafe_setObject:(id)anObject forKey:(id<NSCopying>)aKey {
    if (anObject && aKey) {
        [self TKCrashNilSafe_setObject:anObject forKey:aKey];
    }else{
        if (aKey) {
            NSString *reason = [NSString stringWithFormat:@"-[%@ setObject:forKey:] ==> object cannot be nil; current key:%@",self.class,aKey];
            [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
        }else{
            NSString *reason = [NSString stringWithFormat:@"-[%@ setObject:forKey:] ==> key cannot be nil",self.class];
            [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
        }
    }
}

//key->nonull   object->nullnull
- (void)TKCrashNilSafe_setObject:(id)obj forKeyedSubscript:(id<NSCopying>)key {
    if (key) {
        [self TKCrashNilSafe_setObject:obj forKeyedSubscript:key];
    }else{
        NSString *reason = [NSString stringWithFormat:@"-[%@ setObject:forKeyedSubscript:] ==> key cannot be nil",self.class];
        [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
    }
}

- (void)TKCrashNilSafe_removeObjectForKey:(id)aKey
{
    if (aKey) {
        [self TKCrashNilSafe_removeObjectForKey:aKey];
    }else{
        NSString *reason = [NSString stringWithFormat:@"-[%@ removeObjectForKey:] ==> key cannot be nil",self.class];
        [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
    }
}

- (void)TKCrashNilSafe_removeObjectsForKeys:(NSArray *)keyArray
{
    if (keyArray) {
        if ([keyArray isKindOfClass:NSArray.class]) {
            [self TKCrashNilSafe_removeObjectsForKeys:keyArray];
        }else{
            NSString *reason = [NSString stringWithFormat:@"-[%@ removeObjectsForKeys:] ==> The value type added must be NSArray; The current type is:%@",self.class,keyArray.class];
            [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
        }
    }else{
        [self TKCrashNilSafe_removeObjectsForKeys:keyArray];
    }
}


- (void)TKCrashNilSafe_addEntriesFromDictionary:(NSDictionary *)otherDictionary
{
    if (otherDictionary) {
        if ([otherDictionary isKindOfClass:NSDictionary.class]) {
            [self TKCrashNilSafe_addEntriesFromDictionary:otherDictionary];
        }else{
            NSString *reason = [NSString stringWithFormat:@"-[%@ addEntriesFromDictionary:] ==> The value type added must be NSDictionary; The current type is:%@",self.class,otherDictionary.class];
            [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
        }
    }
}



- (void)TKCrashNilSafe_setDictionary:(NSDictionary *)otherDictionary
{
    if (otherDictionary) {
        if ([otherDictionary isKindOfClass:NSDictionary.class]) {
            [self TKCrashNilSafe_setDictionary:otherDictionary];
        }else{
            NSString *reason = [NSString stringWithFormat:@"-[%@ setDictionary:] ==> The value type added must be NSDictionary; The current type is:%@",self.class,otherDictionary.class];
            [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
        }
    }else{
        [self TKCrashNilSafe_setDictionary:otherDictionary];
    }
}


@end

