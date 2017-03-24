//
//  UIView+LXJHUD.m
//  LXJView
//
//  Created by xiaojuan on 17/3/23.
//  Copyright © 2017年 xiaojuan. All rights reserved.
//

#import "UIView+LXJHUD.h"

#define kShowMsgDelayDuration 1
#define kTimeoutDuration 30

@implementation UIView (LXJHUD)




- (void)showMessage:(NSString *)msg{
    //异步主线程中进行
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideAllHUDsForView:self animated:YES];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = msg;
        [hud hide:YES afterDelay:kShowMsgDelayDuration];
    });
}

- (void)showLoading{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideAllHUDsForView:self animated:YES];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
        hud.labelText = @"加载中...";
        [hud hide:YES afterDelay:kTimeoutDuration];
    });
}

- (void)hideBusyHUD{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideAllHUDsForView:self animated:YES];
    });
}

@end
