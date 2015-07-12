//
//  WXOInputViewPluginPhotoPicker.h
//  WXOpenIMUIKit
//
//  Created by Zhiqiang Bao on 15-2-3.
//  Copyright (c) 2015年 www.alibaba.com. All rights reserved.
//

#import "YWInputViewPlugin.h"

extern NSString *kPluginIndentityPhotoPicker;

/**
 *  选中图片的回调
 *  @param plugin 正在操作的插件
 *  @param image 选中的图片
 */
typedef void(^YWInputViewPluginImageBlock)(id<YWInputViewPluginProtocol> plugin, UIImage *image);


@interface YWInputViewPluginPhotoPicker : YWInputViewPlugin

/**
 *  初始化照片选择插件
 *  @param blk 选中某个照片的回调
 */
- (instancetype)initWithPickerOverBlock:(YWInputViewPluginImageBlock)blk;

@end
