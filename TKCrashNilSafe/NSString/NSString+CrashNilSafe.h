//
//  NSString+CrashNilSafe.h
//  NilSafeTest
//
//  Created by mac on 2019/10/15.
//  Copyright © 2019 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 方法处理时：一般只判断是否为nil,越界，只有部分实例化方法会进行类型判断
 */

NS_ASSUME_NONNULL_BEGIN

@interface NSString (CrashNilSafe)

@end

@interface NSMutableString (CrashNilSafe)

@end

NS_ASSUME_NONNULL_END
