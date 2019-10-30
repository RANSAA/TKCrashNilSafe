//
//  NSString+CrashNilSafe.m
//  NilSafeTest
//
//  Created by mac on 2019/10/15.
//  Copyright © 2019 mac. All rights reserved.
//

#import "NSString+CrashNilSafe.h"
#import <objc/runtime.h>


@implementation NSString (CrashNilSafe)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = objc_getClass("__NSCFConstantString");
        [class TK_exchangeMethod:@selector(substringFromIndex:) withMethod:@selector(tk_substringFromIndex:)];
        [class TK_exchangeMethod:@selector(substringWithRange:) withMethod:@selector(tk_substringWithRange:)];
        [class TK_exchangeMethod:@selector(substringToIndex:) withMethod:@selector(tk_substringToIndex:)];
        [class TK_exchangeMethod:@selector(characterAtIndex:) withMethod:@selector(tk_characterAtIndex:)];
        [class TK_exchangeMethod:@selector(stringByReplacingOccurrencesOfString:withString:options:range:) withMethod:@selector(tk_stringByReplacingOccurrencesOfString:withString:options:range:)];
        [class TK_exchangeMethod:@selector(stringByReplacingOccurrencesOfString:withString:) withMethod:@selector(tk_stringByReplacingOccurrencesOfString:withString:)];
        [class TK_exchangeMethod:@selector(stringByReplacingCharactersInRange:withString:) withMethod:@selector(tk_stringByReplacingCharactersInRange:withString:)];
    });
}

- (NSString *)tk_substringFromIndex:(NSUInteger)from
{
    NSString *str = nil;
    @try {
        str = [self tk_substringFromIndex:from];
    }@catch (NSException *exception) {
        NSString *tips = [NSString stringWithFormat:@"⚠️⚠️NSString ==> substringFromIndex:溢出，lenght:%ld  fromIndex:%ld",self.length,from];
        [self noteErrorWithException:exception defaultToDo:tips];
    }@finally {
        return str;
    }
}

- (NSString *)tk_substringWithRange:(NSRange)range
{
    NSString *str = nil;

    @try {
        str = [self tk_substringWithRange:range];
    }@catch (NSException *exception) {
        NSString *tips = [NSString stringWithFormat:@"⚠️⚠️NSString ==> substringFromIndex:溢出，lenght:%ld  range.location:%ld  range.length:%ld",self.length,range.location,range.length];
        [self noteErrorWithException:exception defaultToDo:tips];
    }@finally {
        return str;
    }
}

- (NSString *)tk_substringToIndex:(NSUInteger)to
{
    NSString *str = nil;
    @try {
        str = [self tk_substringToIndex:to];
    }@catch (NSException *exception) {
        NSString *tips = [NSString stringWithFormat:@"⚠️⚠️NSString ==> substringFromIndex:溢出，lenght:%ld  toIndex:%ld",self.length,to];
        [self noteErrorWithException:exception defaultToDo:tips];
    }@finally {
        return str;
    }
}

- (unichar)tk_characterAtIndex:(NSUInteger)index
{
    unichar characteristic;
    @try {
        characteristic = [self tk_characterAtIndex:index];
    }@catch (NSException *exception) {
        NSString *tips = [NSString stringWithFormat:@"⚠️⚠️NSString ==> characterAtIndex:溢出，lenght:%ld  index:%ld",self.length,index];
        [self noteErrorWithException:exception defaultToDo:tips];
    }@finally {
        return characteristic;
    }
}

- (NSString *)tk_stringByReplacingOccurrencesOfString:(NSString *)target withString:(NSString *)replacement options:(NSStringCompareOptions)options range:(NSRange)searchRange
{
    NSString *str = nil;
    @try {
        str = [self tk_stringByReplacingOccurrencesOfString:target withString:replacement options:options range:searchRange];
    }@catch (NSException *exception) {
        NSString *tips = [NSString stringWithFormat:@"⚠️⚠️NSString ==> stringByReplacingOccurrencesOfString:withString:options:range:错误，lenght:%ld  searchRange.location:%ld  searchRange.length:%ld",self.length,searchRange.location,searchRange.length];
        [self noteErrorWithException:exception defaultToDo:tips];
    }@finally {
        return str;
    }
}

- (NSString *)tk_stringByReplacingOccurrencesOfString:(NSRange)range withString:(NSString *)replacement
{
    NSString *str = nil;
    @try {
        str = [self tk_stringByReplacingOccurrencesOfString:range withString:replacement];
    }@catch (NSException *exception) {
        NSString *tips = [NSString stringWithFormat:@"⚠️⚠️NSString ==> stringByReplacingOccurrencesOfString:withString:错误，lenght:%ld  range.location:%ld  range.length:%ld",self.length,range.location,range.length];
        [self noteErrorWithException:exception defaultToDo:tips];
    }@finally {
        return str;
    }
}

- (NSString *)tk_stringByReplacingCharactersInRange:(NSRange)range withString:(NSString *)replacement {

    NSString *str = nil;
    @try {
        str = [self tk_stringByReplacingCharactersInRange:range withString:replacement];
    }@catch (NSException *exception) {
        NSString *tips = [NSString stringWithFormat:@"⚠️⚠️NSString ==> stringByReplacingCharactersInRange:withString:错误，lenght:%ld  range.location:%ld  range.length:%ld",self.length,range.location,range.length];
        [self noteErrorWithException:exception defaultToDo:tips];
    }@finally {
        return str;
    }
}


@end

@implementation NSMutableString (CrashNilSafe)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = objc_getClass("__NSCFString");
        [class TK_exchangeMethod:@selector(replaceCharactersInRange:withString:) withMethod:@selector(tk_replaceCharactersInRange:withString:)];
        [class TK_exchangeMethod:@selector(insertString:atIndex:) withMethod:@selector(tk_insertString:atIndex:)];
        [class TK_exchangeMethod:@selector(deleteCharactersInRange:) withMethod:@selector(tk_deleteCharactersInRange:)];
    });
}

- (void)tk_replaceCharactersInRange:(NSRange)range withString:(NSString *)aString
{
    @try {
        [self tk_replaceCharactersInRange:range withString:aString];
    }@catch (NSException *exception) {
        NSString *tips = [NSString stringWithFormat:@"NSMutableString ==> replaceCharactersInRange:withString:错误，lenght:%ld  range.location:%ld  range.length:%ld",self.length,range.location,range.length];
        [self noteErrorWithException:exception defaultToDo:tips];
    }@finally {

    }
}

- (void)tk_insertString:(NSString *)aString atIndex:(NSUInteger)loc
{
    @try {
        [self tk_insertString:aString atIndex:loc];
    }@catch (NSException *exception) {
        NSString *tips = [NSString stringWithFormat:@"NSMutableString ==> insertString:atIndex:错误，lenght:%ld  atIndex:%ld",self.length,loc];
        [self noteErrorWithException:exception defaultToDo:tips];
    }@finally {
    }
}

- (void)tk_deleteCharactersInRange:(NSRange)range
{
    @try {
        [self tk_deleteCharactersInRange:range];
    }@catch (NSException *exception) {
        NSString *tips = [NSString stringWithFormat:@"NSMutableString ==> deleteCharactersInRange:错误，lenght:%ld  range.location:%ld  range.length:%ld",self.length,range.location,range.length];
        [self noteErrorWithException:exception defaultToDo:tips];
    }@finally {
    }
}

@end
