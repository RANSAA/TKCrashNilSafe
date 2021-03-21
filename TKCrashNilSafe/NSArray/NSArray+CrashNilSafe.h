//
//  NSArray+CrashNilSafe.h
//  NilSafeTest
//
//  Created by mac on 2019/9/27.
//  Copyright © 2019 mac. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 其它：
   -[replaceObjectsAtIndexes: withObjects:]这个判断函数条件比较严谨，在使用时用户要注意自行判断
 */

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (CrashNilSafe)

@end


@interface NSMutableArray (CrashNilSafe)

@end

NS_ASSUME_NONNULL_END
