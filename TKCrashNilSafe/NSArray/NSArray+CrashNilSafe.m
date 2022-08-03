//
//  NSArray+CrashNilSafe.m
//  NilSafeTest
//
//  Created by mac on 2019/9/27.
//  Copyright © 2019 mac. All rights reserved.
//

#import "NSArray+CrashNilSafe.h"
#import <objc/runtime.h>
#import "TKCrashNilSafe.h"


@implementation NSArray (CrashNilSafe)


/**
 函数交换通用入口
 */
+ (void)TKCrashNilSafe_SwapMethod
{
    if (!TKCrashNilSafe.share.isEnableInDebug) {
        return;
    }

    //优
    [self exchangeClassMethod:@selector(arrayWithObjects:count:) withMethod:@selector(TKCrashNilSafe_arrayWithObjects:count:)];

    [self exchangeClassMethod:@selector(arrayWithObject:) withMethod:@selector(TKCrashNilSafe_arrayWithObject:)];
    [self exchangeClassMethod:@selector(arrayWithArray:) withMethod:@selector(TKCrashNilSafe_arrayWithArray:)];

    Class cls0 = objc_getClass("__NSPlaceholderArray");
    [cls0 exchangeObjMethod:@selector(initWithArray:) withMethod:@selector(TKCrashNilSafe_initWithArray:)];
    [cls0 exchangeObjMethod:@selector(initWithArray:copyItems:) withMethod:@selector(TKCrashNilSafe_initWithArray:copyItems:)];
    //重复-需要删除该方法
    //[cls0 exchangeObjMethod:@selector(initWithObjects:count:) withMethod:@selector(TKCrashNilSafe_initWithObjects:count:)];

    Class cls1 = objc_getClass("__NSArrayI");
    [cls1 exchangeObjMethod:@selector(objectAtIndexedSubscript:) withMethod:@selector(TKCrashNilSafe_objectAtIndexedSubscript:)];
    [cls1 exchangeObjMethod:@selector(objectAtIndex:) withMethod:@selector(TKCrashNilSafe_objectAtIndex:)];

    [self exchangeObjMethod:@selector(objectsAtIndexes:) withMethod:@selector(TKCrashNilSafe_objectsAtIndexes:)];
    [self exchangeObjMethod:@selector(arrayByAddingObject:) withMethod:@selector(TKCrashNilSafe_arrayByAddingObject:)];
    [self exchangeObjMethod:@selector(arrayByAddingObjectsFromArray:) withMethod:@selector(TKCrashNilSafe_arrayByAddingObjectsFromArray:)];
}


//优
+ (instancetype)TKCrashNilSafe_arrayWithObjects:(id  _Nonnull const [])objects count:(NSUInteger)cnt
{
    id safeObjects[cnt];
    NSUInteger safeCount = 0;
    BOOL crash = NO;
    NSString *locStr = @"";
    for (NSInteger i=0; i<cnt; i++) {
        id item = objects[i];
        if (!item) {
            crash = YES;
            locStr = [NSString stringWithFormat:@"%@ %ld",locStr,i];
            continue;
        }
        safeObjects[safeCount]=item;
        safeCount++;
    }
    if (crash) {
        NSString *reason = [NSString stringWithFormat:@"+[%@ arrayWithObjects:count:] ==> index:%@ the value cannot be nil",self.class,locStr];
        [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
    }
    return [self TKCrashNilSafe_arrayWithObjects:safeObjects count:safeCount];
}


#pragma mark //重复-需要删除该方法
- (instancetype)TKCrashNilSafe_initWithObjects:(const id [])objects count:(NSUInteger)cnt
{
    id safeObjects[cnt];
    NSUInteger safeCount = 0;
    BOOL crash = NO;
    NSString *locStr = @"";
    for (NSInteger i=0; i<cnt; i++) {
        id item = objects[i];
        if (!item) {
            crash = YES;
            locStr = [NSString stringWithFormat:@"%@ %ld",locStr,i];
            continue;
        }
        safeObjects[safeCount]=item;
        safeCount++;
    }
    if (crash) {
        NSString *reason = [NSString stringWithFormat:@"-[%@ initWithObjects:count:] ==> index:%@ the value cannot be nil",self.class,locStr];
        [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
    }
    return [self TKCrashNilSafe_initWithObjects:safeObjects count:safeCount];
}



+ (instancetype)TKCrashNilSafe_arrayWithObject:(id)anObject
{
    if (anObject) {
        return [self TKCrashNilSafe_arrayWithObject:anObject];
    }else{
        NSString *reason = [NSString stringWithFormat:@"+[%@ arrayWithObject:] ==> object cannot be nil",self.class];
        [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
        return nil;
    }
}

+ (instancetype)TKCrashNilSafe_arrayWithArray:(NSArray *)array
{
    if (array) {
        if ([array isKindOfClass: NSArray.class]) {
            return [self TKCrashNilSafe_arrayWithArray:array];
        }else{
            NSString *reason = [NSString stringWithFormat:@"+[%@ arrayWithArray:] ==> The value type added must be NSArray; The current type is:%@ ",self.class,array.class];
            [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
            return nil;
        }
    }else{
        return [self TKCrashNilSafe_arrayWithArray:array];
    }
}


- (instancetype)TKCrashNilSafe_initWithArray:(NSArray *)array
{
    if (array) {
        if ([array isKindOfClass: NSArray.class]) {
            return [self TKCrashNilSafe_initWithArray:array];
        }else{
            NSString *reason = [NSString stringWithFormat:@"-[%@ initWithArray:] ==> The value type added must be NSArray; The current type is:%@ ",self.class,array.class];
            [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
            return nil;
        }
    }else{
        return [self TKCrashNilSafe_initWithArray:array];
    }
}

- (instancetype)TKCrashNilSafe_initWithArray:(NSArray *)array copyItems:(BOOL)flag
{
    if (array) {
        if ([array isKindOfClass: NSArray.class]) {
            return [self TKCrashNilSafe_initWithArray:array copyItems:flag];
        }else{
            NSString *reason = [NSString stringWithFormat:@"-[%@ initWithArray:copyItems:] ==> The value type added must be NSArray; The current type is:%@ ",self.class,array.class];
            [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
            return nil;
        }
    }else{
        return [self TKCrashNilSafe_initWithArray:array copyItems:flag];
    }
}




#pragma mark getter
- (id)TKCrashNilSafe_objectAtIndexedSubscript:(NSUInteger)idx
{
    if (idx<self.count) {
        return [self TKCrashNilSafe_objectAtIndexedSubscript:idx];
    }else{
        NSString *reason = [NSString stringWithFormat:@"-[%@ objectAtIndexedSubscript:] ==> index %lu, But count %lu",self.class,idx,self.count];
        [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
        return nil;
    }
}


- (id)TKCrashNilSafe_objectAtIndex:(NSUInteger)index
{
    if (index<self.count) {
        return [self TKCrashNilSafe_objectAtIndex:index];
    }else{
        NSString *reason = [NSString stringWithFormat:@"-[%@ objectAtIndex:] ==> index %lu, But count %lu",self.class,index,self.count];
        [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
        return nil;
    }
}

- (NSArray *)TKCrashNilSafe_objectsAtIndexes:(NSIndexSet *)indexes
{
    if (indexes.lastIndex < self.count || indexes.lastIndex == NSNotFound) {
        return [self TKCrashNilSafe_objectsAtIndexes:indexes];
    }else{
        NSString *reason = [NSString stringWithFormat:@"-[%@ objectsAtIndexes:] ==> indexes.lastIndex %lu, But count %lu",self.class,indexes.lastIndex,self.count];
        [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
        return nil;
    }
}

- (NSArray *)TKCrashNilSafe_arrayByAddingObject:(id)anObject
{
    if (anObject) {
        return [self TKCrashNilSafe_arrayByAddingObject:anObject];
    }else{
        NSString *reason = [NSString stringWithFormat:@"-[%@ arrayByAddingObject:] ==> object connot nil",self.class];
        [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
        return self;
    }
}

- (NSArray *)TKCrashNilSafe_arrayByAddingObjectsFromArray:(NSArray *)otherArray
{
    if (otherArray) {
        if ([otherArray isKindOfClass:NSArray.class]) {
            return [self TKCrashNilSafe_arrayByAddingObjectsFromArray:otherArray];
        }else{
            NSString *reason = [NSString stringWithFormat:@"-[%@ arrayByAddingObjectsFromArray:] ==> The value type added must be NSArray; The current type is:%@",self.class,otherArray.class];
            [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
            return self;
        }
    }else{
        return self;
    }
}

@end



@implementation NSMutableArray (CrashNilSafe)


/**
 函数交换通用入口
 */
+ (void)TKCrashNilSafe_SwapMethod
{
    if (!TKCrashNilSafe.share.isEnableInDebug) {
        return;
    }

    [self exchangeObjMethod:@selector(arrayByAddingObjectsFromArray:) withMethod:@selector(TKCrashNilSafe_arrayByAddingObjectsFromArray:)];

    Class _mAry = objc_getClass("__NSArrayM");
    [_mAry exchangeObjMethod:@selector(objectAtIndexedSubscript:) withMethod:@selector(TKCrashNilSafe_objectAtIndexedSubscript:)];
    [_mAry exchangeObjMethod:@selector(objectAtIndex:) withMethod:@selector(TKCrashNilSafe_objectAtIndex:)];

    [_mAry exchangeObjMethod:@selector(addObject:) withMethod:@selector(TKCrashNilSafe_addObject:)];
    [_mAry exchangeObjMethod:@selector(addObjectsFromArray:) withMethod:@selector(TKCrashNilSafe_addObjectsFromArray:)];
    [_mAry exchangeObjMethod:@selector(insertObject:atIndex:) withMethod:@selector(TKCrashNilSafe_insertObject:atIndex:)];

    [_mAry exchangeObjMethod:@selector(replaceObjectAtIndex:withObject:) withMethod:@selector(TKCrashNilSafe_replaceObjectAtIndex:withObject:)];
    [_mAry exchangeObjMethod:@selector(exchangeObjectAtIndex:withObjectAtIndex:) withMethod:@selector(TKCrashNilSafe_exchangeObjectAtIndex:withObjectAtIndex:)];

    [_mAry exchangeObjMethod:@selector(removeObjectAtIndex:) withMethod:@selector(TKCrashNilSafe_removeObjectAtIndex:)];
    [_mAry exchangeObjMethod:@selector(removeObject:inRange:) withMethod:@selector(TKCrashNilSafe_removeObject:inRange:)];
    [_mAry exchangeObjMethod:@selector(removeObjectsInRange:) withMethod:@selector(TKCrashNilSafe_removeObjectsInRange:)];
    [_mAry exchangeObjMethod:@selector(removeObjectsInArray:) withMethod:@selector(TKCrashNilSafe_removeObjectsInArray:)];
    [_mAry exchangeObjMethod:@selector(removeObjectsAtIndexes:) withMethod:@selector(TKCrashNilSafe_removeObjectsAtIndexes:)];

    [_mAry exchangeObjMethod:@selector(setObject:atIndexedSubscript:) withMethod:@selector(TKCrashNilSafe_setObject:atIndexedSubscript:)];
    [_mAry exchangeObjMethod:@selector(setArray:) withMethod:@selector(TKCrashNilSafe_setArray:) ];
}




- (NSArray *)TKCrashNilSafe_arrayByAddingObjectsFromArray:(NSArray *)otherArray
{
    if (otherArray) {
        if ([otherArray isKindOfClass:NSArray.class]) {
            return [self TKCrashNilSafe_arrayByAddingObjectsFromArray:otherArray];
        }else{
            NSString *reason = [NSString stringWithFormat:@"-[%@ arrayByAddingObjectsFromArray:] ==> The value type added must be NSArray; The current type is:%@",self.class,otherArray.class];
            [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
            return self;
        }
    }else{
        return self;
    }
}


- (void)TKCrashNilSafe_addObject:(id)anObject
{
    if (anObject) {
        [self TKCrashNilSafe_addObject:anObject];
    }else{
        NSString *reason = [NSString stringWithFormat:@"-[%@ addObject:] ==> object cannot be nil",self.class];
        [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
    }
}

- (void)TKCrashNilSafe_addObjectsFromArray:(NSArray *)array
{
    if (array) {
        if ([array isKindOfClass:NSArray.class]) {
            [self TKCrashNilSafe_addObjectsFromArray:array];
        }else{
            NSString *reason = [NSString stringWithFormat:@"-[%@ addObjectsFromArray:] ==> The value type added must be NSArray; The current type is:%@",self.class,array.class];
            [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
        }
    }
}


- (void)TKCrashNilSafe_insertObject:(id)anObject atIndex:(NSUInteger)index
{
    if (anObject) {
        if (index > self.count) {
            NSString *reason = [NSString stringWithFormat:@"-[%@ insertObject:atIndex:] ==> atIndex %lu, But the bounds [0 .. %lu]",self.class,index,self.count];
            [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
        }else{
            [self TKCrashNilSafe_insertObject:anObject atIndex:index];
        }
    }else{
        NSString *reason = [NSString stringWithFormat:@"-[%@ insertObject:atIndex:] ==> objct can't nil ",self.class];
        [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
    }
}



- (void)TKCrashNilSafe_replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject
{
    if (anObject) {
        if (index<self.count) {
            [self TKCrashNilSafe_replaceObjectAtIndex:index withObject:anObject];
        }else{
            NSString *reason = [NSString stringWithFormat:@"-[%@ replaceObjectAtIndex:withObject:] ==> index %lu, But the count %lu",self.class,index,self.count];
            [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
        }
    }else{
        NSString *reason = [NSString stringWithFormat:@"-[%@ replaceObjectAtIndex:withObject:] ==> object cannot be nil",self.class];
        [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
    }
}

- (void)TKCrashNilSafe_exchangeObjectAtIndex:(NSUInteger)idx1 withObjectAtIndex:(NSUInteger)idx2
{
    NSUInteger count = self.count;
    if (idx1<count && idx2 < count) {
        [self TKCrashNilSafe_exchangeObjectAtIndex:idx1 withObjectAtIndex:idx2];
    }else{
        NSString *reason = [NSString stringWithFormat:@"-[%@ exchangeObjectAtIndex:withObjectAtIndex:] ==> index1:%lu index2:%lu, But the count %lu",self.class,idx1,idx2,count];
        [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
    }
}

- (void)TKCrashNilSafe_removeObjectAtIndex:(NSUInteger)index
{
    if (index<self.count) {
        [self TKCrashNilSafe_removeObjectAtIndex:index];
    }else{
        NSString *reason = [NSString stringWithFormat:@"-[%@ removeObjectAtIndex:] ==> index %lu, But the count %lu",self.class,index,self.count];
        [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
    }
}


- (void)TKCrashNilSafe_removeObject:(id)anObject inRange:(NSRange)range
{
    if (TKSafeMaxRange(range) <= self.count) {
        [self TKCrashNilSafe_removeObject:anObject inRange:range];
    }else{
        NSString *reason = [NSString stringWithFormat:@"-[%@ removeObject:inRange:] ==> inRange %@, But the bounds [0 .. %lu]",self.class,NSStringFromRange(range),self.count];
        [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
    }
}

- (void)TKCrashNilSafe_removeObjectsInRange:(NSRange)range
{
    if (TKSafeMaxRange(range) <= self.count) {
        [self TKCrashNilSafe_removeObjectsInRange:range];
    }else{
        NSString *reason = [NSString stringWithFormat:@"-[%@ removeObjectsInRange:] ==> inRange %@, But the bounds [0 .. %lu]",self.class,NSStringFromRange(range),self.count];
        [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
    }
}

- (void)TKCrashNilSafe_removeObjectsInArray:(NSArray *)otherArray
{
    if (otherArray) {
        if ([otherArray isKindOfClass:NSArray.class]) {
            [self TKCrashNilSafe_removeObjectsInArray:otherArray];
        }else{
            NSString *reason = [NSString stringWithFormat:@"-[%@ removeObjectsInArray:] ==> The value type added must be NSArray; The current type is:%@",self.class,otherArray.class];
            [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
        }
    }
}

- (void)TKCrashNilSafe_removeObjectsAtIndexes:(NSIndexSet *)indexes
{
    if (indexes.lastIndex < self.count || indexes.lastIndex == NSNotFound) {
        [self TKCrashNilSafe_removeObjectsAtIndexes:indexes];
    }else{
        NSString *reason = [NSString stringWithFormat:@"-[%@ removeObjectsAtIndexes:] ==> indexes.lastIndex %lu, But count %lu",self.class,indexes.lastIndex,self.count];
        [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
    }
}


- (void)TKCrashNilSafe_setObject:(id)obj atIndexedSubscript:(NSUInteger)idx
{
    if (obj) {
        if (idx>self.count) {
            NSString *reason = [NSString stringWithFormat:@"-[%@ setObject:atIndexedSubscript:] ==> index %lu, But the bounds [0 .. %lu]",self.class,idx,self.count];
            [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
        }else{
            [self TKCrashNilSafe_setObject:obj atIndexedSubscript:idx];
        }
    }else{
        NSString *reason = [NSString stringWithFormat:@"-[%@ setObject:atIndexedSubscript:] ==> object cannot be nil",self.class];
        [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
    }
}

- (void)TKCrashNilSafe_setArray:(NSArray *)otherArray
{
    if (otherArray) {
        if ([otherArray isKindOfClass:NSArray.class]) {
            [self TKCrashNilSafe_setArray:otherArray];
        }else{
            NSString *reason = [NSString stringWithFormat:@"-[%@ setArray:] ==> The value type added must be NSArray; The current type is:%@",self.class,otherArray.class];
            [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
        }
    }else{
        [self TKCrashNilSafe_setArray:otherArray];
    }
}

@end
