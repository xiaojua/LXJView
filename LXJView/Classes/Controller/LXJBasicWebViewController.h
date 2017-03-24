//
//  LXJBasicWebViewController.h
//  LXJView
//
//  Created by xiaojuan on 17/3/24.
//  Copyright © 2017年 xiaojuan. All rights reserved.
//

#import "LXJBasicViewController.h"

@interface LXJBasicWebViewController : LXJBasicViewController

/* webView */
@property (strong, nonatomic) UIWebView *basicWebView;
@property WebViewJavascriptBridge *bridge;
/* url */
@property (copy, nonatomic) NSString *webUrl;

- (void)loadWebView;
- (void)loadExampleView;

@end
