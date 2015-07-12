//
//  LookUpViewController.h
//  Stranger-Social
//
//  Created by lerrruby on 15/5/26.
//  Copyright (c) 2015年 lerruby.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
@interface LookUpViewController : UIViewController
@property (nonatomic,strong)UIImageView *iconImage;
@property (nonatomic,strong)User *myUser;
@property (nonatomic,copy)void (^getUser)(User *user);
@property (nonatomic,strong)UILabel *nickNameLabel;
@end
