//
//  LXJHomeViewController.m
//  LXJView
//
//  Created by xiaojuan on 17/3/7.
//  Copyright © 2017年 xiaojuan. All rights reserved.
//

#import "LXJHomeViewController.h"
#import "LXJZoneView.h"
#import "LXJGetData.h"
#import "Masonry.h"
#import "LXJHeaderView.h"


@interface LXJHomeViewController ()

@property (nonatomic, strong) LXJZoneView *zoneView;

@property (strong, nonatomic) LXJHeaderView *headerView;

@end

@implementation LXJHomeViewController

- (LXJZoneView *)zoneView{
    if (_zoneView == nil) {
        self.zoneView = [[LXJZoneView alloc]init];
        self.zoneView.hvc = self;
        self.zoneView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addSubview:self.zoneView];
        [self.zoneView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view.mas_top);
            make.left.mas_equalTo(self.view.mas_left);
            make.right.mas_equalTo(self.view.mas_right);
            make.bottom.mas_equalTo(self.view.mas_bottom);
//            make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        
    }
    return _zoneView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.title = @"朋友圈";
    [self getDatasource];
    
    //初始化headerView
    [self initWithHeaderView];
    
    
    
}

- (void)getDatasource{
    NSMutableArray *arr = [LXJGetData getDataSource];
    
    self.zoneView.zoneInfo = arr;
    
}
- (void)initWithHeaderView{
    self.headerView = [[LXJHeaderView alloc]initWithFrame:CGRectMake((SCREEN_W - 80)/2, 12, 40, 40)];
    self.navigationItem.titleView = self.headerView;
    self.headerView.basicVc = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
