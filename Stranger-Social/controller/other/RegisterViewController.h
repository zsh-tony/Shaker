//
//  registerViewController.h
//  SchoolExpress
//
//  Created by zsh tony on 15-4-23.
//  Copyright (c) 2015年 zsh-tony. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController<UITextFieldDelegate>
@property (nonatomic,strong)UILabel *phoneLabel;
@property (nonatomic,strong)UITextField *phoneText;
@property (nonatomic,strong)UILabel *phonePlaceholder;
@property (nonatomic,strong)UILabel *note;
@property (nonatomic,strong)UIButton *loginBtn;
@end
