//
//  UIView+LXJHUD.h
//  LXJView
//
//  Created by xiaojuan on 17/3/23.
//  Copyright © 2017年 xiaojuan. All rights reserved.
//

#import <UIKit/UIKit.h>

//封装HUD
//常用的有个：显示文字信息、忙加“加载中”提示、隐藏忙提示

@interface UIView (LXJHUD)



- (void)showMessage:(NSString *)msg;

- (void)showLoading;

- (void)hideBusyHUD;

@end
