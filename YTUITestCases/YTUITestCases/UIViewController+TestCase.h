//
//  UIViewController+TestCase.h
//  taobaoreader
//
//  Created by huanwh on 2016/10/17.
//  Copyright © 2016年 AlibabaLiterature. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UIViewControllerTestCaseProtocol <NSObject>

/* 暂时屏蔽掉自动执行的代码
@optional
-(NSArray<NSInvocation *> *)preTestCases;
*/
@required
-(NSArray<NSInvocation *> *)testCases;
@end



@interface UIViewController (TestCase)

@property(nonatomic, strong)NSMutableArray * selectors;
/* 暂时屏蔽掉自动执行的代码
@property(nonatomic, strong)NSMutableArray * preSelectors;
@property(nonatomic, strong)NSMutableArray<NSString *> * performedList;
*/
/*
-(void)startObserveMotion;
-(void)endObserveMotion;
*/
-(NSInvocation *)invocationForSelector:(SEL)selector args:(id)first,...;

@end





@interface TBRTestDataSouce : NSObject <UITableViewDelegate,UITableViewDataSource>
{
    UITableView * _tableView;
    NSArray * _bgColors;
}
@property(nonatomic, copy) NSUInteger (^numberOfTableView)();
@property(nonatomic, copy) NSInvocation * (^nameForIndex)(NSUInteger index);


+(instancetype)shareInstance;

-(void)reloadData;

@end
