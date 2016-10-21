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
    NSArray     * _bgColors;
}
@property(nonatomic, copy) NSUInteger (^numberOfTestCases)();
@property(nonatomic, copy) NSUInteger (^numberOfAutoCases)();

@property(nonatomic, copy) NSInvocation * (^nameForIndex)(NSIndexPath * indexPath);


+(instancetype)shareInstance;

-(void)reloadData;

@end
