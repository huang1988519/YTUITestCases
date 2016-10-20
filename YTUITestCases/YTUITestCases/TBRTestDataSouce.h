//
//  TBRTestDataSouce.h
//  YTUITestCases
//
//  Created by huanwh on 2016/10/20.
//  Copyright © 2016年 hwh. All rights reserved.
//

#import <UIKit/UIKit.h>

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
