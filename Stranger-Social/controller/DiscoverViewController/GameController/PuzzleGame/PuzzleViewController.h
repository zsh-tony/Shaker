//
//  PuzzleViewController.h
//  Stranger-Social
//
//  Created by lerrruby on 15/5/25.
//  Copyright (c) 2015年 lerruby.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "IAPuzzleBoardView.h"
@interface PuzzleViewController : UIViewController<IAPuzzleBoardDelegate> {
    UIImage *gambar;

    UISegmentedControl *boardSize;
    
    NSInteger step;
}

@property (nonatomic, retain) IAPuzzleBoardView *board;
@property (nonatomic, retain) UIButton *startButton;
@property (nonatomic,copy)void (^passImageIndex)(UIImage *image,int index);
@property (nonatomic,assign)int puzzleClass;
/*
 Well, it's for... starting this puzzle game. What else?
 Untuk... memulai bermain puzzle lah.
 */
- (IBAction)start:(id)sender;

@end
