//
//  GameViewController.m
//  Stranger-Social
//
//  Created by lerrruby on 15/5/23.
//  Copyright (c) 2015年 lerruby.com. All rights reserved.


#import "GameViewController.h"
#import "PuzzleViewController.h"
#import "MouseViewController.h"
#import "WetKoalaViewController.h"
#import "LookUpViewController.h"
@interface GameViewController ()
{
    
    NSMutableArray *imageArray;
    UIImageView *displayImage;
    int category;
    int puzzleClass;
    
}
@end

@implementation GameViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        // 初始化
        {
            _getUser = ^(User *user){
                _myUser = user;
            };
        }
    }
    
    return self;
}
-(void)pushLookUpVC:(NSNotification *)notification
{
    LookUpViewController *lookUp=[[LookUpViewController alloc]init];
    if (lookUp.getUser) {
        lookUp.getUser(_myUser);
    }
    [self.navigationController pushViewController:lookUp animated:NO];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushLookUpVC:) name:@"pushLookUpVC" object:nil];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kGlobalBg;
     category = (arc4random() % 40) + 1;
    // category = 2;
    puzzleClass = (arc4random() % 2) + 3;
    //puzzleClass=5;
    [self.navigationController setNavigationBarHidden:YES];
    self.title = _myUser.nickName;
    //[[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
    
    displayImage = [[UIImageView alloc]initWithFrame:CGRectMake(35, 140, 250, 250)];
    [self.view addSubview:displayImage];
    
    imageArray  = [NSMutableArray array];
    [self initImageArray];
    
    
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(50, 440, 77, 35)];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"返回_normal.png"] forState:UIControlStateNormal];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"返回_highlighted.png"] forState:UIControlStateHighlighted];
    [backBtn addTarget:self action:@selector(backVC) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    UIButton *nextBtn = [[UIButton alloc]initWithFrame:CGRectMake(backBtn.frame.origin.x + backBtn.frame.size.width + 66, 440, 77, 35)];
    [nextBtn setBackgroundImage:[UIImage imageNamed:@"挑战_normal.png"] forState:UIControlStateNormal];
    [nextBtn setBackgroundImage:[UIImage imageNamed:@"挑战_highlighted.png"] forState:UIControlStateHighlighted];
    [nextBtn addTarget:self action:@selector(pushVC) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBtn];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 30, 260, 80)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.numberOfLines = 0;
    
    
    if (category <= 20) {
        
       displayImage.image = imageArray[category -1];
        titleLabel.text = [NSString stringWithFormat:@"要看到TA，需完成以下图片的%d阶拼图挑战噢!",puzzleClass];
      
    }else if(category <= 30){
      
        displayImage.image = [UIImage imageNamed:@"patMouse.png"];
         titleLabel.text = @"要看到TA，需在以下游戏中得到15分噢!";
        
    }else{
        
        displayImage.image = [UIImage imageNamed:@"wetKoala.png"];
         titleLabel.text = @"要看到TA，需在以下游戏中得到50分噢!";
    }

    [self.view addSubview:titleLabel];
   
}

-(void)pushVC
{
    
    [self presentViewController:[self selectGame] animated:YES completion:nil];
    
}
-(void)backVC
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)initImageArray
{
    
    for (int i = 0; i<20; i++) {
        
        UIImage *image = [UIImage imageNamed:[NSString     stringWithFormat:@"image-%d.jpg",i+1]];
        if(image != nil){
        [imageArray addObject:image];
        }else{
            NSLog(@"image-%d为空");
        }
    }
    
}

-(UIViewController *)selectGame
{
    if (category <= 20) {
        PuzzleViewController *puzzle = [[PuzzleViewController alloc]init];
        if (puzzle.passImageIndex) {
            
            puzzle.passImageIndex(imageArray[category -1],puzzleClass);
        }
        
           // [self.navigationController pushViewController:puzzle animated:YES];
        return puzzle;
        
    }else if(category <= 30){
        
        MouseViewController *mouse  = [[MouseViewController alloc]init];
        
        //[self.navigationController pushViewController:mouse animated:YES];
        
        return mouse;
        
    }else{
        WetKoalaViewController *wetKoala = [[WetKoalaViewController alloc]init];
        
        // [self.navigationController pushViewController:wetKoala animated:YES];

        return wetKoala;
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
