//
//  UIViewController+TestCase.h
//  taobaoreader
//
//  Created by huanwh on 2016/10/17.
//  Copyright © 2016年 hwh. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UIViewControllerTestCaseProtocol <NSObject>


@optional
-(NSArray<NSInvocation *> *)autoTestCases;

@required
-(NSArray<NSInvocation *> *)testCases;
@end



@interface UIViewController (TestCase)

@property(nonatomic, strong)NSMutableArray * selectors;
@property(nonatomic, strong)NSMutableArray * preSelectors;

/* 暂时屏蔽掉自动执行的代码
@property(nonatomic, strong)NSMutableArray<NSString *> * performedList;
*/
/*
-(void)startObserveMotion;
-(void)endObserveMotion;
*/
-(NSInvocation *)invocationForSelector:(SEL)selector args:(id)first,...;

@end




