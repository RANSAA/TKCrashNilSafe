//
//  ViewController.m
//  NilSafeTest
//
//  Created by mac on 2019/9/24.
//  Copyright © 2019 mac. All rights reserved.
//

#import "ViewController.h"
#import "NSArray+CrashNilSafe.h"


@interface ViewController ()

@end

@implementation ViewController

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
//    ary = @[item];
//    ary = [NSArray arrayWithObject:item];
//    ary = [NSArray arrayWithArray:arySub];
//    ary = [[NSArray alloc] initWithArray:arySub];
//    ary = [[NSArray alloc] initWithArray:arySub copyItems:YES];
    NSLog(@"ary:%@",ary);

    NSMutableArray *mAry = nil;
//    mAry = @[@"111",item].mutableCopy;
//    mAry = [NSMutableArray arrayWithObject:item];
    mAry = @[].mutableCopy;
//    mAry = [NSMutableArray arrayWithArray:arySub];
//    mAry = [[NSMutableArray alloc] initWithArray:arySub];
//    mAry = [[NSMutableArray alloc] initWithArray:arySub copyItems:YES];
//    mAry = [[NSMutableArray alloc] initWithContentsOfFile:@"test"];

//    [mAry addObject:@"111"];
//    mAry = [NSMutableArray arrayWithCapacity:50];
//    [mAry insertObject:@"44" atIndex:1];
    [mAry insertObjectVerify:@"44" atIndex:0];
//    [mAry objectAtIndex:6];
//    [mAry addObjectsFromArray:arySub];
//    [mAry objectAtIndexedSubscript:7];

    NSLog(@"mAry:%@",mAry);
}

@end
