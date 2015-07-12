//
//  NSString+file.h
//  weibo
//
//  Created by zsh tony on 14-7-25.
//  Copyright (c) 2014年 zsh-tony. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (file)
//太麻烦 应该用对象方法，谁调用我们加到谁的身上+(NSString *)filenameApppend:(NSString *)append (NSString*)exfile;
-(NSString*)filenameAppend:(NSString *)append;
-(NSString*)stringWithBeliefStr:(NSString*)str;
@end
