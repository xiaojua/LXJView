//
//  LXJDynamicCell.h
//  LXJView
//
//  Created by xiaojuan on 17/3/7.
//  Copyright © 2017年 xiaojuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LXJViewItem.h"

@class LXJDynamicCell;
@protocol LXJDynamicCellDelegate <NSObject>

/* 长按文字 */
- (void)onlongPressText:(NSString *)text onDynamicCell:(LXJDynamicCell *)cell;
/* 按下更多或者收起按钮 */
- (void)onpressMoreBtnOnDynamicCell:(LXJDynamicCell *)cell;
/* 长按图片ImageView */
- (void)onlongPressImageView:(UIImageView *)imageView onDynamicCell:(LXJDynamicCell *)cell;
/* 点击图片ImageView */
- (void)onpressImageView:(UIImageView *)imageView onDynamicCell:(LXJDynamicCell *)cell;



@end




@interface LXJDynamicCell : UITableViewCell


@property (strong, nonatomic) UIImageView *headerView;
@property (strong, nonatomic) UIView *bodyView;
@property (strong, nonatomic) UIView *zanBarView;
@property (strong, nonatomic) UIView *footerView;

/* 昵称 */
@property (strong, nonatomic) UILabel *name;
@property (strong, nonatomic) UIButton *deleteBtn;
@property (strong, nonatomic) UIImageView *zanBtn;
@property (strong, nonatomic) UIImageView *replyBtn;
@property (strong, nonatomic) LXJViewItem *data;

@property (strong, nonatomic) NSMutableArray *imageArr;
@property (strong, nonatomic) NSMutableArray *imageViewArr;

/* 代理属性 */
@property (nonatomic, weak) id<LXJDynamicCellDelegate> delegate;

@end
