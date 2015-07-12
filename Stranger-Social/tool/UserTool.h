//
//  OrderTool.h
//  weibo
//
//  Created by zsh tony on 14-8-1.
//  Copyright (c) 2014年 zsh-tony. All rights reserved.
//

#import <Foundation/Foundation.h>
@class User;
@interface UserTool : NSObject
//类方法的知名缺点：不能返回成员变量
+(void)requestUsersWithPath:(NSString *)path UserPhone:(NSString *)phone success:(void (^)(NSMutableArray *))success fail:(void (^)())fail;

+(void)requestUserWithPath:(NSString *)path UserPhone:(NSString *)phone success:(void (^)(User *))success fail:(void (^)())fail;
@end
