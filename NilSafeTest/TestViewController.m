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
#import "NSObject+TKSafeCore.h"
#import "TKCrashNilSafe.h"



@interface TestViewController ()

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifacuion:) name:kTKCrashNilSafeCheckNotification object:nil];



    
//    TKCrashNilSafe.share.enabledCrashLog = YES;
//    TKCrashNilSafe.share.crashLogType = TKCrashNilSafeLogTypeSimple;
    
    

    
    [self run];
    
    
//    Class cls = NSClassFromString(@"NSTaggedPointerString");
//    id obj = [cls new];
//    NSLog(@"obj:%@",obj);
//
//    NSMutableArray *ary = @[@"123"].mutableCopy;
//    NSLog(@"ary class:%@",ary.class);
    
//    NSMutableString *mStr = [[NSMutableString alloc] initWithString:@"mstr"];
//    [mStr setString:nil];
    

}

- (IBAction)testAction:(id)sender {
    [self run];
}

- (void)run
{
    [self testStr];
    [self testMutableStr];

    [self testAttr];
    [self testMutableAttr];

    [self testAry];
    [self testMutableAry];
//
    [self testDic];
    [self testMutableDic];


    [self testSet];

    [self testOrderedSet];
    [self testMutableOrderedSet];


    [self testKVO];

    [self testData];
    [self testMutableData];

    [self testJSONSerialization];

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

- (void)testStr
{
    NSString *k = @"k";
    NSString *v = nil;
    NSData *data = nil;
    NSString *crt = nil;

    
    NSString *str = nil;
    str = [[NSString alloc] init];
    str = [[NSString alloc] initWithString:k];
    str = [[NSString alloc] initWithString:v];
    str = [[NSString alloc] initWithFormat:@"%@",v];
    str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    str = [[NSString alloc] initWithContentsOfFile:@"path" encoding:NSUTF8StringEncoding error:nil];
    str = [[NSString alloc] initWithContentsOfFile:v encoding:NSUTF8StringEncoding error:nil];
    str = [[NSString alloc] initWithContentsOfURL:[NSURL URLWithString:@""] encoding:NSUTF8StringEncoding error:nil];
    str = [[NSString alloc] initWithContentsOfURL:k encoding:NSUTF8StringEncoding error:nil];
    str = [[NSString alloc] initWithContentsOfURL:v encoding:NSUTF8StringEncoding error:nil];
    str = [[NSString alloc] initWithContentsOfURL:k usedEncoding:NSUTF8StringEncoding error:nil];
    str = [[NSString alloc] initWithContentsOfURL:v usedEncoding:NSUTF8StringEncoding error:nil];

    str = [NSString stringWithContentsOfURL:k encoding:NSUTF8StringEncoding error:nil];
    str = [NSString stringWithContentsOfURL:v encoding:NSUTF8StringEncoding error:nil];
    str = [NSString stringWithContentsOfURL:k usedEncoding:NSUTF8StringEncoding error:nil];
    str = [NSString stringWithContentsOfURL:v usedEncoding:NSUTF8StringEncoding error:nil];
    str = [NSString stringWithContentsOfFile:k encoding:NSUTF8StringEncoding error:nil];
    str = [NSString stringWithContentsOfFile:v encoding:NSUTF8StringEncoding error:nil];
    str = [NSString stringWithContentsOfFile:k usedEncoding:NSUTF8StringEncoding error:nil];
    str = [NSString stringWithContentsOfFile:v usedEncoding:NSUTF8StringEncoding error:nil];
    
    str = [NSString stringWithFormat:@"%@",v];
    str = [NSString stringWithString:v];


    str = @"abcd";
    
    crt = [str substringToIndex:3];
    NSLog(@"crt 3:%@",crt);
    crt = [str substringToIndex:4];
    NSLog(@"crt 4:%@",crt);
    crt = [str substringToIndex:5];
    NSLog(@"crt 5:%@",crt);
    
    crt = [str substringFromIndex:3];
    NSLog(@"crt 3:%@",crt);
    crt = [str substringFromIndex:4];
    NSLog(@"crt 4:%@",crt);
    crt = [str substringFromIndex:5];
    NSLog(@"crt 5:%@",crt);

    crt = [str substringWithRange:NSMakeRange(0, 3)];
    NSLog(@"crt 3:%@",crt);
    crt = [str substringWithRange:NSMakeRange(0, 4)];
    NSLog(@"crt 4:%@",crt);
    crt = [str substringWithRange:NSMakeRange(0, 5)];
    NSLog(@"crt 5:%@",crt);
    
    unichar uchar;
    uchar = [str characterAtIndex:3];
    NSLog(@"uchar 3:%hu",uchar);
    uchar = [str characterAtIndex:4];
    NSLog(@"uchar 4:%hu",uchar);
    uchar = [str characterAtIndex:5];
    NSLog(@"uchar 5:%hu",uchar);
    
    
    crt = [str stringByAppendingString:k];
    NSLog(@"crt k:%@",crt);
    crt = [str stringByAppendingString:v];
    NSLog(@"crt v:%@",crt);
    
    crt = [str stringByAppendingPathComponent:k];
    NSLog(@"crt k:%@",crt);
    crt = [str stringByAppendingPathComponent:v];
    NSLog(@"crt k:%@",crt);
    
    crt = [str stringByAppendingPathExtension:k];
    NSLog(@"crt k:%@",crt);
    crt = [str stringByAppendingPathExtension:v];
    NSLog(@"crt k:%@",crt);
    
    crt = [str stringByReplacingCharactersInRange:NSMakeRange(0, 3) withString:k];
    NSLog(@"crt 3:%@",crt);
    crt = [str stringByReplacingCharactersInRange:NSMakeRange(0, 4) withString:k];
    NSLog(@"crt 4:%@",crt);
    crt = [str stringByReplacingCharactersInRange:NSMakeRange(0, 5) withString:k];
    NSLog(@"crt 5:%@",crt);

    crt = [str stringByReplacingCharactersInRange:NSMakeRange(0, 3) withString:v];
    NSLog(@"crt 3-nil:%@",crt);
    crt = [str stringByReplacingCharactersInRange:NSMakeRange(0, 4) withString:v];
    NSLog(@"crt 4-nil:%@",crt);
    crt = [str stringByReplacingCharactersInRange:NSMakeRange(0, 5) withString:v];
    NSLog(@"crt 5-nil:%@",crt);
    
    
    crt = [str stringByReplacingOccurrencesOfString:@"a" withString:@"k"];
    NSLog(@"crt k:%@",crt);
    crt = [str stringByReplacingOccurrencesOfString:v withString:v];
    NSLog(@"crt v:%@",crt);
    crt = [str stringByReplacingOccurrencesOfString:k withString:v];
    NSLog(@"crt k-v:%@",crt);
    crt = [str stringByReplacingOccurrencesOfString:v withString:k];
    NSLog(@"crt v-k:%@",crt);


    NSLog(@"str:%@",str);

    
}

- (void)testMutableStr
{
    NSString *k = @"k";
    NSString *v = nil;
    NSData *data = nil;
    NSString *crt = nil;
    
    NSMutableString *str = nil;
    
    str = [[NSMutableString alloc] initWithString:k];
    str = [[NSMutableString alloc] initWithString:v];
    str = [[NSMutableString alloc] initWithFormat:@"%@",v];
    str = [[NSMutableString alloc] initWithFormat:@"%@",k];
    str = [[NSMutableString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    str = [[NSMutableString alloc] initWithContentsOfFile:k encoding:NSUTF8StringEncoding error:nil];
    str = [[NSMutableString alloc] initWithContentsOfFile:v encoding:NSUTF8StringEncoding error:nil];
    str = [[NSMutableString alloc] initWithContentsOfURL:[NSURL URLWithString:@""] encoding:NSUTF8StringEncoding error:nil];
    str = [[NSMutableString alloc] initWithContentsOfURL:k encoding:NSUTF8StringEncoding error:nil];
    str = [[NSMutableString alloc] initWithContentsOfURL:v encoding:NSUTF8StringEncoding error:nil];
    str = [[NSMutableString alloc] initWithContentsOfURL:k usedEncoding:NSUTF8StringEncoding error:nil];
    str = [[NSMutableString alloc] initWithContentsOfURL:v usedEncoding:NSUTF8StringEncoding error:nil];

    str = [NSMutableString stringWithContentsOfURL:k encoding:NSUTF8StringEncoding error:nil];
    str = [NSMutableString stringWithContentsOfURL:v encoding:NSUTF8StringEncoding error:nil];
    str = [NSMutableString stringWithContentsOfURL:k usedEncoding:NSUTF8StringEncoding error:nil];
    str = [NSMutableString stringWithContentsOfURL:v usedEncoding:NSUTF8StringEncoding error:nil];
    str = [NSMutableString stringWithContentsOfFile:k encoding:NSUTF8StringEncoding error:nil];
    str = [NSMutableString stringWithContentsOfFile:v encoding:NSUTF8StringEncoding error:nil];
    str = [NSMutableString stringWithContentsOfFile:k usedEncoding:NSUTF8StringEncoding error:nil];
    str = [NSMutableString stringWithContentsOfFile:v usedEncoding:NSUTF8StringEncoding error:nil];

    str = [NSMutableString stringWithFormat:@"%@",v];
    str = [NSMutableString stringWithString:v];


    str = @"abcd".mutableCopy;
    
    crt = [str substringToIndex:3];
    NSLog(@"crt 3:%@",crt);
    crt = [str substringToIndex:4];
    NSLog(@"crt 4:%@",crt);
    crt = [str substringToIndex:5];
    NSLog(@"crt 5:%@",crt);

    crt = [str substringFromIndex:3];
    NSLog(@"crt 3:%@",crt);
    crt = [str substringFromIndex:4];
    NSLog(@"crt 4:%@",crt);
    crt = [str substringFromIndex:5];
    NSLog(@"crt 5:%@",crt);

    crt = [str substringWithRange:NSMakeRange(0, 3)];
    NSLog(@"crt 3:%@",crt);
    crt = [str substringWithRange:NSMakeRange(0, 4)];
    NSLog(@"crt 4:%@",crt);
    crt = [str substringWithRange:NSMakeRange(0, 5)];
    NSLog(@"crt 5:%@",crt);

    unichar uchar;
    uchar = [str characterAtIndex:3];
    NSLog(@"uchar 3:%hu",uchar);
    uchar = [str characterAtIndex:4];
    NSLog(@"uchar 4:%hu",uchar);
    uchar = [str characterAtIndex:5];
    NSLog(@"uchar 5:%hu",uchar);


    crt = [str stringByAppendingString:k];
    NSLog(@"crt k:%@",crt);
    crt = [str stringByAppendingString:v];
    NSLog(@"crt v:%@",crt);

    crt = [str stringByAppendingPathComponent:k];
    NSLog(@"crt k:%@",crt);
    crt = [str stringByAppendingPathComponent:v];
    NSLog(@"crt k:%@",crt);

    crt = [str stringByAppendingPathExtension:k];
    NSLog(@"crt k:%@",crt);
    crt = [str stringByAppendingPathExtension:v];
    NSLog(@"crt k:%@",crt);

    crt = [str stringByReplacingCharactersInRange:NSMakeRange(0, 3) withString:k];
    NSLog(@"crt 3:%@",crt);
    crt = [str stringByReplacingCharactersInRange:NSMakeRange(0, 4) withString:k];
    NSLog(@"crt 4:%@",crt);
    crt = [str stringByReplacingCharactersInRange:NSMakeRange(0, 5) withString:k];
    NSLog(@"crt 5:%@",crt);

    crt = [str stringByReplacingCharactersInRange:NSMakeRange(0, 3) withString:v];
    NSLog(@"crt 3-nil:%@",crt);
    crt = [str stringByReplacingCharactersInRange:NSMakeRange(0, 4) withString:v];
    NSLog(@"crt 4-nil:%@",crt);
    crt = [str stringByReplacingCharactersInRange:NSMakeRange(0, 5) withString:v];
    NSLog(@"crt 5-nil:%@",crt);


    crt = [str stringByReplacingOccurrencesOfString:@"a" withString:@"k"];
    NSLog(@"crt k:%@",crt);
    crt = [str stringByReplacingOccurrencesOfString:v withString:v];
    NSLog(@"crt v:%@",crt);
    crt = [str stringByReplacingOccurrencesOfString:k withString:v];
    NSLog(@"crt k-v:%@",crt);
    crt = [str stringByReplacingOccurrencesOfString:v withString:k];
    NSLog(@"crt v-k:%@",crt);

    [str replaceCharactersInRange:NSMakeRange(0, 3) withString:v];
    NSLog(@"str 3:%@",str);
    [str replaceCharactersInRange:NSMakeRange(0, 3) withString:@"1234"];
    NSLog(@"str 3:%@",str);

    [str replaceCharactersInRange:NSMakeRange(0, 4) withString:v];
    NSLog(@"str 4:%@",str);
    [str replaceCharactersInRange:NSMakeRange(0, 4) withString:@"1234"];
    NSLog(@"str 4:%@",str);

    [str replaceCharactersInRange:NSMakeRange(0, 5) withString:v];
    NSLog(@"str 5:%@",str);
    [str replaceCharactersInRange:NSMakeRange(0, 5) withString:@"1234"];
    NSLog(@"str 5:%@",str);

    NSUInteger count = 0;
    
    count = [str replaceOccurrencesOfString:@"a" withString:k options:NSLiteralSearch range:NSMakeRange(0, 3)];
    NSLog(@"count:%lu",count);
    count = [str replaceOccurrencesOfString:@"a" withString:v options:NSLiteralSearch range:NSMakeRange(0, 3)];
    NSLog(@"count:%lu",count);
    count = [str replaceOccurrencesOfString:v withString:v options:NSLiteralSearch range:NSMakeRange(0, 3)];
    NSLog(@"count:%lu",count);
    
    count = [str replaceOccurrencesOfString:@"a" withString:k options:NSLiteralSearch range:NSMakeRange(0, 4)];
    NSLog(@"count:%lu",count);
    count = [str replaceOccurrencesOfString:@"a" withString:v options:NSLiteralSearch range:NSMakeRange(0, 4)];
    NSLog(@"count:%lu",count);
    count = [str replaceOccurrencesOfString:v withString:v options:NSLiteralSearch range:NSMakeRange(0, 4)];
    NSLog(@"count:%lu",count);
    
    count = [str replaceOccurrencesOfString:@"a" withString:k options:NSLiteralSearch range:NSMakeRange(0, 5)];
    NSLog(@"count:%lu",count);
    count = [str replaceOccurrencesOfString:@"a" withString:v options:NSLiteralSearch range:NSMakeRange(0, 5)];
    NSLog(@"count:%lu",count);
    count = [str replaceOccurrencesOfString:v withString:v options:NSLiteralSearch range:NSMakeRange(0, 5)];
    NSLog(@"count:%lu",count);
    
    [str insertString:v atIndex:3];
    NSLog(@"str:%@",str);
    [str insertString:v atIndex:4];
    NSLog(@"str:%@",str);
    [str insertString:v atIndex:5];
    NSLog(@"str:%@",str);
    
    [str insertString:k atIndex:3];
    NSLog(@"str:%@",str);
    [str insertString:k atIndex:4];
    NSLog(@"str:%@",str);
    [str insertString:k atIndex:5];
    NSLog(@"str:%@",str);
    
    [str deleteCharactersInRange:NSMakeRange(0, 4)];
    NSLog(@"str:%@",str);
    
    [str deleteCharactersInRange:NSMakeRange(0, 5)];
    NSLog(@"str:%@",str);
    
    [str appendString:k];
    NSLog(@"str:%@",str);

    [str appendString:v];
    NSLog(@"str:%@",str);
    
    [str setString:k];
    NSLog(@"str:%@",str);
    
    [str setString:v];
    NSLog(@"str:%@",str);
    
    
    
    NSLog(@"str:%@",str);
}


- (void)testAttr
{
    NSString *k = @"k";
    NSString *v = nil;
    NSNumber *num = @(1234);
    NSAttributedString *ctr = nil;
    NSAttributedString *atr = nil;
    
    
    atr = [[NSAttributedString alloc] initWithString:k];
    atr = [[NSAttributedString alloc] initWithString:v];
    atr = [[NSAttributedString alloc] initWithString:num];
    atr = [[NSAttributedString alloc] initWithAttributedString:k];
    atr = [[NSAttributedString alloc] initWithAttributedString:v];
    atr = [[NSAttributedString alloc] initWithAttributedString:num];
    atr = [[NSAttributedString alloc] initWithString:k attributes:nil];
    atr = [[NSAttributedString alloc] initWithString:v attributes:nil];
    atr = [[NSAttributedString alloc] initWithString:num attributes:nil];

    atr = [[NSAttributedString alloc] initWithString:@"abcd"];
    
    ctr = [atr attributedSubstringFromRange:NSMakeRange(0, 3)];
    NSLog(@"ctr 3:%@",ctr);
    ctr = [atr attributedSubstringFromRange:NSMakeRange(0, 4)];
    NSLog(@"ctr 4:%@",ctr);
    ctr = [atr attributedSubstringFromRange:NSMakeRange(0, 5)];
    NSLog(@"ctr 5:%@",ctr);
    
    

    
    NSLog(@"atr :%@",atr);
}

- (void)testMutableAttr
{
    NSString *k = @"k";
    NSString *v = nil;
    NSNumber *num = @(1234);
    NSAttributedString *ctr = nil;
    NSMutableAttributedString *atr = nil;
    
    
    atr = [[NSMutableAttributedString alloc] initWithString:k];
    atr = [[NSMutableAttributedString alloc] initWithString:v];
    atr = [[NSMutableAttributedString alloc] initWithString:num];
    atr = [[NSMutableAttributedString alloc] initWithAttributedString:k];
    atr = [[NSMutableAttributedString alloc] initWithAttributedString:v];
    atr = [[NSMutableAttributedString alloc] initWithAttributedString:num];
    atr = [[NSMutableAttributedString alloc] initWithString:k attributes:nil];
    atr = [[NSMutableAttributedString alloc] initWithString:v attributes:nil];
    atr = [[NSMutableAttributedString alloc] initWithString:num attributes:nil];

    atr = [[NSMutableAttributedString alloc] initWithString:@"abcd"];

    ctr = [atr attributedSubstringFromRange:NSMakeRange(0, 3)];
    NSLog(@"ctr 3:%@",ctr);
    ctr = [atr attributedSubstringFromRange:NSMakeRange(0, 4)];
    NSLog(@"ctr 4:%@",ctr);
    ctr = [atr attributedSubstringFromRange:NSMakeRange(0, 5)];
    NSLog(@"ctr 5:%@",ctr);
    
    [atr replaceCharactersInRange:NSMakeRange(0, 3) withString:v];
    NSLog(@"atr 3:%@",atr);
    [atr replaceCharactersInRange:NSMakeRange(0, 4) withString:v];
    NSLog(@"atr 4:%@",atr);
    [atr replaceCharactersInRange:NSMakeRange(0, 5) withString:v];
    NSLog(@"atr 5:%@",atr);
    
    [atr replaceCharactersInRange:NSMakeRange(0, 3) withString:@"1234"];
    NSLog(@"atr 3:%@",atr);
    [atr replaceCharactersInRange:NSMakeRange(0, 4) withString:@"1234"];
    NSLog(@"atr 4:%@",atr);
    [atr replaceCharactersInRange:NSMakeRange(0, 5) withString:@"1234"];
    NSLog(@"atr 5:%@",atr);
    [atr replaceCharactersInRange:NSMakeRange(0, 4) withString:num];
    NSLog(@"atr 4:%@",atr);
    ctr = [[NSAttributedString alloc]initWithString:@"ctr"];
    [atr replaceCharactersInRange:NSMakeRange(0, 4) withString:ctr];
    NSLog(@"atr 4:%@",atr);

    [atr setAttributes:nil range:NSMakeRange(0, 4)];
    [atr setAttributes:nil range:NSMakeRange(0, 5)];
    
    [atr addAttribute:NSForegroundColorAttributeName value:nil range:NSMakeRange(0, 4)];
    [atr addAttribute:nil value:UIColor.redColor range:NSMakeRange(0, 4)];
    [atr addAttribute:NSForegroundColorAttributeName value:UIColor.redColor range:NSMakeRange(0, 4)];
    [atr addAttribute:NSForegroundColorAttributeName value:UIColor.redColor range:NSMakeRange(0, 5)];
    
    
    [atr addAttributes:nil range:NSMakeRange(0, 4)];
    [atr addAttributes:@{} range:NSMakeRange(0, 5)];
    
    [atr removeAttribute:nil range:NSMakeRange(0, 4)];
    [atr removeAttribute:NSForegroundColorAttributeName range:NSMakeRange(0, 4)];
    [atr removeAttribute:NSForegroundColorAttributeName range:NSMakeRange(0, 5)];
    [atr replaceCharactersInRange:NSMakeRange(0, 4) withAttributedString:nil];
    
    [atr insertAttributedString:ctr atIndex:5];
    [atr insertAttributedString:v atIndex:4];
    [atr insertAttributedString:ctr atIndex:4];
    
    [atr appendAttributedString:k];
    [atr appendAttributedString:v];
    [atr appendAttributedString:ctr];

    [atr deleteCharactersInRange:NSMakeRange(0, 4)];
    [atr deleteCharactersInRange:NSMakeRange(0, 5)];
    
    [atr setAttributedString:k];
    [atr setAttributedString:v];
    [atr setAttributedString:ctr];
    
    NSLog(@"atr :%@",atr);
}


- (void)testAry
{
    NSString *k = @"k";
    NSString *v = nil;
    NSNumber *num = @(1234);
    id item = nil;
    NSInteger n;
    NSArray *ctr = nil;
    NSArray *ary = nil;
    
//    ary = [NSArray arrayWithObject:k];
//    ary = [NSArray arrayWithObject:v];
//
//    ary = [NSArray arrayWithArray:v];
//    ary = [NSArray arrayWithArray:k];
//    ary = [NSArray arrayWithArray:ctr];
//
//    ary = [NSArray arrayWithObjects:v,v, nil];
//
//    ary = [[NSArray alloc] initWithObjects:v,k,k,v, nil];
//    ary = [[NSArray alloc] initWithArray:ctr];
//    ary = [[NSArray alloc] initWithArray:v];
//    ary = [[NSArray alloc] initWithArray:k];
//    ary = [[NSArray alloc] initWithArray:ctr copyItems:YES];
//    ary = [[NSArray alloc] initWithArray:v copyItems:YES];
//    ary = [[NSArray alloc] initWithArray:k copyItems:YES];

//    ary = @[];
//    ary = @[k,v,@"V"];
    
    ary = @[@"a",@"b",@"c",@"d"];
    
//    item = ary[0];
//    NSLog(@"item:%@",item);
//    item = ary[1];
//    NSLog(@"item:%@",item);
//    item = ary[10];
//    NSLog(@"item:%@",item);
//
//    item = [ary objectAtIndex:3];
//    NSLog(@"item:%@",item);
//    item = [ary objectAtIndex:4];
//    NSLog(@"item:%@",item);

    NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
//    [indexSet addIndex:3];
//    [indexSet addIndex:0];
//    [indexSet addIndex:4];
    NSLog(@"indexSet:%lu",indexSet.lastIndex);
    item = [ary objectsAtIndexes:indexSet];
    NSLog(@"item:%@",item);

    
//    item = [ary arrayByAddingObject:k];
//    NSLog(@"item:%@",item);
//    item = [ary arrayByAddingObject:v];
//    NSLog(@"item:%@",item);
//    item = [ary arrayByAddingObject:@(123)];
//    NSLog(@"item:%@",item);
//
//
//    item = [ary arrayByAddingObjectsFromArray:k];
//    NSLog(@"item:%@",item);
//    item = [ary arrayByAddingObjectsFromArray:v];
//    NSLog(@"item:%@",item);
//    item = [ary arrayByAddingObjectsFromArray:@[@"9900"]];
//    NSLog(@"item:%@",item);
//
    
    NSLog(@"ary:%@",ary);
    
 
}

- (void)testMutableAry
{
    NSString *k = @"k";
    NSString *v = nil;
    NSNumber *num = @(1234);
    id item = nil;
    NSInteger n;
    NSArray *ctr = @[@"1234"];
    NSMutableArray *ary = nil;
    NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];

    
    ary = [NSMutableArray arrayWithObject:k];
    ary = [NSMutableArray arrayWithObject:v];

    ary = [NSMutableArray arrayWithArray:v];
    ary = [NSMutableArray arrayWithArray:k];
    ary = [NSMutableArray arrayWithArray:ctr];

    ary = [NSMutableArray arrayWithObjects:v,v, nil];

    ary = [[NSMutableArray alloc] initWithObjects:v,k,k,v, nil];
    ary = [[NSMutableArray alloc] initWithArray:ctr];
    ary = [[NSMutableArray alloc] initWithArray:v];
    ary = [[NSMutableArray alloc] initWithArray:k];
    ary = [[NSMutableArray alloc] initWithArray:ctr copyItems:YES];
    ary = [[NSMutableArray alloc] initWithArray:v copyItems:YES];
    ary = [[NSMutableArray alloc] initWithArray:k copyItems:YES];
//
    ary = @[];
    ary = @[k,v,@"V"].mutableCopy;

    ary = @[@"a",@"b",@"c",@"d"].mutableCopy;
    NSLog(@"ary count:%ld",ary.count);

    item = ary[0];
    NSLog(@"item:%@",item);
    item = ary[1];
    NSLog(@"item:%@",item);
    item = ary[10];
    NSLog(@"item:%@",item);

    item = [ary objectAtIndex:3];
    NSLog(@"item:%@",item);
    item = [ary objectAtIndex:4];
    NSLog(@"item:%@",item);

    [indexSet addIndex:3];
    [indexSet addIndex:0];
    [indexSet addIndex:4];
    NSLog(@"indexSet:%lu",indexSet.lastIndex);
    item = [ary objectsAtIndexes:indexSet];
    NSLog(@"item:%@",item);


    item = [ary arrayByAddingObject:k];
    NSLog(@"item:%@",item);
    item = [ary arrayByAddingObject:v];
    NSLog(@"item:%@",item);
    item = [ary arrayByAddingObject:@(123)];
    NSLog(@"item:%@",item);


    item = [ary arrayByAddingObjectsFromArray:k];
    NSLog(@"item:%@",item);
    item = [ary arrayByAddingObjectsFromArray:v];
    NSLog(@"item:%@",item);
    item = [ary arrayByAddingObjectsFromArray:@[@"9900"]];
    NSLog(@"item:%@",item);
//
    
    [ary addObject:k];
    NSLog(@"ary:%@",ary);
    [ary addObject:v];
    NSLog(@"ary:%@",ary);
    [ary addObject:ctr];
    NSLog(@"ary:%@",ary);
    
    
    [ary addObjectsFromArray:v];
    NSLog(@"ary:%@",ary);
    [ary addObjectsFromArray:k];
    NSLog(@"ary:%@",ary);
    [ary addObjectsFromArray:ctr];
    NSLog(@"ary:%@",ary);
    
    
    
    [ary insertObject:v atIndex:3];
    NSLog(@"ary:%@",ary);
    [ary insertObject:v atIndex:3];
    NSLog(@"ary:%@",ary);
    [ary insertObject:ctr atIndex:3];
    NSLog(@"ary:%@",ary);

    [ary insertObject:v atIndex:34];
    NSLog(@"ary:%@",ary);
    [ary insertObject:v atIndex:4];
    NSLog(@"ary:%@",ary);
    [ary insertObject:ctr atIndex:5];
    NSLog(@"ary:%@",ary);
    
    [ary removeObjectAtIndex:4];
    NSLog(@"ary:%@",ary);
    
    [ary replaceObjectAtIndex:0 withObject:v];
    NSLog(@"ary:%@",ary);
    [ary replaceObjectAtIndex:4 withObject:@"1"];
    NSLog(@"ary:%@",ary);
    [ary replaceObjectAtIndex:3 withObject:@"1"];
    NSLog(@"ary:%@",ary);
    
    [ary exchangeObjectAtIndex:1 withObjectAtIndex:1];
    NSLog(@"ary:%@",ary);
    [ary exchangeObjectAtIndex:1 withObjectAtIndex:2];
    NSLog(@"ary:%@",ary);
    [ary exchangeObjectAtIndex:4 withObjectAtIndex:4];
    NSLog(@"ary:%@",ary);
    
    
    [ary removeObject:@"a" inRange:NSMakeRange(0, 4)];
    NSLog(@"ary:%@",ary);
    [ary removeObject:@"a" inRange:NSMakeRange(0, 5)];
    NSLog(@"ary:%@",ary);
    
    [ary removeObjectsInRange:NSMakeRange(0, 4)];
    NSLog(@"ary:%@",ary);
    [ary removeObjectsInRange:NSMakeRange(0, 4)];
    NSLog(@"ary:%@",ary);
    
    [ary removeObjectsInArray:v];
    NSLog(@"ary:%@",ary);
    [ary removeObjectsInArray:k];
    NSLog(@"ary:%@",ary);

    [ary removeObjectsInArray:@[@"1",@"2",@"a"]];
    NSLog(@"ary:%@",ary);
    
    [ary setObject:k atIndexedSubscript:5];
    NSLog(@"ary:%@",ary);
    
    [ary setObject:v atIndexedSubscript:0];
    NSLog(@"ary:%@",ary);
    
    [indexSet addIndex:0];
    [indexSet addIndex:3];
    [indexSet addIndex:4];
    indexSet = [NSMutableIndexSet indexSet];
    NSLog(@"indexSet:%lu",indexSet.lastIndex);
    [ary removeObjectsAtIndexes:indexSet];
    NSLog(@"indexSet ary:%@",ary);
    

    
    [ary setArray:k];
    [ary setArray:v];
    
    
    NSLog(@"class:%@   ary:%@",ary.class,ary);
}




- (void)testDic
{
    NSString *v = nil;
    NSString *k = @"k";
    id item;
    NSDictionary *crt = @{};
    NSDictionary *dic1;
    
    NSLog(@"begin:");
    dic1 = @{k:k,v:v};
    
    dic1 = [[NSDictionary alloc] initWithObjectsAndKeys:k,k, nil];
    dic1 = [[NSDictionary alloc] initWithObjects:@[] forKeys:@[]];
    dic1 = [[NSDictionary alloc] initWithObjects:v forKeys:@[]];
    dic1 = [[NSDictionary alloc] initWithObjects:@[] forKeys:v];
    dic1 = [[NSDictionary alloc] initWithObjects:@[] forKeys:k];
    dic1 = [[NSDictionary alloc] initWithObjects:@[@"1"] forKeys:@[@"1",@"2"]];
    dic1 = [[NSDictionary alloc] initWithObjects:@[@"1",@"2"] forKeys:@[@"1"]];
    

    dic1 = [NSDictionary dictionaryWithObject:k forKey:k];
    dic1 = [NSDictionary dictionaryWithObject:k forKey:v];
    dic1 = [NSDictionary dictionaryWithObject:v forKey:k];
    dic1 = [NSDictionary dictionaryWithObject:v forKey:v];
    
    dic1 = [NSDictionary dictionaryWithDictionary:k];
    dic1 = [NSDictionary dictionaryWithDictionary:v];
    dic1 = [NSDictionary dictionaryWithDictionary:crt];
    
    dic1 = [NSDictionary dictionaryWithObjects:v forKeys:v];
    dic1 = [NSDictionary dictionaryWithObjects:k forKeys:k];
    dic1 = [NSDictionary dictionaryWithObjects:k forKeys:v];
    dic1 = [NSDictionary dictionaryWithObjects:v forKeys:k];
    
    
    dic1 = [[NSDictionary alloc] initWithDictionary:k];
    dic1 = [[NSDictionary alloc] initWithDictionary:v];
    dic1 = [[NSDictionary alloc] initWithDictionary:crt];
    
    
    dic1 = [[NSDictionary alloc] initWithDictionary:k copyItems:YES];
    dic1 = [[NSDictionary alloc] initWithDictionary:v copyItems:YES];
    dic1 = [[NSDictionary alloc] initWithDictionary:crt copyItems:YES];
    
    
    dic1 = [[NSDictionary alloc] initWithObjects:v forKeys:v];
    dic1 = [[NSDictionary alloc] initWithObjects:v forKeys:k];
    dic1 = [[NSDictionary alloc] initWithObjects:k forKeys:v];
    dic1 = [[NSDictionary alloc] initWithObjects:k forKeys:k];


    dic1 = @{@"a":@"a",@"b":@"b",@"c":@"c"};
    item = dic1[k];
    item = dic1[v];
    k = dic1[@"123"];
    k = dic1[@"cc"];
    item = [dic1 objectForKey:v];
    item = [dic1 valueForKey:v];
    
    [dic1 setValue:v forKey:@"k"];
    [dic1 setValue:k forKey:k];
    [dic1 setValue:k forKey:v];
    [dic1 setValue:v forKey:v];
    [dic1 setValue:v forKey:k];
    
    

    NSLog(@"item:%@",item);

    NSLog(@"class:%@ dic1:%@",dic1.class,dic1);
}


- (void)testMutableDic
{
    NSString *v = nil;
    NSString *k = @"a";
    id item;
    NSDictionary *crt = @{};
    NSArray *ary = @[];
    NSMutableDictionary *dic1;
    
    NSLog(@"begin:");
    dic1 = @{k:k,v:v}.mutableCopy;
    
    dic1 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:k,k, nil];
    dic1 = [[NSMutableDictionary alloc] initWithObjects:@[] forKeys:@[]];
    dic1 = [[NSMutableDictionary alloc] initWithObjects:v forKeys:@[]];
    dic1 = [[NSMutableDictionary alloc] initWithObjects:@[] forKeys:v];
    dic1 = [[NSMutableDictionary alloc] initWithObjects:@[] forKeys:k];
    dic1 = [[NSMutableDictionary alloc] initWithObjects:@[@"1"] forKeys:@[@"1",@"2"]];
    dic1 = [[NSMutableDictionary alloc] initWithObjects:@[@"1",@"2"] forKeys:@[@"1"]];


    dic1 = [NSMutableDictionary dictionaryWithObject:k forKey:k];
    dic1 = [NSMutableDictionary dictionaryWithObject:k forKey:v];
    dic1 = [NSMutableDictionary dictionaryWithObject:v forKey:k];
    dic1 = [NSMutableDictionary dictionaryWithObject:v forKey:v];

    dic1 = [NSMutableDictionary dictionaryWithDictionary:k];
    dic1 = [NSMutableDictionary dictionaryWithDictionary:v];
    dic1 = [NSMutableDictionary dictionaryWithDictionary:crt];

    dic1 = [NSMutableDictionary dictionaryWithObjects:v forKeys:v];
    dic1 = [NSMutableDictionary dictionaryWithObjects:k forKeys:k];
    dic1 = [NSMutableDictionary dictionaryWithObjects:k forKeys:v];
    dic1 = [NSMutableDictionary dictionaryWithObjects:v forKeys:k];


    dic1 = [[NSMutableDictionary alloc] initWithDictionary:k];
    dic1 = [[NSMutableDictionary alloc] initWithDictionary:v];
    dic1 = [[NSMutableDictionary alloc] initWithDictionary:crt];


    dic1 = [[NSMutableDictionary alloc] initWithDictionary:k copyItems:YES];
    dic1 = [[NSMutableDictionary alloc] initWithDictionary:v copyItems:YES];
    dic1 = [[NSMutableDictionary alloc] initWithDictionary:crt copyItems:YES];


    dic1 = [[NSMutableDictionary alloc] initWithObjects:v forKeys:v];
    dic1 = [[NSMutableDictionary alloc] initWithObjects:v forKeys:k];
    dic1 = [[NSMutableDictionary alloc] initWithObjects:k forKeys:v];
    dic1 = [[NSMutableDictionary alloc] initWithObjects:k forKeys:k];


    dic1 = @{@"a":@"a",@"b":@"b",@"c":@"c"}.mutableCopy;
    item = dic1[k];
    item = dic1[v];
    item = dic1[@"123"];
    item = dic1[@"cc"];
    item = [dic1 objectForKey:v];
    item = [dic1 valueForKey:v];

    [dic1 setValue:k forKey:@"a"];
    [dic1 setValue:k forKey:k];
    [dic1 setValue:k forKey:v];
    [dic1 setValue:v forKey:v];
    [dic1 setValue:v forKey:k];
    
    
    
    [dic1 setObject:k forKey:k];
    [dic1 setObject:k forKey:v];
    [dic1 setObject:v forKey:@"b"];
    [dic1 setObject:v forKey:v];
    
    dic1[k] = k;
    dic1[k] = v;
    dic1[v] = v;
    dic1[v] = k;
    
    [dic1 removeObjectForKey:k];
    [dic1 removeObjectForKey:k];
    [dic1 removeObjectForKey:v];
    
    [dic1 removeObjectsForKeys:k];
    [dic1 removeObjectsForKeys:v];
    [dic1 removeObjectsForKeys:ary];
    
    
    [dic1 addEntriesFromDictionary:nil];

    [dic1 addEntriesFromDictionary:@{@"11":@"222"}];
    [dic1 addEntriesFromDictionary:@""];
    [dic1 addEntriesFromDictionary:@{@"1":@"1"}];
    
    
    [dic1 setDictionary:nil];
    [dic1 setDictionary:k];
    [dic1 setDictionary:crt];



    NSLog(@"item:%@",item);
    
    
    

    NSLog(@"class:%@ dic1:%@",dic1.class,dic1);
    

}


- (void)testSet
{
    id ary[] = {@"1",@"2",@"3",@"4"};
    NSSet *set = nil;
    
    set = [NSSet set];
    set = [NSSet setWithObjects:@"123", nil];
    set = [NSSet setWithArray:nil];
    
    NSLog(@"set:%@",set);

    NSMutableSet *muSet = [[NSMutableSet alloc] init];
    [muSet addObject:nil];
    [muSet removeObject:nil];

    NSLog(@"mSet:%@",muSet);



}


- (void)testOrderedSet
{
    NSString *str3 = @"3";
    NSArray *ary = @[@"1",@"2",str3,@"4"];
    id item;
    NSUInteger u;
    NSOrderedSet *set = nil;
    
    set = [NSOrderedSet orderedSetWithArray:ary];
    
    item = set[4];
    NSLog(@"item:%@",item);
    
    item = [set objectAtIndex:4];
    NSLog(@"item:%@",item);
    
    u = [set indexOfObject:@"6"];
    NSLog(@"u:%lu",u);
    
    u = [set indexOfObject:@"3"];
    NSLog(@"u:%lu",u);
    
    


    NSLog(@"set:%@",set);
}


- (void)testMutableOrderedSet
{
    NSString *k = @"k";
    NSString *v = nil;
    NSArray *ary = @[@"1",@"2",@"3",@"4"];
    id item;
    NSUInteger u;
    NSMutableOrderedSet *set = nil;
    
    set = [NSMutableOrderedSet orderedSetWithArray:ary];
    
//    item = set[4];
//    NSLog(@"item:%@",item);
//
//    item = [set objectAtIndex:4];
//    NSLog(@"item:%@",item);
//
//    u = [set indexOfObject:@"6"];
//    NSLog(@"u:%lu",u);
//
//    u = [set indexOfObject:@"3"];
//    NSLog(@"u:%lu",u);
//
//    [set addObject:k];
//    [set addObject:v];
    
//    [set setObject:v atIndex:4];
//    [set setObject:k atIndex:5];
//    [set setObject:k atIndex:4];
    
    
//    [set insertObject:v atIndex:4];
//    [set insertObject:k atIndex:5];
//    [set insertObject:k atIndex:4];
    
//    [set removeObject:k];
//    [set removeObject:k];
//    [set removeObject:v];
    
//    [set removeObjectAtIndex:5];
//    [set removeObjectAtIndex:4];
    
//    [set removeObjectsInRange:NSMakeRange(0, 5)];
//    [set removeObjectsInRange:NSMakeRange(0, 4)];
//    
//    [set removeObjectsInArray:k];
//    [set removeObjectsInArray:v];
//    [set removeObjectsInArray:ary];
//    
    
    NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
    [indexSet addIndex:0];
    [indexSet addIndex:3];
//    [indexSet addIndex:4];
    NSLog(@"indexSet:%lu",indexSet.lastIndex);
    [set removeObjectsAtIndexes:indexSet];
    NSLog(@"ary:%@",ary);
    [set removeObjectsAtIndexes:indexSet];
    NSLog(@"ary:%@",ary);

    
    [set setObject:k atIndexedSubscript:5];


    NSLog(@"set:%@",set);
}


- (void)testKVO
{
    [TKCrashNilSafe.share setSafeKVOType:TKCrashSafeKVOTypeCache];

    //    [self removeObserver:self forKeyPath:@"er"];
//        [self addObserver:self forKeyPath:@"key1" options:NSKeyValueObservingOptionOld context:@"123"];
//        [self addObserver:self forKeyPath:@"key2" options:NSKeyValueObservingOptionNew context:@"234"];
//        [self addObserver:self forKeyPath:@"key2" options:NSKeyValueObservingOptionNew context:@"234"];
//        [self addObserver:self forKeyPath:@"key3" options:NSKeyValueObservingOptionNew context:nil];
//    
//        [self.view addObserver:self forKeyPath:@"key1" options:NSKeyValueObservingOptionOld context:@"123"];
//        [self.view addObserver:self forKeyPath:@"key2" options:NSKeyValueObservingOptionNew context:@"234"];
//        [self.view addObserver:self forKeyPath:@"key2" options:NSKeyValueObservingOptionNew context:@"234"];
//        [self.view addObserver:self forKeyPath:@"key3" options:NSKeyValueObservingOptionNew context:nil];
    
    
    
    id observer0 = self;
    id observer1 = self;
    [observer1 addObserver:self forKeyPath:@"view" options:NSKeyValueObservingOptionNew context:nil];   //tag
    [observer1 addObserver:self forKeyPath:@"view" options:NSKeyValueObservingOptionNew context:nil];

    [observer1 addObserver:self forKeyPath:@"view" options:NSKeyValueObservingOptionInitial context:nil];
    [observer1 addObserver:self forKeyPath:@"view" options:NSKeyValueObservingOptionInitial context:@"123"];

    [observer1 addObserver:self forKeyPath:@"view" options:NSKeyValueObservingOptionOld context:nil];
    [observer1 addObserver:self forKeyPath:@"view" options:NSKeyValueObservingOptionInitial context:@"123"];
    
    
    [self infoKVO];
    
    [observer0 removeObserver:self forKeyPath:@"view"context:nil];
    [observer0 removeObserver:self forKeyPath:@"view"context:@"123"];

    [observer0 removeObserver:self forKeyPath:@"view"];
    [observer0 removeObserver:self forKeyPath:@"view"context:@"123"];

    [observer0 removeObserver:self forKeyPath:@"view"context:nil];
    [observer0 removeObserver:self forKeyPath:@"view"context:nil];
    

    
    
    
    [observer0 removeObserver:self forKeyPath:@"view"];
    [observer0 removeObserver:self forKeyPath:@"view"];
//
//    [observer0 removeObserver:self forKeyPath:@"view"];
//    [observer0 removeObserver:self forKeyPath:@"view"];
    
    
//    [observer0 removeObserver:self forKeyPath:@"view"context:nil];
//    [observer0 removeObserver:self forKeyPath:@"view"context:nil];
//    [observer0 removeObserver:self forKeyPath:@"view"context:nil];
//    [observer0 removeObserver:self forKeyPath:@"view"];
//
//
//    [observer0 removeObserver:self forKeyPath:@"view"context:@"2341"];
//    [observer0 removeObserver:self forKeyPath:@"view"context:@"2341"];
//    [observer0 removeObserver:self forKeyPath:@"view"context:@"123"];
//    
    [self infoKVO];
    
//    [observer0 removeObserver:self forKeyPath:@"view"];
//
//    [self infoKVO];
    

    //    [self addObserver:self forKeyPath:@"df" options:NSKeyValueObservingOptionOld context:nil];
    //    [self addObserver:self.view forKeyPath:@"df" options:NSKeyValueObservingOptionNew context:nil];

}

- (void)infoKVO
{
    NSArray *ary =[(id)self.observationInfo valueForKey:@"_observances"];
    for (id info in ary) {
        NSLog(@"info:%@\n",info);
//            NSLog(@"class:%@\n",[info class]);
//            NSLog(@"Observer:%@\n",[info valueForKey:@"_observer"]);
//            NSLog(@"Property:%@\n",[info valueForKey:@"_property"]);
//            NSLog(@"Context:%@\n",[info valueForKey:@"_options"]);
        
        
//            NSLog(@"keyPath:%@\n...\n",[[info valueForKey:@"_property"] valueForKey:@"_keyPath"]);
//        NSLog(@"options:%@",[info valueForKey:@"_context"]);

//        NSLog(@"allKey:%@",(id)[info allKeys]);
//        [info objectForKey:@"_context"];
//        [info valueForKey:@"_originalObservable"]
//        [self listWith:info];

//        NSLog(@"print:%p",&self);
//        NSLog(@"print:%p",self);
//        NSLog(@"print:%@",self);
    }
    NSLog(@"end");
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    NSLog(@"keyPath:%@",keyPath);
}



- (void)testData
{
    NSData *data = nil;
    NSString *str = nil;
    
    data = [[NSData alloc] initWithData:nil];
    data = [str dataUsingEncoding:NSUTF8StringEncoding];
    data = [[NSData alloc] initWithBase64EncodedData:nil options:kNilOptions];
    data = [[NSData alloc] initWithBase64EncodedString:nil options:kNilOptions];
    
    
    NSLog(@"data:%@",data);
}

- (void)testMutableData
{
    NSMutableData *data = nil;
    NSString *str = nil;
    
    data = [[NSMutableData alloc] initWithData:nil];
    data = [str dataUsingEncoding:NSUTF8StringEncoding];
    data = [[NSMutableData alloc] initWithBase64EncodedData:nil options:kNilOptions];
    data = [[NSMutableData alloc] initWithBase64EncodedString:nil options:kNilOptions];
    
   
    NSLog(@"data:%@",data);
}

- (void)testJSONSerialization
{
    NSJSONSerialization *JSON = Nil;
    
//    JSON = [NSJSONSerialization JSONObjectWithData:nil options:kNilOptions error:Nil];
//    
//    
//    NSLog(@"json:%@",JSON);
    
    id sel = [TestViewController new];
    sel = [NSSet set];
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:nil options:kNilOptions error:nil];
    
    NSLog(@"data:%@",data);
}

@end




