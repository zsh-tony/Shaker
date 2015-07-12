//
//  AppDelegate.h
//  Stranger-Social
//
//  Created by lerrruby on 15/5/21.
//  Copyright (c) 2015年 lerruby.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WXOpenIMSDKFMWK/YWFMWK.h>
#import <WXOUIModule/YWUIFMWK.h>


@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic, readwrite) YWIMKit *ywIMKit;
@property (strong, nonatomic) UIWindow *window;


@end

