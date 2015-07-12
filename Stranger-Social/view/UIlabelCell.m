//
//  UIlabelCell.m
//  SchoolExpress
//
//  Created by zsh tony on 15-5-8.
//  Copyright (c) 2015年 zsh-tony. All rights reserved.
//

#import "UIlabelCell.h"
#define kTitleHeight 20
#define kTitileWidth 60
#define kContentWidth 200
@implementation UIlabelCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(k10WidthMargin, k10HeightMargin, kTitileWidth, kTitleHeight)];
        _titleLabel.font = k13Font;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = kTitleColor;
        [self.contentView addSubview:_titleLabel];

        _contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(_titleLabel.frame.origin.x+_titleLabel.frame.size.width +k10WidthMargin, k10HeightMargin, kContentWidth, kTitleHeight)];
        _contentLabel.backgroundColor = [UIColor clearColor];
        _contentLabel.font = k13Font;
        [self.contentView addSubview:_contentLabel];
        
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
