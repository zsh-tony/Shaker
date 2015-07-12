//
//  YWBaseBubbleChatView.h
//  Messenger
//
//  Created by muqiao.hyk on 13-4-19.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/// 说明：消息气泡基类谨慎修改，修改后请联系慕桥Review。

typedef enum _BubbleStyle{
    
    /// 不显示
    BubbleStyleNone,
    
    /// 内容在下层的样式，居左
    BubbleStyleCoverLeft,
    /// 内容在下层的样式，居中
    BubbleStyleCoverMid,
    /// 内容在下层的样式，居右
    BubbleStyleCoverRight,
    
    /// 内容在上层的样式，居左
    BubbleStyleFlatLeft,
    /// 内容在上层的样式，居中
    BubbleStyleFlatMid,
    /// 内容在上层的样式，居右
    BubbleStyleFlatRight,
    
    /// 凹陷样式，用于居中显示系统消息
    BubbleStyleDepressMid,
    
    // 自定义气泡风格
    BubbleStyleCustomize,
}BubbleStyle;

/**
 *  开发者的自定义YWBaseBubbleChatView需要实现这个协议
 */
@protocol YWBaseBubbleChatViewInf <NSObject>
@required
/// 内容区域大小
- (CGSize)getBubbleContentSize;
/// 需要刷新BubbleView时会被调用
- (void)updateBubbleView;
@optional
// 返回所持ViewModel类名，用于类型检测
- (NSString *)viewModelClassName;
@end

@class YWBaseBubbleViewModel;
@class YWBaseBubbleChatView;

@interface YWBaseBubbleChatView : UIView<YWBaseBubbleChatViewInf>

/// 是否需要强制更新
@property (nonatomic, assign, readonly) BOOL forceLayout;
/// 设置强制更新
- (void)setForceLayout:(BOOL)forceLayout;

/// 是否高亮
@property (nonatomic, assign, readonly) BOOL highLight;
/// 设置高亮
- (void)setHighLight:(BOOL)highLight;

// 背景视图
@property (nonatomic, strong) UIImageView*  imageViewBk;
@property (nonatomic, assign) UIEdgeInsets edgeInsets4BK;

/// 对应的ViewModel
@property (nonatomic, strong, readonly) YWBaseBubbleViewModel *viewModel;

@end

@interface YWBaseBubbleChatView (CustomBubbleRect)

/// 设置头像与气泡的间距
+ (void)setBubbleAvatarOffset:(CGFloat)aBubbleAvatarOffset;
+ (CGFloat)bubbleAvatarOffset;

/// 设置居中气泡的最小边距
+ (void)setCenterBubbleMinMarginX:(CGFloat)aMinMarginX;
+ (CGFloat)centerBubbleMinMarginX;

@end

@interface YWBaseBubbleChatView(PlaceBaseBubbleStyle)
// 是否应该被居中放置
+ (BOOL)shouldBePlacedCentrally:(BubbleStyle)bubbleStyle;
// 是否应该靠左放置
+ (BOOL)shouldBePlacedLeftSide:(BubbleStyle)bubbleStyle;

// 是否应该被居中放置
- (BOOL)shouldBePlacedCentrally;
// 是否应该靠左放置
- (BOOL)shouldBePlacedLeftSide;
@end
