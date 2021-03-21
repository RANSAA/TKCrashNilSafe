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


+ (void)load
{
    if (TKCrashNilSafe.share.checkCrashNilSafeSwitch) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [self exchangeObjMethod:@selector(methodSignatureForSelector:) withMethod:@selector(safe_methodSignatureForSelector:)];
            [self exchangeObjMethod:@selector(forwardInvocation:) withMethod:@selector(safe_forwardInvocation:)];
        });
    }
}

- (NSMethodSignature *)safe_methodSignatureForSelector:(SEL)aSelector {
    NSMethodSignature *sig = [self safe_methodSignatureForSelector:aSelector];
    if (sig) {
        return sig;
    }
    
    NSString *reason = [NSString stringWithFormat:@"⚠️unrecognized selector ==> [%@ %@]",self.class,NSStringFromSelector(aSelector)];
    [self handleErrorWithName:TKCrashNilSafeExceptionNoAbort mark:reason];
    
    return [NSMethodSignature signatureWithObjCTypes:@encode(void)];
}

- (void)safe_forwardInvocation:(NSInvocation *)anInvocation {
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
