//
//  TBRTestDataSouce.m
//  YTUITestCases
//
//  Created by huanwh on 2016/10/20.
//  Copyright © 2016年 hwh. All rights reserved.
//

#import "TBRTestDataSouce.h"

static int kTableViewTag = 555;


@implementation TBRTestDataSouce

+(instancetype)shareInstance {
    static TBRTestDataSouce *sharedManager;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager =  [[TBRTestDataSouce alloc] init];
    });
    return sharedManager;
}
-(instancetype)init {
    self = [super init];
    if (self) {
        [self setupTableView];
        _bgColors = @[@"#f1fafa",
                      @"#e8ffe8",
                      @"#e8e8ff",
                      @"#8080c0",
                      @"#e8d098",
                      @"#efefda",
                      @"#f2fld7",
                      @"#336699",
                      @"#6699cc",
                      @"#66cccc",
                      @"#b45b3e",
                      @"#479ac7",
                      @"#00b271",
                      @"#fbfbea",
                      @"#d5f3f4",
                      @"#d7fff0",
                      @"#f0dad2",
                      @"#ddf3ff"
                      ];
    }
    return self;
}
-(void)setupTableView {
    if (_tableView) {
        return ;
    }
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 100, 150, 180) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.alpha = 0.8;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tag = kTableViewTag;
    _tableView.tableFooterView = [UIView new];
    
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    UIApplication * app = [UIApplication sharedApplication];
    UIWindow * keyWindow = [app keyWindow];
    if (!keyWindow) {
        keyWindow = app.windows.lastObject;
    }
    
    [keyWindow.rootViewController.view addSubview:_tableView];
    [keyWindow.rootViewController.view bringSubviewToFront:_tableView];
    
    _tableView.center = CGPointMake(_tableView.center.x,keyWindow.rootViewController.view.center.y);
}

-(void)reloadData {
    [_tableView reloadData];
}



#pragma mark - UITableViewDelegate & Datasource
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInvocation * invotion = self.nameForIndex(indexPath.row);
    [invotion invoke];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.backgroundView = [UIView new];
    
    if (indexPath) {
        NSUInteger colorIndex = MAX(0, (indexPath.row % _bgColors.count));
        cell.backgroundColor = [self colorFromHexString:_bgColors[colorIndex] alpha:0.8];
    }
    
    cell.textLabel.textColor = [UIColor darkGrayColor];
    cell.textLabel.font      = [UIFont boldSystemFontOfSize:12];
    cell.textLabel.text = @"null";
    
    if (self.nameForIndex) {
        NSInvocation * invotion = self.nameForIndex(indexPath.row);
        
        NSString *name = NSStringFromSelector(invotion.selector);
        cell.textLabel.text = name;
    }
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    _tableView.hidden = !self.numberOfTableView || self.numberOfTableView() <= 0;
    
    if (self.numberOfTableView && self.numberOfTableView() > 0) {
        return self.numberOfTableView();
    }
    
    return 0;
}

- (UIColor *)colorFromHexString:(NSString *)hexString  alpha:(float) alpha{
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:alpha];
}
@end

