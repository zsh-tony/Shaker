//
//  user.h
//  weibo
//
//  Created by zsh tony on 14-8-1.
//  Copyright (c) 2014年 zsh-tony. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
@interface User : NSObject
@property (nonatomic ,copy) NSString *phone;
@property (nonatomic ,copy) NSString *nickName;
@property (nonatomic ,copy) NSString *imgUrl;
@property (nonatomic,strong)NSString *sex;
@property ( nonatomic , copy ) NSString *pinYin;
@property (nonatomic,assign) CLLocationCoordinate2D coords;
-(id)initWithDict:(NSDictionary *)dict;

@end
