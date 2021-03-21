//
//  NSString+CrashNilSafe.m
//  NilSafeTest
//
//  Created by mac on 2019/10/15.
//  Copyright © 2019 mac. All rights reserved.
//

#import "NSString+CrashNilSafe.h"
#import <objc/runtime.h>
#import "TKCrashNilSafe.h"



@implementation NSString (CrashNilSafe)

+ (void)load
{
    if (TKCrashNilSafe.share.checkCrashNilSafeSwitch) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            Class cls0 = objc_getClass("NSPlaceholderString");//->self
            [cls0 exchangeObjMethod:@selector(initWithString:) withMethod:@selector(safe_initWithString:)];
            [cls0 exchangeObjMethod:@selector(initWithContentsOfURL:encoding:error:) withMethod:@selector(safe_initWithContentsOfURL:encoding:error:)];
            [cls0 exchangeObjMethod:@selector(initWithContentsOfURL:usedEncoding:error:) withMethod:@selector(safe_initWithContentsOfURL:usedEncoding:error:)];
            
            
            Class class = objc_getClass("__NSCFConstantString");
            [class exchangeObjMethod:@selector(substringFromIndex:) withMethod:@selector(safe_substringFromIndex:)];
            [class exchangeObjMethod:@selector(substringWithRange:) withMethod:@selector(safe_substringWithRange:)];
            [class exchangeObjMethod:@selector(substringToIndex:) withMethod:@selector(safe_substringToIndex:)];
            [class exchangeObjMethod:@selector(characterAtIndex:) withMethod:@selector(safe_characterAtIndex:)];
            
            [class exchangeObjMethod:@selector(stringByAppendingString:) withMethod:@selector(safe_stringByAppendingString:)];
            [class exchangeObjMethod:@selector(stringByAppendingPathExtension:) withMethod:@selector(safe_stringByAppendingPathExtension:)];
            
            [class exchangeObjMethod:@selector(stringByReplacingCharactersInRange:withString:) withMethod:@selector(safe_stringByReplacingCharactersInRange:withString:)];
            [class exchangeObjMethod:@selector(stringByReplacingOccurrencesOfString:withString:) withMethod:@selector(safe_stringByReplacingOccurrencesOfString:withString:)];
            [class exchangeObjMethod:@selector(stringByReplacingOccurrencesOfString:withString:options:range:) withMethod:@selector(safe_stringByReplacingOccurrencesOfString:withString:options:range:)];

        });
    }
}

- (instancetype)safe_initWithString:(NSString *)aString
{
    if (aString) {
        return [self safe_initWithString:aString];
    }else{
        NSString *reason = [NSString stringWithFormat:@"-[%@ initWithString:] ==> nil argument",self.class];
        [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
        return nil;
    }
}

- (instancetype)safe_initWithContentsOfURL:(NSURL *)url encoding:(NSStringEncoding)enc error:(NSError *__autoreleasing  _Nullable *)error
{
    if (url) {
        if ([url isKindOfClass:NSURL.class]) {
            return [self safe_initWithContentsOfURL:url encoding:enc error:error];
        }else{
            NSString *reason = [NSString stringWithFormat:@"-[%@ initWithContentsOfURL:encoding:error:] ==> The value type added must be NSURL; The current type is:%@",self.class,url.class];
            [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
            return nil;
        }
    }else{
        NSString *reason = [NSString stringWithFormat:@"-[%@ initWithContentsOfURL:encoding:error:] ==> url can't nil",self.class];
        [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
        return nil;
    }
}

- (instancetype)safe_initWithContentsOfURL:(NSURL *)url usedEncoding:(NSStringEncoding *)enc error:(NSError *__autoreleasing  _Nullable *)error
{
    if (url) {
        if ([url isKindOfClass:NSURL.class]) {
            return [self safe_initWithContentsOfURL:url usedEncoding:enc error:error];
        }else{
            NSString *reason = [NSString stringWithFormat:@"-[%@ initWithContentsOfURL:usedEncoding:error:] ==> The value type added must be NSURL; The current type is:%@",self.class,url.class];
            [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
            return nil;
        }
    }else{
        NSString *reason = [NSString stringWithFormat:@"-[%@ initWithContentsOfURL:usedEncoding:error:] ==> url can't nil",self.class];
        [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
        return nil;
    }
}

- (NSString *)safe_substringToIndex:(NSUInteger)to
{
    if (to>self.length) {
        NSString *reason = [NSString stringWithFormat:@"-[%@ substringToIndex:] ==> Index %ld out of bounds; string length %ld",self.class,to,self.length];
        [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
        return nil;
    }else{
        return [self safe_substringToIndex:to];
    }
}


- (NSString *)safe_substringFromIndex:(NSUInteger)from
{
    if (from>self.length) {
        NSString *reason = [NSString stringWithFormat:@"-[%@ substringFromIndex:] ==> Index %ld out of bounds; string length %ld",self.class,from,self.length];
        [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
        return nil;
    }else{
        return [self safe_substringFromIndex:from];
    }
}

- (NSString *)safe_substringWithRange:(NSRange)range
{
    if (TKSafeMaxRange(range) <= self.length) {
        return [self safe_substringWithRange:range];
    }else{
        NSString *reason = [NSString stringWithFormat:@"-[%@ substringWithRange:] ==> inRange %@, But the bounds [0 .. %lu]",self.class,NSStringFromRange(range),self.length];
        [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
        return nil;
    }
}


- (unichar)safe_characterAtIndex:(NSUInteger)index
{
    unichar istic = 0;
    if ( index < self.length) {
        istic = [self safe_characterAtIndex:index];
    }else{
        NSString *reason = [NSString stringWithFormat:@"-[%@ characterAtIndex:] ==> AtIndex out of bounds; index: %lu, string lenght %ld. ",self.class,index,self.length];
        [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
    }
    return istic;;
}


- (NSString *)safe_stringByAppendingString:(NSString *)aString
{
    if (aString) {
        return [self safe_stringByAppendingString:aString];
    }else{
        NSString *reason = [NSString stringWithFormat:@"-[%@ stringByAppendingString:] ==> nil argument",self.class];
        [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
        return self;
    }
}

- (NSString *)safe_stringByAppendingPathExtension:(NSString *)aString
{
    if (aString) {
        return [self safe_stringByAppendingPathExtension:aString];
    }else{
        NSString *reason = [NSString stringWithFormat:@"-[%@ stringByAppendingPathExtension:] ==> nil argument",self.class];
        [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
        return self;
    }
}


- (NSString *)safe_stringByReplacingCharactersInRange:(NSRange)range withString:(NSString *)replacement {
    if (replacement) {
        if (TKSafeMaxRange(range) <= self.length) {
            return  [self safe_stringByReplacingCharactersInRange:range withString:replacement];
        }else{
            NSString *reason = [NSString stringWithFormat:@"-[%@ stringByReplacingCharactersInRange:withString:] ==> inRange %@, But the bounds [0 .. %lu]",self.class,NSStringFromRange(range),self.length];
            [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
            return self;
        }
    }else{
        NSString *reason = [NSString stringWithFormat:@"-[%@ stringByReplacingCharactersInRange:withString] ==> replacement can't nil",self.class];
        [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
        return self;
    }
}


- (NSString *)safe_stringByReplacingOccurrencesOfString:(NSString *)target withString:(NSString *)replacement
{
    if (!target || !replacement) {
        NSString *reason = [NSString stringWithFormat:@"-[%@ stringByReplacingCharactersInRange:withString] ==> nil argument",self.class];
        [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
        return self;
    }else{
        return [self safe_stringByReplacingOccurrencesOfString:target withString:replacement];;
    }
}


- (NSString *)safe_stringByReplacingOccurrencesOfString:(NSString *)target withString:(NSString *)replacement options:(NSStringCompareOptions)options range:(NSRange)searchRange
{
    NSString *str = self;
    @try {
        str = [self safe_stringByReplacingOccurrencesOfString:target withString:replacement options:options range:searchRange];
    }@catch (NSException *exception) {
        NSString *reason = [exception.reason stringByReplacingOccurrencesOfString:@"safe_" withString:@""];
        [self handleErrorWithName:exception.name mark:reason];
    }@finally {
        return str;
    }
}

@end



@implementation NSMutableString (CrashNilSafe)

+ (void)load
{
    if (TKCrashNilSafe.share.checkCrashNilSafeSwitch) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            Class cls0 = objc_getClass("NSPlaceholderMutableString");
            [cls0 exchangeObjMethod:@selector(initWithString:) withMethod:@selector(safe_initWithString:)];
            [cls0 exchangeObjMethod:@selector(initWithContentsOfURL:encoding:error:) withMethod:@selector(safe_initWithContentsOfURL:encoding:error:)];
            [cls0 exchangeObjMethod:@selector(initWithContentsOfURL:usedEncoding:error:) withMethod:@selector(safe_initWithContentsOfURL:usedEncoding:error:)];
            
            Class class = objc_getClass("__NSCFString");
            [class exchangeObjMethod:@selector(substringToIndex:) withMethod:@selector(safe_substringToIndex:)];
            [class exchangeObjMethod:@selector(substringFromIndex:) withMethod:@selector(safe_substringFromIndex:)];
            [class exchangeObjMethod:@selector(substringWithRange:) withMethod:@selector(safe_substringWithRange:)];
            [class exchangeObjMethod:@selector(characterAtIndex:) withMethod:@selector(safe_characterAtIndex:)];
            
            [class exchangeObjMethod:@selector(stringByAppendingString:) withMethod:@selector(safe_stringByAppendingString:)];
            [class exchangeObjMethod:@selector(stringByAppendingPathExtension:) withMethod:@selector(safe_stringByAppendingPathExtension:)];
            
            [class exchangeObjMethod:@selector(stringByReplacingCharactersInRange:withString:) withMethod:@selector(safe_stringByReplacingCharactersInRange:withString:)];
            [class exchangeObjMethod:@selector(stringByReplacingOccurrencesOfString:withString:) withMethod:@selector(safe_stringByReplacingOccurrencesOfString:withString:)];
            [class exchangeObjMethod:@selector(stringByReplacingOccurrencesOfString:withString:options:range:) withMethod:@selector(safe_stringByReplacingOccurrencesOfString:withString:options:range:)];
            
            
            //NSMutableString新增部分
            [class exchangeObjMethod:@selector(replaceCharactersInRange:withString:) withMethod:@selector(safe_replaceCharactersInRange:withString:)];
            [class exchangeObjMethod:@selector(replaceOccurrencesOfString:withString:options:range:) withMethod:@selector(safe_replaceOccurrencesOfString:withString:options:range:)];

            [class exchangeObjMethod:@selector(insertString:atIndex:) withMethod:@selector(safe_insertString:atIndex:)];
            [class exchangeObjMethod:@selector(deleteCharactersInRange:) withMethod:@selector(safe_deleteCharactersInRange:)];
            [class exchangeObjMethod:@selector(appendString:) withMethod:@selector(safe_appendString:)];
            [class exchangeObjMethod:@selector(setString:) withMethod:@selector(safe_setString:)];
            
        });
    }
}



- (void)safe_replaceCharactersInRange:(NSRange)range withString:(NSString *)aString
{
    if (aString) {
        NSUInteger length = self.length;
        if (TKSafeMaxRange(range) <= length) {
            [self safe_replaceCharactersInRange:range withString:aString];
        }else{
            NSString *reason = [NSString stringWithFormat:@"-[%@ replaceCharactersInRange:withString:] ==> inRange %@, But the bounds [0 .. %lu]",self.class,NSStringFromRange(range),self.length];
            [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
        }
    }else{
        NSString *reason = [NSString stringWithFormat:@"-[%@ replaceCharactersInRange:withString:] ==> nil argument",self.class];
        [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
    }
}



- (NSUInteger)safe_replaceOccurrencesOfString:(NSString *)target withString:(NSString *)replacement options:(NSStringCompareOptions)options range:(NSRange)searchRange
{
    NSUInteger count = 0;
    @try {
        count = [self safe_replaceOccurrencesOfString:target withString:replacement options:options range:searchRange];
    } @catch (NSException *exception) {
        NSString *reason = [exception.reason stringByReplacingOccurrencesOfString:@"safe_" withString:@""];
        [self handleErrorWithName:exception.name mark:reason];
    } @finally {
        return count;
    }
}


- (void)safe_insertString:(NSString *)aString atIndex:(NSUInteger)loc
{
    if (aString) {
        if (loc <= self.length) {
            [self safe_insertString:aString atIndex:loc];
        }else{
            NSString *reason = [NSString stringWithFormat:@"-[%@ insertString:atIndex:] ==> AtIndex out of bounds; index: %lu, string lenght %ld. ",self.class,loc,self.length];
            [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
        }
    }else{
        NSString *reason = [NSString stringWithFormat:@"-[%@ insertString::atIndex:] ==> nil argument",self.class];
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

- (void)safe_appendString:(NSString *)aString
{
    if (aString) {
        [self safe_appendString:aString];
    }else{
        NSString *reason = [NSString stringWithFormat:@"-[%@ appendString:] ==> nil argument",self.class];
        [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
    }
}

- (void)safe_setString:(NSString *)aString
{
    if (aString) {
        [self safe_setString:aString];
    }else{
        NSString *reason = [NSString stringWithFormat:@"-[%@ setString:] ==> nil argument",self.class];
        [self handleErrorWithName:TKCrashNilSafeExceptionDefault mark:reason];
    }
}


@end





