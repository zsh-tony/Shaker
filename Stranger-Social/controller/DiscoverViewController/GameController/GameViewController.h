//
//  GameViewController.h
//  Stranger-Social
//
//  Created by lerrruby on 15/5/23.
//  Copyright (c) 2015年 lerruby.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
@interface GameViewController : UIViewController
@property (nonatomic,copy)void (^getUser)(User *user);
@property (nonatomic,strong)User *myUser;
@end
