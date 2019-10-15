//
//  NSObject+CrashNilSafe.h
//  NilSafeTest
//
//  Created by mac on 2019/9/27.
//  Copyright © 2019 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>


NS_ASSUME_NONNULL_BEGIN

#ifdef DEBUG
#define  CrashNilSafeLog(...) NSLog(@"%@",[NSString stringWithFormat:__VA_ARGS__])
#else
#define  CrashNilSafeLog(...)
#endif

/**
 如果要收集异常日志，请监听该通知
 **/
#define CrashNilSafeNotification  @"CrashNilSafeNotification"


@interface NSObject (CrashNilSafe)

#pragma mark 函数交换，注意这两个方法是相同的只是使用者不同
/**
 交换对象中的方法
 **/
+ (BOOL)tk_swizzleMethod:(SEL)origSel withMethod:(SEL)altSel;

/**
 交换类中的方法
 **/
+ (BOOL)tk_swizzleClassMethod:(SEL)origSel withMethod:(SEL)altSel;



#pragma mark 捕获异常出现位置及其相关错误信息
/**
 *  获取堆栈主要崩溃精简化的信息<根据正则表达式匹配出来>
 *  @param callStackSymbols 堆栈主要崩溃信息
 *  @return 堆栈主要崩溃精简化的信息
 */
- (NSString *)getMainCallStackSymbolMessageWithCallStackSymbols:(NSArray<NSString *> *)callStackSymbols;
/**
 *  提示崩溃的信息(控制台输出、通知)
 *  @param exception   捕获到的异常
 *  @param defaultToDo 这个框架里默认的做法
 */
- (void)noteErrorWithException:(nullable NSException *)exception defaultToDo:(NSString *)defaultToDo;

@end

NS_ASSUME_NONNULL_END
