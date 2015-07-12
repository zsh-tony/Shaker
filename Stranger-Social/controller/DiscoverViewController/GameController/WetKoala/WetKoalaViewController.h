//
//  WetKoalaViewController.h
//  Stranger-Social
//
//  Created by lerrruby on 15/5/25.
//  Copyright (c) 2015年 lerruby.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
@interface WetKoalaViewController : UIViewController
-(void) turnOffSound;
-(void) turnOnSound;
-(void) switchSound;
-(BOOL) isSound;

@property (strong, nonatomic) IBOutlet SKView *view;

@end
