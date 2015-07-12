//
//  MainViewController.h
//  weibo
//
//  Created by zsh tony on 14-7-24.
//  Copyright (c) 2014年 zsh-tony. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Singleton.h"
@interface MainViewController : UIViewController<UINavigationControllerDelegate>
singleton_interface(MainViewController)

@property (nonatomic ,readonly,strong) UINavigationController *selectedController;
@end
