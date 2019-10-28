//
//  VC2.m
//  NilSafeTest
//
//  Created by mac on 2019/10/28.
//  Copyright © 2019 mac. All rights reserved.
//

#import "VC2.h"

@interface VC2 ()

@end

@implementation VC2

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self addObserver:self forKeyPath:@"VC2+1" options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self forKeyPath:@"VC2+2" options:NSKeyValueObservingOptionNew context:@""];
    [self addObserver:self forKeyPath:@"VC2+2" options:NSKeyValueObservingOptionNew context:@""];
}
- (IBAction)tapBackAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)dealloc
{
    NSLog(@"dealloc vc2");
    [self removeObserver:self forKeyPath:@"VC2+1"];
    [self removeObserver:self forKeyPath:@"VC2+2"];
//    [self removeObserver:self forKeyPath:@"VC2+1"];
//    [self removeObserver:self forKeyPath:@"VC2+2"];
    [self removeObserver:self forKeyPath:@"VC2+2" context:@""];
    [self removeObserver:self forKeyPath:@"VC2+2" context:@""];

}

@end
