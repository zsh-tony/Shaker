//
//  MyIconCell.m
//  SchoolExpress
//
//  Created by zsh tony on 15-5-8.
//  Copyright (c) 2015年 zsh-tony. All rights reserved.
//

#import "MyIconCell.h"
#define kIconLength 80
#define kTitleHeight 20
#define kTitileWidth 40
@implementation MyIconCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _iconTitle = [[UILabel alloc]initWithFrame:CGRectMake(k10WidthMargin, (kIconLength+2*k20HeightMargin-kTitleHeight)/2, kTitileWidth, kTitleHeight)];
        _iconTitle.font = k13Font;
        _iconTitle.backgroundColor = [UIColor clearColor];
        _iconTitle.text = @"头像 :";
        _iconTitle.textColor = kTitleColor;
        [self.contentView addSubview:_iconTitle];
        
        _iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width - k50WidthMargin-kIconLength, k20HeightMargin, kIconLength, kIconLength)];
        [_iconImage.layer setCornerRadius:40];
        [_iconImage.layer setMasksToBounds:YES];
        _iconImage.image = [UIImage imageNamed:@"avatar_default_big.png"];
        [self.contentView addSubview:_iconImage];
        
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
