//
//  NSAttributedString+CrashNilSafe.m
//  NilSafeTest
//
//  Created by mac on 2019/10/15.
//  Copyright © 2019 mac. All rights reserved.
//

#import "NSAttributedString+CrashNilSafe.h"
#import <objc/runtime.h>
#import "TKCrashNilSafe.h"


@implementation NSAttributedString (CrashNilSafe)

/**
 函数交换通用入口
 */
+ (void)TKCrashNilSafe_SwapMethod
{
    if (!TKCrashNilSafe.share.isEnableInDebug) {
        return;
    }

    Class class = objc_getClass("NSConcreteAttributedString");
    [class exchangeObjMethod:@selector(initWithString:) withMethod:@selector(TKCrashNilSafe_initWithString:)];
    [class exchangeObjMethod:@selector(initWithString:attributes:) withMethod:@selector(TKCrashNilSafe_initWithString:attributes:)];
    [class exchangeObjMethod:@selector(initWithAttributedString:) withMethod:@selector(TKCrashNilSafe_initWithAttributedString:)];
    [class exchangeObjMethod:@selector(attributedSubstringFromRange:) withMethod:@selector(TKCrashNilSafe_attributedSubstringFromRange:)];
}

- (instancetype)TKCrashNilSafe_initWithString:(NSString *)str
{
    if (str) {
        if ([str isKindOfClass:NSString.class]) {
            return [self TKCrashNilSafe_initWithString:str];
        }else{
            NSString *reason = [NSString stringWithFormat:@"-[%@ initWithString:] ==> The value type added must be NSString; The current type is:%@",self.class,str.class];
            [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
            TKCrashNilSafeInitWithNull
        }
    }else{
        NSString *reason = [NSString stringWithFormat:@"-[%@ initWithString:] ==> nil argument",self.class];
        [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
        TKCrashNilSafeInitWithNull
    }
}

- (instancetype)TKCrashNilSafe_initWithAttributedString:(NSAttributedString *)attrStr
{
    if (attrStr) {
        if ([attrStr isKindOfClass:NSAttributedString.class]) {
            return  [self TKCrashNilSafe_initWithAttributedString:attrStr];
        }else{
            NSString *reason = [NSString stringWithFormat:@"-[%@ initWithAttributedString:] ==> The value type added must be NSAttributedString; The current type is:%@",self.class,attrStr.class];
            [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
            TKCrashNilSafeInitWithNull
        }
    }else{
        NSString *reason = [NSString stringWithFormat:@"-[%@ initWithAttributedString:] ==> nil argument",self.class];
        [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
        TKCrashNilSafeInitWithNull
    }
}


//不检测attrs
- (instancetype)TKCrashNilSafe_initWithString:(NSString *)str attributes:(NSDictionary<NSString *,id> *)attrs {
    if (str) {
        if ([str isKindOfClass:NSString.class]) {
            return [self TKCrashNilSafe_initWithString:str attributes:attrs];
        }else{
            NSString *reason = [NSString stringWithFormat:@"-[%@ initWithString:attributes:] ==> The value type added must be NSString; The current type is:%@",self.class,str.class];
            [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
            TKCrashNilSafeInitWithNull
        }
    }else{
        NSString *reason = [NSString stringWithFormat:@"-[%@ initWithString:attributes:] ==> nil argument",self.class];
        [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
        TKCrashNilSafeInitWithNull
    }
}

- (NSAttributedString *)TKCrashNilSafe_attributedSubstringFromRange:(NSRange)range
{
    if (TKSafeMaxRange(range) <= self.length) {
        return [self TKCrashNilSafe_attributedSubstringFromRange:range];
    }else{
        NSString *reason = [NSString stringWithFormat:@"-[%@ attributedSubstringFromRange:] ==> inRange %@, But the bounds [0 .. %lu]",self.class,NSStringFromRange(range),self.length];
        [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
        return nil;
    }
}

@end


@implementation NSMutableAttributedString (CrashNilSafe)

/**
 函数交换通用入口
 */
+ (void)TKCrashNilSafe_SwapMethod
{
    if (!TKCrashNilSafe.share.isEnableInDebug) {
        return;
    }

    Class class = objc_getClass("NSConcreteMutableAttributedString");

    [class exchangeObjMethod:@selector(initWithString:) withMethod:@selector(TKCrashNilSafe_initWithString:)];
    [class exchangeObjMethod:@selector(initWithString:attributes:) withMethod:@selector(TKCrashNilSafe_initWithString:attributes:)];
    [class exchangeObjMethod:@selector(initWithAttributedString:) withMethod:@selector(TKCrashNilSafe_initWithAttributedString:)];
    [class exchangeObjMethod:@selector(attributedSubstringFromRange:) withMethod:@selector(TKCrashNilSafe_attributedSubstringFromRange:)];

    [class exchangeObjMethod:@selector(replaceCharactersInRange:withString:) withMethod:@selector(TKCrashNilSafe_replaceCharactersInRange:withString:)];
    [class exchangeObjMethod:@selector(setAttributes:range:) withMethod:@selector(TKCrashNilSafe_setAttributes:range:)];

    [class exchangeObjMethod:@selector(addAttribute:value:range:) withMethod:@selector(TKCrashNilSafe_addAttribute:value:range:)];
    [class exchangeObjMethod:@selector(addAttributes:range:) withMethod:@selector(TKCrashNilSafe_addAttributes:range:)];
    [class exchangeObjMethod:@selector(removeAttribute:range:) withMethod:@selector(TKCrashNilSafe_removeAttribute:range:)];
    [class exchangeObjMethod:@selector(replaceCharactersInRange:withAttributedString:) withMethod:@selector(TKCrashNilSafe_replaceCharactersInRange:withAttributedString:)];
    [class exchangeObjMethod:@selector(insertAttributedString:atIndex:) withMethod:@selector(TKCrashNilSafe_insertAttributedString:atIndex:)];
    [class exchangeObjMethod:@selector(appendAttributedString:) withMethod:@selector(TKCrashNilSafe_appendAttributedString:)];
    [class exchangeObjMethod:@selector(deleteCharactersInRange:) withMethod:@selector(TKCrashNilSafe_deleteCharactersInRange:)];
    [class exchangeObjMethod:@selector(setAttributedString:) withMethod:@selector(TKCrashNilSafe_setAttributedString:)];
}



//这儿有点特殊，与NSAttributedString有区别
- (instancetype)TKCrashNilSafe_initWithAttributedString:(NSAttributedString *)attrStr
{
    if (attrStr) {
        if ([attrStr isKindOfClass:NSAttributedString.class]) {
            return  [self TKCrashNilSafe_initWithAttributedString:attrStr];
        }else{
            NSString *reason = [NSString stringWithFormat:@"-[%@ initWithAttributedString:] ==> The value type added must be NSAttributedString; The current type is:%@",self.class,attrStr.class];
            [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
            TKCrashNilSafeInitWithNull
        }
    }else{
        //与NSAttributedString有区别
        return  [self TKCrashNilSafe_initWithAttributedString:attrStr];
    }
}


- (void)TKCrashNilSafe_replaceCharactersInRange:(NSRange)range withString:(NSString *)str
{
    if (str) {
        if (TKSafeMaxRange(range) <= self.length) {
            if ([str isKindOfClass:NSString.class]) {
                [self TKCrashNilSafe_replaceCharactersInRange:range withString:str];
            }else{
                NSString *reason = [NSString stringWithFormat:@"-[%@ replaceCharactersInRange:withString:] ==> The value type added must be NSString; The current type is:%@",self.class,str.class];
                [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
            }
        }else{
            NSString *reason = [NSString stringWithFormat:@"-[%@ replaceCharactersInRange:withString:] ==> inRange %@, But the bounds [0 .. %lu]",self.class,NSStringFromRange(range),self.length];
            [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
        }
    }else{
        NSString *reason = [NSString stringWithFormat:@"-[%@ replaceCharactersInRange:withString:] ==> nil argument",self.class];
        [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
    }
}

- (void)TKCrashNilSafe_setAttributes:(NSDictionary<NSAttributedStringKey,id> *)attrs range:(NSRange)range
{
    if (TKSafeMaxRange(range) <= self.length) {
        [self TKCrashNilSafe_setAttributes:attrs range:range];
    }else{
        NSString *reason = [NSString stringWithFormat:@"-[%@ setAttributes:range:] ==> inRange %@, But the bounds [0 .. %lu]",self.class,NSStringFromRange(range),self.length];
        [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
    }
}

- (void)TKCrashNilSafe_addAttribute:(NSAttributedStringKey)name value:(id)value range:(NSRange)range
{
    if (!name || !value) {
        NSString *reason = [NSString stringWithFormat:@"-[%@ addAttribute:value:range:] ==> name connot nil",self.class];
        if (name) {
            reason = [NSString stringWithFormat:@"-[%@ addAttribute:value:range:] ==> value connot nil",self.class];
        }
        [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
    }else{
        NSUInteger length = self.length;
        if (TKSafeMaxRange(range) <= length) {
            [self TKCrashNilSafe_addAttribute:name value:value range:range];
        }else{
            NSString *reason = [NSString stringWithFormat:@"-[%@ addAttribute:value:range:] ==> inRange %@, But the bounds [0 .. %lu]",self.class,NSStringFromRange(range),length];
            [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
        }
    }
}


- (void)TKCrashNilSafe_addAttributes:(NSDictionary<NSAttributedStringKey,id> *)attrs range:(NSRange)range
{
    if (attrs) {
        NSUInteger length = self.length;
        if (TKSafeMaxRange(range) <= length) {
            [self TKCrashNilSafe_addAttributes:attrs range:range];
        }else{
            NSString *reason = [NSString stringWithFormat:@"-[%@ addAttributes:range:] ==> inRange %@, But the bounds [0 .. %lu]",self.class,NSStringFromRange(range),length];
            [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
        }
    }else{
        NSString *reason = [NSString stringWithFormat:@"-[%@ addAttributes:range:] ==> attrs connot nil",self.class];
        [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
    }
}

- (void)TKCrashNilSafe_removeAttribute:(NSAttributedStringKey)name range:(NSRange)range
{
    if (name) {
        NSUInteger length = self.length;
        if (TKSafeMaxRange(range) <= length) {
            [self TKCrashNilSafe_removeAttribute:name range:range];
        }else{
            NSString *reason = [NSString stringWithFormat:@"-[%@ removeAttribute:range:] ==> inRange %@, But the bounds [0 .. %lu]",self.class,NSStringFromRange(range),length];
            [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
        }
    }else{
        NSString *reason = [NSString stringWithFormat:@"-[%@ removeAttribute:range:] ==> name connot nil",self.class];
        [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
    }
}

- (void)TKCrashNilSafe_replaceCharactersInRange:(NSRange)range withAttributedString:(NSAttributedString *)attrString
{
    if (attrString) {
        if (TKSafeMaxRange(range) <= self.length) {
            if ([attrString isKindOfClass:NSAttributedString.class]) {
                [self TKCrashNilSafe_replaceCharactersInRange:range withAttributedString:attrString];
            }else{
                NSString *reason = [NSString stringWithFormat:@"-[%@ replaceCharactersInRange:withAttributedString:] ==> The value type added must be NSAttributedString; The current type is:%@",self.class,attrString.class];
                [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
            }
        }else{
            NSString *reason = [NSString stringWithFormat:@"-[%@ replaceCharactersInRange:withAttributedString:] ==> inRange %@, But the bounds [0 .. %lu]",self.class,NSStringFromRange(range),self.length];
            [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
        }
    }else{
        NSString *reason = [NSString stringWithFormat:@"-[%@ replaceCharactersInRange:withAttributedString:] ==> attrString connot nil",self.class];
        [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
    }
}

- (void)TKCrashNilSafe_insertAttributedString:(NSAttributedString *)attrString atIndex:(NSUInteger)loc
{
    if (attrString) {
        if (loc <= self.length) {
            if ([attrString isKindOfClass:NSAttributedString.class]) {
                [self TKCrashNilSafe_insertAttributedString:attrString atIndex:loc];
            }else{
                NSString *reason = [NSString stringWithFormat:@"-[%@ insertAttributedString:atIndex:] ==> The value type added must be NSAttributedString; The current type is:%@",self.class,attrString.class];
                [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
            }
        }else{
            NSString *reason = [NSString stringWithFormat:@"-[%@ rinsertAttributedString:atIndex:] ==> atIndex %lu, But the bounds [0 .. %lu]",self.class,loc,self.length];
            [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
        }
    }else{
        NSString *reason = [NSString stringWithFormat:@"-[%@ insertAttributedString:atIndex:] ==> attrString connot nil",self.class];
        [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
    }
}

- (void)TKCrashNilSafe_appendAttributedString:(NSAttributedString *)attrString
{
    if (attrString) {
        if ([attrString isKindOfClass:NSAttributedString.class]) {
            [self TKCrashNilSafe_appendAttributedString:attrString];
        }else{
            NSString *reason = [NSString stringWithFormat:@"-[%@ appendAttributedString:] ==> The value type added must be NSAttributedString; The current type is:%@",self.class,attrString.class];
            [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
        }
    }else{
        NSString *reason = [NSString stringWithFormat:@"-[%@ appendAttributedString:] ==> attrString connot nil",self.class];
        [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
    }
}

- (void)TKCrashNilSafe_deleteCharactersInRange:(NSRange)range
{
    if (TKSafeMaxRange(range) <= self.length) {
        [self TKCrashNilSafe_deleteCharactersInRange:range];
    }else{
        NSString *reason = [NSString stringWithFormat:@"-[%@ deleteCharactersInRange:] ==> inRange %@, But the bounds [0 .. %lu]",self.class,NSStringFromRange(range),self.length];
        [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
    }
}

- (void)TKCrashNilSafe_setAttributedString:(NSAttributedString *)attrString
{
    if (attrString) {
        if ([attrString isKindOfClass:NSAttributedString.class]) {
            [self TKCrashNilSafe_setAttributedString:attrString];
        }else{
            NSString *reason = [NSString stringWithFormat:@"-[%@ setAttributedString:] ==> The value type added must be NSAttributedString; The current type is:%@",self.class,attrString.class];
            [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
        }
    }else{
        NSString *reason = [NSString stringWithFormat:@"-[%@ setAttributedString:] ==> attrString connot nil",self.class];
        [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
    }
}

@end



