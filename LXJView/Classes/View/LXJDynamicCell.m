//
//  LXJDynamicCell.m
//  LXJView
//
//  Created by xiaojuan on 17/3/7.
//  Copyright © 2017年 xiaojuan. All rights reserved.
//

#import "LXJDynamicCell.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"
#import "TTTAttributedLabel.h"

#define kPicInsert 4

@interface LXJDynamicCell()<TTTAttributedLabelDelegate>

@property (nonatomic, strong) UIButton  *moreBtn;

@end



@implementation LXJDynamicCell



- (void)setData:(LXJViewItem *)data{
    _data = data;
    for (UIView *view in [self.contentView subviews]) {
        [view removeFromSuperview];
    }
    [self setHeaderView];
    [self setBodyView];
    [self setZanBarView];
    [self setFooterView];
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.bounds = [UIScreen mainScreen].bounds;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
#pragma mark - headerView
- (void)setHeaderView{
    _headerView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 14, 40, 40)];
    [self.contentView addSubview:_headerView];
    _headerView.layer.borderColor = [[UIColor redColor] CGColor];
    _headerView.layer.borderWidth = 1;
    _headerView.layer.masksToBounds = YES;
    _headerView.layer.cornerRadius = 5;
    
    CGFloat nameW = SCREEN_W - 60 - 32;
    _name = [[UILabel alloc]initWithFrame:CGRectMake(60, 18, nameW, 14)];
    [self.contentView addSubview:_name];
    _name.font = [UIFont systemFontOfSize:14];
    _name.textColor = [UIColor colorWithRed:200/255.0 green:148/255.0 blue:40/255.0 alpha:1];
    
    [_headerView sd_setImageWithURL:[NSURL URLWithString:_data.icon]];
    
    _name.text = _data.name;
}
#pragma mark - bodyView
- (void)setBodyView{
    CGFloat bodyW = SCREEN_W - 60 - 32;
    CGFloat bodyAddH = 0;
    BOOL showMoreBtn = NO;
    NSString *content = _data.content;
    
    /* 富文本 */
    TTTAttributedLabel *contentLabel = [[TTTAttributedLabel alloc]initWithFrame:CGRectMake(0, 0, bodyW, 0)];
    contentLabel.numberOfLines = 0;
    contentLabel.enabledTextCheckingTypes = NSTextCheckingTypeLink;
    contentLabel.delegate = self;
    if (content != nil && content.length > 0) {
        /* 设置段落 */
        NSMutableParagraphStyle *parStyle = [[NSMutableParagraphStyle alloc]init];
        parStyle.maximumLineHeight = 18;
        parStyle.minimumLineHeight = 16;
        parStyle.firstLineHeadIndent = 0;
        parStyle.headIndent = 0;
        parStyle.lineSpacing = 6;
        parStyle.alignment = NSTextAlignmentLeft;
        
        NSDictionary *att = @{NSFontAttributeName:[UIFont systemFontOfSize:14],
                              NSParagraphStyleAttributeName:parStyle};
        contentLabel.attributedText = [[NSAttributedString alloc]initWithString:content attributes:att];
        
        CGSize size = CGSizeMake(bodyW, 1000);
        CGSize finalSize = [contentLabel sizeThatFits:size];
        contentLabel.frame = CGRectMake(0, 0, finalSize.width, finalSize.height);
        
        contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        contentLabel.linkAttributes = @{(NSString *)kCTUnderlineStyleAttributeName:[NSNumber numberWithBool:YES],
                                        (NSString *)kCTForegroundColorAttributeName:(id)[UIColor blueColor].CGColor};
        contentLabel.highlightedTextColor = [UIColor redColor];
        contentLabel.verticalAlignment = TTTAttributedLabelVerticalAlignmentTop;
        
        /* 获取超链接 */
        NSError *error = nil;
        NSString *regulaStr = @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
        /* 过滤规则 */
        NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:regulaStr options:NSRegularExpressionCaseInsensitive error:&error];
        /* 找出符合的链接返回数组 */
        NSArray *allMatchArr = [regular matchesInString:content options:0 range:NSMakeRange(0, [content length])];
        
        NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc]initWithString:content];
        for (NSTextCheckingResult *mach in allMatchArr) {
            NSString *subMatch = [content substringWithRange:mach.range];
            //给截取出来的链接设置颜色字体
            [attribute addAttribute:(NSString *)kCTFontAttributeName value:(id)contentLabel.font range:mach.range];
            [attribute addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColor blueColor].CGColor range:mach.range];
            [contentLabel addLinkToURL:[NSURL URLWithString:subMatch] withRange:mach.range];
        }
        
        
        /* 给文本添加手势 */
        contentLabel.userInteractionEnabled = YES;//和用户交互的按钮打开
        UILongPressGestureRecognizer *longPre = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(onlongPressText:)];
        [contentLabel addGestureRecognizer:longPre];
        contentLabel.frame = CGRectMake(0, 0, finalSize.width, finalSize.height);
        bodyAddH = 0;
        
        //如果文字内容H小于144，则没有更多按钮，否则需要判断_data.isOpenContent属性为yes或no
        if (finalSize.height > 144) {
            if (_data.isOpenContent == NO) {//不打开文本的时候
                contentLabel.frame = CGRectMake(0, 0, finalSize.width, 144);
                _moreBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                _moreBtn.frame = CGRectMake(0, 0, 50, 20);
                _moreBtn.titleLabel.font = [UIFont systemFontOfSize:14];
                [_moreBtn setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
                UIEdgeInsets titleEdgeInset = UIEdgeInsetsMake(-10, 0, 0, 0);
                _moreBtn.titleEdgeInsets = titleEdgeInset;
                [_moreBtn setContentMode:UIViewContentModeLeft];
                [_moreBtn setTitle:@"全文" forState:UIControlStateNormal];
                
                CGRect moreBtnFrame = _moreBtn.frame;
                moreBtnFrame.origin.y = contentLabel.frame.size.height + contentLabel.frame.origin.y;
                _moreBtn.frame = moreBtnFrame;
                [_moreBtn addTarget:self action:@selector(showMore) forControlEvents:UIControlEventTouchUpInside];
                showMoreBtn = YES;
                bodyAddH = 20;
            }else{//打开文本的时候
                contentLabel.frame = CGRectMake(0, 0, finalSize.width, finalSize.height);
                _moreBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                _moreBtn.frame = CGRectMake(0, 0, 30, 20);
                _moreBtn.titleLabel.font = [UIFont systemFontOfSize:14];
                [_moreBtn setTitle:@"收起" forState:UIControlStateNormal];
                [_moreBtn setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
                _moreBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
                [_moreBtn setContentMode:UIViewContentModeLeft];
                [_moreBtn addTarget:self action:@selector(showMore) forControlEvents:UIControlEventTouchUpInside];
                
                CGRect moreBtnFrme = _moreBtn.frame;
                moreBtnFrme.origin.y = contentLabel.frame.size.height + contentLabel.frame.origin.y;
                _moreBtn.frame = moreBtnFrme;
                
                showMoreBtn = YES;
                bodyAddH = 20;
            }
        }else{
            contentLabel.frame = CGRectMake(0, 0, finalSize.width, finalSize.height);
            _moreBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            bodyAddH = 0;
            showMoreBtn = NO;
        }
        
        
        /* 图片排版 */
        //先保证放图片的数组不为空
        if (_imageArr == nil) {
            _imageArr = [NSMutableArray array];
        }
        [_imageArr removeAllObjects];
        [_imageArr addObjectsFromArray:_data.imgs];
        if (_imageViewArr == nil) {
            _imageViewArr = [NSMutableArray array];
        }
        [_imageViewArr removeAllObjects];
        //确定图片的y
        CGFloat y = contentLabel == nil ? 0 : contentLabel.frame.origin.y + contentLabel.frame.size.height + 10;
        NSLog(@"y=%f,height=%f,yy=%f",contentLabel.frame.origin.y,contentLabel.frame.size.height,y);
        if (showMoreBtn) {
            y += bodyAddH;
        }
        //判断有几张图片，分类：1张的、4张的、其余
        if (_imageArr.count == 1) {
            CGFloat imgW = bodyW / 7*3;
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, y, imgW, imgW)];
            imageView.tag = 0;
            imageView.userInteractionEnabled = YES;
            [imageView sd_setImageWithURL:[NSURL URLWithString:_imageArr[0]]];
            [_imageViewArr addObject:imageView];
            //加手势
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onpressImageView:)];
            [imageView addGestureRecognizer:tap];
            UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(onlongPressImageView:)];
            [imageView addGestureRecognizer:longPress];
            
        }else if (_imageArr.count == 4){
            CGFloat imgW = (bodyW - 2*kPicInsert)/3;
            for (int i = 0; i < _imageArr.count; i++) {
                UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((i%2)*(imgW+kPicInsert), (i/2)*(imgW+kPicInsert)+y, imgW, imgW)];
                imageView.tag = i;
                imageView.userInteractionEnabled = YES;
                [imageView sd_setImageWithURL:[NSURL URLWithString:_imageArr[i]]];
                [_imageViewArr addObject:imageView];
                
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onpressImageView:)];
                [imageView addGestureRecognizer:tap];
                UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(onlongPressImageView:)];
                [imageView addGestureRecognizer:longPress];
            }
        }else{
            CGFloat imgW = (bodyW - 2*kPicInsert)/3;
            for (int i = 0; i < _imageArr.count; i++) {
                UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((i%3)*(imgW+kPicInsert), (i/3)*(imgW+kPicInsert)+y, imgW, imgW)];
                imageView.tag = i;
                imageView.userInteractionEnabled = YES;
                [imageView sd_setImageWithURL:[NSURL URLWithString:_imageArr[i]]];
                [_imageViewArr addObject:imageView];
                
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onpressImageView:)];
                [imageView addGestureRecognizer:tap];
                UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(onlongPressImageView:)];
                [imageView addGestureRecognizer:longPress];
            }
        }
        
        //取出最后一个图片的位置，计算中间内容body的高
        UIImageView *lastImageView = [_imageViewArr objectAtIndex:(_imageViewArr.count - 1)];
        CGFloat bodyH = lastImageView.frame.size.height + lastImageView.frame.origin.y;
        if (showMoreBtn) {
            bodyH += bodyAddH;
        }
        NSLog(@"bodyH=%f",bodyH);
        self.bodyView = [[UIView alloc]initWithFrame:CGRectMake(_name.frame.origin.x, _name.frame.origin.y+_name.frame.size.height+10, bodyW, bodyH)];
        [self.contentView addSubview:self.bodyView];
        
        //富文本和更多按钮加上
        if (contentLabel != nil) {
            [self.bodyView addSubview:contentLabel];
            if (showMoreBtn) {
                [self.bodyView addSubview:_moreBtn];
            }
        }
        //图片加上
        for (UIImageView *imageView in _imageViewArr) {
            [self.bodyView addSubview:imageView];
        }
    }
    
    
    
}
#pragma mark - ZanBarView
- (void)setZanBarView{
    //设置通用字体
    CGFloat ldLenght = 8;
    UIFont *fontSize = [UIFont systemFontOfSize:13];
    UIFont *labelFontSize = [UIFont systemFontOfSize:15];
    if (SCREEN_W == 320) {
        ldLenght = -8;
        fontSize = [UIFont systemFontOfSize:11];
        labelFontSize = [UIFont systemFontOfSize:13];
    }
    
    _zanBarView = [[UIView alloc]initWithFrame:CGRectMake(0, _bodyView.frame.size.height+_bodyView.frame.origin.y, SCREEN_W, 36)];
    [self.contentView addSubview:_zanBarView];
    
    
    //1、时间label：@"08/29 10:25"
    UILabel *timeLabel = [UILabel new];
    timeLabel.translatesAutoresizingMaskIntoConstraints = NO;//关掉自动约束
    [_zanBarView addSubview:timeLabel];
    timeLabel.text = _data.time;
    timeLabel.font = fontSize;
    timeLabel.textColor = [UIColor colorWithRed:115.0/255 green:115.0/255 blue:115.0/255 alpha:1];
    CGRect rect = [_data.time boundingRectWithSize:CGSizeMake(320, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:13]} context:nil];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_zanBarView.mas_left).offset(60);
        make.centerY.mas_equalTo(_zanBarView.mas_centerY);
        make.width.mas_equalTo(rect.size.width+8);
        
    }];
    
    //2、删除按钮
    _deleteBtn = [[UIButton alloc]init];
    [_deleteBtn setContentMode:UIViewContentModeCenter];
    [_zanBarView addSubview:_deleteBtn];
    [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    [_deleteBtn setTitleColor:[UIColor colorWithRed:115.0/255 green:115.0/255 blue:115.0/255 alpha:1] forState:UIControlStateNormal];
    _deleteBtn.titleLabel.font = labelFontSize;
    _deleteBtn.userInteractionEnabled = YES;
    _deleteBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [_deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(timeLabel.mas_right).offset(ldLenght);
        make.centerY.mas_equalTo(_zanBarView.mas_centerY);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(40);
    }];
    _deleteBtn.hidden = NO;
#pragma mark - 点击删除事件没写！
    
    
    
    
    //3、评论图片和按钮
    UILabel *replylabel = [UILabel new];
    replylabel.text = @"评论";
    replylabel.textColor = [UIColor colorWithRed:115.0/255 green:115.0/255 blue:115.0/255 alpha:1];
    replylabel.userInteractionEnabled = YES;
    replylabel.translatesAutoresizingMaskIntoConstraints = NO;
    replylabel.font = labelFontSize;
    [_zanBarView addSubview:replylabel];
    [replylabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_zanBarView.mas_centerY);
        make.right.mas_equalTo(_zanBarView.mas_right).offset(-10);
        make.width.mas_equalTo(38);
        make.height.mas_equalTo(38);
    }];
    [replylabel setContentMode:UIViewContentModeCenter];
    
    
    
    _replyBtn = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"评论"]];
    [_replyBtn setContentMode:UIViewContentModeCenter];
    _replyBtn.userInteractionEnabled = YES;
    _replyBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [_zanBarView addSubview:_replyBtn];
    [_replyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_zanBarView.mas_centerY);
        make.right.mas_equalTo(replylabel.mas_left).offset(4);
        make.width.mas_equalTo(28);
        make.height.mas_equalTo(28);
    }];
    
    
    
    //4、赞图片和按钮
    UILabel *zanLabel = [UILabel new];
    zanLabel.text = @"赞";
    zanLabel.font = labelFontSize;
    zanLabel.textColor = [UIColor colorWithRed:115.0/255 green:115.0/255 blue:115.0/255 alpha:1];
    zanLabel.userInteractionEnabled = YES;
    zanLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [_zanBarView addSubview:zanLabel];
    [zanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_zanBarView.mas_centerY);
        make.right.mas_equalTo(_replyBtn.mas_left).offset(15);
        make.width.mas_equalTo(38);
        make.height.mas_equalTo(38);
    }];
    [zanLabel setContentMode:UIViewContentModeCenter];
    
#pragma mark - 没有加手势
    
    _zanBtn = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"评论-点赞"]];
    _zanBtn.userInteractionEnabled = YES;
    _zanBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [_zanBarView addSubview:_zanBtn];
    [_zanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_zanBarView.mas_centerY);
        make.right.mas_equalTo(zanLabel.mas_left).offset(4);
        make.width.mas_equalTo(28);
        make.height.mas_equalTo(28);
    }];
    [_zanBtn setContentMode:UIViewContentModeCenter];
    
    
}
#pragma mark - FooterView
- (void)setFooterView{
    
}

#pragma mark - 使用delegate
/* 长按 */
- (void)onlongPressText:(UILongPressGestureRecognizer *)sender{
    NSLog(@"长按文字");
    if (sender.state == UIGestureRecognizerStateBegan) {
        //判断代理属性是否响应的是此代理方法
        if (_delegate && [_delegate respondsToSelector:@selector(onlongPressText:onDynamicCell:)]) {
            //把响应的文字传过去
            TTTAttributedLabel *label = (TTTAttributedLabel *)sender.view;
            [_delegate onlongPressText:label.text onDynamicCell:self];
        }
    }
}
/* 更多或收起 */
- (void)showMore{
    if ([_moreBtn.titleLabel.text isEqualToString:@"全文"]) {
        if (_delegate && [_delegate respondsToSelector:@selector(onpressMoreBtnOnDynamicCell:)]) {
            _data.isOpenContent = YES;
            [_delegate onpressMoreBtnOnDynamicCell:self];
        }
    }else if ([_moreBtn.titleLabel.text isEqualToString:@"收起"]){
        if (_delegate && [_delegate respondsToSelector:@selector(onpressMoreBtnOnDynamicCell:)]) {
            _data.isOpenContent = NO;
            [_delegate onpressMoreBtnOnDynamicCell:self];
        }
    }
}
/* 长按图片imageView */
- (void)onlongPressImageView:(UILongPressGestureRecognizer *)sender{
    NSLog(@"长按图片");
    if (sender.state == UIGestureRecognizerStateBegan) {
        if (_delegate && [_delegate respondsToSelector:@selector(onlongPressText:onDynamicCell:)]) {
            UIImageView *imageView = (UIImageView *)sender.view;
            [_delegate onlongPressImageView:imageView onDynamicCell:self];
        }
    }
}
/* 点击图片imageView */
- (void)onpressImageView:(UITapGestureRecognizer *)sender{
    NSLog(@"点击图片");
    if (_delegate && [_delegate respondsToSelector:@selector(onpressImageView:onDynamicCell:)]) {
        UIImageView *imageView = (UIImageView *)sender.view;
        [_delegate onpressImageView:imageView onDynamicCell:self];
    }
}

- (CGSize)sizeThatFits:(CGSize)size{
    return CGSizeMake(SCREEN_W, _zanBarView.frame.size.height+_zanBarView.frame.origin.y+10);
}

@end
