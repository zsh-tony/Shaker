//
//  Dock.h
//  weibo
//
//  Created by zsh tony on 14-7-25.
//  Copyright (c) 2014年 zsh-tony. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DockItem;
@interface Dock : UIView
//添加一个选项
- (DockItem *)addItemWithIcon:(NSString *)icon title:(NSString *)title;
@property (nonatomic,copy) void (^itemClickBlock)(int index);
@property (nonatomic,assign) int selectedIndex;

@end
