//
//  NSAttributedString+CrashNilSafe.h
//  NilSafeTest
//
//  Created by mac on 2019/10/15.
//  Copyright © 2019 mac. All rights reserved.
//

/**
 优化策略不是太好
 **/

#import <Foundation/Foundation.h>
#import "NSObject+CrashNilSafe.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSAttributedString (CrashNilSafe)

@end

@interface NSMutableAttributedString (CrashNilSafe)

@end

NS_ASSUME_NONNULL_END
