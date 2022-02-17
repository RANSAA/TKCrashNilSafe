//
//  NSObject+TKSafeCore.h
//  NilSafeTest
//
//  Created by PC on 2021/3/13.
//  Copyright © 2021 mac. All rights reserved.
//

#import <Foundation/Foundation.h>



NS_ASSUME_NONNULL_BEGIN


extern NSString * const TKCrashNilSafeExceptionDefault; //default
extern NSString * const TKCrashNilSafeExceptionNoAbort; //该标志下的Crash是不用abort中断的


/**
 功能：获取range.location + range.length
 条件：
 1: negative value
 - NSUInteger  > NSIntegerMax
 2: overflow
 - (a+ b) > a
 */
NS_INLINE NSUInteger TKSafeMaxRange(NSRange range)
{
    // negative or reach limit
    if (range.location >= NSNotFound
        || range.length >= NSNotFound){
        return NSNotFound;
    }
    // overflow
    if ((range.location + range.length) < range.location){
        return NSNotFound;
    }
    return (range.location + range.length);
}


@interface NSObject (TKSafeCore)


#pragma mark 提供函数交换方法
/** 交换类中的方法*/
+ (BOOL)exchangeClassMethod:(SEL)originSel withMethod:(SEL)swizzledSel;
/** 交换对象中的方法*/
+ (BOOL)exchangeObjMethod:(SEL)originSel withMethod:(SEL)swizzledSel;

/**
 函数交换
 交换类中的方法： Class.class
 交换对象中的方法: obj.class
 */
+ (void)swizzleMethod:(Class)class orgSel:(SEL)originSel swizzSel:(SEL)swizzledSel;


#pragma mark Crash处理入口方法

/**
 Crash处理入口方法(控制台输出、通知)
 expName:Crash异常类型名称
 mark:Crash描述信息
 */
- (void)handleErrorWithName:(NSString *)expName mark:(NSString *)mark;


@end

NS_ASSUME_NONNULL_END
