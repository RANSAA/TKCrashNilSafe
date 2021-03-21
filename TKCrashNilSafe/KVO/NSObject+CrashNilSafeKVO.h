//
//  NSObject+CrashNilSafeKVO.h
//  NilSafeTest
//
//  Created by PC on 2021/3/18.
//  Copyright © 2021 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 TKCrashSafeKVOTypeCache:模式下可以防止重复添加KVO监听，重复删除KVO监听,并且可以准确的定位出错误信息，Default
 TKCrashSafeKVOTypeTry:模式下可以防止重复删除问题，但是无法解决重复添加相同的KVO监听
 TKCrashSafeKVOTypeOff:关闭KVO安全模式
 */

@interface NSObject (CrashNilSafeKVO)

@end

NS_ASSUME_NONNULL_END
