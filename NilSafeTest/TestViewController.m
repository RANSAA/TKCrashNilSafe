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
}


- (void)testDic
{
    NSString *v = nil;
    NSMutableDictionary *dic = @{@"key":v}.mutableCopy;
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
    mAry = @[@"111",item].mutableCopy;
    mAry = [NSMutableArray arrayWithObject:item];
    mAry = @[].mutableCopy;
    mAry = [NSMutableArray arrayWithArray:arySub];
    mAry = [[NSMutableArray alloc] initWithArray:arySub];
    mAry = [[NSMutableArray alloc] initWithArray:arySub copyItems:YES];

    [mAry addObject:@"111"];
    mAry = [NSMutableArray arrayWithCapacity:50];
    [mAry insertObject:nil atIndex:1];
    [mAry objectAtIndex:6];
    [mAry lastObject];
    [mAry firstObject];
    [mAry addObjectsFromArray:arySub];
    [mAry objectAtIndexedSubscript:7];

    NSLog(@"mAry:%@",mAry);
}

@end
