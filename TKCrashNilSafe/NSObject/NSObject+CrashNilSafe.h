//
//  NSObject+CrashNilSafe.h
//  NilSafeTest
//
//  Created by mac on 2019/9/27.
//  Copyright © 2019 mac. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

#ifdef DEBUG
#define  CrashNilSafeLog(...) NSLog(@"%@",[NSString stringWithFormat:__VA_ARGS__])
#else
#define  CrashNilSafeLog(...)
#endif

/**
 如果要收集异常日志，请监听该通知,提取（crashInfo）信息
 **/
#define kTKCrashNilSafeCheckNotification  @"kTKCrashNilSafeCheckNotification"

/**
 KVO重复添加处理控制宏，可以根据需求设置对应模式
 0:不处理重复添加
 1:处理重复添加，只校验observer和keyPath --该项为默认
 2:处理重复添加，检查所有：observer，keyPath，options，context（手动管理KVO信息）
 **/
#define kCrashNilSafeCheckKVOAddType    1



@interface NSObject (CrashNilSafe)

#pragma mark 函数交换，注意这两个方法是相同的只是使用者不同
/**
 交换对象中的方法
 **/
+ (BOOL)TK_exchangeMethod:(SEL)origSel withMethod:(SEL)altSel;

/**
 交换类中的方法
 **/
+ (BOOL)TK_exchangeClassMethod:(SEL)origSel withMethod:(SEL)altSel;


#pragma mark 捕获异常出现位置及其相关错误信息
/**
 *  提示崩溃的信息(控制台输出、通知)
 *  @param exception   捕获到的异常
 *  @param defaultToDo 这个框架里默认的做法
 */
- (void)noteErrorWithException:(nullable NSException *)exception defaultToDo:(NSString *)defaultToDo;

@end

NS_ASSUME_NONNULL_END
