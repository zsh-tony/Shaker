//
//  DiscoverViewController.m
//  Stranger-Social
//
//  Created by lerrruby on 15/5/21.
//  Copyright (c) 2015年 lerruby.com. All rights reserved.
//

#import "DiscoverViewController.h"
#import "LZAudioTool.h"
#import <MapKit/MapKit.h>
#import "MapViewController.h"
#import "LPPopup.h"
#import "User.h"
#import "SPKitExample.h"
@interface DiscoverViewController ()<MKMapViewDelegate,CLLocationManagerDelegate>
{
     SystemSoundID  soundID;
    NSString *latituduText;
    NSString *longitudeText;
    LPPopup *popup;
    
}
@end

@implementation DiscoverViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"摇一摇";
    
    
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kGlobalBg;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"shake" ofType:@"mp3"];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &soundID);
    CGRect frame = [UIScreen mainScreen].applicationFrame;
    _bgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 160,frame.size.width , 96)];
    _bgView.image = [UIImage imageNamed:@"更新背景2.png"];
    [self.view addSubview:_bgView];
    
    _upImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, 208)];
    
    _upImage.image = [UIImage imageNamed:@"Shake_01.png"];
    
    [self.view addSubview:_upImage];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 40, 220, 50)];
    titleLabel.text = @"摇一摇发现身边的TA";
    titleLabel.font = k18Font;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor =  kGetColor(0,165,224);
    [_upImage addSubview:titleLabel];
    
    _downImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, _upImage.frame.size.height, frame.size.width, 208)];
    
    _downImage.image = [UIImage imageNamed:@"Shake_02.png"];
    
    [self.view addSubview:_downImage];
    
       //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addAnimations) name:@"shake" object:nil];
    if([CLLocationManager locationServicesEnabled]) {
        //定位初始化
        _locationManager=[[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.distanceFilter = 1000.0f;
        if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8) {
            [_locationManager requestWhenInUseAuthorization];//使用程序其间允许访问位置数据（iOS8定位需要）
        }
        //开启定位
    }else {
        //提示用户无法进行定位操作
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"定位不成功 ,请确认开启定位" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }
    // 开始定位
//    [_locationManager startUpdatingLocation];
//
//    _locationManager = [[CLLocationManager alloc] init] ;
//    _locationManager.delegate = self;
//    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
//    _locationManager.distanceFilter = 1000.0f;
//    [_locationManager requestAlwaysAuthorization];
//    [_locationManager startUpdatingLocation];
    
}
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake )
    {
        // User was shaking the device. Post a notification named "shake".
        
        [self addAnimations];
    }
}

- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
}
- (void) viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:animated];
    [self resignFirstResponder];
    [super viewWillAppear:animated];
}
-(BOOL)canBecomeFirstResponder
{
    return YES;
}
- (void)addAnimations
{
    _indictor  = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _indictor.frame = CGRectMake(150, _downImage.frame.origin.y-10, 20, 20);
    [self.view insertSubview:_indictor aboveSubview:_downImage];
    [_indictor startAnimating];
    //AudioServicesPlaySystemSound (soundID);
     [LZAudioTool playMusic:@"shake.mp3"];
    //让imgup上下移动
    CABasicAnimation *translation2 = [CABasicAnimation animationWithKeyPath:@"position"];
    translation2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    translation2.fromValue = [NSValue valueWithCGPoint:CGPointMake(160, 115)];
    translation2.toValue = [NSValue valueWithCGPoint:CGPointMake(160, 20)];
    translation2.duration = 0.4;
    translation2.repeatCount = 1;
    translation2.autoreverses = YES;
    
    //让imagdown上下移动
    CABasicAnimation *translation = [CABasicAnimation animationWithKeyPath:@"position"];
    translation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    translation.fromValue = [NSValue valueWithCGPoint:CGPointMake(160, 345)];
    translation.toValue = [NSValue valueWithCGPoint:CGPointMake(160, 440)];
    translation.duration = 0.4;
    translation.repeatCount = 1;
    translation.autoreverses = YES;
    
    [_downImage.layer addAnimation:translation forKey:@"translation"];
    [_upImage.layer addAnimation:translation2 forKey:@"translation2"];
    
    //[_indictor stopAnimating];
    //    [aiLoad stopAnimating];
    //    aiLoad.hidden=YES;
    [self shareAndGetLocation];
    
    
    
}
-(void)shareAndGetLocation
{
  
    [_locationManager startUpdatingLocation];
    
}

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    latituduText = [NSString stringWithFormat:@"%3.5f",newLocation.coordinate.latitude];
    longitudeText = [NSString stringWithFormat:@"%3.5f",newLocation.coordinate.longitude];
    [_indictor stopAnimating];
    [_locationManager stopUpdatingLocation];
    NSLog(@"location ok---lon=%@----lat=%@",longitudeText,latituduText);
    
//    MapViewController *map = [[MapViewController alloc]init];
//   
//    [self.navigationController pushViewController:map animated:YES];

    
    [self sendLocation];
   
}
-(void)sendLocation
{
    NSURLRequest *request = [NSURLRequest requestWithPath:kSharkPath params:@{@"phone":[[NSUserDefaults standardUserDefaults] objectForKey:kPhone],@"lat":latituduText,@"lon":longitudeText }];
    //
    NSHTTPURLResponse *response = nil;
    NSError *error =nil;
    NSLog(@"%@",request);
    NSData *responeData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
  NSString *teststr1 = [[NSString alloc]initWithData:responeData encoding:NSUTF8StringEncoding];
    NSLog(@"%@",teststr1);
    if (responeData != nil) {
        
        NSError *jsonError = nil;
        NSMutableDictionary *responseJSON=[NSJSONSerialization JSONObjectWithData:responeData  options:NSJSONReadingAllowFragments  error:&jsonError];

        NSArray *array = responseJSON[@"users"];
        
        NSLog(@"responseJson%@",responseJSON);
        
        NSMutableArray *users = [NSMutableArray array];
        
        for (NSDictionary *dict in array) {
            User *u = [[User alloc]initWithDict:dict];
            [users addObject:u];
        }

        [_indictor stopAnimating];
        MapViewController *map = [[MapViewController alloc]init];
        if (map.getUsers) {
            map.getUsers(users);
        }
        [self.navigationController pushViewController:map animated:YES];
     
    }else{
        popup = [LPPopup popupWithText:@"网络连接失败,再试一次吧!"];
        popup.popupColor = [UIColor blackColor];
        popup.alpha = 0.8;
        popup.textColor = [UIColor whiteColor];
        popup.font = kDetailContentFont;
        //popup.textInsets = UIEdgeInsetsMake(10, 0, 0, 0);
        [popup showInView:self.view
            centerAtPoint:self.view.center
                 duration:1.5
               completion:nil];
    }

}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"定位失败:%@", error);
    [_indictor stopAnimating];
    popup = [LPPopup popupWithText:@"定位失败,再试一次吧!"];
    popup.popupColor = [UIColor blackColor];
    popup.alpha = 0.8;
    popup.textColor = [UIColor whiteColor];
    popup.font = kDetailContentFont;
    //popup.textInsets = UIEdgeInsetsMake(10, 0, 0, 0);
    [popup showInView:self.view
        centerAtPoint:self.view.center
             duration:1.5
           completion:nil];
    
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
