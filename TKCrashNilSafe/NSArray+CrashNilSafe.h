//
//  NSArray+CrashNilSafe.h
//  NilSafeTest
//
//  Created by mac on 2019/9/27.
//  Copyright © 2019 mac. All rights reserved.
//

/**
 空值处理策略：
 1.初始化时遇到空值nil,直接将该nil值剔除
 
 **/

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (CrashNilSafe)

@end


@interface NSMutableArray (CrashNilSafe)
///**
// 插入数据：验证nil空值，和是否越界
// **/
//- (void)insertObjectVerify:(id)anObject atIndex:(NSUInteger)index;
@end

NS_ASSUME_NONNULL_END
