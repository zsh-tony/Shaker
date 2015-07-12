//
//  UIBarButtonItem+creat.h
//  weibo
//
//  Created by zsh tony on 14-7-26.
//  Copyright (c) 2014年 zsh-tony. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (creat)
+(UIBarButtonItem *)barButtonItemWithIcon:(NSString *)icon target:(id)target action:(SEL)action;
+(UIBarButtonItem *)barButtonItemWithBg:(NSString *)bg title:(NSString *)title size:
                                 (CGSize)size target:(id)target action:(SEL)action;
@end
