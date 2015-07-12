//
//  SPUtil.m
//  WXOpenIMSampleDev
//
//  Created by huanglei on 15/4/12.
//  Copyright (c) 2015年 taobao. All rights reserved.
//

#import "SPUtil.h"

//#import <TSMessages/TSMessage.h>

@implementation SPUtil

+ (instancetype)sharedInstance
{
    static SPUtil *sUtil = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sUtil = [[SPUtil alloc] init];
    });
    
    return sUtil;
}

- (void)showNotificationInViewController:(UIViewController *)viewController title:(NSString *)title subtitle:(NSString *)subtitle type:(SPMessageNotificationType)type
{
    /// 我们在Demo中使用了第三方库TSMessage来显示提示信息
    /// 强烈建议您使用自己的提示信息显示方法，以便保持App内风格一致
    //[TSMessage showNotificationInViewController:viewController title:title subtitle:subtitle type:(TSMessageNotificationType)type];
    NSLog(@"message-%@---%@",title,subtitle);
    
}

- (void)getPersonDisplayName:(NSString *__autoreleasing *)aName avatar:(UIImage *__autoreleasing *)aAvatar ofPerson:(YWPerson *)aPerson
{
    if (aName) {
        *aName = [NSString stringWithFormat:@"M-%@-%@", aPerson.appKey, aPerson.personId];
    }
    
    if (aAvatar) {
        *aAvatar = [UIImage imageNamed:@"同学帮.png"];
    }
}

@end
