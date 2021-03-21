//
//  NSObject+CrashNilSafeKVC.m
//  NilSafeTest
//
//  Created by PC on 2021/3/18.
//  Copyright © 2021 mac. All rights reserved.
//

#import "NSObject+CrashNilSafeKVC.h"
#import "TKCrashNilSafe.h"


@implementation NSObject (CrashNilSafeKVC)

#pragma mark NSObject通用处理
//解决kvc时key为nil的异常
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    NSString *reason = [NSString stringWithFormat:@"-[setValue:forUndefinedKey:] ==> error info: object:%@  key:%@  value:%@",self,key,value];
    [self handleErrorWithName:TKCrashNilSafeExceptionNoAbort mark:reason];
}

@end
