//
//  NSObject+CrashNilSafe.h
//  NilSafeTest
//
//  Created by mac on 2019/9/27.
//  Copyright © 2019 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (CrashNilSafe)
+ (BOOL)tk_swizzleMethod:(SEL)origSel withMethod:(SEL)altSel;
+ (BOOL)tk_swizzleClassMethod:(SEL)origSel withMethod:(SEL)altSel;

@end

NS_ASSUME_NONNULL_END
