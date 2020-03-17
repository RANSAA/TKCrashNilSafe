//
//  NSObject+CrashNilSafe.m
//  NilSafeTest
//
//  Created by mac on 2019/9/27.
//  Copyright © 2019 mac. All rights reserved.
//

#import "NSObject+CrashNilSafe.h"
#import <objc/runtime.h>


#define crashNilSafeSeparatorWithFlag @"========================CrashNilSafe Log=========================="

/**
 用于存储KVO记录
 **/
#define TKAnyObj void *
@interface CrashNilSafeKVOCache : NSObject
@property(nonatomic, copy)   NSString *observer;
@property(nonatomic, copy)   NSString *keyPath;
@property(nonatomic, assign) NSKeyValueObservingOptions options;
@property(nonatomic, nullable) TKAnyObj context;
@end

@implementation CrashNilSafeKVOCache

- (instancetype)initWithObserver:(NSString *)observer keyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options
{
    if (self = [super init]) {
        self.observer = observer;
        self.keyPath  = keyPath;
        self.options  = options;
    }
    return self;
}

/** 比较两个对象是否相等 **/
- (BOOL)isEqualMatch:(CrashNilSafeKVOCache *)obj
{
    BOOL isEqual = NO;
    id context = (id)self.context;
    id tmpContext = (id)obj.context;
    BOOL isContext = NO;
    if ((!context && !tmpContext) || (context && !tmpContext) || (!context && tmpContext) || [context isEqual:tmpContext]) {
        isContext = YES;
    }
    if ([self.observer isEqual:obj.observer] && [self.keyPath isEqualToString:obj.keyPath] && self.options == obj.options && isContext) {
        isEqual = YES;
    }
    return isEqual;
}

- (NSString *)LogRemarkInfo
{
    NSString *des = [NSString stringWithFormat:@"observer:%@\tkeyPath:%@\toptions:%ld",self.observer,self.keyPath,self.options];
    return des;
}

@end



@implementation NSObject (CrashNilSafe)


#pragma mark 函数交换，注意这两个方法是相同的只是使用者不同

/**
 交换对象中的方法
 **/
+ (BOOL)TK_exchangeMethod:(SEL)origSel withMethod:(SEL)altSel
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
+ (BOOL)TK_exchangeClassMethod:(SEL)origSel withMethod:(SEL)altSel
{
    return [object_getClass((id)self) TK_exchangeMethod:origSel withMethod:altSel];
}

/**
+ (void)miSwizzleInstanceMethod:(Class)class
                       swizzSel:(SEL)originSel
                  toSwizzledSel:(SEL)swizzledSel
{
    Method originMethod   =  class_getInstanceMethod(class, originSel);
    Method swizzledMethod =  class_getInstanceMethod(class, swizzledSel);
    BOOL didAddMethod = class_addMethod(class,
                                        originSel,
                                        method_getImplementation(swizzledMethod),
                                        method_getTypeEncoding(swizzledMethod));
    if (didAddMethod) {
        class_replaceMethod(class,
                            swizzledSel,
                            method_getImplementation(originMethod),
                            method_getTypeEncoding(originMethod));
    }else{
        method_exchangeImplementations(originMethod, swizzledMethod);
    }
}
**/

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

    crashInfoStr = [NSString stringWithFormat:@"\n异常类型     ：\t%@\n出现异常的位置：\t%@\n精简的异常信息：\t%@\nDev错误提示  ：\t%@", errorName, errorPlace, errorReason, defaultToDo];


    logErrorMessage = [NSString stringWithFormat:@"\n\n%@\n%@\n\n%@\n.\n",crashNilSafeSeparatorWithFlag,crashInfoStr,crashNilSafeSeparatorWithFlag];
    CrashNilSafeLog(@"%@",logErrorMessage);

    //CrashNilSafe 上报信息
    NSDictionary *crashInfo = @{@"error":crashInfoStr};
    //将错误信息放在字典里，用通知的形式发送出去
//    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:kTKCrashNilSafeCheckNotification object:nil userInfo:crashInfo];
//    });

}

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //交换KVO添加移出函数
        [self TK_exchangeMethod:@selector(addObserver:forKeyPath:options:context:) withMethod:@selector(tk_addObserver:forKeyPath:options:context:)];
        [self TK_exchangeMethod:@selector(removeObserver: forKeyPath:) withMethod:@selector(tk_removeObserver:forKeyPath:)];
        [self TK_exchangeMethod:@selector(removeObserver: forKeyPath: context:) withMethod:@selector(tk_removeObserver:forKeyPath:context:)];
        [self TK_exchangeMethod:@selector(observeValueForKeyPath:ofObject:change:context:) withMethod:@selector(tk_observeValueForKeyPath:ofObject:change:context:)];

        //交换performSelector:
        [self TK_exchangeMethod:@selector(methodSignatureForSelector:) withMethod:@selector(tk_methodSignatureForSelector:)];
        [self TK_exchangeMethod:@selector(forwardInvocation:) withMethod:@selector(tk_forwardInvocation:)];
    });
}


#pragma mark KVO重复添加，删除奔溃异常处理，采用try-catch方式
//用于存储kvo,
static NSMutableDictionary *cacheStrogeKVODict = nil;
- (NSMutableDictionary *)getCacheStrogeKVODict
{
    if (!cacheStrogeKVODict) {
        cacheStrogeKVODict = @{}.mutableCopy;
    }
    return cacheStrogeKVODict;
}

- (void)tk_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context
{
    if (!observer || !keyPath) {
        NSString *tips = [NSString stringWithFormat:@"⚠️⚠️KVO添加时observer与keyPath不能为nil，observer:%@  keyPath:%@",observer,keyPath];
        [self noteErrorWithException:nil defaultToDo:tips];
        return;
    }

    BOOL isRepeat = NO;//标记是否重复
    if(kCrashNilSafeCheckKVOAddType == 1){
        NSArray *ary =[(id)self.observationInfo valueForKey:@"_observances"];
        if (ary.count>0) {
            BOOL isRepeat = NO;
            for (id node in ary) {
                id tmpObserver = [node valueForKey:@"_observer"];
                NSString *tmpKeyPath = [[node valueForKey:@"_property"] valueForKey:@"_keyPath"];
                if (observer == tmpObserver && [tmpKeyPath isEqualToString:keyPath]) {
                    isRepeat = YES;
                    break;
                }
            }
            if (isRepeat) {
                NSString *tips = [NSString stringWithFormat:@"⚠️⚠️KVO请不要重复添加监听，observer:%@  keyPath:%@  options:%ld  context:%@",[observer class],keyPath,options,context];
                [self noteErrorWithException:nil defaultToDo:tips];
                return;
            }
        }

    }else if (kCrashNilSafeCheckKVOAddType == 2){
        NSString *cacheKey = [NSString stringWithFormat:@"%p+%@",observer,keyPath];
        if (context) {
            cacheKey = [NSString stringWithFormat:@"%p+%@+%p",observer,keyPath,context];
        }
        NSMutableDictionary *set = [self getCacheStrogeKVODict];
        CrashNilSafeKVOCache *obj = [[CrashNilSafeKVOCache alloc] init];
        obj.observer = [NSString stringWithFormat:@"%p",observer];
        obj.keyPath  = keyPath;
        obj.options  = options;
        CrashNilSafeKVOCache *checkObj = [set objectForKey:cacheKey];
        if (checkObj && [checkObj isEqualMatch:obj]) {
            isRepeat = YES;
        }
        if (isRepeat) {//重复，不添加
            NSString *tips = [NSString stringWithFormat:@"⚠️⚠️KVO请不要重复添加监听，observer:%@  keyPath:%@  options:%ld  context:%@",[observer class],keyPath,options,context];
            [self noteErrorWithException:nil defaultToDo:tips];
            return;
        }else{
            [set addEntriesFromDictionary:@{cacheKey:obj}];
        }
    }


    [self tk_addObserver:observer forKeyPath:keyPath options:options context:context];
}

- (void)tk_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath
{
    @try {
        [self tk_removeObserver:observer forKeyPath:keyPath];
    } @catch (NSException *exception) {
        NSString *tips = [NSString stringWithFormat:@"⚠️⚠️KVO键值移出时出现错误，请不要重复移出！"];
        [self noteErrorWithException:exception defaultToDo:tips];
    } @finally {
        if (kCrashNilSafeCheckKVOAddType == 2){
            NSString *cacheKey = [NSString stringWithFormat:@"%p+%@",observer,keyPath];
            NSMutableDictionary *dic = [self getCacheStrogeKVODict];
            [dic removeObjectForKey:cacheKey];
        }
    }
}

- (void)tk_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath context:(void *)context
{
    @try {
        [self tk_removeObserver:observer forKeyPath:keyPath context:context];
    } @catch (NSException *exception) {
        NSString *tips = [NSString stringWithFormat:@"⚠️⚠️KVO键值移出时出现错误，请不要重复移出！"];
        [self noteErrorWithException:exception defaultToDo:tips];
    } @finally {
        if (kCrashNilSafeCheckKVOAddType == 2){
            NSString *cacheKey = [NSString stringWithFormat:@"%p+%@",observer,keyPath];
            if (context) {
                cacheKey = [NSString stringWithFormat:@"%p+%@+%p",observer,keyPath,context];
            }
            NSMutableDictionary *dic = [self getCacheStrogeKVODict];
            [dic removeObjectForKey:cacheKey];
        }
    }
}

- (void)tk_observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    @try {
        [self tk_observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    } @catch (NSException *exception) {
        NSString *tips = [NSString stringWithFormat:@"⚠️⚠️KVO ==> observeValueForKeyPath:ofObject:change:context:中出现错误"];
        [self noteErrorWithException:exception defaultToDo:tips];
    } @finally {

    }
}



#pragma mark 处理performSelector：调用调用找不到方法时奔溃问题(unrecognized selector sent to instance)

- (NSMethodSignature *)tk_methodSignatureForSelector:(SEL)aSelector {
    NSMethodSignature *sig = [self tk_methodSignatureForSelector:aSelector];
    if (sig) {
        return sig;
    }
    NSString *tips = [NSString stringWithFormat:@"⚠️⚠️==> unrecognized selector找不到对应的方法,找不到的方法为: %@",NSStringFromSelector(aSelector)];
    [self noteErrorWithException:nil defaultToDo:tips];
    return [NSMethodSignature signatureWithObjCTypes:@encode(void)];
}

- (void)tk_forwardInvocation:(NSInvocation *)anInvocation {
    NSUInteger returnLength = [[anInvocation methodSignature] methodReturnLength];
    if (!returnLength) {
        // nothing to do
        return;
    }
    // set return value to all zero bits
    char buffer[returnLength];
    memset(buffer, 0, returnLength);
    [anInvocation setReturnValue:buffer];
}


@end
