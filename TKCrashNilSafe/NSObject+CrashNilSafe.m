//
//  NSObject+CrashNilSafe.m
//  NilSafeTest
//
//  Created by mac on 2019/9/27.
//  Copyright © 2019 mac. All rights reserved.
//

#import "NSObject+CrashNilSafe.h"
#import <objc/runtime.h>




#define crashNilSafeSeparatorWithFlag @"⚠️⚠️========================CrashNilSafe Log=========================="




@implementation NSObject (CrashNilSafe)

#pragma mark 函数交换
/**
 交换两个函数
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
    if (exception) {
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

        crashInfoStr = [NSString stringWithFormat:@"\n异常类型：\t\t%@\n出现异常的位置：\t%@\n精简的异常信息：\t%@\n错误提示：\t\t%@", errorName, errorPlace, errorReason, defaultToDo];
    }else{
        crashInfoStr = [NSString stringWithFormat:@"\n错误提示：\t\t%@", defaultToDo];
    }

    logErrorMessage = [NSString stringWithFormat:@"\n\n%@%@\n%@\n\n",crashNilSafeSeparatorWithFlag,crashInfoStr,crashNilSafeSeparatorWithFlag];
    CrashNilSafeLog(@"%@",logErrorMessage);

    //CrashNilSafe 上报信息
    NSDictionary *crashInfo = @{@"crashInfo":crashInfoStr};
//    将错误信息放在字典里，用通知的形式发送出去
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:CrashNilSafeNotification object:nil userInfo:crashInfo];
    });

}

@end
