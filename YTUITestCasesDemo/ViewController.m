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
}

/** 
 * 测试用例： 检查参数是否正确
 */
-(void)invalidParams {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        @try {
            NSAssert([NSThread isMainThread], @"[YT Error]: method must run on main thread");
        } @catch (NSException *exception) {
            NSLog(@"[YT ERROR]: 捕获异常 :%@", exception.name);
            
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Catch exception" message:exception.name preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction * sure = [UIAlertAction actionWithTitle:@"I knonw" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:sure];
            
            [self presentViewController:alert animated:YES completion:nil];
            
        } @finally {
            NSLog(@"[YT DEBUG]: methods on main thread perform sucessly");
        }
        
    });
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


-(NSArray<NSInvocation*> *)autoTestCases {
    return @[[self invocationForSelector:@selector(invalidParams) args:nil]];
}

-(NSArray<NSInvocation *> *)testCases {
    
    NSMutableArray<NSInvocation *> * methods = [NSMutableArray arrayWithCapacity:7];
    
    for (int i = 1; i<=7;i++) {
        NSString * methodName = [NSString stringWithFormat:@"changeBg%d",i];
        
        NSInvocation * invocation = [self invocationForSelector:NSSelectorFromString(methodName) args:nil];
        [methods addObject:invocation];
    }
    
    [methods insertObject:[self invocationForSelector:@selector(invalidParams) args:nil] atIndex:0];
    
    return methods;
}

@end
