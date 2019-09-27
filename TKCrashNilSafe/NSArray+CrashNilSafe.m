//
//  NSArray+CrashNilSafe.m
//  NilSafeTest
//
//  Created by mac on 2019/9/27.
//  Copyright © 2019 mac. All rights reserved.
//

#import "NSArray+CrashNilSafe.h"
#import "NSObject+CrashNilSafe.h"
#import <objc/runtime.h>


@implementation NSArray (CrashNilSafe)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self tk_swizzleClassMethod:@selector(arrayWithObjects:count:) withMethod:@selector(tk_arrayWithObjects:count:)];
        [objc_getClass("__NSPlaceholderArray") tk_swizzleMethod:@selector(initWithObjects:count:) withMethod:@selector(tk_initWithObjects:count:)];
    });
}

- (instancetype)tk_initWithObjects:(const id [])objects count:(NSUInteger)cnt
{
    id safeObjects[cnt];
    NSUInteger j = 0;
    for (NSInteger i=0; i<cnt; i++) {
        id item = objects[i];
        if (!item) {
            NSLog(@"🆘🆘🆘NSArray中含有空值nil，处理策略是：该item不添加，即NSArray的有效长度减一,出现空值的位置⭕️index:%ld⭕️⚠️⚠️⚠️请尽快修改!",i);
            continue;
        }
        safeObjects[j]=item;
        j++;
    }
    return [self tk_initWithObjects:safeObjects count:j++];
}

+ (instancetype)tk_arrayWithObjects:(const id [])objects count:(NSUInteger)cnt
{
    id safeObjects[cnt];
    NSUInteger j = 0;
    for (NSInteger i=0; i<cnt; i++) {
        id item = objects[i];
        if (!item) {
            NSLog(@"🆘🆘🆘NSArray中含有空值nil，处理策略是：该item不添加，即NSArray的有效长度减一,出现空值的位置⭕️index:%ld⭕️⚠️⚠️⚠️请尽快修改!",i);
            continue;
        }
        safeObjects[j]=item;
        j++;
    }
    return [self tk_arrayWithObjects:safeObjects count:j];
}

@end



@implementation NSMutableArray (CrashNilSafe)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [objc_getClass("__NSArrayM") tk_swizzleMethod:@selector(insertObject:atIndex:) withMethod:@selector(tk_insertObject:atIndex:)];
        [objc_getClass("__NSArrayM") tk_swizzleMethod:@selector(objectAtIndex:) withMethod:@selector(tk_objectAtIndex:)];

//        [objc_getClass("__NSArrayM") tk_swizzleMethod:@selector(objectAtIndex:) withMethod:@selector(tk_objectAtIndex:)];

//        [objc_getClass("__NSArray0") tk_swizzleMethod:@selector(objectAtIndex:) withMethod:@selector(emptyArray_objectAtIndex:)];
//        [objc_getClass("__NSArrayI") tk_swizzleMethod:@selector(objectAtIndex:) withMethod:@selector(arrayI_objectAtIndex:)];
//        [objc_getClass("__NSArrayM") tk_swizzleMethod:@selector(objectAtIndex:) withMethod:@selector(arrayM_objectAtIndex:)];
//        [objc_getClass("__NSSingleObjectArrayI") tk_swizzleMethod:@selector(objectAtIndex:) withMethod:@selector(singleObjectArrayI_objectAtIndex:)];
//
//        [objc_getClass("__NSArray0") tk_swizzleMethod:@selector(objectAtIndexedSubscript:) withMethod:@selector(emptyArray_objectAtIndexedSubscript:)];
//        [objc_getClass("__NSArrayI") tk_swizzleMethod:@selector(objectAtIndexedSubscript:) withMethod:@selector(arrayI_objectAtIndexedSubscript:)];
//        [objc_getClass("__NSArrayM") tk_swizzleMethod:@selector(objectAtIndexedSubscript:) withMethod:@selector(arrayM_objectAtIndexedSubscript:)];
//        [objc_getClass("__NSSingleObjectArrayI") tk_swizzleMethod:@selector(objectAtIndex:) withMethod:@selector(singleObjectArrayI_objectAtIndexedSubscript:)];


    });
}

- (void)tk_insertObject:(id)anObject atIndex:(NSUInteger)index
{
    if (anObject ) {
        [self tk_insertObject:anObject atIndex:index];
    }else{
        NSLog(@"🆘🆘🆘向NSMutableArray添加了nil空数据,⭕️添加数据的位置是:%ld⭕️⚠️⚠️⚠️请尽快修改!",index);
    }
}

/**
 插入数据：验证nil空值，和是否越界
 替换 insertObject:atIndex: 方法使用！
 **/
- (void)insertObjectVerify:(id)anObject atIndex:(NSUInteger)index
{
    if (anObject && index<self.count) {
        [self tk_insertObject:anObject atIndex:index];
    }
}


- (id)tk_objectAtIndex:(NSUInteger)index
{
    if (index<self.count) {
        return [self tk_objectAtIndex:index];
    }else{
        NSLog(@"🆘🆘🆘NSArray越界,返回nil⚠️⚠️⚠️请尽快修改!");
        return nil;
    }
}





@end
