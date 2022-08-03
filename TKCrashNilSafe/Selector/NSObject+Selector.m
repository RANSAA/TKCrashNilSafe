//
//  NSObject+Selector.m
//  NilSafeTest
//
//  Created by PC on 2021/3/13.
//  Copyright © 2021 mac. All rights reserved.
//

#import "NSObject+Selector.h"
#import "TKCrashNilSafe.h"


@implementation NSObject (Selector)


/**
 函数交换通用入口
 */
+ (void)TKCrashNilSafe_SwapMethod_Selector
{
    if (!TKCrashNilSafe.share.isEnableInDebug) {
        return;
    }

    [self exchangeObjMethod:@selector(methodSignatureForSelector:) withMethod:@selector(TKCrashNilSafe_methodSignatureForSelector:)];
    [self exchangeObjMethod:@selector(forwardInvocation:) withMethod:@selector(TKCrashNilSafe_forwardInvocation:)];
}


- (NSMethodSignature *)TKCrashNilSafe_methodSignatureForSelector:(SEL)aSelector {
    NSMethodSignature *sig = [self TKCrashNilSafe_methodSignatureForSelector:aSelector];
    if (sig) {
        return sig;
    }
    
    NSString *reason = [NSString stringWithFormat:@"⚠️unrecognized selector ==> [%@ %@]",self.class,NSStringFromSelector(aSelector)];
    [self handleErrorWithName:TKCrashNilSafeExceptionNoAbort mark:reason];
    
    return [NSMethodSignature signatureWithObjCTypes:@encode(void)];
}

- (void)TKCrashNilSafe_forwardInvocation:(NSInvocation *)anInvocation {
    NSUInteger returnLength = [[anInvocation methodSignature] methodReturnLength];
    if (!returnLength) {
        // nothing to do
        return;
    }
    // set return value to all zero bits
    char buffer[returnLength];
    memset(buffer, 0, returnLength);
    [anInvocation setReturnValue:buffer];
}

@end
