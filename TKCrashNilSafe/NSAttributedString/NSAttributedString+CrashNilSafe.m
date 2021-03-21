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

+ (void)load
{
    if (TKCrashNilSafe.share.checkCrashNilSafeSwitch) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            Class class = objc_getClass("NSConcreteAttributedString");
            [class exchangeObjMethod:@selector(initWithString:) withMethod:@selector(safe_initWithString:)];
            [class exchangeObjMethod:@selector(initWithString:attributes:) withMethod:@selector(safe_initWithString:attributes:)];
            [class exchangeObjMethod:@selector(initWithAttributedString:) withMethod:@selector(safe_initWithAttributedString:)];
            [class exchangeObjMethod:@selector(attributedSubstringFromRange:) withMethod:@selector(safe_attributedSubstringFromRange:)];
        });
    }
}

- (instancetype)safe_initWithString:(NSString *)str
{
    if (str) {
        if ([str isKindOfClass:NSString.class]) {
            return [self safe_initWithString:str];
        }else{
            NSString *reason = [NSString stringWithFormat:@"-[%@ initWithString:] ==> The value type added must be NSString; The current type is:%@",self.class,str.class];
            [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
            return  nil;
        }
    }else{
        NSString *reason = [NSString stringWithFormat:@"-[%@ initWithString:] ==> nil argument",self.class];
        [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
        return  nil;
    }
}

- (instancetype)safe_initWithAttributedString:(NSAttributedString *)attrStr
{
    if (attrStr) {
        if ([attrStr isKindOfClass:NSAttributedString.class]) {
            return  [self safe_initWithAttributedString:attrStr];
        }else{
            NSString *reason = [NSString stringWithFormat:@"-[%@ initWithAttributedString:] ==> The value type added must be NSAttributedString; The current type is:%@",self.class,attrStr.class];
            [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
            return nil;
        }
    }else{
        NSString *reason = [NSString stringWithFormat:@"-[%@ initWithAttributedString:] ==> nil argument",self.class];
        [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
        return  nil;
    }
}


//不检测attrs
- (instancetype)safe_initWithString:(NSString *)str attributes:(NSDictionary<NSString *,id> *)attrs {
    if (str) {
        if ([str isKindOfClass:NSString.class]) {
            return [self safe_initWithString:str attributes:attrs];
        }else{
            NSString *reason = [NSString stringWithFormat:@"-[%@ initWithString:attributes:] ==> The value type added must be NSString; The current type is:%@",self.class,str.class];
            [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
            return nil;
        }
    }else{
        NSString *reason = [NSString stringWithFormat:@"-[%@ initWithString:attributes:] ==> nil argument",self.class];
        [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
        return nil;
    }
}

- (NSAttributedString *)safe_attributedSubstringFromRange:(NSRange)range
{
    if (TKSafeMaxRange(range) <= self.length) {
        return [self safe_attributedSubstringFromRange:range];
    }else{
        NSString *reason = [NSString stringWithFormat:@"-[%@ attributedSubstringFromRange:] ==> inRange %@, But the bounds [0 .. %lu]",self.class,NSStringFromRange(range),self.length];
        [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
        return nil;
    }
}

@end


@implementation NSMutableAttributedString (CrashNilSafe)

+ (void)load
{
    if (TKCrashNilSafe.share.checkCrashNilSafeSwitch) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            Class class = objc_getClass("NSConcreteMutableAttributedString");
            
            [class exchangeObjMethod:@selector(initWithString:) withMethod:@selector(safe_initWithString:)];
            [class exchangeObjMethod:@selector(initWithString:attributes:) withMethod:@selector(safe_initWithString:attributes:)];
            [class exchangeObjMethod:@selector(initWithAttributedString:) withMethod:@selector(safe_initWithAttributedString:)];
            [class exchangeObjMethod:@selector(attributedSubstringFromRange:) withMethod:@selector(safe_attributedSubstringFromRange:)];
 
            [class exchangeObjMethod:@selector(replaceCharactersInRange:withString:) withMethod:@selector(safe_replaceCharactersInRange:withString:)];
            [class exchangeObjMethod:@selector(setAttributes:range:) withMethod:@selector(safe_setAttributes:range:)];
            
            [class exchangeObjMethod:@selector(addAttribute:value:range:) withMethod:@selector(safe_addAttribute:value:range:)];
            [class exchangeObjMethod:@selector(addAttributes:range:) withMethod:@selector(safe_addAttributes:range:)];
            [class exchangeObjMethod:@selector(removeAttribute:range:) withMethod:@selector(safe_removeAttribute:range:)];
            [class exchangeObjMethod:@selector(replaceCharactersInRange:withAttributedString:) withMethod:@selector(safe_replaceCharactersInRange:withAttributedString:)];
            [class exchangeObjMethod:@selector(insertAttributedString:atIndex:) withMethod:@selector(safe_insertAttributedString:atIndex:)];
            [class exchangeObjMethod:@selector(appendAttributedString:) withMethod:@selector(safe_appendAttributedString:)];
            [class exchangeObjMethod:@selector(deleteCharactersInRange:) withMethod:@selector(safe_deleteCharactersInRange:)];
            [class exchangeObjMethod:@selector(setAttributedString:) withMethod:@selector(safe_setAttributedString:)];
        });
    }
}

//这儿有点特殊，与NSAttributedString有区别
- (instancetype)safe_initWithAttributedString:(NSAttributedString *)attrStr
{
    if (attrStr) {
        if ([attrStr isKindOfClass:NSAttributedString.class]) {
            return  [self safe_initWithAttributedString:attrStr];
        }else{
            NSString *reason = [NSString stringWithFormat:@"-[%@ initWithAttributedString:] ==> The value type added must be NSAttributedString; The current type is:%@",self.class,attrStr.class];
            [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
            return nil;
        }
    }else{
        //与NSAttributedString有区别
        return  [self safe_initWithAttributedString:attrStr];
    }
}


- (void)safe_replaceCharactersInRange:(NSRange)range withString:(NSString *)str
{
    if (str) {
        if (TKSafeMaxRange(range) <= self.length) {
            if ([str isKindOfClass:NSString.class]) {
                [self safe_replaceCharactersInRange:range withString:str];
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

- (void)safe_setAttributes:(NSDictionary<NSAttributedStringKey,id> *)attrs range:(NSRange)range
{
    if (TKSafeMaxRange(range) <= self.length) {
        [self safe_setAttributes:attrs range:range];
    }else{
        NSString *reason = [NSString stringWithFormat:@"-[%@ setAttributes:range:] ==> inRange %@, But the bounds [0 .. %lu]",self.class,NSStringFromRange(range),self.length];
        [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
    }
}

- (void)safe_addAttribute:(NSAttributedStringKey)name value:(id)value range:(NSRange)range
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
            [self safe_addAttribute:name value:value range:range];
        }else{
            NSString *reason = [NSString stringWithFormat:@"-[%@ addAttribute:value:range:] ==> inRange %@, But the bounds [0 .. %lu]",self.class,NSStringFromRange(range),length];
            [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
        }
    }
}


- (void)safe_addAttributes:(NSDictionary<NSAttributedStringKey,id> *)attrs range:(NSRange)range
{
    if (attrs) {
        NSUInteger length = self.length;
        if (TKSafeMaxRange(range) <= length) {
            [self safe_addAttributes:attrs range:range];
        }else{
            NSString *reason = [NSString stringWithFormat:@"-[%@ addAttributes:range:] ==> inRange %@, But the bounds [0 .. %lu]",self.class,NSStringFromRange(range),length];
            [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
        }
    }else{
        NSString *reason = [NSString stringWithFormat:@"-[%@ addAttributes:range:] ==> attrs connot nil",self.class];
        [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
    }
}

- (void)safe_removeAttribute:(NSAttributedStringKey)name range:(NSRange)range
{
    if (name) {
        NSUInteger length = self.length;
        if (TKSafeMaxRange(range) <= length) {
            [self safe_removeAttribute:name range:range];
        }else{
            NSString *reason = [NSString stringWithFormat:@"-[%@ removeAttribute:range:] ==> inRange %@, But the bounds [0 .. %lu]",self.class,NSStringFromRange(range),length];
            [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
        }
    }else{
        NSString *reason = [NSString stringWithFormat:@"-[%@ removeAttribute:range:] ==> name connot nil",self.class];
        [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
    }
}

- (void)safe_replaceCharactersInRange:(NSRange)range withAttributedString:(NSAttributedString *)attrString
{
    if (attrString) {
        if (TKSafeMaxRange(range) <= self.length) {
            if ([attrString isKindOfClass:NSAttributedString.class]) {
                [self safe_replaceCharactersInRange:range withAttributedString:attrString];
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

- (void)safe_insertAttributedString:(NSAttributedString *)attrString atIndex:(NSUInteger)loc
{
    if (attrString) {
        if (loc <= self.length) {
            if ([attrString isKindOfClass:NSAttributedString.class]) {
                [self safe_insertAttributedString:attrString atIndex:loc];
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

- (void)safe_appendAttributedString:(NSAttributedString *)attrString
{
    if (attrString) {
        if ([attrString isKindOfClass:NSAttributedString.class]) {
            [self safe_appendAttributedString:attrString];
        }else{
            NSString *reason = [NSString stringWithFormat:@"-[%@ appendAttributedString:] ==> The value type added must be NSAttributedString; The current type is:%@",self.class,attrString.class];
            [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
        }
    }else{
        NSString *reason = [NSString stringWithFormat:@"-[%@ appendAttributedString:] ==> attrString connot nil",self.class];
        [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
    }
}

- (void)safe_deleteCharactersInRange:(NSRange)range
{
    if (TKSafeMaxRange(range) <= self.length) {
        [self safe_deleteCharactersInRange:range];
    }else{
        NSString *reason = [NSString stringWithFormat:@"-[%@ deleteCharactersInRange:] ==> inRange %@, But the bounds [0 .. %lu]",self.class,NSStringFromRange(range),self.length];
        [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
    }
}

- (void)safe_setAttributedString:(NSAttributedString *)attrString
{
    if (attrString) {
        if ([attrString isKindOfClass:NSAttributedString.class]) {
            [self safe_setAttributedString:attrString];
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



