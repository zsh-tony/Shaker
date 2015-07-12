//
//  NSURLRequest+url.h
//  weibo
//
//  Created by zsh tony on 14-8-1.
//  Copyright (c) 2014年 zsh-tony. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURLRequest (Url)
+(NSURLRequest *)requestWithPath:(NSString *)path params:(NSDictionary *)param;
+(NSMutableURLRequest *)mutableRequestWithPath:(NSString *)path params:(NSDictionary *)params;
@end
