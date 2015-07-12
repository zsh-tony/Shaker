//
//  LookUpViewController.m
//  Stranger-Social
//
//  Created by lerrruby on 15/5/26.
//  Copyright (c) 2015年 lerruby.com. All rights reserved.
//

#import "LookUpViewController.h"
#import "MapViewController.h"
#import "User.h"
#import "SPKitExample.h"
@interface LookUpViewController ()<UIAlertViewDelegate>
{
    LPPopup *popup;
    UIActivityIndicatorView *_indictor;
}
@end

@implementation LookUpViewController
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
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIImageView *bgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 568)];
    
    bgView.image = [UIImage imageNamed:@"加好友背景.png"];
    [self.view addSubview:bgView];
    
    
    _iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(60, 100, 200, 200)];
    _iconImage.layer.cornerRadius= 100;
    [_iconImage.layer setMasksToBounds:YES];
    _iconImage.image =[UIImage imageNamed:@"puzzleBg.jpg"];
    
    [self.view addSubview:_iconImage];
    _nickNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, _iconImage.frame.size.height + _iconImage.frame.origin.y +20, 220, 25)];
    _nickNameLabel.textAlignment = NSTextAlignmentCenter;
    if ([_myUser.sex isEqualToString:@"男"]) {
        _nickNameLabel.text = [NSString stringWithFormat:@"%@  ♂",_myUser.nickName];
        _nickNameLabel.textColor = [UIColor blueColor];
    }else{
        _nickNameLabel.textColor = [UIColor redColor];
        _nickNameLabel.text = [NSString stringWithFormat:@"%@  ♀",_myUser.nickName];
    }
    [self.view addSubview:_nickNameLabel];
    
    UIButton *addFriend = [[UIButton alloc]initWithFrame:CGRectMake(30, _nickNameLabel.frame.origin.y + _nickNameLabel.frame.size.height + 40, 260, 50)];
    [addFriend setTitle:@"加为好友" forState:UIControlStateNormal];
    addFriend.backgroundColor = kGetColor(0,165,224);
    addFriend.layer.cornerRadius = 5;
    [self.view addSubview:addFriend];
    [addFriend addTarget:self  action:@selector(addFriend) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *back = [[UIButton alloc]initWithFrame:CGRectMake(30, addFriend.frame.origin.y + addFriend.frame.size.height + 20, 260, 50)];
    [back setTitle:@"返回" forState:UIControlStateNormal];
    back.backgroundColor = kGetColor(0,165,224);
    back.layer.cornerRadius = 5;
    [self.view addSubview:back];
    [back addTarget:self  action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    
}


-(void)addFriend
{
    _indictor = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(140, 320, 40, 40 )];
    [self.view addSubview:_indictor];
    [_indictor startAnimating];
    
    
    NSURLRequest *request = [NSURLRequest requestWithPath:kAddFriendsPath params:@{@"userPhone":[[NSUserDefaults standardUserDefaults] objectForKey:kPhone],@"friendPhone":_myUser.phone                                                  }];
    //
    NSHTTPURLResponse *response = nil;
    NSError *error =nil;
    NSLog(@"%@",request);
    NSData *responeData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSString *responesStr = [[NSString alloc]initWithData:responeData encoding:NSUTF8StringEncoding];
    //NSLog(@"%@----%@",teststr1,teststr);
    NSLog(@"responeStr%@",responesStr);
    
    
    
    if ([responesStr isEqualToString:@"success"]){

        [_indictor stopAnimating];
        BOOL success;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError *error;
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *deviceFilePath = [documentsDirectory stringByAppendingPathComponent:@"deviceToken.txt"];
        NSLog(@"deviceFilePath->>%@",deviceFilePath);
        success = [fileManager fileExistsAtPath:deviceFilePath];
        NSString *deviceToken = [[NSString alloc]init];
        if(success) {
            deviceToken = [NSString stringWithContentsOfFile:deviceFilePath encoding:NSUTF8StringEncoding error:nil];
            NSLog(@"deviceToken%@",deviceToken);

        }
        NSURLRequest *request = [NSURLRequest requestWithPath:kRequestPush params:@{@"userPhone":[[NSUserDefaults standardUserDefaults] objectForKey:kPhone],@"friendPhone":_myUser.phone,@"deviceToken": deviceToken                                                 }];
        //
        NSHTTPURLResponse *response = nil;
        NSError *pusherror =nil;
        NSLog(@"pushreq%@",request);
        NSData *responeData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&pusherror];
        NSString *responesStr = [[NSString alloc]initWithData:responeData encoding:NSUTF8StringEncoding];
        //NSLog(@"%@----%@",teststr1,teststr);
        NSLog(@"responeStr%@",responesStr);
        if ([responesStr isEqualToString:@"success"]) {
            popup = [LPPopup popupWithText:@"已经通知TA你们已经成为好友!"];
            popup.popupColor = [UIColor blackColor];
            popup.alpha = 0.8;
            popup.textColor = [UIColor whiteColor];
            popup.font = kDetailContentFont;
            //popup.textInsets = UIEdgeInsetsMake(10, 0, 0, 0);
            [popup showInView:self.view
                centerAtPoint:self.view.center
                     duration:1
                   completion:nil];
        }
        UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"添加成功" message:nil delegate:self cancelButtonTitle:@"返回" otherButtonTitles:@"和TA打个招呼", nil];
        [alter show];
        
    }else{
        popup = [LPPopup popupWithText:@"添加失败，再试一次!"];
        popup.popupColor = [UIColor blackColor];
        popup.alpha = 0.8;
        popup.textColor = [UIColor whiteColor];
        popup.font = kDetailContentFont;
        //popup.textInsets = UIEdgeInsetsMake(10, 0, 0, 0);
        [popup showInView:self.view
            centerAtPoint:self.view.center
                 duration:1
               completion:nil];
    }

}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        YWPerson *person =[[YWPerson alloc]initWithPersonId: _myUser.phone];
        
        [[SPKitExample sharedInstance] exampleOpenConversationViewControllerWithPerson:person fromNavigationController:self.navigationController];
        
    }
}
-(void)back
{
    [self.navigationController popToRootViewControllerAnimated:YES];
//    MapViewController *map = [[MapViewController alloc]init];
//    [self.navigationController popToViewController:map animated:YES];
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
