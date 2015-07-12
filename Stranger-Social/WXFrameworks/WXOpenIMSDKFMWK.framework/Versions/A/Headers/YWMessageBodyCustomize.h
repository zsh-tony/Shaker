//
//  YWMessageBodyCustomize.h
//  
//
//  Created by 慕桥(黄玉坤) on 1/15/15.
//  Copyright (c) 2015 taobao. All rights reserved.
//

#import "YWMessageBody.h"

@interface YWMessageBodyCustomize : YWMessageBody

/// 自定义数据
@property (nonatomic, strong, readonly) NSString *content;

/// 推送穿透内容
@property (nonatomic, strong, readonly) NSString *summary;

/// 初始化
- (instancetype)initWithMessageCustomizeContent:(NSString *)content summary:(NSString *)summary;
@end
