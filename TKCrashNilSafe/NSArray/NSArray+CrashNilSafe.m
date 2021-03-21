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

+ (void)load
{
    if (TKCrashNilSafe.share.checkCrashNilSafeSwitch) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            //优
            [self exchangeClassMethod:@selector(arrayWithObjects:count:) withMethod:@selector(safe_arrayWithObjects:count:)];
            
            [self exchangeClassMethod:@selector(arrayWithObject:) withMethod:@selector(safe_arrayWithObject:)];
            [self exchangeClassMethod:@selector(arrayWithArray:) withMethod:@selector(safe_arrayWithArray:)];

            Class cls0 = objc_getClass("__NSPlaceholderArray");
            [cls0 exchangeObjMethod:@selector(initWithArray:) withMethod:@selector(safe_initWithArray:)];
            [cls0 exchangeObjMethod:@selector(initWithArray:copyItems:) withMethod:@selector(safe_initWithArray:copyItems:)];
            //重复-需要删除该方法
            //[cls0 exchangeObjMethod:@selector(initWithObjects:count:) withMethod:@selector(safe_initWithObjects:count:)];
            
            Class cls1 = objc_getClass("__NSArrayI");
            [cls1 exchangeObjMethod:@selector(objectAtIndexedSubscript:) withMethod:@selector(safe_objectAtIndexedSubscript:)];
            [cls1 exchangeObjMethod:@selector(objectAtIndex:) withMethod:@selector(safe_objectAtIndex:)];
            
            [self exchangeObjMethod:@selector(objectsAtIndexes:) withMethod:@selector(safe_objectsAtIndexes:)];
            [self exchangeObjMethod:@selector(arrayByAddingObject:) withMethod:@selector(safe_arrayByAddingObject:)];
            [self exchangeObjMethod:@selector(arrayByAddingObjectsFromArray:) withMethod:@selector(safe_arrayByAddingObjectsFromArray:)];
        });
    }
}



//优
+ (instancetype)safe_arrayWithObjects:(id  _Nonnull const [])objects count:(NSUInteger)cnt
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
    return [self safe_arrayWithObjects:safeObjects count:safeCount];
}


#pragma mark //重复-需要删除该方法
- (instancetype)safe_initWithObjects:(const id [])objects count:(NSUInteger)cnt
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
    return [self safe_initWithObjects:safeObjects count:safeCount];
}



+ (instancetype)safe_arrayWithObject:(id)anObject
{
    if (anObject) {
        return [self safe_arrayWithObject:anObject];
    }else{
        NSString *reason = [NSString stringWithFormat:@"+[%@ arrayWithObject:] ==> object cannot be nil",self.class];
        [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
        return nil;
    }
}

+ (instancetype)safe_arrayWithArray:(NSArray *)array
{
    if (array) {
        if ([array isKindOfClass: NSArray.class]) {
            return [self safe_arrayWithArray:array];
        }else{
            NSString *reason = [NSString stringWithFormat:@"+[%@ arrayWithArray:] ==> The value type added must be NSArray; The current type is:%@ ",self.class,array.class];
            [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
            return nil;
        }
    }else{
        return [self safe_arrayWithArray:array];
    }
}


- (instancetype)safe_initWithArray:(NSArray *)array
{
    if (array) {
        if ([array isKindOfClass: NSArray.class]) {
            return [self safe_initWithArray:array];
        }else{
            NSString *reason = [NSString stringWithFormat:@"-[%@ initWithArray:] ==> The value type added must be NSArray; The current type is:%@ ",self.class,array.class];
            [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
            return nil;
        }
    }else{
        return [self safe_initWithArray:array];
    }
}

- (instancetype)safe_initWithArray:(NSArray *)array copyItems:(BOOL)flag
{
    if (array) {
        if ([array isKindOfClass: NSArray.class]) {
            return [self safe_initWithArray:array copyItems:flag];
        }else{
            NSString *reason = [NSString stringWithFormat:@"-[%@ initWithArray:copyItems:] ==> The value type added must be NSArray; The current type is:%@ ",self.class,array.class];
            [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
            return nil;
        }
    }else{
        return [self safe_initWithArray:array copyItems:flag];
    }
}




#pragma mark getter
- (id)safe_objectAtIndexedSubscript:(NSUInteger)idx
{
    if (idx<self.count) {
        return [self safe_objectAtIndexedSubscript:idx];
    }else{
        NSString *reason = [NSString stringWithFormat:@"-[%@ objectAtIndexedSubscript:] ==> index %lu, But count %lu",self.class,idx,self.count];
        [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
        return nil;
    }
}


- (id)safe_objectAtIndex:(NSUInteger)index
{
    if (index<self.count) {
        return [self safe_objectAtIndex:index];
    }else{
        NSString *reason = [NSString stringWithFormat:@"-[%@ objectAtIndex:] ==> index %lu, But count %lu",self.class,index,self.count];
        [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
        return nil;
    }
}

- (NSArray *)safe_objectsAtIndexes:(NSIndexSet *)indexes
{
    if (indexes.lastIndex < self.count || indexes.lastIndex == NSNotFound) {
        return [self safe_objectsAtIndexes:indexes];
    }else{
        NSString *reason = [NSString stringWithFormat:@"-[%@ objectsAtIndexes:] ==> indexes.lastIndex %lu, But count %lu",self.class,indexes.lastIndex,self.count];
        [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
        return nil;
    }
}

- (NSArray *)safe_arrayByAddingObject:(id)anObject
{
    if (anObject) {
        return [self safe_arrayByAddingObject:anObject];
    }else{
        NSString *reason = [NSString stringWithFormat:@"-[%@ arrayByAddingObject:] ==> object connot nil",self.class];
        [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
        return self;
    }
}

- (NSArray *)safe_arrayByAddingObjectsFromArray:(NSArray *)otherArray
{
    if (otherArray) {
        if ([otherArray isKindOfClass:NSArray.class]) {
            return [self safe_arrayByAddingObjectsFromArray:otherArray];
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

+ (void)load
{
    if (TKCrashNilSafe.share.checkCrashNilSafeSwitch) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [self exchangeObjMethod:@selector(arrayByAddingObjectsFromArray:) withMethod:@selector(safe_arrayByAddingObjectsFromArray:)];

            Class _mAry = objc_getClass("__NSArrayM");
            [_mAry exchangeObjMethod:@selector(objectAtIndexedSubscript:) withMethod:@selector(safe_objectAtIndexedSubscript:)];
            [_mAry exchangeObjMethod:@selector(objectAtIndex:) withMethod:@selector(safe_objectAtIndex:)];

            [_mAry exchangeObjMethod:@selector(addObject:) withMethod:@selector(safe_addObject:)];
            [_mAry exchangeObjMethod:@selector(addObjectsFromArray:) withMethod:@selector(safe_addObjectsFromArray:)];
            [_mAry exchangeObjMethod:@selector(insertObject:atIndex:) withMethod:@selector(safe_insertObject:atIndex:)];
            
            [_mAry exchangeObjMethod:@selector(replaceObjectAtIndex:withObject:) withMethod:@selector(safe_replaceObjectAtIndex:withObject:)];
            [_mAry exchangeObjMethod:@selector(exchangeObjectAtIndex:withObjectAtIndex:) withMethod:@selector(safe_exchangeObjectAtIndex:withObjectAtIndex:)];
            
            [_mAry exchangeObjMethod:@selector(removeObjectAtIndex:) withMethod:@selector(safe_removeObjectAtIndex:)];
            [_mAry exchangeObjMethod:@selector(removeObject:inRange:) withMethod:@selector(safe_removeObject:inRange:)];
            [_mAry exchangeObjMethod:@selector(removeObjectsInRange:) withMethod:@selector(safe_removeObjectsInRange:)];
            [_mAry exchangeObjMethod:@selector(removeObjectsInArray:) withMethod:@selector(safe_removeObjectsInArray:)];
            [_mAry exchangeObjMethod:@selector(removeObjectsAtIndexes:) withMethod:@selector(safe_removeObjectsAtIndexes:)];

            [_mAry exchangeObjMethod:@selector(setObject:atIndexedSubscript:) withMethod:@selector(safe_setObject:atIndexedSubscript:)];
            [_mAry exchangeObjMethod:@selector(setArray:) withMethod:@selector(safe_setArray:) ];
            
        });
    }
}

- (NSArray *)safe_arrayByAddingObjectsFromArray:(NSArray *)otherArray
{
    if (otherArray) {
        if ([otherArray isKindOfClass:NSArray.class]) {
            return [self safe_arrayByAddingObjectsFromArray:otherArray];
        }else{
            NSString *reason = [NSString stringWithFormat:@"-[%@ arrayByAddingObjectsFromArray:] ==> The value type added must be NSArray; The current type is:%@",self.class,otherArray.class];
            [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
            return self;
        }
    }else{
        return self;
    }
}


- (void)safe_addObject:(id)anObject
{
    if (anObject) {
        [self safe_addObject:anObject];
    }else{
        NSString *reason = [NSString stringWithFormat:@"-[%@ addObject:] ==> object cannot be nil",self.class];
        [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
    }
}

- (void)safe_addObjectsFromArray:(NSArray *)array
{
    if (array) {
        if ([array isKindOfClass:NSArray.class]) {
            [self safe_addObjectsFromArray:array];
        }else{
            NSString *reason = [NSString stringWithFormat:@"-[%@ addObjectsFromArray:] ==> The value type added must be NSArray; The current type is:%@",self.class,array.class];
            [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
        }
    }
}


- (void)safe_insertObject:(id)anObject atIndex:(NSUInteger)index
{
    if (anObject) {
        if (index > self.count) {
            NSString *reason = [NSString stringWithFormat:@"-[%@ insertObject:atIndex:] ==> atIndex %lu, But the bounds [0 .. %lu]",self.class,index,self.count];
            [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
        }else{
            [self safe_insertObject:anObject atIndex:index];
        }
    }else{
        NSString *reason = [NSString stringWithFormat:@"-[%@ insertObject:atIndex:] ==> objct can't nil ",self.class];
        [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
    }
}



- (void)safe_replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject
{
    if (anObject) {
        if (index<self.count) {
            [self safe_replaceObjectAtIndex:index withObject:anObject];
        }else{
            NSString *reason = [NSString stringWithFormat:@"-[%@ replaceObjectAtIndex:withObject:] ==> index %lu, But the count %lu",self.class,index,self.count];
            [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
        }
    }else{
        NSString *reason = [NSString stringWithFormat:@"-[%@ replaceObjectAtIndex:withObject:] ==> object cannot be nil",self.class];
        [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
    }
}

- (void)safe_exchangeObjectAtIndex:(NSUInteger)idx1 withObjectAtIndex:(NSUInteger)idx2
{
    NSUInteger count = self.count;
    if (idx1<count && idx2 < count) {
        [self safe_exchangeObjectAtIndex:idx1 withObjectAtIndex:idx2];
    }else{
        NSString *reason = [NSString stringWithFormat:@"-[%@ exchangeObjectAtIndex:withObjectAtIndex:] ==> index1:%lu index2:%lu, But the count %lu",self.class,idx1,idx2,count];
        [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
    }
}

- (void)safe_removeObjectAtIndex:(NSUInteger)index
{
    if (index<self.count) {
        [self safe_removeObjectAtIndex:index];
    }else{
        NSString *reason = [NSString stringWithFormat:@"-[%@ removeObjectAtIndex:] ==> index %lu, But the count %lu",self.class,index,self.count];
        [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
    }
}


- (void)safe_removeObject:(id)anObject inRange:(NSRange)range
{
    if (TKSafeMaxRange(range) <= self.count) {
        [self safe_removeObject:anObject inRange:range];
    }else{
        NSString *reason = [NSString stringWithFormat:@"-[%@ removeObject:inRange:] ==> inRange %@, But the bounds [0 .. %lu]",self.class,NSStringFromRange(range),self.count];
        [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
    }
}

- (void)safe_removeObjectsInRange:(NSRange)range
{
    if (TKSafeMaxRange(range) <= self.count) {
        [self safe_removeObjectsInRange:range];
    }else{
        NSString *reason = [NSString stringWithFormat:@"-[%@ removeObjectsInRange:] ==> inRange %@, But the bounds [0 .. %lu]",self.class,NSStringFromRange(range),self.count];
        [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
    }
}

- (void)safe_removeObjectsInArray:(NSArray *)otherArray
{
    if (otherArray) {
        if ([otherArray isKindOfClass:NSArray.class]) {
            [self safe_removeObjectsInArray:otherArray];
        }else{
            NSString *reason = [NSString stringWithFormat:@"-[%@ removeObjectsInArray:] ==> The value type added must be NSArray; The current type is:%@",self.class,otherArray.class];
            [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
        }
    }
}

- (void)safe_removeObjectsAtIndexes:(NSIndexSet *)indexes
{
    if (indexes.lastIndex < self.count || indexes.lastIndex == NSNotFound) {
        [self safe_removeObjectsAtIndexes:indexes];
    }else{
        NSString *reason = [NSString stringWithFormat:@"-[%@ removeObjectsAtIndexes:] ==> indexes.lastIndex %lu, But count %lu",self.class,indexes.lastIndex,self.count];
        [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
    }
}


- (void)safe_setObject:(id)obj atIndexedSubscript:(NSUInteger)idx
{
    if (obj) {
        if (idx>self.count) {
            NSString *reason = [NSString stringWithFormat:@"-[%@ setObject:atIndexedSubscript:] ==> index %lu, But the bounds [0 .. %lu]",self.class,idx,self.count];
            [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
        }else{
            [self safe_setObject:obj atIndexedSubscript:idx];
        }
    }else{
        NSString *reason = [NSString stringWithFormat:@"-[%@ setObject:atIndexedSubscript:] ==> object cannot be nil",self.class];
        [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
    }
}

- (void)safe_setArray:(NSArray *)otherArray
{
    if (otherArray) {
        if ([otherArray isKindOfClass:NSArray.class]) {
            [self safe_setArray:otherArray];
        }else{
            NSString *reason = [NSString stringWithFormat:@"-[%@ setArray:] ==> The value type added must be NSArray; The current type is:%@",self.class,otherArray.class];
            [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
        }
    }else{
        [self safe_setArray:otherArray];
    }
}

@end
