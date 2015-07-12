//
//  MapViewController.m
//  Stranger-Social
//
//  Created by lerrruby on 15/5/22.
//  Copyright (c) 2015年 lerruby.com. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "JPSThumbnail.h"
#import "JPSThumbnailAnnotation.h"
#import "GameViewController.h"
#import "User.h"
#define kMargin 20
#define kRefreshBtnLength 35
@interface MapViewController ()
<MKMapViewDelegate, CLLocationManagerDelegate> {
    MKMapView *myMapView;
    //CLLocationManager *locationManager;
    UIActivityIndicatorView *_indictor;
}
@end

@implementation MapViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _getUsers = ^(NSMutableArray *users){
            NSLog(@"users===%@",users);
            _userArray = users;
        };
    }
    return self;
}
- (void)initLocaton {
    // Do any additional setup after loading the view.
    myMapView = [[MKMapView alloc] initWithFrame:[self.view bounds]];
    myMapView.showsUserLocation = YES;
    myMapView.delegate = self;
    myMapView.mapType = MKMapTypeStandard;
    [self.view addSubview:myMapView];
    
    
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
        [_locationManager startUpdatingLocation];
    }else {
        //提示用户无法进行定位操作
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"定位不成功 ,请确认开启定位" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }
}

- (void)getData {

    _testArray = [NSMutableArray array];
    
    User *user = [[User alloc]init];
    user.nickName = @"小帅";
    user.sex = @"男";
    user.coords = CLLocationCoordinate2DMake(34.23640,108.95545);
    [_testArray addObject:user];
    
    User *user1 = [[User alloc]init];
    user1.nickName = @"大臭";
    user1.coords = CLLocationCoordinate2DMake(34.23858,108.94949);
    [_testArray addObject:user1];
    
    User *user2 = [[User alloc]init];
    user2.nickName = @"无聊";
    user2.coords = CLLocationCoordinate2DMake(34.23048,108.94652);
    [_testArray addObject:user2];
    
    User *user3 = [[User alloc]init];
    user3.nickName = @"小气";
    user3.coords = CLLocationCoordinate2DMake(34.22842,108.95060);
    [_testArray addObject:user3];
    
}


//- (void)viewDidAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:YES];
//    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:animated];
//}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:animated];
}
//- (void)viewDidDisappear:(BOOL)animated
//{
//    [self.navigationController setNavigationBarHidden:NO];
//    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:animated];
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    //[self setNeedsStatusBarAppearanceUpdate];
//    [self.navigationController setNavigationBarHidden:YES];
//    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
    [self initLocaton];
    _annotations = [NSMutableArray array];
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 20, 40, 30)];
    backBtn.backgroundColor = [UIColor blackColor];
    backBtn.alpha = 0.7;
    [backBtn setBackgroundImage:[UIImage imageNamed:@"map_navigationbar_back.png"] forState:UIControlStateNormal];
    [myMapView addSubview:backBtn];
    
    [backBtn addTarget:self action:@selector(popMapVC) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *refreshBtn = [[UIButton alloc]initWithFrame:CGRectMake([UIScreen mainScreen].applicationFrame.size.width - kMargin-kRefreshBtnLength, [UIScreen mainScreen].applicationFrame.size.height - kMargin - kRefreshBtnLength, kRefreshBtnLength, kRefreshBtnLength)];
    refreshBtn.layer.borderWidth = 1;
    refreshBtn.layer.borderColor = [kGetColor(215, 215, 215) CGColor];
    refreshBtn.layer.cornerRadius = 3;
    refreshBtn.layer.shadowOffset = CGSizeMake(0.5, 0.5);
    refreshBtn.layer.shadowColor = [kGetColor(118, 118, 118)CGColor ];
    refreshBtn.layer.shadowOpacity = 0.3;
    refreshBtn.backgroundColor= kGlobalBg;
    [refreshBtn setBackgroundImage:[UIImage imageNamed:@"map_refresh.png"] forState:UIControlStateNormal];
    [refreshBtn addTarget:self action:@selector(refreshLocation) forControlEvents:UIControlEventTouchUpInside];
    [myMapView addSubview:refreshBtn];
    
    [self getData];
    
}
-(void)refreshLocation
{
    [myMapView removeAnnotations:_annotations];
    
    [_locationManager startUpdatingLocation];
}
-(void)popMapVC
{
    [self.navigationController popViewControllerAnimated:YES];
     [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
    [self.navigationController setNavigationBarHidden:NO];
}
-(JPSThumbnailAnnotation*)creatWithTitle:(NSString *)title Coords:(CLLocationCoordinate2D) coords
{
    JPSThumbnail *jpsThumbnail = [[JPSThumbnail alloc] init];
   
    jpsThumbnail.title = title;
 
    jpsThumbnail.coordinate = coords;
 
    
   return  [[JPSThumbnailAnnotation alloc] initWithThumbnail:jpsThumbnail];

}
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    _indictor = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(140, 320, 40, 40 )];
    [self.view addSubview:_indictor];
    [_indictor startAnimating];

    NSLog(@"%d",view.tag);
    GameViewController *gameVC = [[GameViewController  alloc]init];
    if (gameVC.getUser) {
        gameVC.getUser(_userArray[view.tag]);
    }
    [self.navigationController pushViewController:gameVC animated:YES];
    [self.navigationController setNavigationBarHidden:NO];
    NSLog(@"tag=%d",view.tag);
    [_indictor stopAnimating];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation conformsToProtocol:@protocol(JPSThumbnailAnnotationProtocol)]) {
        return [((NSObject<JPSThumbnailAnnotationProtocol> *)annotation) annotationViewInMap:mapView];
    }
    return nil;
}


-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{

    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, 2000,2000);
    [myMapView setRegion:[myMapView regionThatFits:region] animated:YES];
    _currentLocation = newLocation;
    [_locationManager stopUpdatingLocation];
    NSLog(@"location ok---lat%@----%@",[NSString stringWithFormat:@"%3.5f",newLocation.coordinate.latitude],[NSString stringWithFormat:@"%3.5f",newLocation.coordinate.longitude]);
    NSLog(@"count == %d", _userArray.count);
    for (int i=0; i<_userArray.count; i++) {
        CLLocationCoordinate2D newCoords = [_userArray[i] coords];
        JPSThumbnailAnnotation *annotation = [self creatWithTitle:[_userArray[i] nickName]  Coords:newCoords];
        annotation.tag = i;
        
        CLLocation *fromLocation = [[CLLocation alloc]initWithLatitude:newCoords.latitude longitude:newCoords.longitude];
        NSLog(@"distance----%f",[fromLocation distanceFromLocation:_currentLocation],_currentLocation);
        
        if ([fromLocation distanceFromLocation:_currentLocation] <= 1000) {
            [_annotations addObject:annotation];
        }
    }
    
//    for (int i=0; i<_testArray.count; i++) {
//        CLLocationCoordinate2D newCoords = [_testArray[i] coords];
//        JPSThumbnailAnnotation *annotation = [self creatWithTitle:[_testArray[i] nickName]  Coords:newCoords];
//        annotation.tag = i;
//        
//        CLLocation *fromLocation = [[CLLocation alloc]initWithLatitude:newCoords.latitude longitude:newCoords.longitude];
//        NSLog(@"distance----%f",[fromLocation distanceFromLocation:_currentLocation],_currentLocation);
//        
//        if ([fromLocation distanceFromLocation:_currentLocation] <= 1000) {
//            [_annotations addObject:annotation];
//        }
//    }

    
    [myMapView addAnnotations:_annotations];
   

}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"locError:%@", error);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (MKAnnotationView *) mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>) annotation {
//
//    MKAnnotationView * result = nil;
//    if([annotation isKindOfClass:[CustomAnnotation class]] == NO)
//    {
//        return result;
//    }
//
//    if([theMapView isEqual:mapView] == NO)
//    {
//        return result;
//    }
//
//
//    CustomAnnotation * senderAnnotation = (CustomAnnotation *)annotation;
//    NSString * pinReusableIdentifier = [CustomAnnotation reusableIdentifierforPinColor:senderAnnotation.pinColor];
//    MKPinAnnotationView * annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pinReusableIdentifier];
//    if(annotationView == nil)
//    {
//        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:senderAnnotation reuseIdentifier:pinReusableIdentifier];
//
//        [annotationView setCanShowCallout:YES];
//    }
//
//
////    MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"PIN_ANNOTATION"];
////    if(annotationView == nil) {
////        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
////                                                          reuseIdentifier:@"PIN_ANNOTATION"];
////    }
//    UIButton * button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
//    annotationView.rightCalloutAccessoryView = button;
//    annotationView.backgroundColor = [UIColor blackColor];
//    annotationView.alpha = 0.5;
//    annotationView.canShowCallout = YES;
//    annotationView.image = [UIImage imageNamed:@"同学帮.png"];
//    //annotationView.pinColor = MKPinAnnotationColorRed;
//    annotationView.animatesDrop = YES;
//    //annotationView.highlighted = YES;
//    annotationView.draggable = YES;
//    [annotationView setSelected:YES];
//    NSLog(@"%u",annotationView.selected);
//    UIImageView * imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"同学帮.png"]];
//    imageView.frame = CGRectMake(0, 0, 40, 40);
//    annotationView.leftCalloutAccessoryView = imageView;
//
//    return annotationView;
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
