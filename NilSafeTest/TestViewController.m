//
//  TestViewController.m
//  NilSafeTest
//
//  Created by mac on 2019/9/24.
//  Copyright © 2019 mac. All rights reserved.
//

#import "TestViewController.h"
#import "NSArray+CrashNilSafe.h"
#import <objc/runtime.h>




@interface TestViewController ()

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifacuion:) name:kCrashNilSafeNotification object:nil];


//    [self testDic];
//    [self testAry];
//    [self testFuncation];
//    [self testAttrStr];
    [self testSet];

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
//    return;
    [self performSelector:@selector(carch:)];

//    [self removeObserver:self forKeyPath:@"er"];
    [self addObserver:self forKeyPath:@"key" options:NSKeyValueObservingOptionNew context:@"context"];
    [self addObserver:self forKeyPath:@"key" options:NSKeyValueObservingOptionNew context:@"123"];
    [self addObserver:self forKeyPath:@"key" options:NSKeyValueObservingOptionNew context:nil];

//    [self addObserver:self forKeyPath:@"df" options:NSKeyValueObservingOptionOld context:nil];
//    [self addObserver:self.view forKeyPath:@"df" options:NSKeyValueObservingOptionNew context:nil];
    NSArray *ary =[(id)self.observationInfo valueForKey:@"_observances"];
    for (id info in ary) {
        NSLog(@"class:%@    info:%@",[info class],info);
        NSLog(@"observer:%@",[info valueForKey:@"_observer"]);
        NSLog(@"keyPath:%@",[[info valueForKey:@"_property"] valueForKey:@"_keyPath"]);
//        NSLog(@"options:%@",[info valueForKey:@"_context"]);

//        NSLog(@"allKey:%@",(id)[info allKeys]);
//        [info objectForKey:@"_context"];
//        [info valueForKey:@"_originalObservable"]
//        [self listWith:info];

//        NSLog(@"print:%p",&self);
//        NSLog(@"print:%p",self);
//        NSLog(@"print:%@",self);
    }
//    NSLog(@"print:%p",&ary);
//    NSLog(@"print:%p",ary);
//     NSLog(@"print:%@",ary);

//    id p1 = self;
//    id p2 = self;
//    NSLog(@"printp1:%p",&p1);
//    NSLog(@"printp1:%p",p1);
//    NSLog(@"printp1:%@",p1);
//
//    NSLog(@"printp1p2:%p",&p2);
//    NSLog(@"printp1p2:%p",p2);
//    NSLog(@"printp1p2:%@",p2);
}


- (void)notifacuion:(NSNotification *)notif
{
    NSLog(@"NSNotification:%@",notif.userInfo);
}

- (NSDictionary *)properties_aps

{



    NSMutableDictionary *props = [NSMutableDictionary dictionary];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (i = 0; i<outCount; i++)
    {
        objc_property_t property = properties[i];
        const char* char_f =property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        id propertyValue = [self valueForKey:(NSString *)propertyName];
        if (propertyValue) [props setObject:propertyValue forKey:propertyName];
    }
    free(properties);
    return props;

}

- (void)listWith:(id)obj
{
    Class cls = [obj class];
    NSMutableDictionary *props = [NSMutableDictionary dictionary];

    unsigned int outCount, i;

    objc_property_t *properties = class_copyPropertyList(cls, &outCount);

    for (i = 0; i<outCount; i++)

    {

        objc_property_t property = properties[i];

        const char* char_f =property_getName(property);

        NSString *propertyName = [NSString stringWithUTF8String:char_f];

        id propertyValue = [self valueForKey:(NSString *)propertyName];

        if (propertyValue) [props setObject:propertyValue forKey:propertyName];

    }

    free(properties);

    NSLog(@"props:%@",props);
}

- (void)testAttrStr
{
    NSAttributedString *atr = nil;
    atr = [[NSAttributedString alloc] initWithString:nil];
//    atr = [[NSAttributedString alloc] initWithAttributedString:atr];
//    atr = [[NSAttributedString alloc] initWithString:@"2" attributes:nil];
    NSLog(@"atr :%@",atr);

    NSMutableAttributedString *at = nil;
//    at = [[NSMutableAttributedString alloc] initWithString:nil];
    at = [[NSMutableAttributedString alloc] initWithString:@"xxx" attributes:nil];
//    at = [[NSMutableAttributedString alloc] initWithAttributedString:@""];
    NSLog(@"at:%@",at);
    [at replaceCharactersInRange:NSMakeRange(0, 3) withString:@"34547457457"];
    NSLog(@"at:%@",at);

}

- (void)testSet
{


//    NSMutableSet *muSet = [[NSMutableSet alloc] init];
//    muSet = [[NSMutableSet alloc] initWithObjects:nil count:23];
//    [muSet addObject:nil];
//    [muSet removeObject:nil];

    NSMutableOrderedSet *or = [[NSMutableOrderedSet alloc] init];
//    [or objectAtIndex:34];


}



@end




