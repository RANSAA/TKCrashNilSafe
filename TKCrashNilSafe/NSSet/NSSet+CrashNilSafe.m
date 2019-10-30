//
//  NSSet+CrashNilSafe.m
//  NilSafeTest
//
//  Created by mac on 2019/10/15.
//  Copyright © 2019 mac. All rights reserved.
//

#import "NSSet+CrashNilSafe.h"
#import <objc/runtime.h>


@implementation NSSet (CrashNilSafe)


@end


@implementation NSMutableSet (CrashNilSafe)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = objc_getClass("__NSSetM");
        [class TK_exchangeMethod:@selector(addObject:) withMethod:@selector(tk_addObject:)];
        [class TK_exchangeMethod:@selector(removeObject:) withMethod:@selector(tk_removeObject:)];
    });
}

- (void)tk_addObject:(id)object
{
    if (object) {
        [self tk_addObject:object];
    }else{
        NSString *tips = [NSString stringWithFormat:@"⚠️⚠️NSMutableSet ==> addObject: 不能为nil"];
        [self noteErrorWithException:nil defaultToDo:tips];
    }
}

- (void)tk_removeObject:(id)object
{
    if (object) {
        [self tk_removeObject:object];
    }else{
        NSString *tips = [NSString stringWithFormat:@"⚠️⚠️NSMutableSet ==> removeObject: 不能为nil"];
        [self noteErrorWithException:nil defaultToDo:tips];
    }
}

@end




@implementation NSOrderedSet (CrashNilSafe)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class orderedSetI = NSClassFromString(@"__NSOrderedSetI");
        [orderedSetI TK_exchangeMethod:@selector(objectAtIndex:) withMethod:@selector(tk_objectAtIndex:)];
    });
}

- (id)tk_objectAtIndex:(NSUInteger)index
{
    if (index < self.count) {
        return [self tk_objectAtIndex:index];
    }else{
        NSString *tips = [NSString stringWithFormat:@"⚠️⚠️NSOrderedSet ==> objectAtIndex: 越界，count:%ld  index:%ld",self.count,index];
        [self noteErrorWithException:nil defaultToDo:tips];
        return nil;
    }
}

@end

@implementation NSMutableOrderedSet (CrashNilSafe)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = NSClassFromString(@"__NSOrderedSetM");
        [class TK_exchangeMethod:@selector(objectAtIndex:) withMethod:@selector(tk_mu_objectAtIndex:)];
        [class TK_exchangeMethod:@selector(addObject:) withMethod:@selector(tk_addObject:)];
        [class TK_exchangeMethod:@selector(insertObject:atIndex:) withMethod:@selector(tk_insertObject:atIndex:)];
        [class TK_exchangeMethod:@selector(removeObjectAtIndex:) withMethod:@selector(tk_removeObjectAtIndex:)];
        [class TK_exchangeMethod:@selector(replaceObjectAtIndex:withObject:) withMethod:@selector(tk_replaceObjectAtIndex:withObject:)];
        [class TK_exchangeMethod:@selector(setObject:atIndex:) withMethod:@selector(tk_setObject:atIndex:)];
    });
}

- (id)tk_mu_objectAtIndex:(NSUInteger)index
{
    if (index < self.count) {
        return [self tk_mu_objectAtIndex:index];
    }else{
        NSString *tips = [NSString stringWithFormat:@"⚠️⚠️NSMutableOrderedSet ==> objectAtIndex: 越界，count:%ld  index:%ld",self.count,index];
        [self noteErrorWithException:nil defaultToDo:tips];
        return nil;
    }
}

- (void)tk_insertObject:(id)anObject atIndex:(NSUInteger)index
{
    if (anObject && index<self.count+1) {
        [self tk_insertObject:anObject atIndex:index];
    }else{
        NSString *tips = [NSString stringWithFormat:@"⚠️⚠️NSMutableOrderedSet ==> insertObject:atIndex:错误，object:%@  maxIndex:%ld  index:%ld",anObject,self.count,index];
        [self noteErrorWithException:nil defaultToDo:tips];
    }
}

- (void)tk_removeObjectAtIndex:(NSUInteger)index
{
    if (index<self.count) {
        [self tk_removeObjectAtIndex:index];
    }else{
        NSString *tips = [NSString stringWithFormat:@"⚠️⚠️NSMutableOrderedSet ==>  removeObjectAtIndex:越界， maxIndex:%ld  index:%ld",self.count-1,index];
        [self noteErrorWithException:nil defaultToDo:tips];
    }
}

- (void)tk_addObject:(id)object
{
    if (object) {
        [self tk_addObject:object];
    }else{
        NSString *tips = [NSString stringWithFormat:@"⚠️⚠️NSMutableOrderedSet ==> addObject:错误,object不能为nil"];
        [self noteErrorWithException:nil defaultToDo:tips];
    }
}

- (void)tk_setObject:(id)obj atIndex:(NSUInteger)idx
{
    if (obj && idx<self.count+1) {
        [self tk_setObject:obj atIndex:idx];
    }else{
        NSString *tips = [NSString stringWithFormat:@"⚠️⚠️NSMutableOrderedSet ==> setObject:atIndex:错误, object:%@  maxIndex:%ld  AtIndex:%ld",obj,self.count,idx];
        [self noteErrorWithException:nil defaultToDo:tips];
    }
}

- (void)tk_replaceObjectAtIndex:(NSUInteger)index withObject:(id)object
{
    if (index<self.count && object) {
        [self tk_replaceObjectAtIndex:index withObject:object];
    }else{
        NSString *tips = [NSString stringWithFormat:@"⚠️⚠️NSMutableOrderedSet ==> replaceObjectAtIndex:withObject:错误, object:%@  maxIndex:%ld  AtIndex:%ld",object,self.count-1,index];
        [self noteErrorWithException:nil defaultToDo:tips];
    }
}



@end
