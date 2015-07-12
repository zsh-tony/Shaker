//
//  MapViewController.h
//  Stranger-Social
//
//  Created by lerrruby on 15/5/22.
//  Copyright (c) 2015年 lerruby.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
@interface MapViewController : UIViewController
@property (nonatomic,strong)NSMutableArray *annotations;
@property (nonatomic,strong)NSMutableArray *userArray;
@property (nonatomic,strong)NSMutableArray *testArray;
@property (nonatomic,strong)CLLocationManager *locationManager;
@property (nonatomic,assign)CLLocation *currentLocation;
@property (nonatomic,strong)void (^getUsers)(NSMutableArray *);
@end
