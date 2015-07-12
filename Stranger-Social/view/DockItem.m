//
//  DockItem.m
//  weibo
//
//  Created by zsh tony on 14-7-25.
//  Copyright (c) 2014年 zsh-tony. All rights reserved.
//

#define kImageRatio 0.7

#import "DockItem.h"

@implementation DockItem

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //1.设置文字属性
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:11];
        [self setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self setTitleColor:kGetColor(0,165,224) forState:UIControlStateSelected];
        //2.设置图片属性
        
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.adjustsImageWhenHighlighted = NO;
        //3.设置选中时的bgimage
       // [self setBackgroundImage:[UIImage imageNamed:@"navigationbar_background@2x.png"] forState:UIControlStateSelected];
        //highted会影响状态，每次 长按时会回到highlighted，为防止此影响，重写父类的高亮方法
  
        UIButton *seperator = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, [ UIScreen mainScreen ].applicationFrame.size.width/4, 1)];
        seperator.backgroundColor = kSeperatorColor;
        [self addSubview:seperator];
    }
    return self;
}
//重写父类的方法可以去掉某些从父类继承来的不想要的设置
-(void)setHighlighted:(BOOL)highlighted
{
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
//返回的是按钮内部UILabel的边框，这个UILabel是和button的title相关的
-(CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(0, contentRect.size.height * kImageRatio-2, contentRect.size.width,contentRect.size.height * (1-kImageRatio));
    
}

//返回的是按钮内部的UIImageview的边框，和按钮的image相关
-(CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return  CGRectMake(0, 0, contentRect.size.width, contentRect.size.height * 0.7);
}


@end
