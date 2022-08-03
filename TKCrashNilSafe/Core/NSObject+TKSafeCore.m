//
//  NSObject+Core.m
//  NilSafeTest
//
//  Created by PC on 2021/3/13.
//  Copyright © 2021 mac. All rights reserved.
//

#import "NSObject+TKSafeCore.h"
#import "TKCrashNilSafe.h"
#import <objc/runtime.h>

NSString * const TKCrashNilSafeExceptionDefault     = @"TKCrashNilSafeExceptionDefault"; //default
NSString * const TKCrashNilSafeExceptionNoAbort     = @"TKCrashNilSafeExceptionNoAbort"; //该标志下的Crash是不用abort中断的

@implementation NSObject (TKSafeCore)


#pragma mark 提供函数交换方法
/** 交换类中的方法*/
+ (BOOL)exchangeClassMethod:(SEL)originSel withMethod:(SEL)swizzledSel
{
    return [object_getClass((id)self) exchangeObjMethod:originSel withMethod:swizzledSel];
}

/** 交换对象中的方法*/
+ (BOOL)exchangeObjMethod:(SEL)originSel withMethod:(SEL)swizzledSel
{
    Method originaMethod = class_getInstanceMethod(self, originSel);
    Method swizzleMethod = class_getInstanceMethod(self, swizzledSel);
    if (!originaMethod || !swizzleMethod) {
        return NO;
    }

//方式1：    
    class_addMethod(self,
                    originSel,
                    class_getMethodImplementation(self, originSel),
                    method_getTypeEncoding(originaMethod));
    class_addMethod(self,
                    swizzledSel,
                    class_getMethodImplementation(self, swizzledSel),
                    method_getTypeEncoding(swizzleMethod));
    method_exchangeImplementations(class_getInstanceMethod(self, originSel),
                                   class_getInstanceMethod(self, swizzledSel));
    
    
    
//    //方式二：
//     /* add selector if not exist, implement append with method */
//    BOOL didAddMethod = class_addMethod(class,
//                                        originSel,
//                                        method_getImplementation(swizzleMethod),
//                                        method_getTypeEncoding(swizzleMethod));
//    if (didAddMethod) {
//        /* replace class instance method, added if selector not exist */
//        /* for class cluster , it always add new selector here */
//        class_replaceMethod(class,
//                            swizzledSel,
//                            method_getImplementation(originaMethod),
//                            method_getTypeEncoding(originaMethod));
//    } else {
//        /** 交换 **/
//        method_exchangeImplementations(originaMethod, swizzleMethod);
//    }


//    //方式三（有问题）
//    /* add selector if not exist, implement append with method */
//    BOOL didAddMethod = class_addMethod(self,
//                                        originSel,
//                                        method_getImplementation(swizzleMethod),
//                                        method_getTypeEncoding(swizzleMethod));
//    if (didAddMethod) {
//        /* replace class instance method, added if selector not exist */
//        /* for class cluster , it always add new selector here */
//        class_replaceMethod(self,
//                            swizzledSel,
//                            method_getImplementation(originaMethod),
//                            method_getTypeEncoding(originaMethod));
//    }else{
//        /* swizzleMethod maybe belong to super */
//           class_replaceMethod(self,
//                               swizzledSel,
//                               class_replaceMethod(self,
//                                                   originSel,
//                                                   method_getImplementation(swizzleMethod),
//                                                   method_getTypeEncoding(swizzleMethod)),
//                               method_getTypeEncoding(originaMethod));
//    }

    return YES;
}


/**
 函数交换
 交换类中的方法： Class.class -> self.class
 交换对象中的方法: obj.class -> objc_getClass("__NSArrayI");
 */
+ (void)swizzleMethod:(Class)class originSel:(SEL)originSel swizzSel:(SEL)swizzledSel
{
    Method originaMethod = class_getInstanceMethod(class, originSel);
    Method swizzleMethod = class_getInstanceMethod(class, swizzledSel);

    if (!originaMethod || !swizzleMethod) {
      return ;
    }

// 方式一：
    class_addMethod(class,
                    originSel,
                    class_getMethodImplementation(class, originSel),
                    method_getTypeEncoding(originaMethod));
    class_addMethod(class,
                    swizzledSel,
                    class_getMethodImplementation(class, swizzledSel),
                    method_getTypeEncoding(swizzleMethod));
    method_exchangeImplementations(class_getInstanceMethod(class, originSel),
                                   class_getInstanceMethod(class, swizzledSel));

}


#pragma mark 精简处理crash信息

/**
 *  获取堆栈主要崩溃Crash精简化的信息<根据正则表达式匹配出来>
 *  @return 堆栈主要崩溃精简化的信息
 *  PS:这是一个耗时操作
 */
- (NSString *)callStackSymbolsSimpleCrashInfoWith:(NSArray*)callStackSymbols
{
    //堆栈主要崩溃信息
//    NSArray *callStackSymbols = [NSThread callStackSymbols];
//    NSLog(@"callStackSymbols:%@",callStackSymbols);
    
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
 Crash处理入口方法(控制台输出、通知)
 expName:Crash异常类型名称
 mark:Crash描述信息
 */
- (void)handleErrorWithName:(NSString *)expName mark:(NSString *)mark
{
    TKCrashNilSafeLogType type = TKCrashNilSafe.share.crashLogType;
    if (type == TKCrashNilSafeLogTypeOff) {
        return;
    };
    
    NSString *crashInfo = @"";
    NSString *tips = @"⚠️⚠️CrashNilSafe Info:\n";
    if (type == TKCrashNilSafeLogTypeSimple) {
        crashInfo = [NSString stringWithFormat:@"%@异常类型:%@\n异常信息:%@\n",tips,expName,mark];
    }else if (type == TKCrashNilSafeLogTypeCallStackSimple){
        //精简错误异常数据
        NSArray *callStackSymbolsArr = [NSThread callStackSymbols];
        NSString *mainCallStackSymbolMsg = [self callStackSymbolsSimpleCrashInfoWith:callStackSymbolsArr];
        crashInfo = [NSString stringWithFormat:@"%@异常类型:%@\n异常位置:%@\n异常信息:%@\n",tips,expName,mainCallStackSymbolMsg,mark];
    }else if (type == TKCrashNilSafeLogTypeCallStackFull){
        NSArray *callStackSymbolsArr = [NSThread callStackSymbols];
        NSString *mainCallStackSymbolMsg = [self callStackSymbolsSimpleCrashInfoWith:callStackSymbolsArr];
        NSMutableArray *callStack = [[NSMutableArray alloc] initWithCapacity:60];
        [callStack addObject:[NSString stringWithFormat:@"TK  TKCrashNilSafe                      %@",expName]];
        [callStack addObject:[NSString stringWithFormat:@"TK  TKCrashNilSafe                      %@",mainCallStackSymbolMsg]];
        [callStack addObject:[NSString stringWithFormat:@"TK  TKCrashNilSafe                      %@",mark]];
        [callStack addObjectsFromArray:callStackSymbolsArr];
        crashInfo = [NSString stringWithFormat:@"%@",callStack];
    }else if (type == TKCrashNilSafeLogTypeCallStackOriginal){
        crashInfo = [NSString stringWithFormat:@"%@",[NSThread callStackSymbols]];
    }

    [TKCrashNilSafe TKCrashNilSafeLog:crashInfo];
    [self handleCenterNotificationWitnInfo:crashInfo];
    [self handleAbortDebugWithExceptionName:expName];
}



- (void)handleAbortDebugWithExceptionName:(NSString *)expName
{
    if (TKCrashNilSafe.share.isAbortDebug) {
        if (![expName isEqualToString:TKCrashNilSafeExceptionNoAbort]) {
            abort();
        }
    }
}


- (void)handleCenterNotificationWitnInfo:(NSString *)crashInfo
{
    NSDictionary *crashDict = @{kTKCrashNilSafeReceiveCrashInfoKey:crashInfo};
    [[NSNotificationCenter defaultCenter] postNotificationName:kTKCrashNilSafeReceiveNotification object:nil userInfo:crashDict];
}





@end
