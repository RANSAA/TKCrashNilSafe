//
//  NSObject+CrashNilSafe.m
//  NilSafeTest
//
//  Created by mac on 2019/9/27.
//  Copyright © 2019 mac. All rights reserved.
//

#import "NSObject+CrashNilSafe.h"
#import <objc/runtime.h>


@implementation NSObject (CrashNilSafe)

/**
 交换两个函数
 **/
+ (BOOL)tk_swizzleMethod:(SEL)origSel withMethod:(SEL)altSel
{
    Method origMethod = class_getInstanceMethod(self, origSel);
    Method altMethod = class_getInstanceMethod(self, altSel);
    if (!origMethod || !altMethod) {
        return NO;
    }
    class_addMethod(self,
                    origSel,
                    class_getMethodImplementation(self, origSel),
                    method_getTypeEncoding(origMethod));
    class_addMethod(self,
                    altSel,
                    class_getMethodImplementation(self, altSel),
                    method_getTypeEncoding(altMethod));
    method_exchangeImplementations(class_getInstanceMethod(self, origSel),
                                   class_getInstanceMethod(self, altSel));
    return YES;
}

+ (BOOL)tk_swizzleClassMethod:(SEL)origSel withMethod:(SEL)altSel
{
    return [object_getClass((id)self) tk_swizzleMethod:origSel withMethod:altSel];
}

@end
