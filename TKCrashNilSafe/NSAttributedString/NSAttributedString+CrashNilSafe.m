//
//  NSAttributedString+CrashNilSafe.m
//  NilSafeTest
//
//  Created by mac on 2019/10/15.
//  Copyright © 2019 mac. All rights reserved.
//

#import "NSAttributedString+CrashNilSafe.h"
#import <objc/runtime.h>


@implementation NSAttributedString (CrashNilSafe)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
//        Class class = objc_getClass("NSConcreteAttributedString");
        Class class = NSClassFromString(@"NSConcreteAttributedString");
        [class TK_exchangeMethod:@selector(initWithString:) withMethod:@selector(tk_initWithString:)];
        [class TK_exchangeMethod:@selector(initWithAttributedString:) withMethod:@selector(tk_initWithAttributedString:)];
        [class TK_exchangeMethod:@selector(initWithString:attributes:) withMethod:@selector(tk_initWithString:attributes:)];
    });
}

- (instancetype)tk_initWithString:(NSString *)str
{
    id object = nil;
//    @try {
//        object = [self tk_initWithString:str];
//    } @catch (NSException *exception) {
//        NSString *tips = [NSString stringWithFormat:@"⚠️⚠️NSAttributedString ==> initWithString:失败， str不能为nil,且类型应该为NSString； classType:%@  attrStr:%@,  请尽快修改！",str.class,str];
//        [self noteErrorWithException:exception defaultToDo:tips];
//    } @finally {
//        return object;
//    }

    if (str && [str isKindOfClass:NSString.class]) {
        object = [self tk_initWithString:str];
    }else{
        NSString *tips = [NSString stringWithFormat:@"⚠️⚠️NSAttributedString ==> initWithString:错误，str不能为nil,且类型应该为NSString； classType:%@  str:%@",str.class,str];
        [self noteErrorWithException:nil defaultToDo:tips];
    }
    return object;
}

- (instancetype)tk_initWithAttributedString:(NSAttributedString *)attrStr
{
    id object = nil;
//    @try {
//        object = [self tk_initWithAttributedString:attrStr];
//    } @catch (NSException *exception) {
//        NSString *tips = [NSString stringWithFormat:@"⚠️⚠️NSAttributedString ==> initWithAttributedString:失败， attrStr不能为nil,且类型应该为NSAttributedString； classType:%@  attrStr:%@,  请尽快修改！",attrStr.class,attrStr];
//        [self noteErrorWithException:exception defaultToDo:tips];
//    } @finally {
//        return object;
//    }


    if (attrStr && [attrStr isKindOfClass:NSAttributedString.class]) {
        object = [self tk_initWithAttributedString:attrStr];
    }else{
        NSString *tips = [NSString stringWithFormat:@"⚠️⚠️NSAttributedString ==> initWithAttributedString:错误，attrStr不能为nil,且类型应该为NSAttributedString； classType:%@  attrStr:%@",attrStr.class,attrStr];
        [self noteErrorWithException:nil defaultToDo:tips];
    }
    return object;
}

- (instancetype)tk_initWithString:(NSString *)str attributes:(NSDictionary<NSString *,id> *)attrs {
    id object = nil;
//    @try {
//        object = [self tk_initWithString:str attributes:attrs];
//    } @catch (NSException *exception) {
//        NSString *tips = [NSString stringWithFormat:@"⚠️⚠️NSAttributedString ==> initWithString:attributes:失败， str不能为nil,且类型应该为NSString； classType:%@  attrStr:%@,  请尽快修改！",str.class,str];
//        [self noteErrorWithException:exception defaultToDo:tips];
//    } @finally {
//        return object;
//    }

    if (str && [str isKindOfClass:NSString.class]) {
        object = [self tk_initWithString:str attributes:attrs];
    }else{
        NSString *tips = [NSString stringWithFormat:@"⚠️⚠️NSAttributedString ==> initWithString:attributes:失败， str不能为nil,且类型应该为NSString； classType:%@  str:%@,  请尽快修改！",str.class,str];
        [self noteErrorWithException:nil defaultToDo:tips];
    }
    return object;
}

@end


@implementation NSMutableAttributedString (CrashNilSafe)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
//        Class class = objc_getClass("NSConcreteMutableAttributedString");
        Class class = NSClassFromString(@"NSConcreteMutableAttributedString");
        [class TK_exchangeMethod:@selector(initWithString:) withMethod:@selector(tk_mutable_initWithString:)];
        [class TK_exchangeMethod:@selector(initWithString:attributes:) withMethod:@selector(tk_mutable_initWithString:attributes:)];
        [class TK_exchangeMethod:@selector(replaceCharactersInRange:withString:) withMethod:@selector(tk_replaceCharactersInRange:withString:)];
    });
}


- (instancetype)tk_mutable_initWithString:(NSString *)str
{
    id object = nil;
//    @try {
//        object = [self tk_mutable_initWithString:str];
//    } @catch (NSException *exception) {
//        NSString *tips = [NSString stringWithFormat:@"⚠️⚠️NSMutableAttributedString ==> initWithString:失败， str不能为nil,且类型应该为NSString； classType:%@  attrStr:%@",str.class,str];
//        [self noteErrorWithException:exception defaultToDo:tips];
//    } @finally {
//        return object;
//    }

    if (str && [str isKindOfClass:NSString.class]) {
        object = [self tk_mutable_initWithString:str];
    }else{
        NSString *tips = [NSString stringWithFormat:@"⚠️⚠️NSMutableAttributedString ==> initWithString:错误， str不能为nil,且类型应该为NSString； classType:%@  str:%@",str.class,str];
        [self noteErrorWithException:nil defaultToDo:tips];
    }
    return object;
}

- (instancetype)tk_mutable_initWithString:(NSString *)str attributes:(NSDictionary<NSString *,id> *)attrs {
    id object = nil;
//    @try {
//        object = [self tk_mutable_initWithString:str attributes:attrs];
//    } @catch (NSException *exception) {
//        NSString *tips = [NSString stringWithFormat:@"⚠️⚠️NSMutableAttributedString ==> initWithString:attributes:失败， str不能为nil,且类型应该为NSString； classType:%@  attrStr:%@",str.class,str];
//        [self noteErrorWithException:exception defaultToDo:tips];
//    } @finally {
//        return object;
//    }

    if (str && [str isKindOfClass:NSString.class]) {
        object = [self tk_mutable_initWithString:str attributes:attrs];
    }else{
        NSString *tips = [NSString stringWithFormat:@"⚠️⚠️NSMutableAttributedString ==> initWithString:attributes:错误， str不能为nil,且类型应该为NSString； classType:%@  str:%@",str.class,str];
        [self noteErrorWithException:nil defaultToDo:tips];
    }
    return object;
}

- (instancetype)tk_mutable_initWithAttributedString:(NSAttributedString *)attrStr
{
    id object = nil;

//    @try {
//        object = [self tk_mutable_initWithAttributedString:attrStr];
//    } @catch (NSException *exception) {
//        NSString *tips = [NSString stringWithFormat:@"⚠️⚠️NSMutableAttributedString ==> initWithAttributedString:失败， str不能为nil,且类型应该为NSAttributedString； classType:%@  attrStr:%@",attrStr.class,attrStr];
//        [self noteErrorWithException:exception defaultToDo:tips];
//    } @finally {
//        return object;
//    }

    if (attrStr && [attrStr isKindOfClass:NSAttributedString.class]) {
        object = [self tk_mutable_initWithAttributedString:attrStr];
    }else{
        NSString *tips = [NSString stringWithFormat:@"⚠️⚠️NSMutableAttributedString ==> initWithAttributedString:错误，str不能为nil,且类型应该为NSAttributedString； classType:%@  attrStr:%@",attrStr.class,attrStr];
        [self noteErrorWithException:nil defaultToDo:tips];
    }
    return object;
}

- (void)tk_replaceCharactersInRange:(NSRange)range withString:(NSString *)str
{
    NSString *tips = nil;
    if (range.location+range.length>self.length) {
        tips = [NSString stringWithFormat:@"⚠️⚠️NSMutableAttributedString ==> replaceCharactersInRange:withString：越界，lenght:%ld  range.location:%ld  range.length:%ld",self.length,range.location,range.length];
        [self noteErrorWithException:nil defaultToDo:tips];
        return;
    }else if (!str){
        tips = [NSString stringWithFormat:@"⚠️⚠️NSMutableAttributedString ==> replaceCharactersInRange:withString：错误，str不能为nil"];
        [self noteErrorWithException:nil defaultToDo:tips];
        return;
    }else{
        [self tk_replaceCharactersInRange:range withString:str];
    }
}

@end
