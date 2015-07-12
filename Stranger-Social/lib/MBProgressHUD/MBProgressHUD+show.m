//
//  MBProgressHUD+show.m
//  weibo
//
//  Created by zsh tony on 14-8-2.
//  Copyright (c) 2014年 zsh-tony. All rights reserved.
//

#import "MBProgressHUD+show.h"

@implementation MBProgressHUD (show)
+(void)showText:(NSString *)text name:(NSString*)name
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];//把窗口传进去
    //hud.mode = MBProgressHUDModeDeterminate;
    hud.mode = MBProgressHUDModeCustomView;//一定要写在后面一句的前面
    name = [NSString stringWithFormat:@"MBProgressHUD.bundle/%@",name];
    hud.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:name]];
    hud.labelText = text;
    hud.removeFromSuperViewOnHide = YES;//隐藏不等于移除
    [hud hide:YES afterDelay:1];

}
+(void)showErrorWithText:(NSString *)text
{
    
    [self showText:text name:@"error.png"];
}
+(void)showSuccessWithText:(NSString *)text
{
    [self showText:text name:@"success.png"];
}
@end
