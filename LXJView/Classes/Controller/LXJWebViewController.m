//
//  LXJWebViewController.m
//  LXJView
//
//  Created by xiaojuan on 17/3/24.
//  Copyright © 2017年 xiaojuan. All rights reserved.
//

#import "LXJWebViewController.h"

@interface LXJWebViewController ()

@end

@implementation LXJWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.title = @"网页";
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    self.webUrl = self.url;
    [self loadWebView];
    
    
}


- (void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
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
