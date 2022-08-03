//
//  NSSet+CrashNilSafe.m
//  NilSafeTest
//
//  Created by mac on 2019/10/15.
//  Copyright © 2019 mac. All rights reserved.
//

#import "NSSet+CrashNilSafe.h"
#import <objc/runtime.h>
#import "TKCrashNilSafe.h"


//@implementation NSSet (CrashNilSafe)
//
//
//@end


@implementation NSMutableSet (CrashNilSafe)

/**
 函数交换通用入口
 */
+ (void)TKCrashNilSafe_SwapMethod
{
    if (!TKCrashNilSafe.share.isEnableInDebug) {
        return;
    }

    Class class = objc_getClass("__NSSetM");
    [class exchangeObjMethod:@selector(addObject:) withMethod:@selector(TKCrashNilSafe_addObject:)];
    [class exchangeObjMethod:@selector(removeObject:) withMethod:@selector(TKCrashNilSafe_removeObject:)];
}

- (void)TKCrashNilSafe_addObject:(id)object
{
    if (object) {
        [self TKCrashNilSafe_addObject:object];
    }else{
        NSString *reason = [NSString stringWithFormat:@"-[%@ addObject:] ==> object cannot be nil",self.class];
        [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
    }
}

- (void)TKCrashNilSafe_removeObject:(id)object
{
    if (object) {
        [self TKCrashNilSafe_removeObject:object];
    }else{
        NSString *reason = [NSString stringWithFormat:@"-[%@ removeObject:] ==> key cannot be nil",self.class];
        [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
    }
}

@end




@implementation NSOrderedSet (CrashNilSafe)


/**
 函数交换通用入口
 */
+ (void)TKCrashNilSafe_SwapMethod
{
    if (!TKCrashNilSafe.share.isEnableInDebug) {
        return;
    }

    Class class = NSClassFromString(@"__NSOrderedSetI");
    [class exchangeObjMethod:@selector(objectAtIndex:) withMethod:@selector(TKCrashNilSafe_objectAtIndex:)];
}


- (id)TKCrashNilSafe_objectAtIndex:(NSUInteger)index
{
    if (index < self.count) {
        return [self TKCrashNilSafe_objectAtIndex:index];
    }else{
        NSString *reason = [NSString stringWithFormat:@"-[%@ objectAtIndex:] ==> index %lu, But count %lu",self.class,index,self.count];
        [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
        return nil;
    }
}

@end


@implementation NSMutableOrderedSet (CrashNilSafe)

/**
 函数交换通用入口
 */
+ (void)TKCrashNilSafe_SwapMethod
{
    if (!TKCrashNilSafe.share.isEnableInDebug) {
        return;
    }

    Class class = NSClassFromString(@"__NSOrderedSetM");
    [class exchangeObjMethod:@selector(objectAtIndex:) withMethod:@selector(TKCrashNilSafe_objectAtIndex:)];
    [class exchangeObjMethod:@selector(addObject:) withMethod:@selector(TKCrashNilSafe_addObject:)];
    [class exchangeObjMethod:@selector(insertObject:atIndex:) withMethod:@selector(TKCrashNilSafe_insertObject:atIndex:)];
    [class exchangeObjMethod:@selector(setObject:atIndex:) withMethod:@selector(TKCrashNilSafe_setObject:atIndex:)];

    [class exchangeObjMethod:@selector(removeObjectAtIndex:) withMethod:@selector(TKCrashNilSafe_removeObjectAtIndex:)];
    [class exchangeObjMethod:@selector(removeObjectsInRange:) withMethod:@selector(TKCrashNilSafe_removeObjectsInRange:)];
    [class exchangeObjMethod:@selector(removeObjectsInArray:) withMethod:@selector(TKCrashNilSafe_removeObjectsInArray:)];
    [class exchangeObjMethod:@selector(removeObjectsAtIndexes:) withMethod:@selector(TKCrashNilSafe_removeObjectsAtIndexes:)];

    [class exchangeObjMethod:@selector(replaceObjectAtIndex:withObject:) withMethod:@selector(TKCrashNilSafe_replaceObjectAtIndex:withObject:)];
    [class exchangeObjMethod:@selector(exchangeObjectAtIndex:withObjectAtIndex:) withMethod:@selector(TKCrashNilSafe_exchangeObjectAtIndex:withObjectAtIndex:)];
}


- (void)TKCrashNilSafe_addObject:(id)object
{
    if (object) {
        [self TKCrashNilSafe_addObject:object];
    }else{
        NSString *reason = [NSString stringWithFormat:@"-[%@ addObject:] ==> object cannot be nil",self.class];
        [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
    }
}


- (void)TKCrashNilSafe_insertObject:(id)anObject atIndex:(NSUInteger)index
{
    if (anObject) {
        if (index <= self.count) {
            [self TKCrashNilSafe_insertObject:anObject atIndex:index];
        }else{
            NSString *reason = [NSString stringWithFormat:@"-[%@ insertObject:atIndex:] ==> atIndex %lu, But the bounds [0 .. %lu]",self.class,index,self.count];
            [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
        }
    }else{
        NSString *reason = [NSString stringWithFormat:@"-[%@ insertObject:] ==> object cannot be nil",self.class];
        [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
    }
}

- (void)TKCrashNilSafe_setObject:(id)obj atIndex:(NSUInteger)idx
{
    if (obj) {
        if (idx>self.count) {
            NSString *reason = [NSString stringWithFormat:@"-[%@ setObject:atIndex:] ==> index %lu, But the bounds [0 .. %lu]",self.class,idx,self.count];
            [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
        }else{
            [self TKCrashNilSafe_setObject:obj atIndex:idx];
        }
    }else{
        NSString *reason = [NSString stringWithFormat:@"-[%@ setObject:atIndex:] ==> object cannot be nil",self.class];
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
    if (indexes.lastIndex < self.count) {
        [self TKCrashNilSafe_removeObjectsAtIndexes:indexes];
    }else{
        NSString *reason = [NSString stringWithFormat:@"-[%@ removeObjectsAtIndexes:] ==> indexes.lastIndex %lu, But count %lu",self.class,indexes.lastIndex,self.count];
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


@end
