//
//  NSArray+CrashNilSafe.m
//  NilSafeTest
//
//  Created by mac on 2019/9/27.
//  Copyright © 2019 mac. All rights reserved.
//

#import "NSArray+CrashNilSafe.h"
#import <objc/runtime.h>


@implementation NSArray (CrashNilSafe)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self TK_exchangeClassMethod:@selector(arrayWithObjects:count:) withMethod:@selector(tk_arrayWithObjects:count:)];
        [objc_getClass("__NSPlaceholderArray") TK_exchangeMethod:@selector(initWithObjects:count:) withMethod:@selector(tk_initWithObjects:count:)];

        [objc_getClass("__NSArray0") TK_exchangeMethod:@selector(objectAtIndex:) withMethod:@selector(tk_objectAtIndex:)];
        [objc_getClass("__NSArrayM") TK_exchangeMethod:@selector(objectAtIndex:) withMethod:@selector(tk_objectAtIndex:)];
        [objc_getClass("__NSArrayM") TK_exchangeMethod:@selector(objectAtIndexedSubscript:) withMethod:@selector(tk_objectAtIndexedSubscript:)];
    });
}

- (instancetype)tk_initWithObjects:(const id [])objects count:(NSUInteger)cnt
{
    id safeObjects[cnt];
    NSUInteger j = 0;
    BOOL isCatch = NO;
    NSString *locStr = @"";
    for (NSInteger i=0; i<cnt; i++) {
        id item = objects[i];
        if (!item) {
            isCatch = YES;
            locStr = [NSString stringWithFormat:@"%@ %ld",locStr,i];
            continue;
        }
        safeObjects[j]=item;
        j++;
    }
    if (isCatch) {
        NSString *tips = [NSString stringWithFormat:@"⚠️⚠️初始化NSArray时含有空值nil，处理策略:忽略nil值，请尽快修改！出现nil的位置:%@",locStr];
        [self noteErrorWithException:nil defaultToDo:tips];
    }
    return [self tk_initWithObjects:safeObjects count:j++];
}

+ (instancetype)tk_arrayWithObjects:(const id [])objects count:(NSUInteger)cnt
{
    id safeObjects[cnt];
    NSUInteger j = 0;
    BOOL isCatch = NO;
    NSString *locStr = @"";
    for (NSInteger i=0; i<cnt; i++) {
        id item = objects[i];
        if (!item) {
            isCatch = YES;
            locStr = [NSString stringWithFormat:@"%@ %ld",locStr,i];
            continue;
        }
        safeObjects[j]=item;
        j++;
    }
    if (isCatch) {
        NSString *tips = [NSString stringWithFormat:@"⚠️⚠️初始化NSArray时含有空值nil，处理策略:忽略nil值，请尽快修改！出现nil的位置:%@",locStr];
        [self noteErrorWithException:nil defaultToDo:tips];
    }
    return [self tk_arrayWithObjects:safeObjects count:j];
}

#pragma mark getter
- (id)tk_objectAtIndex:(NSUInteger)index
{
    id obj = nil;
    @try {
        obj = [self tk_objectAtIndex:index];
    } @catch (NSException *exception) {
        NSString *tips = @"⚠️⚠️NSArray越界,返回nil，请尽快修改!";
        [self noteErrorWithException:exception defaultToDo:tips];
    } @finally {
        return obj;
    }
}

- (id)tk_objectAtIndexedSubscript:(NSUInteger)idx
{
    id obj = nil;
    @try {
        obj = [self tk_objectAtIndexedSubscript:idx];
    } @catch (NSException *exception) {
        NSString *tips = @"⚠️⚠️NSArray越界,返回nil，请尽快修改!";
        [self noteErrorWithException:exception defaultToDo:tips];
    } @finally {
        return obj;
    }
}

@end



@implementation NSMutableArray (CrashNilSafe)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [objc_getClass("__NSArrayM") TK_exchangeMethod:@selector(insertObject:atIndex:) withMethod:@selector(tk_insertObject:atIndex:)];
    });
}

- (void)tk_insertObject:(id)anObject atIndex:(NSUInteger)index
{
    @try {
        [self tk_insertObject:anObject atIndex:index];
    } @catch (NSException *exception) {
        NSString *tips = [NSString stringWithFormat:@"⚠️⚠️NSMutableArray中插入数据为nil或者越界。 插入位置:%ld    插入数据:%@，请尽快修改!",index,anObject];
        [self noteErrorWithException:exception defaultToDo:tips];
    } @finally {

    }
}

@end
