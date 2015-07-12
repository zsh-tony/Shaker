//
//  user.m
//  weibo
//
//  Created by zsh tony on 14-8-1.
//  Copyright (c) 2014年 zsh-tony. All rights reserved.
//

#import "user.h"


@implementation User
-(id)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        self.phone = dict[@"phone"];
        self.nickName = dict[@"nickName"];
        self.pinYin = dict[@"pinYin"];
        self.imgUrl = dict[@"imgUrl"];
        self.sex = dict[@"sex"];
        self.coords = CLLocationCoordinate2DMake([dict[@"lat"] doubleValue],[dict[@"lon"] doubleValue]);
        


    }
    return self;

}


@end
