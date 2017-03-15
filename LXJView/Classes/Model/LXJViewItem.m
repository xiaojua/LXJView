//
//  LXJViewItem.m
//  LXJView
//
//  Created by xiaojuan on 17/3/7.
//  Copyright © 2017年 xiaojuan. All rights reserved.
//

#import "LXJViewItem.h"

@implementation LXJViewItem

- (id)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
+ (id)dynamicWithDict:(NSDictionary *)dict{
    return [[self alloc]initWithDict:dict];
}


@end
