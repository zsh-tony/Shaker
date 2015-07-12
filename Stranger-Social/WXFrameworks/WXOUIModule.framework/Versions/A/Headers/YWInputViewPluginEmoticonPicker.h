//
//  WXOInputViewPluginLocationPicker.h
//  WXOpenIMUIKit
//
//  Created by Zhiqiang Bao on 15-2-3.
//  Copyright (c) 2015年 www.alibaba.com. All rights reserved.
//

#import "YWInputViewPlugin.h"
#import "YWMessageInputView.h"
#import "YWEmoticonFactory.h"

/**
 *  选中某个表情的回调
 */
typedef void(^YWInputViewPluginEmoticonPickBlock)(id<YWInputViewPluginProtocol> plugin, YWEmoticon *emoticon, YWEmoticonType type);

/**
 *  点击发送的回调
 */
typedef void(^YWInputViewPluginEmoticonSendBlock)(id<YWInputViewPluginProtocol> plugin, NSString *sendText);

extern NSString *kPluginIndentityEmoticonPicker;

@interface YWInputViewPluginEmoticonPicker : YWInputViewPlugin

/**
 *  初始化表情选择插件
 *  @param pickBlk 选中某个表情的回调
 *  @param sendBlk 发送按钮按下的回调
 */
- (instancetype)initWithPickerOverBlock:(YWInputViewPluginEmoticonPickBlock)pickBlk
                              sendBlock:(YWInputViewPluginEmoticonSendBlock)sendBlk;

@end
