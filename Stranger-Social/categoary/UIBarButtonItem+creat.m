
//
//  UIBarButtonItem+creat.m
//  weibo
//
//  Created by zsh tony on 14-7-26.
//  Copyright (c) 2014年 zsh-tony. All rights reserved.
//

#import "UIBarButtonItem+creat.h"

@implementation UIBarButtonItem (creat)
+(UIBarButtonItem *)barButtonItemWithIcon:(NSString *)icon target:(id)target action:(SEL)action
{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    CGSize btnsize = [btn setAllStateBg:icon];
    btn.bounds = (CGRect){ CGPointZero,btnsize};
    
    return [[UIBarButtonItem alloc]initWithCustomView:btn];
}
+(UIBarButtonItem *)barButtonItemWithBg:(NSString *)bg title:(NSString *)title size:
(CGSize)size target:(id)target action:(SEL)action
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    //btn.titleEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 3);
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:bg] forState:UIControlStateNormal];
    //btn.imageEdgeInsets = UIEdgeInsetsMake(0, 40, 0, 0);
    //图片的拉伸，不然会有阴影
    btn.bounds = (CGRect){CGPointZero,size};
    
    return  [[UIBarButtonItem alloc]initWithCustomView:btn];
    


}
@end
