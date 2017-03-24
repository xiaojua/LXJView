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
#import "LCActionSheet.h"
#import "IDMPhotoBrowser.h"
#import "LXJWebViewController.h"

#define Tag_MyReplySheetShow 0x01
#define Tag_LongPressTextSheetShow 0x02
#define Tag_LongPressPicSheetShow 0x03
#define Tag_CoverViewSheetShow 0x04
#define Tag_LongPressShareUrlSheetShow 0x05
#define Tag_CopyMyReplySheetShow 0x06




@interface LXJZoneView ()<UITableViewDelegate, UITableViewDataSource, LXJDynamicCellDelegate, LCActionSheetDelegate, IDMPhotoBrowserDelegate>

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
    [_zoneTableView reloadData];
    [_zoneTableView footerEndRefreshing];
}

#pragma mark - LXJDynamicCellDelegate
/* 打开全文收起全文 */
- (void)onpressMoreBtnOnDynamicCell:(LXJDynamicCell *)cell{
    NSIndexPath *indexPath = [_zoneTableView indexPathForCell:cell];
    NSLog(@"%@",indexPath);
    NSMutableArray *arr = [NSMutableArray array];
    [arr addObject:indexPath];
    [_zoneTableView reloadRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationAutomatic];
}
/* 长按文字 */
- (void)onlongPressText:(NSString *)text onDynamicCell:(LXJDynamicCell *)cell{
    
    LCActionSheet *actionSheet = [LCActionSheet sheetWithTitle:nil buttonTitles:@[@"收藏",@"转发到聊天",@"转发到公告"] redButtonIndex:3 delegate:self];
    actionSheet.tag = Tag_LongPressTextSheetShow;
    [actionSheet show];
}

/* 长按图片 */
- (void)onlongPressImageView:(UIImageView *)imageView onDynamicCell:(LXJDynamicCell *)cell{
    LCActionSheet *actionSheet = [LCActionSheet sheetWithTitle:nil buttonTitles:@[@"保存图片",@"转发到聊天",@"转发到公告"] redButtonIndex:-1 delegate:self];
    actionSheet.tag = Tag_LongPressPicSheetShow;
    actionSheet.userObj = imageView;
    actionSheet.userObj2 = cell;
    [actionSheet show];
}
/* 点击图片 */
- (void)onpressImageView:(UIImageView *)imageView onDynamicCell:(LXJDynamicCell *)cell{
    LXJViewItem *item = cell.data;
    if (item == nil) {
        return;
    }
    
    NSMutableArray *picArr = [NSMutableArray array];
    for (int i=0; i<[item.imgs count]; i++) {
        NSURL *urlStr = [NSURL URLWithString:item.imgs[i]];
        IDMPhoto *photo = [IDMPhoto photoWithURL:urlStr];
        [picArr addObject:photo];
    }
    
    IDMPhotoBrowser *browser = [[IDMPhotoBrowser alloc]initWithPhotos:picArr animatedFromView:imageView];
    [browser setInitialPageIndex:imageView.tag];
    browser.delegate = self;
//    browser.doneButtonImage = [UIImage imageNamed:@"重拍"];//自己定返回按钮图片
    browser.displayActionButton = YES;
    browser.displayArrowButton = NO;//设置滚动图片时左右的箭头
    browser.displayCounterLabel = YES;
    browser.actionButtonTitles = @[@"转发到聊天",@"转发到公告",@"收藏",@"保存到手机" ];
    [_hvc presentViewController:browser animated:YES completion:nil];
    
     
}
/* 点击url */
- (void)onpressUrl:(NSURL *)url{
    LXJWebViewController *vc = [LXJWebViewController new];
    NSString *urlStr = url.absoluteString;
    if ([urlStr hasPrefix:@"https://"] || [urlStr hasPrefix:@"http://"]) {
        vc.url = urlStr;
    }else{
        vc.url = [NSString stringWithFormat:@"http://%@", urlStr];
    }
    [_hvc.navigationController pushViewController:vc animated:YES];
}


#pragma mark - LCActionSheetDelegate
- (void)actionSheet:(LCActionSheet *)actionSheet didClickedButtonAtIndex:(NSInteger)buttonIndex{
    NSInteger tag = actionSheet.tag;
    if (tag == Tag_LongPressTextSheetShow) {
        NSLog(@"长按文字后点中了某个按钮的下标：%ld", buttonIndex);
    }else if (tag == Tag_LongPressPicSheetShow){
        NSLog(@"长按图片点中了某个按钮的下标：%ld", buttonIndex);
        if (buttonIndex == 0) {
            UIImageView *imgView = (UIImageView *)actionSheet.userObj;
            UIImage *img = imgView.image;
            //需要在infoplist中加入Privacy - Photo Library Usage Description这个key
            [self saveImageToPhotoAlbum:img];
            
        }
        
    }
    
    
    
}
#pragma mark - 保存图片到手机
- (void)saveImageToPhotoAlbum:(UIImage *)image{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(saveImageWithImage:didfinishWithError:contextInfo:), nil);
    });
}
- (void)saveImageWithImage:(UIImage *)image didfinishWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        NSLog(@"%@", error.description);
    }else{
        NSLog(@"保存成功");
        [self showMessage:@"保存成功"];
        
    }
}

#pragma mark - 图片浏览器代理
- (void)photoBrowser:(IDMPhotoBrowser *)photoBrowser didDismissActionSheetWithButtonIndex:(NSUInteger)buttonIndex photoIndex:(NSUInteger)photoIndex{
    NSLog(@"1111");
    switch (buttonIndex) {
        case 0:
            NSLog(@"0");
            break;
        case 1:
            NSLog(@"1");
            break;
        case 2:
            NSLog(@"2");
            break;
            
        default:
            break;
    }
}
- (void)photoBrowser:(IDMPhotoBrowser *)photoBrowser didPressUseButtonAtIndex:(NSUInteger)index{
    NSLog(@"2222");
    switch (index) {
        case 0:
            NSLog(@"00");
            break;
        case 1:
            NSLog(@"11");
            break;
        case 2:
            NSLog(@"22");
            break;
            
        default:
            break;
    }
}
//左右浏览图片时捕捉当前图片的下标
- (void)photoBrowser:(IDMPhotoBrowser *)photoBrowser didShowPhotoAtIndex:(NSUInteger)index{
    NSLog(@"第%ld张图片已经显示", index+1);
    
    
    
}
//浏览完图片最后一张消失的图片下标
- (void)photoBrowser:(IDMPhotoBrowser *)photoBrowser didDismissAtPageIndex:(NSUInteger)index{
    NSLog(@"第%ld张图片已经消失", index+1);
}

@end
