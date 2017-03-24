//
//  LXJBasicViewController.m
//  LXJView
//
//  Created by xiaojuan on 17/3/24.
//  Copyright © 2017年 xiaojuan. All rights reserved.
//

#import "LXJBasicViewController.h"

@interface LXJBasicViewController ()

@end

@implementation LXJBasicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationController.navigationBar.translucent = NO;//导航栏不透明
    self.edgesForExtendedLayout = UIRectEdgeNone;//四周不延伸
    self.extendedLayoutIncludesOpaqueBars = NO;//在bar不透明的情况下不延伸到bar
    self.modalPresentationCapturesStatusBarAppearance = NO;//控制显示全屏
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
