//
//  ViewController.m
//  YTUITestCases
//
//  Created by huanwh on 2016/10/20.
//  Copyright © 2016年 hwh. All rights reserved.
//

#import "ViewController.h"
#import "UIViewController+TestCase.h"

@interface ViewController ()<UIViewControllerTestCaseProtocol>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)changeBg1 {
    self.view.backgroundColor = [UIColor redColor];
}

-(void)changeBg2 {
    self.view.backgroundColor = [UIColor blueColor];
}
-(void)changeBg3 {
    self.view.backgroundColor = [UIColor yellowColor];
}
-(void)changeBg4 {
    self.view.backgroundColor = [UIColor greenColor];
}
-(void)changeBg5 {
    self.view.backgroundColor = [UIColor darkGrayColor];
}
-(void)changeBg6 {
    self.view.backgroundColor = [UIColor whiteColor];
}
-(void)changeBg7 {
    self.view.backgroundColor = [UIColor brownColor];
}

-(NSArray<NSInvocation *> *)testCases {
    NSMutableArray<NSInvocation *> * methods = [NSMutableArray arrayWithCapacity:7];
    for (int i = 1; i<=7;i++) {
        NSString * methodName = [NSString stringWithFormat:@"changeBg%d",i];
        
        NSInvocation * invocation = [self invocationForSelector:NSSelectorFromString(methodName) args:nil];
        [methods addObject:invocation];
    }
    return methods;
}

@end
