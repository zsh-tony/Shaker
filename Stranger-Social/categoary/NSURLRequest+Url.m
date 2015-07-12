

//
//  NSURLRequest+url.m
//  weibo
//
//  Created by zsh tony on 14-8-1.
//  Copyright (c) 2014年 zsh-tony. All rights reserved.
//

#import "NSURLRequest+Url.h"

@implementation NSURLRequest (Url)
+(NSURLRequest *)requestWithPath:(NSString *)path params:(NSDictionary *)params//传字典比较好
{
    NSMutableString *urlstr = [NSMutableString stringWithFormat:@"%@%@",kBaseUrl,path];
    //遍历字典, 拼接参数
    if (params) {
        [urlstr appendString:@"?"];
        
       // [urlstr appendFormat:@"%@=%@",kAccessToken,[AccountTool sharedAccountTool].currentAccount.accessToken];
        [params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [urlstr appendFormat:@"&%@=%@",key,obj];
        }];//用block来遍历字典
    }
//    NSString *urlstr = [NSString stringWithFormat:@"https://api.weibo.com/2/statuses/friends_timeline.json?access_token=%@&since_id=%@&max_id=%@",[AccountTool sharedAccountTool].currentAccount.accessToken,sinceId,maxId];
    urlstr = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlstr];
      return [NSURLRequest requestWithURL:url];
}

+(NSMutableURLRequest *)mutableRequestWithPath:(NSString *)path params:(NSDictionary *)params//传字典比较好
{
    NSMutableString *urlstr = [NSMutableString stringWithFormat:@"%@%@",kBaseUrl,path];
    //遍历字典, 拼接参数
    if (params) {
        [urlstr appendString:@"?"];
        
        // [urlstr appendFormat:@"%@=%@",kAccessToken,[AccountTool sharedAccountTool].currentAccount.accessToken];
        [params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [urlstr appendFormat:@"&%@=%@",key,obj];
        }];//用block来遍历字典
    }
    //    NSString *urlstr = [NSString stringWithFormat:@"https://api.weibo.com/2/statuses/friends_timeline.json?access_token=%@&since_id=%@&max_id=%@",[AccountTool sharedAccountTool].currentAccount.accessToken,sinceId,maxId];
    urlstr = [urlstr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlstr];
    return [NSMutableURLRequest requestWithURL:url];
}

@end
