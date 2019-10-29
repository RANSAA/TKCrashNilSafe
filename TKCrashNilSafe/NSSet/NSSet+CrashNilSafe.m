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

//+ (void)load
//{
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        Class class = objc_getClass("__NSPlaceholderSet");
//        [class TK_exchangeMethod:@selector(initWithObjects:count:) withMethod:@selector(tk_initWithObjects:count:)];
//
//    });
//}

//- (instancetype)tk_initWithObjects:(id  _Nonnull const [])objects count:(NSUInteger)cnt
//{
//    id instance = nil;
//    @try {
//        instance = [self tk_initWithObjects:objects count:cnt];
//    } @catch (NSException *exception) {
//        NSInteger newObjsIndex = 0;
//        id   newObjects[cnt];
//        for (int i = 0; i < cnt; i++) {
//            if (objects[i] != nil) {
//                newObjects[newObjsIndex] = objects[i];
//                newObjsIndex++;
//            }
//        }
//        instance = [self tk_initWithObjects:newObjects count:newObjsIndex];
//        NSString *tips = [NSString stringWithFormat:@"⚠️⚠️NSSet initWithObjects:count: 不能为nil，请尽快修改！"];
//        [self noteErrorWithException:exception defaultToDo:tips];
//    } @finally {
//        return instance;
//    }


//    id obj = nil;
//    if (objects) {
//        obj = [self tk_initWithObjects:objects count:cnt];
//    }else{
//        obj = [self tk_initWithObjects: count:cnt];
//        NSString *tips = [NSString stringWithFormat:@"⚠️⚠️NSSet initWithObjects:count: 不能为nil，请尽快修改！"];
//        [self noteErrorWithException:nil defaultToDo:tips];
//    }
//    return obj;
//}

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
        NSString *tips = [NSString stringWithFormat:@"⚠️⚠️NSMutableSet addObject: 不能为nil，请尽快修改！"];
        [self noteErrorWithException:nil defaultToDo:tips];
    }
}

- (void)tk_removeObject:(id)object
{
    if (object) {
        [self tk_removeObject:object];
    }else{
        NSString *tips = [NSString stringWithFormat:@"⚠️⚠️NSMutableSet removeObject: 不能为nil，请尽快修改！"];
        [self noteErrorWithException:nil defaultToDo:tips];
    }
}

@end




@implementation NSOrderedSet (CrashNilSafe)

@end

@implementation NSMutableOrderedSet (CrashNilSafe)

@end
