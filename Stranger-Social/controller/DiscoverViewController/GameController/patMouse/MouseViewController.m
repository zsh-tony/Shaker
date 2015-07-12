//
//  MouseViewController.m
//  Stranger-Social
//
//  Created by lerrruby on 15/5/25.
//  Copyright (c) 2015年 lerruby.com. All rights reserved.
//

#import "MouseViewController.h"
#import "MouseView.h"

#import "AAAAchievementDataSource.h"
#import "AAAAchievementManager.h"
#import "AAAGamificationManager.h"
@import AVFoundation;
@interface MouseViewController ()
{
    UIButton *backBtn;
    UIButton *reTryBtn;
    UIImageView *gameoverView;
    UIImageView *failView;
    UIImageView *completeView;
    UIView *maskView;
    UIButton *nextBtn;
    NSUserDefaults * _settings;
    UIButton *musicBtn;
    
}
@property (nonatomic) AVAudioPlayer * backgroundMusicPlayer;
@end



@implementation MouseViewController
{
    NSTimer *_timer;//计时器
    NSMutableArray *mouseArr;
    UIView *_timeBar;//时间轴
    NSTimer *timeTimmer;
    
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self uiConfig];
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    if (![self isSound]) {
        [self turnOnSound];
    }
    self.scoreView.scoreLabel.text = @"0";
    [[AAAGamificationManager sharedManager] resetScoreView];
}
- (void)addSubviews {
  
    musicBtn = [[UIButton alloc]initWithFrame:CGRectMake(118, 130, 84, 36)];
    [musicBtn addTarget:self action:@selector(switchSound) forControlEvents:UIControlEventTouchUpInside];
    [musicBtn setBackgroundImage:[UIImage imageNamed:@"button-music-off.png"] forState:UIControlStateNormal];
    [musicBtn setBackgroundImage:[UIImage imageNamed:@"button-music-on.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:musicBtn];
    
    gameoverView = [[UIImageView alloc]initWithFrame:CGRectMake(35, 100, 250, 60)];
    gameoverView.layer.cornerRadius = 8;
    [gameoverView.layer setMasksToBounds:YES];
    gameoverView.image = [UIImage imageNamed:@"gameover.jpg"];
    [self.view addSubview:gameoverView];
    
    
    
    
    failView = [[UIImageView alloc]initWithFrame:CGRectMake(0, gameoverView.frame.origin.y + gameoverView.frame.size.height +20, 320, 130)];
    failView.image = [UIImage imageNamed:@"failed.png"];
    [self.view addSubview:failView];
    
    completeView = [[UIImageView alloc]initWithFrame:CGRectMake(0, gameoverView.frame.origin.y + gameoverView.frame.size.height +20, 320, 130)];
    completeView.image = [UIImage imageNamed:@"complete.png"];
    [self.view addSubview:completeView];
    
    backBtn = [[UIButton alloc]initWithFrame:CGRectMake(25, failView.frame.size.height + failView.frame.origin.y + 50, 102, 50)];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"quit_normal.png"] forState:UIControlStateNormal];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"quit_highlighted.png"] forState:UIControlStateHighlighted];
    [backBtn addTarget:self action:@selector(backVC) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    reTryBtn = [[UIButton alloc]initWithFrame:CGRectMake(backBtn.frame.origin.x + backBtn.frame.size.width + 66, backBtn.frame.origin.y, 102, 50)];
    [reTryBtn setBackgroundImage:[UIImage imageNamed:@"retry_normal.png"] forState:UIControlStateNormal];
    [reTryBtn setBackgroundImage:[UIImage imageNamed:@"retry_highlighted.png"] forState:UIControlStateHighlighted];
    [reTryBtn addTarget:self action:@selector(reTry) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:reTryBtn];
    
    
    nextBtn = [[UIButton alloc]initWithFrame:CGRectMake(110, reTryBtn.frame.origin.y, 102, 50)];
    nextBtn.layer.cornerRadius = 8;
    [nextBtn.layer setMasksToBounds:YES];
    [nextBtn setBackgroundImage:[UIImage imageNamed:@"下一步.jpg"] forState:UIControlStateHighlighted];
    [nextBtn setBackgroundImage:[UIImage imageNamed:@"下一步.jpg"] forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBtn];
    
    gameoverView.frame =CGRectMake(35, -468, 250, 60);
    completeView.frame = CGRectMake(0, gameoverView.frame.origin.y + gameoverView.frame.size.height +20 - 568, 320, 130);
    failView.frame =CGRectMake(0, gameoverView.frame.origin.y + gameoverView.frame.size.height +20-568, 320, 130);
    backBtn.frame = CGRectMake(25, failView.frame.size.height + failView.frame.origin.y + 50-568, 102, 50);
    nextBtn.frame = CGRectMake(110, reTryBtn.frame.origin.y-568, 102, 50);
    reTryBtn.frame = CGRectMake(backBtn.frame.origin.x + backBtn.frame.size.width + 66, backBtn.frame.origin.y-568, 102, 50);
    
    

}
-(void)failAnimation
{
    [LZAudioTool playMusic:@"失败音效.wav"];
    maskView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 800)];
    maskView.alpha = 0.3;
    maskView.backgroundColor = [UIColor blackColor];
    [self.view insertSubview:maskView belowSubview:gameoverView];
    [UIView animateWithDuration:1.5 animations:^{
        gameoverView.frame =CGRectMake(35, 100, 250, 60);
        
        failView.frame =CGRectMake(0, gameoverView.frame.origin.y + gameoverView.frame.size.height +20, 320, 130);
        backBtn.frame = CGRectMake(25, failView.frame.size.height + failView.frame.origin.y + 50, 102, 50);
        reTryBtn.frame = CGRectMake(backBtn.frame.origin.x + backBtn.frame.size.width + 66, backBtn.frame.origin.y, 102, 50);
    }];
}

-(void)completeAnimation
{
    [LZAudioTool playMusic:@"complete音效.mp3"];
    maskView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 800)];
    maskView.alpha = 0.3;
    maskView.backgroundColor = [UIColor blackColor];
    [self.view insertSubview:maskView belowSubview:gameoverView];
    
    [UIView animateWithDuration:1.5 animations:^{
        gameoverView.frame =CGRectMake(35, 100, 250, 60);
        
        completeView.frame =CGRectMake(0, gameoverView.frame.origin.y + gameoverView.frame.size.height +20, 320, 130);
       nextBtn.frame = CGRectMake(110, 360, 102, 50);
    }];
    
}
-(void)backVC
{
    [self turnOffSound];
    [self dismissViewControllerAnimated:NO completion:nil];
}
-(void)next
{
    [self turnOffSound];
    [self dismissViewControllerAnimated:NO completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"pushLookUpVC" object:nil];
    }];
    
}
-(void)stopTimer
{
    
    if ([self.scoreView.scoreLabel.text intValue]>= 15) {
        [self completeAnimation ];
    }else{
        [self failAnimation];
    }
    
    [_timer invalidate];
    for (MouseView *mouse in mouseArr){
        [mouse reset];
    }
    [timeTimmer invalidate];
    NSLog(@"%@",self.scoreView.scoreLabel);
    
    
    
}

-(void)reTry
{
    if ([self isSound]) {
        [self turnOffSound];
        [self turnOnSound];
    }
   
    [maskView removeFromSuperview];
    gameoverView.frame =CGRectMake(35, -468, 250, 60);
    
    failView.frame =CGRectMake(0, gameoverView.frame.origin.y + gameoverView.frame.size.height +20-568, 320, 130);
    backBtn.frame = CGRectMake(25, failView.frame.size.height + failView.frame.origin.y + 50-568, 102, 50);
    reTryBtn.frame = CGRectMake(backBtn.frame.origin.x + backBtn.frame.size.width + 66, backBtn.frame.origin.y-568, 102, 50);
    
    
    _timeBar.frame = CGRectMake(95, 509, 200, 20);
    self.scoreView.scoreLabel.text = @"0";
    [[AAAGamificationManager sharedManager] resetScoreView];
    //    if (![_timer isValid]) {
    //        [_timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:0]];
    //        [_timer setFireDate:[NSDate date]];
    //    }
    //
    //
    //    [timeTimmer setFireDate:[NSDate dateWithTimeIntervalSinceNow:0]];
    //    [timeTimmer setFireDate:[NSDate date]];
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0/180.0 target:self selector:@selector(refreshView) userInfo:nil repeats:YES];
    timeTimmer = [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(stopTimer) userInfo:nil repeats:NO];
}

- (void)uiConfig{
    
     self.view.backgroundColor = kGlobalBg;
    [self.navigationController setNavigationBarHidden:YES];
    int heights[4] = {315,124,123,116};
    int coodY[4] = {0,278,364,452};
    NSMutableArray *backgroundArr = [[NSMutableArray alloc] init];
    mouseArr = [[NSMutableArray alloc] init];
    for (int i=0;i<4;i++)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, coodY[i], 320, heights[i])];
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"GameBG0%d",i+1]];
        [self.view addSubview:imageView];
        [backgroundArr addObject:imageView];
    }
    for (int i=0;i<9;i++){
        MouseView *mouse = [[MouseView alloc] initWithFrame:CGRectMake(30+102*(i%3), 298+87*(i/3), 56, 79)];
        [mouseArr addObject:mouse];
        [self.view insertSubview:mouse aboveSubview:backgroundArr[i/3]];
        //给每只老鼠添加手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickMouse:)];
        [mouse addGestureRecognizer:tap];
    }
    
    
    
    //给时间进度条添加背景
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(90, 508, 203, 22)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [self.view insertSubview:whiteView belowSubview:backgroundArr[3]];
    //时间进度条
    _timeBar = [[UIView alloc] initWithFrame:CGRectMake(95, 509, 200, 20)];
    _timeBar.backgroundColor = [UIColor blueColor];
    [self.view insertSubview:_timeBar aboveSubview:whiteView];
    
    
    
    
    UILabel *scoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 38, 100, 50)];
    scoreLabel.text = @"scores:";
    scoreLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:25];
    scoreLabel.backgroundColor = [UIColor clearColor];
    scoreLabel.textColor = kGetColor(240, 241, 112);
    [self.view addSubview:scoreLabel];
    self.scoreView = [[AAAScoreView alloc]initWithFrame:CGRectMake(95, 200, 50, 50)];
    
    
    [self.view addSubview:self.scoreView];
    
    
    NSLayoutConstraint *width=[NSLayoutConstraint constraintWithItem:self.scoreView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:50];
    
    [self.scoreView addConstraint:width];
    
    
    
    NSLayoutConstraint *height=[NSLayoutConstraint constraintWithItem:self.scoreView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:50];
    
    [self.scoreView addConstraint:height];
    
    
    
    NSLayoutConstraint *centerX=[NSLayoutConstraint constraintWithItem:self.scoreView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:35];
    
    [self.view addConstraint:centerX];
    
    
    
    NSLayoutConstraint *centerY=[NSLayoutConstraint constraintWithItem:self.scoreView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:-223];
    
    [self.view addConstraint:centerY];
    
//    UIButton *reTryBtn = [[UIButton alloc]initWithFrame:CGRectMake(100, 520, 60, 30)];
//    [reTryBtn setBackgroundImage:[UIImage imageNamed:@"button-retry-on.png"] forState:UIControlStateHighlighted];
//    [reTryBtn setBackgroundImage:[UIImage imageNamed:@"button-retry-off.png"]  forState:UIControlStateNormal];
//    [reTryBtn addTarget:self action:@selector(reTry) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:reTryBtn];
    
    [AAAAchievementManager sharedManager].dataSource = [[AAAAchievementDataSource alloc] init];
    [[AAAGamificationManager sharedManager] setScoreView:self.scoreView];
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0/180.0 target:self selector:@selector(refreshView) userInfo:nil repeats:YES];
    timeTimmer = [NSTimer scheduledTimerWithTimeInterval:13 target:self selector:@selector(stopTimer) userInfo:nil repeats:NO];
    
    [self addSubviews];
    
    
}

//实现手势
- (void)clickMouse:(UITapGestureRecognizer *)tap
{
    //面向对象
    [[AAAGamificationManager sharedManager] addToMainPlayerScore:1];
    MouseView *mouse = (MouseView*)tap.view;
    
    [mouse beAttack];
}
static int count = 0;
- (void)refreshView
{
    count++;
    _timeBar.frame = CGRectMake(_timeBar.frame.origin.x, _timeBar.frame.origin.y,_timeBar.frame.size.width - 200.0/2400.0, _timeBar.frame.size.height);
    
    
    //老鼠运动
    for (MouseView *mouse in mouseArr){
        [mouse move];
    }
    if (count%120 == 0){
        [self mouseComeOut];
    }
}

//设置随机数,让老鼠无规律出现
- (void)mouseComeOut{
    int index = arc4random()%9;
    MouseView *mouse =mouseArr[index];
    //如果没有出现,则出现
    if (![mouse comeOut]){
        [self mouseComeOut];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.scoreView.scoreLabel.text = @"0";
    _settings = [NSUserDefaults standardUserDefaults];
    
    if([_settings objectForKey:@"sound"] == nil){
        [_settings setObject:@"YES" forKey:@"sound"];
    }
    
    NSString * musicPlaySetting = [_settings objectForKey:@"sound"];
    
    NSError *error;
    NSURL * backgroundMusicURL = [[NSBundle mainBundle] URLForResource:@"patmouseBgm" withExtension:@"mp3"];
    self.backgroundMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:backgroundMusicURL error:&error];
    
    self.backgroundMusicPlayer.numberOfLoops = -1;
    [self.backgroundMusicPlayer prepareToPlay];
    
    if ([musicPlaySetting isEqualToString:@"YES"]) {
        // Add Background Music
        [self.backgroundMusicPlayer play];
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
