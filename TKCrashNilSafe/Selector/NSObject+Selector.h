//
//  NSObject+Selector.h
//  NilSafeTest
//
//  Created by PC on 2021/3/13.
//  Copyright © 2021 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 扩展处理performSelector：调用调用找不到方法时奔溃问题(unrecognized selector sent to instance)
 */

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Selector)

@end

NS_ASSUME_NONNULL_END
