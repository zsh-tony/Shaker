//
//  Dock.m
//  weibo
//
//  Created by zsh tony on 14-7-25.
//  Copyright (c) 2014年 zsh-tony. All rights reserved.
//

#import "Dock.h"
#import "NSString+file.h"
#import "DockItem.h"

@interface Dock()
{
    DockItem *currentItem;
}

@end

@implementation Dock

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //不管用！！！！
        //[UIApplication sharedApplication].statusBarHidden = NO;
        
        // Initialization codePattern平铺
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"navigationbar_background.png"]];
        
    }
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(DockItem *)addItemWithIcon:(NSString *)icon title:(NSString *)title
{
    DockItem *item = [DockItem buttonWithType:UIButtonTypeCustom];
    
    [self addSubview:item];
    //NSLog(@"%lu",(unsigned long)self.subviews.count);
    [item setTitle:title forState:UIControlStateNormal];
    //NSLog(@"%@",title);
    //NSLog(@"%@",item.currentImage);
    [item setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    [item setImage:[UIImage imageNamed:[icon filenameAppend:@"_selected"]] forState:UIControlStateSelected];
    
    [item addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchDown];
    
    
     //NSLog(@"%@",item.currentImage.);
    [self adjustDockItemsFrame];
    
    
    
    return item;
}

-(void)itemClick:(DockItem *)item
{
//    //实现此方法的思想
//    if ([AccountTool sharedAccountTool].currentAccount.userId == nil&&(item.tag == 1||item.tag== 3||item.tag == 4)) {
//        
//    }else{
    currentItem.selected = NO;
    
    
    item.selected = YES;
    
    currentItem = item;
    //}
    if (_itemClickBlock) {
        _itemClickBlock(item.tag);
    }
}

//根据添加的item的个数调整item的边框，这个处理可以在这里处理
-(void)adjustDockItemsFrame
{
    int count = self.subviews.count;
    
    CGFloat itemWidth = self.frame.size.width/count;
    CGFloat itemHeight = self.frame.size.height;
    
    for (int i=0; i<count; i++) {
        DockItem *item = self.subviews[i];
        
        item.frame = CGRectMake(i*itemWidth, 0, itemWidth, itemHeight);
        
        if (i==0) {
            item.selected = YES;
            currentItem = item;
        }
        item.tag=i;
    }
    
    
}

//框架编写
-(void)setSelectedIndex:(int)selectedIndex
{
    if (selectedIndex<0||selectedIndex>=self.subviews.count) return;
    _selectedIndex = selectedIndex;
    
    DockItem *item = self.subviews[selectedIndex];
    
    currentItem.selected = NO;
    item.selected = YES;
    currentItem = item;
    
    //相当于点击了item
    [self itemClick:item];
}

@end
