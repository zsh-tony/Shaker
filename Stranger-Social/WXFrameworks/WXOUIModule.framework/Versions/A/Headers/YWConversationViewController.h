//
//  WXOConversationViewController.h
//  testFreeOpenIM
//
//  Created by Jai Chen on 15/1/12.
//  Copyright (c) 2015年 taobao. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YWMessageInputView.h"

@class YWConversation;
@class YWIMCore;
@class YWIMKit;


@interface YWConversationViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>


/**
 *  创建消息列表Controller
 *  @param aIMKit IMKit对象
 *  @param aConversation 会话对象
 */
+ (instancetype)makeControllerWithIMKit:(YWIMKit *)aIMKit conversation:(YWConversation *)aConversation;

/**
 *  YWIMKit对象的弱引用
 */
@property (nonatomic, weak, readonly)   YWIMKit *kitRef;

/**
 *  会话对象
 */
@property (nonatomic, strong, readonly) YWConversation *conversation;

#pragma mark - for CustomUI

/// 输入框
@property (nonatomic, strong, readonly) YWMessageInputView *messageInputView;

/// 顶部自定义View
@property (nonatomic, strong) UIView *customTopView;

#pragma mark - 消息发送
/// 文本发送
- (void)sendTextMessage:(NSString *)text;

/// 图片发送 包含图片上传交互
- (void)sendImageMessage:(UIImage *)image;

/// 语音发送
- (void)sendVoiceMessage:(NSData*)wavData andTime:(int)nRecordingTime;

#pragma mark - 模板消息的气泡事件回调

/// 会接受到模板消息的使用方才需要实现这个block

/// 模板消息的气泡事件回调
typedef void (^YWActionProcessBlock) (NSString *action);
/// 模板消息的气泡事件回调
@property (nonatomic, copy, readonly) YWActionProcessBlock actionProcesser;
/// 模板消息的气泡事件回调
- (void)setActionProcesser:(YWActionProcessBlock)actionProcesser;


@end

