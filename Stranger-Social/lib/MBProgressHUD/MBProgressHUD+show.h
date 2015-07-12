//
//  MBProgressHUD+show.h
//  weibo
//
//  Created by zsh tony on 14-8-2.
//  Copyright (c) 2014年 zsh-tony. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (show)
+(void)showErrorWithText:(NSString *)text;
+(void)showSuccessWithText:(NSString *)text;
@end
