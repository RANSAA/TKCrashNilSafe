//
//  TestViewController.m
//  NilSafeTest
//
//  Created by mac on 2019/9/24.
//  Copyright © 2019 mac. All rights reserved.
//

#import "TestViewController.h"
#import "NSArray+CrashNilSafe.h"


@interface TestViewController ()

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self testDic];
    [self testAry];
//    [self testFuncation];
}


- (void)testDic
{
    NSString *v = nil;
    NSString *k = nil;
    NSMutableDictionary *dic = @{@"keyTest":v,
                                 @"test2":v,
                                 @"key":@""
                                 }.mutableCopy;
    NSLog(@"dic:%@",dic);

    [dic setValue:@"key" forKey:v];
    [dic setValue:@"key" forKey:@"view3232"];
    [dic setValue:@"key" forKey:@"2"];
    [dic setValue:v forKey:@"key"];
    [dic setValue:@"v" forKey:@"key"];
    [dic setValue:@"test2" forKey:@"view"];
    [dic setValue:@"test2" forKey:v];
    [dic setValue:k forKey:v];
    [dic setValue:k forKey:@"view"];


    [dic setObject:@"key" forKey:v];
    [dic setObject:@"key" forKey:@"view3232"];
    [dic setObject:@"key" forKey:@"2"];
    [dic setObject:v forKey:@"key"];
    [dic setObject:@"v" forKey:@"key"];
    [dic setObject:@"test2" forKey:@"view"];
    [dic setObject:@"test2" forKey:v];
    [dic setObject:k forKey:v];
    [dic setObject:k forKey:@"view"];


    [dic addEntriesFromDictionary:@{@"11":@"222"}];
    NSLog(@"dic:%@",dic);

}

- (void)testAry
{
    NSString *item = nil;
    NSArray *ary = nil;
    NSArray *arySub = nil;
    ary = @[item];
    ary = [NSArray arrayWithObject:item];
    ary = [NSArray arrayWithArray:arySub];
    ary = [[NSArray alloc] initWithArray:arySub];
    ary = [[NSArray alloc] initWithArray:arySub copyItems:YES];
    NSLog(@"ary:%@",ary);

    NSMutableArray *mAry = nil;
    mAry = @[@"111",item,@"222",@"3333",item,item].mutableCopy;
    mAry = [NSMutableArray arrayWithObject:item];
    mAry = @[].mutableCopy;
    mAry = [NSMutableArray arrayWithArray:arySub];
    mAry = [[NSMutableArray alloc] initWithArray:arySub];
    mAry = [[NSMutableArray alloc] initWithArray:arySub copyItems:YES];


    [mAry addObject:@"111"];
    mAry = [NSMutableArray arrayWithCapacity:50];
    [mAry insertObject:@"null" atIndex:11];
    [mAry objectAtIndex:6];
    [mAry lastObject];
    [mAry firstObject];
    [mAry addObjectsFromArray:arySub];
    [mAry objectAtIndexedSubscript:7];



    NSLog(@"mAry:%@",mAry);
   
}

- (void)testFuncation
{
    [self performSelector:@selector(carch:)];

    
}


@end
