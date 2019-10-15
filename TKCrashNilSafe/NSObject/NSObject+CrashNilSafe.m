//
//  NSObject+CrashNilSafe.m
//  NilSafeTest
//
//  Created by mac on 2019/9/27.
//  Copyright © 2019 mac. All rights reserved.
//

#import "NSObject+CrashNilSafe.h"


#define crashNilSafeSeparatorWithFlag @"========================CrashNilSafe Log=========================="



@implementation NSObject (CrashNilSafe)

#pragma mark 函数交换，注意这两个方法是相同的只是使用者不同

/**
 交换对象中的方法
 **/
+ (BOOL)tk_swizzleMethod:(SEL)origSel withMethod:(SEL)altSel
{
    Method origMethod = class_getInstanceMethod(self, origSel);
    Method altMethod = class_getInstanceMethod(self, altSel);
    if (!origMethod || !altMethod) {
        return NO;
    }
    class_addMethod(self,
                    origSel,
                    class_getMethodImplementation(self, origSel),
                    method_getTypeEncoding(origMethod));
    class_addMethod(self,
                    altSel,
                    class_getMethodImplementation(self, altSel),
                    method_getTypeEncoding(altMethod));
    method_exchangeImplementations(class_getInstanceMethod(self, origSel),
                                   class_getInstanceMethod(self, altSel));
    return YES;
}

/**
 交换类中的方法
 **/
+ (BOOL)tk_swizzleClassMethod:(SEL)origSel withMethod:(SEL)altSel
{
    return [object_getClass((id)self) tk_swizzleMethod:origSel withMethod:altSel];
}


#pragma mark 捕获异常出现位置及其相关错误信息
/**
 *  获取堆栈主要崩溃精简化的信息<根据正则表达式匹配出来>
 *  @param callStackSymbols 堆栈主要崩溃信息
 *  @return 堆栈主要崩溃精简化的信息
 */
- (NSString *)getMainCallStackSymbolMessageWithCallStackSymbols:(NSArray<NSString *> *)callStackSymbols
{
    //mainCallStackSymbolMsg的格式为   +[类名 方法名]  或者 -[类名 方法名]
    __block NSString *mainCallStackSymbolMsg = nil;
    //匹配出来的格式为 +[类名 方法名]  或者 -[类名 方法名]
    NSString *regularExpStr = @"[-\\+]\\[.+\\]";
    NSRegularExpression *regularExp = [[NSRegularExpression alloc] initWithPattern:regularExpStr options:NSRegularExpressionCaseInsensitive error:nil];
    for (int index = 2; index < callStackSymbols.count; index++) {
        NSString *callStackSymbol = callStackSymbols[index];
        [regularExp enumerateMatchesInString:callStackSymbol options:NSMatchingReportProgress range:NSMakeRange(0, callStackSymbol.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
            if (result) {
                NSString* tempCallStackSymbolMsg = [callStackSymbol substringWithRange:result.range];
                //get className
                NSString *className = [tempCallStackSymbolMsg componentsSeparatedByString:@" "].firstObject;
                className = [className componentsSeparatedByString:@"["].lastObject;
                NSBundle *bundle = [NSBundle bundleForClass:NSClassFromString(className)];
                //filter category and system class
                if (![className hasSuffix:@")"] && bundle == [NSBundle mainBundle]) {
                    mainCallStackSymbolMsg = tempCallStackSymbolMsg;
                }
                *stop = YES;
            }
        }];
        if (mainCallStackSymbolMsg.length) {
            break;
        }
    }
    return mainCallStackSymbolMsg;
}

/**
 *  提示崩溃的信息(控制台输出、通知)
 *  @param exception   捕获到的异常
 *  @param defaultToDo 这个框架里默认的做法
 */
- (void)noteErrorWithException:(nullable NSException *)exception defaultToDo:(NSString *)defaultToDo
{
    NSString *crashInfoStr = nil;
    NSString *logErrorMessage = nil;

    //堆栈数据
    NSArray *callStackSymbolsArr = [NSThread callStackSymbols];

    //获取在哪个类的哪个方法中实例化的数组  字符串格式 -[类名 方法名]  或者 +[类名 方法名] （
    //精简错误异常数据
    NSString *mainCallStackSymbolMsg = [self getMainCallStackSymbolMessageWithCallStackSymbols:callStackSymbolsArr];

    if (mainCallStackSymbolMsg == nil) {
        mainCallStackSymbolMsg = [NSString stringWithFormat:@"%@",callStackSymbolsArr];
        CrashNilSafeLog(@"崩溃方法定位失败,请您查看函数调用栈来排查错误原因");
    }
    NSString *errorName = exception.name;
    NSString *errorReason = exception.reason;
    //errorReason 可能为 -[__NSCFConstantString avoidCrashCharacterAtIndex:]: Range or index out of bounds
    NSString *errorPlace = mainCallStackSymbolMsg;

    crashInfoStr = [NSString stringWithFormat:@"\n异常类型：\t\t%@\n出现异常的位置：\t%@\n精简的异常信息：\t%@\nDev错误提示：\t\t%@", errorName, errorPlace, errorReason, defaultToDo];


    logErrorMessage = [NSString stringWithFormat:@"\n\n%@\n%@\n\n%@\n.\n",crashNilSafeSeparatorWithFlag,crashInfoStr,crashNilSafeSeparatorWithFlag];
    CrashNilSafeLog(@"%@",logErrorMessage);

    //CrashNilSafe 上报信息
    NSDictionary *crashInfo = @{@"crashInfo":crashInfoStr};
    //将错误信息放在字典里，用通知的形式发送出去
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:CrashNilSafeNotification object:nil userInfo:crashInfo];
    });

}

#pragma mark load
+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //交换KVO添加移出函数
        [self tk_swizzleMethod:@selector(addObserver:forKeyPath:options:context:) withMethod:@selector(tk_addObserver:forKeyPath:options:context:)];
        [self tk_swizzleMethod:@selector(removeObserver: forKeyPath:) withMethod:@selector(tk_removeObserver:forKeyPath:)];
        [self tk_swizzleMethod:@selector(removeObserver: forKeyPath: context:) withMethod:@selector(tk_removeObserver:forKeyPath:context:)];

        //交换performSelector:
//        [self tk_swizzleMethod:@selector(performSelector:) withMethod:@selector(tk_performSelector:)];
    });
}


#pragma mark KVO重复添加，删除奔溃异常处理，采用try-catch方式
/**
 *   优点:可以简单，直接的防止重复删除KVO监听键值的问题，而且该方法最安全，直接使用该方法
 *   缺点:直接使用try catch，而且不能解决重复添加KVO监听的问题
 **/

// 交换后的方法
- (void)tk_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath
{
    @try {
        [self tk_removeObserver:observer forKeyPath:keyPath];
    } @catch (NSException *exception) {
//        TKSDKLog(@"\n\n错误提示：%@\nNSException:%@\n",@"KVO重复移出引起的异常崩溃信息",exception);
    } @finally {

    }
}

// 交换后的方法
- (void)tk_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath context:(void *)context
{
    @try {
        [self tk_removeObserver:observer forKeyPath:keyPath context:context];
    } @catch (NSException *exception) {

    } @finally {

    }
}

// 交换后的方法
- (void)tk_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context
{
    @try {
        [self tk_addObserver:observer forKeyPath:keyPath options:options context:context];
    } @catch (NSException *exception) {

    } @finally {

    }
}


#pragma mark 处理performSelector：调用调用找不到方法时奔溃问题


@end
