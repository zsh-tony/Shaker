//
//  IYWLoginService.h
//
//
//  Created by huanglei on 14/12/11.
//  Copyright (c) 2014年 taobao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YWServiceDef.h"
#import "YWLoginServiceDef.h"
#import "YWPerson.h"

#pragma mark - 服务接口定义

/**
 * 登录相关服务提供
 */
@protocol IYWLoginService <NSObject>

/**
 *  当前IM是否已登录
 */
@property (nonatomic, assign, readonly) BOOL isCurrentLogined;

/**
 *  当前登录Id
 */
@property (nonatomic, readonly) NSString *currentLoginedUserId;

/**
 *  当前登录用户的显示名称
 */
@property (nonatomic, readonly) NSString *currentLoginedUserDisplayName;

/**
 *  当前登录的用户
 */
- (YWPerson *)currentLoginedUser;

@property (nonatomic, copy, readonly) YWFetchLoginInfoBlock fetchLoginInfoBlock;
@property (nonatomic, copy, readonly) YWFetchLoginInfoBlockV2 fetchLoginInfoBlockV2;
/**
 *  设置登录能力
 */
- (void)setFetchLoginInfoBlock:(YWFetchLoginInfoBlock)fetchLoginInfoBlock;
- (void)setFetchLoginInfoBlockV2:(YWFetchLoginInfoBlockV2)fetchLoginInfoBlock;

/**
 *  设置固定的登录额外信息。例如与TAE SDK等集成使用时，可以传递额外信息。
 *  一般来说，ISV不需要特别关注这个字段。
 */
@property (nonatomic, copy) NSDictionary *defaultLoginClientData;

/// 设置IM长连接状态变更回调
/// @param aKey 用来区分不同的监听者，一般可以使用监听对象的description
/// @param aPriority 有多个监听者时，调用的优先次序。开发者一般设置：YWBlockPriority
- (void)addConnectionStatusChangedBlock:(YWIMConnectionStatusChangedBlock)connectionStatusChangedBlock forKey:(NSString *)aKey ofPriority:(YWBlockPriority)aPriority;
/// 移除IM长连接状态变更回调
- (void)removeConnectionStatusChangedBlockForKey:(NSString *)aKey;

/**
 *  发起异步登录
 *  @param aCompletionBlock 登录结果回调，如果成功则aError返回nil
 *  @return 如果没能发起登陆请求，则直接返回NO
 */
- (BOOL)asyncLoginWithCompletionBlock:(YWCompletionBlock)aCompletionBlock;

/**
 * 异步登出
 * @param aCompletionBlock 登出结果回调，如果成功则aError返回nil
 */
- (void)asyncLogoutWithCompletionBlock:(YWCompletionBlock)aCompletionBlock;

@end


