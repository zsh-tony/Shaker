//
//  PuzzleViewController.m
//  Stranger-Social
//
//  Created by lerrruby on 15/5/25.
//  Copyright (c) 2015年 lerruby.com. All rights reserved.
//

#import "PuzzleViewController.h"
@import AVFoundation;
@interface PuzzleViewController ()
{
    UIButton *backBtn;
    UIButton *reTryBtn;
    UIImageView *gameoverView;
    UIImageView *failView;
    UIImageView *completeView;
    UIView *maskView;
    UIButton *nextBtn;
    UIButton *showBtn;
    UIImageView *fullImage1;
    NSUserDefaults * _settings;
    UIButton *musicBtn;
}
@property (nonatomic) AVAudioPlayer * backgroundMusicPlayer;
@end

@implementation PuzzleViewController

#pragma mark - View lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _passImageIndex = ^(UIImage *image,int index){
            gambar = image;
            _puzzleClass = index;
        };
    }
    return self;
}

- (void)addSubviews {
    
    musicBtn = [[UIButton alloc]initWithFrame:CGRectMake(118, 40, 84, 36)];
    [musicBtn addTarget:self action:@selector(switchSound) forControlEvents:UIControlEventTouchUpInside];
    [musicBtn setBackgroundImage:[UIImage imageNamed:@"button-music-off.png"] forState:UIControlStateNormal];
    [musicBtn setBackgroundImage:[UIImage imageNamed:@"button-music-on.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:musicBtn];
    
    gameoverView = [[UIImageView alloc]initWithFrame:CGRectMake(35, 100, 250, 60)];
    gameoverView.layer.cornerRadius = 8;
    [gameoverView.layer setMasksToBounds:YES];
    gameoverView.image = [UIImage imageNamed:@"gameover.jpg"];
    [self.view addSubview:gameoverView];
    
    
    completeView = [[UIImageView alloc]initWithFrame:CGRectMake(0, gameoverView.frame.origin.y + gameoverView.frame.size.height +20, 320, 130)];
    completeView.image = [UIImage imageNamed:@"complete.png"];
    [self.view addSubview:completeView];
    
    backBtn = [[UIButton alloc]initWithFrame:CGRectMake(25, 410 + 50, 102, 50)];
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
    [nextBtn setBackgroundImage:[UIImage imageNamed:@"下一步_highlighted.jpg"] forState:UIControlStateHighlighted];
    [nextBtn setBackgroundImage:[UIImage imageNamed:@"下一步.jpg"] forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBtn];
    
    showBtn = [[UIButton alloc]initWithFrame:CGRectMake(110, reTryBtn.frame.origin.y-70, 102, 50)];
    showBtn.layer.cornerRadius = 8;
    [showBtn.layer setMasksToBounds:YES];
    [showBtn setBackgroundImage:[UIImage imageNamed:@"show_highlighted.png"] forState:UIControlStateHighlighted];
    [showBtn setBackgroundImage:[UIImage imageNamed:@"show_normal.png"] forState:UIControlStateNormal];
    [showBtn addTarget:self action:@selector(show) forControlEvents:UIControlEventTouchDown];

     [showBtn addTarget:self action:@selector(hidden) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:showBtn];
    
    gameoverView.frame =CGRectMake(35, -468, 250, 60);
    completeView.frame = CGRectMake(0, gameoverView.frame.origin.y + gameoverView.frame.size.height +20 - 568, 320, 130);
  
    
    nextBtn.frame = CGRectMake(110, reTryBtn.frame.origin.y-568, 102, 50);
    
    
    
}


-(void)completeAnimation
{
    maskView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 800)];
    maskView.alpha = 0.3;
    maskView.backgroundColor = [UIColor blackColor];
    [self.view insertSubview:maskView belowSubview:musicBtn];
    
    reTryBtn.frame = CGRectMake(backBtn.frame.origin.x + backBtn.frame.size.width + 66, backBtn.frame.origin.y-568, 102, 50);
    backBtn.frame = CGRectMake(25, failView.frame.size.height + failView.frame.origin.y + 50-568, 102, 50);
    showBtn.frame = CGRectMake(110, reTryBtn.frame.origin.y-70-568, 102, 50);
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
-(void)show
{
    fullImage1 = [[UIImageView alloc] initWithImage:gambar];
    fullImage1.frame = _board.bounds;
    [_board addSubview:fullImage1];
//    NSLog(@"%u-%u",showBtn.highlighted,showBtn.selected);
//    if(showBtn.highlighted == NO||showBtn.selected == NO){
//        [fullImage1 removeFromSuperview];
//    }
    
}

-(void)hidden
{
    [fullImage1 removeFromSuperview];
}

-(void)viewDidAppear:(BOOL)animated
{
    if (![self isSound]) {
        [self turnOnSound];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    CGRect frame = [[UIScreen mainScreen] applicationFrame];
    self.view.frame = frame;
    self.view.backgroundColor = kGlobalBg;
    UIImageView *bgView= [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 568)];
    bgView.image = [UIImage imageNamed:@"puzzleBg.jpg"];
    [self.view addSubview:bgView];
    // set the image
    // tentukan gambar
   // gambar = [UIImage imageNamed:@"ff.png"];
    UIImageView *bgBoard = [[UIImageView alloc]initWithFrame:CGRectMake(35, 100, 250, 250)];
    bgBoard.image = [UIImage imageNamed:@"board.png"];
    [self.view addSubview:bgBoard];
    
    _board = [[IAPuzzleBoardView alloc]initWithFrame:CGRectMake(60, 125, 200, 200)];
    [self.view addSubview:_board];
    // show the full image first in the view
    // tunjukkan dulu gambar penuh di view
    UIImageView *fullImage = [[UIImageView alloc] initWithImage:gambar];
    fullImage.frame = _board.bounds;
    [_board addSubview:fullImage];
    _board.delegate = self;
    step = 0;
    
    // set the view so that it can interact with touches
    // atur view agar bisa interaksi dengan sentuhan
    [_board setUserInteractionEnabled:YES];
    
    // set the label text to 'reset'
    // ubah teks label menjadi 'reset'
    // [startButton setTitle:@"Reset" forState:UIControlStateNormal];
    
    // initialize the board, lets play!
    // atur papan, mari bermain!
    [_board playWithImage:gambar andSize:_puzzleClass];

    [self addSubviews];
    
    _settings = [NSUserDefaults standardUserDefaults];
    
    if([_settings objectForKey:@"sound"] == nil){
        [_settings setObject:@"YES" forKey:@"sound"];
    }
    
    NSString * musicPlaySetting = [_settings objectForKey:@"sound"];
    
    NSError *error;
    NSURL * backgroundMusicURL = [[NSBundle mainBundle] URLForResource:@"puzzleBgm" withExtension:@"mp3"];
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

- (void)viewDidUnload {
    [self setBoard:nil];
    [self setStartButton:nil];
    
    boardSize = nil;
    [super viewDidUnload];
}
-(void)reTry
{
     [_board playWithImage:gambar andSize:_puzzleClass];
}
#pragma mark - puzzle board view delegate method
/*
 This delegate method is fired when the puzzle board is finished
 Prosedur delegasi ini dipanggil bila papan tersebut telah selesai dimainkan
 */
- (void)puzzleBoardDidFinished:(IAPuzzleBoardView *)puzzleBoard {
    // This method is fired every time the board is finished, you can make this method doing whatever you want. Mine, it does a simple animation :
    // 1. Add the full image, set it's alpha with 0.0. Animate it to 1.0.
    // 2. Upon completion set the view so that it can't interact, and set the label to 'start'
    //
    // Prosedur ini akan terpanggil ketika papan sudah selesai dimainkan. Anda bisa membuat prosedur ini melakukan apa saja. Punya saya, hanya melakukan dua animasi sederhana :
    // 1. Tambahkan gambar asli, atur alphanya 0.0. Animasikan menjadi 1.0.
    // 2. Setelah animasi selesai atur view agar tidak bisa berinteraksi dan ubah label teks menjadi 'start'
    
    // add the full image with 0.0 alpha in view
    // tambahkan gambar penuh dengan alpha 0.0 ke dalam view
    UIImageView *fullImage = [[UIImageView alloc]initWithImage:gambar];
    fullImage.frame = _board.bounds;
    fullImage.alpha = 0.0;
    [_board addSubview:fullImage];
    
    [UIView animateWithDuration:.4
                     animations:^{
                         // set the alpha of full image to 1.0
                         // atur alpha gambar penuh tersebut menjadi 1.0
                         fullImage.alpha = 1.0;
                     }
                     completion:^(BOOL finished){
                    
                      
                         
                         
                         
                             [self completeAnimation ];
                         

                         [_board setUserInteractionEnabled:NO];
                         //[startButton setTitle:@"Start" forState:UIControlStateNormal];
                     }];
}

- (void)puzzleBoard:(IAPuzzleBoardView *)board emptyTileDidMovedTo:(CGPoint)tilePoint {
    // You can add some cool sound effects here
    // Anda bisa tambahkan efek suara yang keren di sini
    step += 1;
}

#pragma mark - IB Actions
/*
 Well, it's for... starting this puzzle game. What else?
 Untuk... memulai bermain puzzle lah.
 */
- (IBAction)start:(id)sender {
    // reset steps
    // ulang jumlah langkah
    step = 0;
    
    // set the view so that it can interact with touches
    // atur view agar bisa interaksi dengan sentuhan
    [_board setUserInteractionEnabled:YES];
    
    // set the label text to 'reset'
    // ubah teks label menjadi 'reset'
   // [startButton setTitle:@"Reset" forState:UIControlStateNormal];
    
    // initialize the board, lets play!
    // atur papan, mari bermain!
    [_board playWithImage:gambar andSize:(boardSize.selectedSegmentIndex+3)];
}

@end
