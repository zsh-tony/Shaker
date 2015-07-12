//
//  NSString+file.m
//  weibo
//
//  Created by zsh tony on 14-7-25.
//  Copyright (c) 2014年 zsh-tony. All rights reserved.
//

#import "NSString+file.h"

@implementation NSString (file)
-(NSString *)filenameAppend:(NSString *)append
{

        NSString *filename = [self stringByDeletingPathExtension];
        filename = [filename stringByAppendingString:append];
        NSString *extension = [self pathExtension];
    //NSLog(@"%@", [filename stringByAppendingPathExtension:extension]);
        return  [filename stringByAppendingPathExtension:extension];
    

}
-(NSString*)stringWithBeliefStr:(NSString*)str
{
    NSRange range = NSMakeRange(1, str.length-2);
    //NSLog(@"%@",range);
    return [str substringWithRange:range];
}
@end
