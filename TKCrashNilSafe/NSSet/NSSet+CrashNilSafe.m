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


@implementation NSSet (CrashNilSafe)


@end


@implementation NSMutableSet (CrashNilSafe)

+ (void)load
{
    if (TKCrashNilSafe.share.checkCrashNilSafeSwitch) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            Class class = objc_getClass("__NSSetM");
            [class exchangeObjMethod:@selector(addObject:) withMethod:@selector(safe_addObject:)];
            [class exchangeObjMethod:@selector(removeObject:) withMethod:@selector(safe_removeObject:)];
        });
    }
}

- (void)safe_addObject:(id)object
{
    if (object) {
        [self safe_addObject:object];
    }else{
        NSString *reason = [NSString stringWithFormat:@"-[%@ addObject:] ==> object cannot be nil",self.class];
        [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
    }
}

- (void)safe_removeObject:(id)object
{
    if (object) {
        [self safe_removeObject:object];
    }else{
        NSString *reason = [NSString stringWithFormat:@"-[%@ removeObject:] ==> key cannot be nil",self.class];
        [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
    }
}

@end




@implementation NSOrderedSet (CrashNilSafe)

+ (void)load
{
    if (TKCrashNilSafe.share.checkCrashNilSafeSwitch) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            Class class = NSClassFromString(@"__NSOrderedSetI");
            [class exchangeObjMethod:@selector(objectAtIndex:) withMethod:@selector(safe_objectAtIndex:)];
        });
    }
}

- (id)safe_objectAtIndex:(NSUInteger)index
{
    if (index < self.count) {
        return [self safe_objectAtIndex:index];
    }else{
        NSString *reason = [NSString stringWithFormat:@"-[%@ objectAtIndex:] ==> index %lu, But count %lu",self.class,index,self.count];
        [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
        return nil;
    }
}

@end


@implementation NSMutableOrderedSet (CrashNilSafe)

+ (void)load
{
    if (TKCrashNilSafe.share.checkCrashNilSafeSwitch) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            Class class = NSClassFromString(@"__NSOrderedSetM");
            [class exchangeObjMethod:@selector(objectAtIndex:) withMethod:@selector(safe_objectAtIndex:)];
            [class exchangeObjMethod:@selector(addObject:) withMethod:@selector(safe_addObject:)];
            [class exchangeObjMethod:@selector(insertObject:atIndex:) withMethod:@selector(safe_insertObject:atIndex:)];
            [class exchangeObjMethod:@selector(setObject:atIndex:) withMethod:@selector(safe_setObject:atIndex:)];
            
            [class exchangeObjMethod:@selector(removeObjectAtIndex:) withMethod:@selector(safe_removeObjectAtIndex:)];
            [class exchangeObjMethod:@selector(removeObjectsInRange:) withMethod:@selector(safe_removeObjectsInRange:)];
            [class exchangeObjMethod:@selector(removeObjectsInArray:) withMethod:@selector(safe_removeObjectsInArray:)];
            [class exchangeObjMethod:@selector(removeObjectsAtIndexes:) withMethod:@selector(safe_removeObjectsAtIndexes:)];
            
            [class exchangeObjMethod:@selector(replaceObjectAtIndex:withObject:) withMethod:@selector(safe_replaceObjectAtIndex:withObject:)];
            [class exchangeObjMethod:@selector(exchangeObjectAtIndex:withObjectAtIndex:) withMethod:@selector(safe_exchangeObjectAtIndex:withObjectAtIndex:)];
            
        });
    }
}


- (void)safe_addObject:(id)object
{
    if (object) {
        [self safe_addObject:object];
    }else{
        NSString *reason = [NSString stringWithFormat:@"-[%@ addObject:] ==> object cannot be nil",self.class];
        [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
    }
}


- (void)safe_insertObject:(id)anObject atIndex:(NSUInteger)index
{
    if (anObject) {
        if (index <= self.count) {
            [self safe_insertObject:anObject atIndex:index];
        }else{
            NSString *reason = [NSString stringWithFormat:@"-[%@ insertObject:atIndex:] ==> atIndex %lu, But the bounds [0 .. %lu]",self.class,index,self.count];
            [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
        }
    }else{
        NSString *reason = [NSString stringWithFormat:@"-[%@ insertObject:] ==> object cannot be nil",self.class];
        [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
    }
}

- (void)safe_setObject:(id)obj atIndex:(NSUInteger)idx
{
    if (obj) {
        if (idx>self.count) {
            NSString *reason = [NSString stringWithFormat:@"-[%@ setObject:atIndex:] ==> index %lu, But the bounds [0 .. %lu]",self.class,idx,self.count];
            [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
        }else{
            [self safe_setObject:obj atIndex:idx];
        }
    }else{
        NSString *reason = [NSString stringWithFormat:@"-[%@ setObject:atIndex:] ==> object cannot be nil",self.class];
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
    if (indexes.lastIndex < self.count) {
        [self safe_removeObjectsAtIndexes:indexes];
    }else{
        NSString *reason = [NSString stringWithFormat:@"-[%@ removeObjectsAtIndexes:] ==> indexes.lastIndex %lu, But count %lu",self.class,indexes.lastIndex,self.count];
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


@end
