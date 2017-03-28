//
//  LXJHeaderView.m
//  LXJView
//
//  Created by xiaojuan on 17/3/28.
//  Copyright © 2017年 xiaojuan. All rights reserved.
//

#import "LXJHeaderView.h"

#define kFilePath @"Documents/curHeaderImage@2x.png"

@interface LXJHeaderView ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) UIImagePickerController *picker;

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UIView *bgView;

@end



@implementation LXJHeaderView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor greenColor];
        self.layer.cornerRadius = self.frame.size.width/2;
        self.layer.masksToBounds = YES;
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.layer.borderWidth = 1;
        
        self.picker = [UIImagePickerController new];
        self.picker.delegate = self;
        
        //view上的ImageView
        self.imageView = [[UIImageView alloc]initWithImage:[self returnImageWithfilePath]];
        self.imageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        self.imageView.backgroundColor = [UIColor whiteColor];
        self.imageView.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:self.imageView];
        
        //tap
        self.imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGrShowImage)];
        tapGr.numberOfTouchesRequired = 1;
        [self.imageView addGestureRecognizer:tapGr];
        
        
        
    }
    return self;
}
//返回当前img
- (UIImage *)returnImageWithfilePath{
    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:kFilePath];
    UIImage *image = [UIImage imageWithContentsOfFile:filePath];
    if (!image) {
        image = [UIImage imageNamed:@"aa"];
    }
    return image;
}

- (void)tapGrShowImage{
    self.basicVc.navigationController.navigationBarHidden = YES;
    NSLog(@"...");
    self.bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
    self.bgView.backgroundColor = [UIColor whiteColor];
    [self.basicVc.view addSubview:self.bgView];
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[self returnImageWithfilePath]];
    imageView.frame = self.bgView.frame;
    imageView.backgroundColor = [UIColor whiteColor];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.bgView addSubview:imageView];
    
    imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGrHide = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGrHideImage)];
    tapGrHide.numberOfTouchesRequired = 1;
    [imageView addGestureRecognizer:tapGrHide];
    
    UILongPressGestureRecognizer *longPre = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPreImage)];
    [imageView addGestureRecognizer:longPre];
    
}

- (void)tapGrHideImage {
    self.basicVc.navigationController.navigationBarHidden = NO;
    [self.bgView removeFromSuperview];
}
- (void)longPreImage{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    __block __typeof(self)weakSelf = self;
    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        weakSelf.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [weakSelf.basicVc presentViewController:weakSelf.picker animated:YES completion:nil];
    }];
    UIAlertAction *photo = [UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        weakSelf.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary ;
        [weakSelf.basicVc presentViewController:weakSelf.picker animated:YES completion:nil];
    }];
    UIAlertAction *save = [UIAlertAction actionWithTitle:@"保存图片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self saveImageToPhotoLibraryWithImg:nil];
    }];
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:camera];
    [alert addAction:photo];
    [alert addAction:save];
    [alert addAction:cancle];
    
    [self.basicVc presentViewController:alert animated:YES completion:nil];
    
}

/* 保存img到本地相册 */
- (void)saveImageToPhotoLibraryWithImg:(UIImage *)image{
    if (image) {
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didfinishSaveImgWithError:contextInfo:), nil);
    }else{
        UIImageWriteToSavedPhotosAlbum([self returnImageWithfilePath], self, @selector(image:didfinishSaveImgWithError:contextInfo:), nil);
    }
    
}
- (void)image:(UIImage *)image didfinishSaveImgWithError:(NSError *)error contextInfo:(void *)info{
    if (!error) {
        NSLog(@"保存到相册成功");
        [self.bgView showMessage:@"保存成功"];
    }else{
        NSLog(@"保存到相册失败");
        [self.bgView showMessage:@"保存失败"];
    }
}


#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary<NSString *,id> *)editingInfo{
    self.imageView.image = image;
    
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        [self saveImageToPhotoLibraryWithImg:image];
        [self saveImageToDocuments:image];
        [self.picker dismissViewControllerAnimated:YES completion:nil];
        [self tapGrHideImage];
    }else if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary){
        [self saveImageToDocuments:image];
        [self.picker dismissViewControllerAnimated:YES completion:nil];
        [self tapGrHideImage];
    }
}
- (void)saveImageToDocuments:(UIImage *)image{
    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:kFilePath];
    NSData *imgData = UIImagePNGRepresentation(image);
    [imgData writeToFile:filePath atomically:YES];
}



@end
