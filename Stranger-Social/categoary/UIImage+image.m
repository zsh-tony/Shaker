//
//  UIImage+image.m
//  weibo
//
//  Created by zsh tony on 14-7-24.
//  Copyright (c) 2014年 zsh-tony. All rights reserved.
//

#import "UIImage+image.h"
#import "NSString+file.h"
@implementation UIImage (image)
+ (UIImage *)fullscreenImageWithName:(NSString *)name
{
    if ([UIScreen mainScreen].bounds.size.height == 568) {
//        NSString *filename = [name stringByDeletingPathExtension];
//        filename = [filename stringByAppendingString:@"-568h@2x"];
//        NSString *extension = [name pathExtension];
//        name = [filename stringByAppendingPathExtension:extension];
        name = [name filenameAppend:@"-568h@2x"];
        
    }
    //NSLog(@"%@",name);
    return [UIImage imageNamed:name];
}
+ (UIImage *)stretchImageWithName:(NSString *)name
{
    UIImage *image = [UIImage imageNamed:name];
    image = [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height *0.5];
    return image;
}
@end
