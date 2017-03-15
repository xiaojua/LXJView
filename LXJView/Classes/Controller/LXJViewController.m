//
//  LXJViewController.m
//  LXJView
//
//  Created by xiaojuan on 17/3/10.
//  Copyright © 2017年 xiaojuan. All rights reserved.
//

#import "LXJViewController.h"
#import "UIImageView+WebCache.h"

@interface LXJViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation LXJViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:@"http://tp1.sinaimg.cn/1618051664/50/5735009977/0"]];
    
    
    
    
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
