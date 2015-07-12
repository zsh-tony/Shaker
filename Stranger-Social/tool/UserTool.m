//
//  StatusTool.m
//  weibo
//
//  Created by zsh tony on 14-8-1.
//  Copyright (c) 2014年 zsh-tony. All rights reserved.
//

#import "UserTool.h"
#import "User.h"

@implementation UserTool
+(void)requestUsersWithPath:(NSString *)path UserPhone:(NSString *)phone success:(void (^)(NSMutableArray *))success fail:(void (^)())fail
{
    
    
    NSURLRequest *request = [NSURLRequest requestWithPath:path                        params:@{@"phone":phone}];
    AFJSONRequestOperation *op = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"dsfdsfds%@--",JSON);
        NSLog(@"%@",request.URL);
         NSArray *array = JSON[@"users"];
    
        
    
//    NSString *pathJSON=[[NSBundle mainBundle] pathForResource:@"test" ofType:@"json"];
//    NSLog(@"%@",pathJSON);
//    NSData *data=[NSData dataWithContentsOfFile:pathJSON];
//    NSLog(@"%@",data);
//    NSError *jsonError = nil;
//    NSMutableDictionary *testJSON=[NSJSONSerialization JSONObjectWithData:data
//                                                  options:NSJSONReadingAllowFragments
//                                              error:&jsonError];
//   NSLog(@"sadasd%@",testJSON);
//   
//        NSArray *array = testJSON[@"users"];
    
    
        //NSString *str = JSON[@"orders"];
       // NSLog(@"%u",[array isKindOfClass:[NSArray class]]);
    
        NSMutableArray *users = [NSMutableArray array];
        
        for (NSDictionary *dict in array) {
            User *u = [[User alloc]initWithDict:dict];

            NSLog(@"nick===%@",u.nickName);

            [users addObject:u];
        }
       
        if (success) {
            success(users);
        }

    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"%@d请求失败-%@",error,JSON);
       
        if (fail) {
            fail();
        }
        
    }];
  
    [op start];
//
}



+(void)requestUserWithPath:(NSString *)path UserPhone:(NSString *)phone success:(void (^)(User *))success fail:(void (^)())fail
{
    
    
    NSURLRequest *request = [NSURLRequest requestWithPath:path                        params:@{@"phone":phone}];
        AFJSONRequestOperation *op = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            NSLog(@"dsfdsfds%@--",JSON);
            NSLog(@"%@",request.URL);
             NSDictionary *userDict = JSON[@"user"];
    
    
    
//    NSString *pathJSON=[[NSBundle mainBundle] pathForResource:@"test" ofType:@"json"];
//    NSLog(@"%@",pathJSON);
//    NSData *data=[NSData dataWithContentsOfFile:pathJSON];
//    NSLog(@"%@",data);
//    NSError *jsonError = nil;
//    NSMutableDictionary *testJSON=[NSJSONSerialization JSONObjectWithData:data
//                   options:NSJSONReadingAllowFragments
//                                                                    error:&jsonError];
//    NSLog(@"sadasd%@",testJSON);
    
//    NSDictionary *userDict = testJSON[@"user"];
   
    User *user = [[User alloc]initWithDict:userDict];
    
    if (success) {
        success(user);
    }
    
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            NSLog(@"%@d请求失败-%@",error,JSON);
    
            if (fail) {
                fail();
            }
            
        }];
    
        [op start];

}



@end
