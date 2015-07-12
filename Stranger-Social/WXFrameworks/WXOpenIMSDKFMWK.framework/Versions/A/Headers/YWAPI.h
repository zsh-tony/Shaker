//
//  YWAPI.h
//
//
//  Created by huanglei on 15/1/12.
//  Copyright (c) 2015年 taobao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "YWServiceDef.h"

@protocol IYWPushService;
@protocol IYWExtensionService;

@protocol IYWUtilService4Cache, IYWUtilService4Network, IYWUtilService4Security;

@protocol IWXOUTService, IWXOSecurityService;

@class YWIMCore;

/**
 *  开发环境
 */
typedef enum {
    YWEnvironmentRelease = 1, // 开发者的线上环境
    YWEnvironmentPreRelease = 2, // 阿里巴巴内网预发环境
    YWEnvironmentDailyForTester = 3, // 阿里巴巴内网87环境，稳定
    YWEnvironmentDailyForDeveloper = 4, // 阿里巴巴内网88环境，开发中
    YWEnvironmentSandBox = 5, // 开发者的沙箱环境
}YWEnvironment;

/**
 *  WXOSdk错误域
 */
FOUNDATION_EXTERN NSString *const YWSdkDomain;

typedef NS_ENUM(NSUInteger, YWSdkInitErrorCode) {
    /// 已经被初始化
    YWSdkInitErrorCodeAlreadyInited = 100,
    /// 获取AppInfo失败
    YWSdkInitErrorCodeGetAppInfoFailed,
};

@interface YWAPI : NSObject

+ (instancetype)sharedInstance;

/**
 *  异步初始化
 *  @param aOwnAppKey 自身的appkey
 *  @param aInteractedAppKeys 需要进行互通的AppKey字符串数组。
 *  @param aCompletionBlock 初始化结果，错误的类型见 WXOSdkErrorCode 定义
 */
- (void)asyncInitWithOwnAppKey:(NSString *)aOwnAppKey
             interactedAppKeys:(NSArray *)aInteractedAppKeys
               completionBlock:(YWCompletionBlock)aCompletionBlock;

/**
 *  云旺AppKey。
 *  如果您收到的消息来自于客服YWPerson，那么该YWPerson对象的appKey为YWSDKAppKey
 */
FOUNDATION_EXTERN NSString *const YWSDKAppKey;


@end


#pragma mark - IMKit for OpenIM

@class YWIMKit;

@interface YWAPI ()

/**
 *  初始化IMKit实例，类型为OpenIM。
 *  您获取该实例后，需要retain住该实例，建议将其作为全局单例使用
 *
 *  注意：目前暂不支持获取多个IMKit实例同时使用
 *  注意：获取IMKit实例后，您无需再获取YWIMCore实例，您可以从IMKit实例中得到YWIMCore实例
 */
- (YWIMKit *)fetchIMKitForOpenIM;

@end


#pragma mark - UserContext

@interface YWAPI ()

/**
 *  获取一个OpenIM的YWIMCore实例。
 *  建议在获取一个YWIMCore后，将其保存为全局单例使用。
 */
- (YWIMCore *)fetchNewIMCoreForOpenIM;

/// YWIMCore被新建的通知
typedef void (^YWSDKIMCoreCreatedBlock)(YWIMCore *aIMCore);

/**
 *  监听新的YWIMCore被生成
 *  @param aKey 用来区分不同的监听者，一般可以使用监听对象的description
 *  @param aPriority 有多个监听者时，调用的优先次序。开发者一般设置：YWBlockPriority
 */
- (void)addIMCoreCreatedBlock:(YWSDKIMCoreCreatedBlock)aBlock forKey:(NSString *)aKey priority:(YWBlockPriority)aPriority;

- (void)removeIMCoreCreatedBlockForKey:(NSString *)aKey;


@end


@interface YWAPI (GlobalServices)

/**
 *  获取PushService
 */
- (id<IYWPushService>)getGlobalPushService;

/**
 *  获取ExtensionService
 */
- (id<IYWExtensionService>)getGlobalExtensionService;

@end

@interface YWAPI (OpenUtilServices)

/**
 *  获取cacheService
 */
- (id<IYWUtilService4Cache>)getGlobalUtilService4Cache;

/**
 *  获取UtilService4Network
 */
- (id<IYWUtilService4Network>)getGlobalUtilService4Network;

/**
 *  获取UtilService4Security
 */
- (id<IYWUtilService4Security>)getGlobalUtilService4Security;

@end

#pragma mark - 内部服务

@interface YWAPI (InternalServices)

/**
 *  UT
 */
- (id<IWXOUTService>)getGlobalUTService;

/**
 *  Security
 */
- (id<IWXOSecurityService>)getGlobalSecurityService;

@end


#pragma mark - 配置信息

@interface YWAPI ()

/**
 *  appkey
 */
@property (nonatomic, copy, readwrite) NSString *appKey;

/**
 *  YW SDK版本信息
 */
@property (nonatomic, readonly) NSString *YWSDKIdentifier;

/**
 *  网络环境，可以通过这个属性，在初始化WXOSdk之前设置网络环境的初始值
 *  热切换网络环境功能暂时不支持。（即如果已经初始化Sdk，则无法切换）
 */
@property (nonatomic, assign, readwrite) YWEnvironment environment;

/**
 *  切换网络环境，此功能暂不支持。
 *  如果需要不同的网络环境，需要在初始化Sdk之前，设置上面的environment属性。
 */
- (void)changeEnvironment:(YWEnvironment)aEnvironment;


/// 网络环境切换的回调（暂不支持）
typedef void(^YWSdkEnvironmentChangedBlock)(YWEnvironment aEnvironment);

/**
 *  添加网络环境切换的监听（暂不支持）
 *  @param aKey 用来区分不同的监听者，一般可以使用监听对象的description
 *  @param aPriority 有多个监听者时，调用的优先次序。开发者一般设置：YWBlockPriority
 */
- (void)addEnvironmentChangedBlock:(YWSdkEnvironmentChangedBlock)aBlock forKey:(NSString *)aKey ofPriority:(YWBlockPriority)aPriority;

/**
 *  移除网络环境切换的监听（暂不支持）
 */
- (void)removeEnvironmentChangedBlockForKey:(NSString *)aKey;

/**
 *  日志开关
 */
@property (nonatomic, assign) BOOL logEnabled;


/**
 *  Crash收集开关，三方开发者接入时默认为开启。如果三方开发者自己具备Crash收集机制，则需要在初始化Sdk前关闭此开关
 *  淘宝二方开发者接入时默认为关闭。
 */
- (void)closeCrashCollector;


@end

#pragma mark - IMKit for Wangwang

@interface YWAPI ()

/**
 *  初始化IMKit实例，类型为旺旺帐号
 *  您获取该实例后，需要retain住该实例，建议将其作为全局单例使用
 *
 *  注意：目前暂不支持获取多个IMKit实例同时使用
 *  注意：获取IMKit实例后，您无需再获取WXOBaseContext实例，您可以从IMKit实例中得到WXOBaseContext实例
 */
- (YWIMKit *)fetchIMKitForWangwang;


/**
 *  获取一个新的YWIMCore对象。
 *  建议在获取一个YWIMCore后，将其保存为全局单例使用。
 */
- (YWIMCore *)fetchNewIMCore;

/// 获取一个旺旺IMCore实例
- (YWIMCore *)fetchNewIMCoreForWangwang;


@end




