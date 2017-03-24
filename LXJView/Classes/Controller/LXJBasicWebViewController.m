//
//  LXJBasicWebViewController.m
//  LXJView
//
//  Created by xiaojuan on 17/3/24.
//  Copyright © 2017年 xiaojuan. All rights reserved.
//

#import "LXJBasicWebViewController.h"

@interface LXJBasicWebViewController ()<UIWebViewDelegate>

@end

@implementation LXJBasicWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)loadWebView{
    [WebViewJavascriptBridge enableLogging];
    self.basicWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H-kNavH)];
    self.basicWebView.scalesPageToFit = NO;
    self.basicWebView.multipleTouchEnabled = NO;
    self.basicWebView.delegate = self;
    [self.view addSubview:self.basicWebView];
    
    _bridge = [WebViewJavascriptBridge bridgeForWebView:self.basicWebView webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"%@", data);
    }];
    
    [self loadExampleView];
    
    
}
- (void)loadExampleView{
    [self.basicWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_webUrl]]];
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
