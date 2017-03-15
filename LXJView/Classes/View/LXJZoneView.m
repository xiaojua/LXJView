//
//  LXJZoneView.m
//  LXJView
//
//  Created by xiaojuan on 17/3/9.
//  Copyright © 2017年 xiaojuan. All rights reserved.
//

#import "LXJZoneView.h"
#import "Masonry.h"
#import "LXJDynamicCell.h"
#import "MJRefresh.h"
#import "LXJViewItem.h"
#import "UITableView+FDTemplateLayoutCell.h"


@interface LXJZoneView ()<UITableViewDelegate, UITableViewDataSource, LXJDynamicCellDelegate>

@property (nonatomic, strong) UITableView *zoneTableView;
@property (nonatomic, strong) NSMutableArray *dynamics;

@end

@implementation LXJZoneView

- (void)setZoneInfo:(NSArray *)zoneInfo{
    _zoneInfo = zoneInfo;
    //初始化界面
    [self setViewWithInfo:zoneInfo];
    
    
}
- (void)setViewWithInfo:(NSArray *)dataSource{
    [_dynamics removeAllObjects];
    if (_zoneTableView == nil) {
        _zoneTableView = [[UITableView alloc]init];
        _zoneTableView.translatesAutoresizingMaskIntoConstraints = NO;
        _zoneTableView.delegate = self;
        _zoneTableView.dataSource = self;
        [self addSubview:_zoneTableView];
        [_zoneTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top);
            make.right.mas_equalTo(self.mas_right);
            make.left.mas_equalTo(self.mas_left);
            make.bottom.mas_equalTo(self.mas_bottom);
        }];
        [_zoneTableView setNeedsLayout];
        [_zoneTableView setNeedsDisplay];
        [_zoneTableView registerClass:[LXJDynamicCell class] forCellReuseIdentifier:@"DynamicCell"];
        
        //隐藏tableView每个cell间的线
        [self setExtraCellLineHide:_zoneTableView];
        
        [_zoneTableView addHeaderWithTarget:self action:@selector(dynamicTableViewHeaderRefresh)];
        [_zoneTableView addFooterWithTarget:self action:@selector(dynamicTableViewFooterRefresh)];
        _zoneTableView.headerPullToRefreshText = @"下拉刷新";
        _zoneTableView.headerReleaseToRefreshText = @"松开刷新";
        _zoneTableView.headerRefreshingText = @"正在刷新";
        _zoneTableView.footerPullToRefreshText = @"加载更多";
        _zoneTableView.footerReleaseToRefreshText = @"松开加载";
        _zoneTableView.footerRefreshingText = @"加载中";
        
        [self getDataSourceWithArr:dataSource];
    }
}
- (void)getDataSourceWithArr:(NSArray *)arr{
    if (_dynamics == nil) {
        _dynamics = [NSMutableArray array];
    }
    NSMutableArray *returnArr = [NSMutableArray array];
    for (NSDictionary *dict in arr) {
        LXJViewItem *item = [LXJViewItem dynamicWithDict:dict];
        [returnArr addObject:item];
    }
    [_dynamics addObjectsFromArray:returnArr];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dynamics.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LXJDynamicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DynamicCell" forIndexPath:indexPath];
    LXJViewItem *item = _dynamics[indexPath.row];
    cell.delegate = self;
    cell.data = item;
    cell.fd_enforceFrameLayout = YES;
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height;
    LXJViewItem *item = [_dynamics objectAtIndex:indexPath.row];
    
    height = [tableView fd_heightForCellWithIdentifier:@"DynamicCell" cacheByIndexPath:indexPath configuration:^(id cell) {
        LXJDynamicCell *cel = (LXJDynamicCell *)cell;
        
        cel.data = item;
        NSLog(@"%@",item);
        cel.fd_enforceFrameLayout = YES;
        NSLog(@"1=%f",height);
    }];
    NSLog(@"2=%f",height);
    
    
    
    return height + 6;
//    return 600;
}
#pragma mark - function
/* 隐藏tableView每个cell间的线 */
- (void)setExtraCellLineHide:(UITableView *)tableView{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}
/* 头部脚部刷新 */
- (void)dynamicTableViewHeaderRefresh{
    [_zoneTableView headerEndRefreshing];
}
- (void)dynamicTableViewFooterRefresh{
    [_zoneTableView footerEndRefreshing];
    [_zoneTableView reloadData];
}

#pragma mark - LXJDynamicCellDelegate
/* 打开全文收起全文 */
- (void)pressMoreBtnOnDynamicCell:(LXJDynamicCell *)cell{
    NSIndexPath *indexPath = [_zoneTableView indexPathForCell:cell];
    NSLog(@"%@",indexPath);
    NSMutableArray *arr = [NSMutableArray array];
    [arr addObject:indexPath];
    [_zoneTableView reloadRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationAutomatic];
}
- (void)longPressText:(NSString *)text onDynamicCell:(LXJDynamicCell *)cell{
    
}
- (void)longPressImageView:(UIImageView *)imageView onDynamicCell:(LXJDynamicCell *)cell{
    
}
- (void)pressImageView:(UIImageView *)imageView onDynamicCell:(LXJDynamicCell *)cell{
    
}

@end
