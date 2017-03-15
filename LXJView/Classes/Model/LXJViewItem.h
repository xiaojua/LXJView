//
//  LXJViewItem.h
//  LXJView
//
//  Created by xiaojuan on 17/3/7.
//  Copyright © 2017年 xiaojuan. All rights reserved.
//

#import <Foundation/Foundation.h>

/* 每一条内容模型 */

@interface LXJViewItem : NSObject

/* 名字 */
@property (nonatomic, copy) NSString *name;
/* 头像 */
@property (nonatomic, copy) NSString *icon;
/* 内容 */
@property (copy, nonatomic) NSString *content;
/* 内容是否打开 */
@property (assign, nonatomic) BOOL isOpenContent;
/* 图片数组 */
@property (strong, nonatomic) NSArray *imgs;
/* ?? */
@property (copy, nonatomic) NSString *date;
/* 日期+时间 */
@property (copy, nonatomic) NSString *time;
/* 每条内容id */
@property (copy, nonatomic) NSString *statusID;
/* 评论数组 */
@property (strong, nonatomic) NSArray *commentList;

- (id)initWithDict:(NSDictionary *)dict;
+ (id)dynamicWithDict:(NSDictionary *)dict;



@end
