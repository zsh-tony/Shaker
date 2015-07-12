//
//  DiscoverViewController.h
//  Stranger-Social
//
//  Created by lerrruby on 15/5/21.
//  Copyright (c) 2015年 lerruby.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <AudioToolbox/AudioToolbox.h>
#import <CoreLocation/CoreLocation.h>
@interface DiscoverViewController : UIViewController
@property (nonatomic,strong)UIImageView *upImage;
@property (nonatomic,strong)UIImageView *downImage;
@property (nonatomic,strong)UIImageView *bgView;
@property (nonatomic,strong)UIActivityIndicatorView *indictor;
@property (nonatomic,strong)CLLocationManager *locationManager;
@end
