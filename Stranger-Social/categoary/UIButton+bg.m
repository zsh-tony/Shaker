
//
//  UIButton+bg.m
//  weibo
//
//  Created by zsh tony on 14-7-26.
//  Copyright (c) 2014年 zsh-tony. All rights reserved.
//

#import "UIButton+bg.h"

@implementation UIButton (bg)
-(CGSize)setAllStateBg:(NSString *)icon
{
    UIImage *normal = [UIImage stretchImageWithName:icon];
     UIImage *highlighted = [UIImage stretchImageWithName:[icon filenameAppend:@"_highlighted"]];
    [self setBackgroundImage:normal forState:UIControlStateNormal];
    [self setBackgroundImage:highlighted forState:UIControlStateHighlighted];
    return normal.size;
}
@end
