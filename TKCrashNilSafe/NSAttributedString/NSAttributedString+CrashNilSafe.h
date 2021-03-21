//
//  NSAttributedString+CrashNilSafe.h
//  NilSafeTest
//
//  Created by mac on 2019/10/15.
//  Copyright © 2019 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 字符串判断时，一般只判断是否为nil， 而不进行字符串的类型判断
 */

NS_ASSUME_NONNULL_BEGIN


@interface NSAttributedString (CrashNilSafe)

@end

@interface NSMutableAttributedString (CrashNilSafe)

@end

NS_ASSUME_NONNULL_END
