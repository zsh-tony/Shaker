//
//  UITextFieldCell.m
//  Stranger-Social
//
//  Created by lerrruby on 15/5/27.
//  Copyright (c) 2015年 lerruby.com. All rights reserved.
//

#import "UITextFieldCell.h"

@implementation UITextFieldCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _textField = [[UITextField alloc]initWithFrame:CGRectMake(35, 0, [UIScreen mainScreen].applicationFrame.size.width, 44)];
        _textField.textAlignment = NSTextAlignmentLeft;
        _textField.backgroundColor = [UIColor clearColor];
       
       
        _textField.font = kDetailContentFont;

        [self.contentView addSubview:_textField];
        
    }
    
    return self;
}

@end
