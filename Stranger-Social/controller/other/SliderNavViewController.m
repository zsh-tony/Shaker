//
//  SliderNavViewController.m
//  weibo
//
//  Created by zsh tony on 14-8-6.
//  Copyright (c) 2014年 zsh-tony. All rights reserved.
//

//
//  SliderNavViewController.m
//  weibo
//
//  Created by zsh tony on 14-8-6.
//  Copyright (c) 2014年 zsh-tony. All rights reserved.
//

#import "SliderNavViewController.h"
#import <QuartzCore/QuartzCore.h>


#define kDefaultScale 0.4

#define kDefayltAlpha 0.7

@interface SliderNavViewController ()<UIGestureRecognizerDelegate>
{
    UIImageView *_imageView;
    
    UIImageView *_cover;
    
    NSMutableArray *_cutImage;
}
@end

@implementation SliderNavViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _cutImage = [NSMutableArray array];
    // Do any additional setup after loading the view.
//    UIGestureRecognizer *panGesture =[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(dragView:)];
//    panGesture.delegate = self;
//    [self.view addGestureRecognizer:panGesture];
    //[self.view addGestureRecognizer:[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(dragView:)]];
    _imageView = [[UIImageView alloc]init];
    //_imageView.frame = [UIScreen mainScreen].applicationFrame;//这个frame会减去状态栏的高度，是位控制器的view准备的
    _imageView.frame = self.view.frame;
    
    _cover = [[UIImageView alloc]init];
    _cover.frame = _imageView.frame;
    _cover.backgroundColor = [UIColor blackColor];//不能在这里添加
    
}
//截图
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
//{
//  
//        
//        return YES;
//    
//    
//}
-(void)cutimage
{
    UIView *cutView = self.view.window.rootViewController.view;
    
    //开启上下文
    
    UIGraphicsBeginImageContext(cutView.frame.size);
    
    //将cutview的涂层渲染到上下文
    
    UIGraphicsBeginImageContextWithOptions(cutView.frame.size, YES, 0.0);//截图的质量高
    
    [cutView.layer renderInContext:UIGraphicsGetCurrentContext()];//裁剪的图片质量不好
    
    //取出image
    UIImage  *image =  UIGraphicsGetImageFromCurrentImageContext();
    
    [_cutImage addObject:image];
    
    //结束上下文
    UIGraphicsEndImageContext();
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count >= 1) {//如果不加这一句，在窗口第一次加载导航控制器的时候就会截图，但是这时候导航控制器还没有view，所以此时截的图为空，所以上面的addobject会报错
        [self cutimage];
    }
    
    
    
    [super pushViewController:viewController animated:animated];
}

-(void)dragView:(UIPanGestureRecognizer *)pan
{
    if(self.topViewController == self.viewControllers[0])return;
    
    //手势监听 的规范写法，用switch
    
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
            
            [self beginDrag];
            
            break;
        case UIGestureRecognizerStateEnded:
            
            [self endedDrag];
            
            break;
            
        default:
            
            [self draging:pan];
            break;
    }
    
    //    if (pan.state == UIGestureRecognizerStateEnded) {
    //
    //
    //
    //    }else{
    //
    //
    //    }
}

-(void)beginDrag
{
    [self.view.window insertSubview:_imageView atIndex:0];
    //[self.view.window insertSubview:_cover aboveSubview:_imageView];
    
    _imageView.image = [_cutImage lastObject];
}

-(void)draging:(UIPanGestureRecognizer *)pan
{
    
    CGFloat tx = [pan translationInView:self.view].x;
    if (tx < 0) tx = 0;//不能往左拖
    self.view.transform = CGAffineTransformMakeTranslation(tx, 0);
    
    //    double tScale = tx / self.view.frame.size.width ;
    //
    //    double scale = kDefaultScale + (tScale/0.75) * (1 - kDefaultScale);
    //
    //    if (scale>1) scale = 1;
    //
    //    _imageView.transform = CGAffineTransformMakeScale(scale, scale);
    //
    //    double alpha = kDefayltAlpha - (tScale/0.75) * kDefayltAlpha;
    //    _cover.alpha = alpha;
    
}

-(void)endedDrag
{
    
    CGFloat tx =  self.view.transform.tx;
    
    CGFloat width = self.view.frame.size.width;
    
    if (tx <= width * 0.5) {
        [UIView animateWithDuration:0.3 animations:^{
            //清空transform
            
            self.view.transform = CGAffineTransformIdentity;
            
            //让背景图片也有动画
            
            // _imageView.transform = CGAffineTransformMakeScale(kDefaultScale, kDefaultScale);
            _cover.alpha = kDefayltAlpha;
            
        } completion:^(BOOL finished) {
            [_imageView removeFromSuperview];
            //[_cover removeFromSuperview];
        }];
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            //清空transform
            
            self.view.transform = CGAffineTransformMakeTranslation(width, 0);
            
            //让背景图片也有动画
            
            // _imageView.transform = CGAffineTransformMakeScale(1 , 1);
            // _cover.alpha = 0;
            
        } completion:^(BOOL finished) {
            
            self.view.transform = CGAffineTransformIdentity;//transform一定要记得清空
            [_imageView removeFromSuperview];
            //[_cover removeFromSuperview];
            
            [self popViewControllerAnimated:NO];
            
            [_cutImage removeLastObject];
        }];
        
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
