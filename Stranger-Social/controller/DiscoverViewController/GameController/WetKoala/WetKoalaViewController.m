//
//  WetKoalaViewController.m
//  Stranger-Social
//
//  Created by lerrruby on 15/5/25.
//  Copyright (c) 2015年 lerruby.com. All rights reserved.
//

#import "WetKoalaViewController.h"
//#import "HomeScene.h"
#import "GameScene.h"

@import AVFoundation;
@interface WetKoalaViewController ()
@property (nonatomic) AVAudioPlayer * backgroundMusicPlayer;
@end

@implementation WetKoalaViewController
{
     NSUserDefaults * _settings;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidAppear:(BOOL)animated
{
    if (![self isSound]) {
        [self turnOnSound];
    }
}
- (void)viewDidLoad
{
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        // iOS 7
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    } else {
        // iOS 6
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    }
    
    [super viewDidLoad];
    
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    if (!skView.scene) {
        
        
        _settings = [NSUserDefaults standardUserDefaults];
        
        if([_settings objectForKey:@"sound"] == nil){
            [_settings setObject:@"YES" forKey:@"sound"];
        }
        
        NSString * musicPlaySetting = [_settings objectForKey:@"sound"];
        
        NSError *error;
        NSURL * backgroundMusicURL = [[NSBundle mainBundle] URLForResource:@"bgm" withExtension:@"m4a"];
        self.backgroundMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:backgroundMusicURL error:&error];
        
        self.backgroundMusicPlayer.numberOfLoops = -1;
        [self.backgroundMusicPlayer prepareToPlay];
        
        if ([musicPlaySetting isEqualToString:@"YES"]) {
            // Add Background Music
            [self.backgroundMusicPlayer play];
        }
        
        skView.showsFPS = NO;
        skView.showsNodeCount = NO;
        
        
        // Create and configure the scene.
        
        GameScene * scene = [GameScene sceneWithSize:skView.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        scene.quit = ^(){
            [self turnOffSound];
            [self dismissViewControllerAnimated:YES completion:nil];
            

        };
        scene.next = ^(){
            [self turnOffSound];
            [self dismissViewControllerAnimated:NO completion:^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"pushLookUpVC" object:nil];
            }];
        };
        
        scene.swtchSound =^(){
            [self switchSound];
        };
        // Present the scene.
        [skView presentScene:scene];
    }
    
//    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(230, 500, 80, 50)];
//    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
//    backBtn.backgroundColor = [UIColor blueColor];
//    [self.view addSubview:backBtn];
    
}



-(void) turnOffSound
{
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:nil];
    [self.backgroundMusicPlayer stop];
    [_settings setObject:@"NO" forKey:@"sound"];
}

-(void) turnOnSound
{
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategorySoloAmbient error:nil];
    [self.backgroundMusicPlayer play];
    [_settings setObject:@"YES" forKey:@"sound"];
}

-(void) switchSound
{
    if ([self isSound]) {
        [self turnOffSound];
    }else{
        [self turnOnSound];
    }
}

-(BOOL) isSound {
    NSString * musicPlaySetting = [_settings objectForKey:@"sound"];
    if ([musicPlaySetting isEqualToString:@"YES"]){
        return YES;
    }else{
        return NO;
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
