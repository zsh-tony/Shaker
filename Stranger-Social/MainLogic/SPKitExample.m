//
//  SPKitExample.m
//  WXOpenIMSampleDev
//
//  Created by huanglei on 15/4/11.
//  Copyright (c) 2015年 taobao. All rights reserved.
//

#import "SPKitExample.h"
#import "AudioToolbox/AudioToolbox.h"
#import <WXOpenIMSDKFMWK/YWFMWK.h>
#import <WXOUIModule/YWUIFMWK.h>

#import "AppDelegate.h"
#import "SPUtil.h"

#import "loginViewController.h"

#import "SPInputViewPluginCustomize.h"

#import "SPBaseBubbleChatViewCustomize.h"
#import "SPBubbleViewModelCustomize.h"
typedef void(^pwdAccountFail)(int code);
@interface SPKitExample ()
{
    LPPopup *popup;
}
@property (nonatomic, readonly) AppDelegate *appDelegate;

@end

@implementation SPKitExample


#pragma mark - properties

- (AppDelegate *)appDelegate
{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

#pragma mark - private methods


#pragma mark - public methods

+ (instancetype)sharedInstance
{
    static SPKitExample *sExample = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sExample = [[SPKitExample alloc] init];
    });
    
    return sExample;
}

#pragma mark - basic

/**
 *  初始化示例代码
 */
- (void)exampleInitWithSuccessBlock:(void (^)())aSuccessBlock
{
    aSuccessBlock = [aSuccessBlock copy];
    /// 设置环境
    [[YWAPI sharedInstance] setEnvironment:YWEnvironmentRelease];
    /// 开启日志
    [[YWAPI sharedInstance] setLogEnabled:NO];
    
    NSLog(@"SDKVersion:%@", [YWAPI sharedInstance].YWSDKIdentifier);
    
    /// 异步初始化IM SDK
    [[YWAPI sharedInstance] asyncInitWithOwnAppKey:@"23180423" interactedAppKeys:@[@"23180423"] completionBlock:^(NSError *aError, NSDictionary *aResult) {
        
        if (aError.code != 0 && aError.code != YWSdkInitErrorCodeAlreadyInited) {
            /// 初始化失败
            [[SPUtil sharedInstance] showNotificationInViewController:self.appDelegate.window.rootViewController title:@"YWAPI 初始化失败" subtitle:aError.description type:SPMessageNotificationTypeError];
            return;
        } else {
            
            if (aError.code == 0) {
                /// 首次初始化成功
                /// 获取一个IMKit并持有
                [[SPUtil sharedInstance] showNotificationInViewController:self.appDelegate.window.rootViewController title:@"YWAPI初始化成功" subtitle:nil type:SPMessageNotificationTypeSuccess];

                self.appDelegate.ywIMKit = [[YWAPI sharedInstance] fetchIMKitForOpenIM];
            } else {
                [[SPUtil sharedInstance] showNotificationInViewController:self.appDelegate.window.rootViewController title:@"YWAPI已经初始化" subtitle:nil type:SPMessageNotificationTypeSuccess];

            }
            
            /// 首次初始化成功，或者已经初始化
            if (aSuccessBlock) {
                aSuccessBlock();
            }
        }
    }];
}

/**
 *  登录的示例代码
 */
- (void)exampleLoginWithUserID:(NSString *)aUserID password:(NSString *)aPassword successBlock:(void(^)())aSuccessBlock failBlock:(void(^)())afailBlock pwdAccountFail:(void(^)(int code))pwdAccountFail
{
    aSuccessBlock = [aSuccessBlock copy];
    
    /// 登录之前，先告诉IM如何获取登录信息。
    /// 当IM向服务器发起登录请求之前，会调用这个block，来获取用户名和密码信息。
    [[self.appDelegate.ywIMKit.IMCore getLoginService] setFetchLoginInfoBlock:^(YWFetchLoginInfoCompletionBlock aCompletionBlock) {
        /// 你可能需要从你的服务器异步获取这些信息，包括用户的显示名称等。成功后再调用aCompletionBlock，告诉IM
        /// 在示例中，我们就直接把输入框中的信息，告诉IM
        
    
        
        [UserTool requestUserWithPath:kGetMyInfoPath UserPhone:aUserID success:^(User *user) {
            NSString *name = user.nickName;
            

            aCompletionBlock(YES, aUserID, aPassword, name, nil);
            
    
           
        } fail:^{
            NSLog(@"服务器连接失败");
            if (afailBlock!= nil) {
                afailBlock();
            }
            
        }];
        
//        NSString *name = nil;
//        [[SPUtil sharedInstance] getPersonDisplayName:&name avatar:NULL ofPerson:[[YWPerson alloc] initWithPersonId:aUserID]];
//        aCompletionBlock(YES, aUserID, aPassword, [NSString stringWithFormat:@"NM-%@", aUserID], nil);
        
    }];
    
    /// 发起登录
    [[self.appDelegate.ywIMKit.IMCore getLoginService] asyncLoginWithCompletionBlock:^(NSError *aError, NSDictionary *aResult) {
        if (aError.code == 0 || [[self.appDelegate.ywIMKit.IMCore getLoginService] isCurrentLogined]) {
            /// 登录成功
            [[SPUtil sharedInstance] showNotificationInViewController:self.appDelegate.window.rootViewController title:@"登录成功" subtitle:nil type:SPMessageNotificationTypeSuccess];
            
            if (aSuccessBlock) {
                aSuccessBlock();
            }
        } else {
            /// 登录失败
            [[SPUtil sharedInstance] showNotificationInViewController:self.appDelegate.window.rootViewController title:@"登录失败" subtitle:aError.description type:SPMessageNotificationTypeError];
            NSLog(@"%d",aError.code);
            if (pwdAccountFail) {
                 pwdAccountFail(aError.code);
            }
           
        }
    }];
}

/**
 *  监听连接状态
 */
- (void)exampleListenConnectionStatusWithLoginController:(loginViewController *)LoginController
{
    __weak typeof(LoginController) weakController = LoginController;
    
    [[self.appDelegate.ywIMKit.IMCore getLoginService] addConnectionStatusChangedBlock:^(YWIMConnectionStatus aStatus, NSError *aError) {
        if (aStatus == YWIMConnectionStatusForceLogout || aStatus == YWIMConnectionStatusMannualLogout || aStatus == YWIMConnectionStatusAutoConnectFailed) {
            /// 手动登出、被踢、自动连接失败，都退出到登录页面
            [[SPUtil sharedInstance] showNotificationInViewController:weakController title:@"退出登录" subtitle:nil type:SPMessageNotificationTypeWarning];
            [weakController.navigationController popToViewController:weakController animated:YES];
        }
    } forKey:[self description] ofPriority:YWBlockPriorityDeveloper];
}


/**
 *  注销的示例代码
 */
- (void)exampleLogout
{
    [[self.appDelegate.ywIMKit.IMCore getLoginService] asyncLogoutWithCompletionBlock:NULL];
}


#pragma mark - abilities

- (void)exampleSetProfile
{
    /// IM会在需要显示profile时，调用这个block，来获取用户的头像和昵称
    [self.appDelegate.ywIMKit setFetchProfileBlock:^(YWPerson *aPerson, YWFetchProfileCompletionBlock aCompletionBlock) {
        /// 理论上您一般会从服务器异步获取用户的profile信息，在成功后调用aCompletionBlock，将结果告诉IM
        /// 在我们的示例代码中，则直接从本地获取
        [UserTool requestUserWithPath:kGetMyInfoPath UserPhone:aPerson.personId success:^(User *user) {
            NSString *name = user.nickName;
            NSLog(@"usernick = %@",user.nickName);
            UIImageView *tmpImage= [[UIImageView alloc]init];
                [tmpImage setImageWithURL:[NSURL URLWithString:user.imgUrl] placeholderImage:[UIImage imageNamed:@"avatar_default_big.png"] options:SDWebImageLowPriority|SDWebImageRetryFailed];
            UIImage *avatar = tmpImage.image;
          
            
            aCompletionBlock(YES, aPerson, name, avatar);
        } fail:^{
             NSLog(@"加载个人信息失败");
        }];
       
    }];
}


#pragma mark - ui pages

/**
 *  创建会话列表页面
 */
- (YWConversationListViewController *)exampleMakeConversationListControllerWithSelectItemBlock:(YWConversationsListDidSelectItemBlock)aSelectItemBlock
{
    YWConversationListViewController *result = [self.appDelegate.ywIMKit makeConversationListViewController];
    
    [result setDidSelectItemBlock:aSelectItemBlock];
    
    return result;
}

/**
 *  打开某个会话
 */
- (void)exampleOpenConversationViewControllerWithConversation:(YWConversation *)aConversation fromNavigationController:(UINavigationController *)aNavigationController
{
    YWConversationViewController *conversationController = [self.appDelegate.ywIMKit makeConversationViewControllerWithConversationId:aConversation.conversationId];
    
    [aNavigationController pushViewController:conversationController animated:YES];
    [aNavigationController setNavigationBarHidden:NO];
    
    /// 添加自定义插件
    [self exampleAddInputViewPluginToConversationController:conversationController];
    
    /// 设置显示自定义消息
    [self exampleShowCustomMessageWithConversationController:conversationController];
}


/**
 *  打开单聊页面
 */
- (void)exampleOpenConversationViewControllerWithPerson:(YWPerson *)aPerson fromNavigationController:(UINavigationController *)aNavigationController
{
    YWConversation *conversation = [YWP2PConversation fetchConversationByPerson:aPerson creatIfNotExist:YES baseContext:self.appDelegate.ywIMKit.IMCore];
    
    [self exampleOpenConversationViewControllerWithConversation:conversation fromNavigationController:aNavigationController];
}

/**
 *  打开群聊页面
 */
- (void)exampleOpenConversationViewControllerWithTribe:(YWTribe *)aTribe fromNavigationController:(UINavigationController *)aNavigationController
{
    YWConversation *conversation = [YWTribeConversation fetchConversationByTribe:aTribe createIfNotExist:YES baseContext:self.appDelegate.ywIMKit.IMCore];
    
    [self exampleOpenConversationViewControllerWithConversation:conversation fromNavigationController:aNavigationController];
}


#pragma mark - Customize

/**
 *  添加输入面板插件
 */
- (void)exampleAddInputViewPluginToConversationController:(YWConversationViewController *)aConversationController
{
    /// 创建自定义插件
    SPInputViewPluginCustomize *plugin = [[SPInputViewPluginCustomize alloc] init];
    /// 添加插件
    [aConversationController.messageInputView addPlugin:plugin];
}

/**
 *  发送自定义消息
 */
- (void)exampleSendCustomMessageWithConversationController:(YWConversationViewController *)aConversationController
{
    /// 构建一个自定义消息
    YWMessageBodyCustomize *body = [[YWMessageBodyCustomize alloc] initWithMessageCustomizeContent:@"Hi!" summary:@"您收到一个招呼"];
    
    /// 发送该自定义消息
    [aConversationController.conversation asyncSendMessageBody:body progress:^(CGFloat progress, NSString *messageID) {
        NSLog(@"消息发送进度:%lf", progress);
    } completion:^(NSError *error, NSString *messageID) {
        if (error.code == 0) {
            [[SPUtil sharedInstance] showNotificationInViewController:aConversationController title:@"打招呼成功!" subtitle:nil type:SPMessageNotificationTypeSuccess];
        } else {
            [[SPUtil sharedInstance] showNotificationInViewController:aConversationController title:@"打招呼失败!" subtitle:nil type:SPMessageNotificationTypeError];
        }
    }];
}

/**
 *  设置如何显示自定义消息
 */
- (void)exampleShowCustomMessageWithConversationController:(YWConversationViewController *)aConversationController
{
    /// 设置用于显示自定义消息的ViewModel
    /// ViewModel，顾名思义，一般用于解析和存储结构化数据
    [aConversationController setHook4BubbleViewModel:^YWBaseBubbleViewModel *(id<IYWMessage> message) {
        if ([[message messageBody] isKindOfClass:[YWMessageBodyCustomize class]]) {
            SPBubbleViewModelCustomize *viewModel = [[SPBubbleViewModelCustomize alloc] initWithMessage:message];
            return viewModel;
        }
        
        return nil;
    }];
    
    /// 设置用于显示自定义消息的ChatView
    /// ChatView一般从ViewModel中获取已经解析的数据，用于显示
    [aConversationController setHook4BubbleView:^YWBaseBubbleChatView *(YWBaseBubbleViewModel *message) {
        if ([message isKindOfClass:[SPBubbleViewModelCustomize class]]) {
            SPBaseBubbleChatViewCustomize *chatView = [[SPBaseBubbleChatViewCustomize alloc] init];
            return chatView;
        }
        
        return nil;
    }];
}


#pragma mark - events

/**
 *  监听新消息
 */
- (void)exampleListenNewMessage
{
    [self.appDelegate.ywIMKit setOnNewMessageBlock:^(NSString *aSenderId, NSString *aContent, NSInteger aType, NSDate *aTime) {
        /// 你可以播放您的提示音
         [LZAudioTool playMusic:@"消息提示音.wav"];
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }];
}

/**
 * 头像点击事件
 */
- (void)exampleListenOnClickAvatar
{
    [self.appDelegate.ywIMKit setOpenProfileBlock:^(YWPerson *aPerson, UIViewController *aParentController) {
        /// 您可以打开该用户的profile页面
        [[SPUtil sharedInstance] showNotificationInViewController:aParentController title:@"打开profile" subtitle:aPerson.description type:SPMessageNotificationTypeMessage];
    }];
}


/**
 *  链接点击事件
 */
- (void)exampleListenOnClickUrl
{
    [self.appDelegate.ywIMKit setOpenURLBlock:^(NSString *aURLString, UIViewController *aParentController) {
        /// 您可以使用您的容器打开该URL
        [[SPUtil sharedInstance] showNotificationInViewController:aParentController title:@"打开链接" subtitle:aURLString type:SPMessageNotificationTypeMessage];
    }];
}


#pragma mark - apns

/**
 *  设置DeviceToken
 */
- (void)exampleSetDeviceToken:(NSData *)aDeviceToken
{
    [[SPUtil sharedInstance] showNotificationInViewController:self.appDelegate.window.rootViewController title:@"设置DeviceToken" subtitle:aDeviceToken.description type:SPMessageNotificationTypeMessage];
    
    [[[YWAPI sharedInstance] getGlobalPushService] setDeviceToken:aDeviceToken];
}

/**
 *  处理启动时APNS消息
 */
//- (void)exampleHandleAPNSWithLaunchOptions:(NSDictionary *)aLaunchOptions
//{
//    /// 初始化->登录->打开单聊页面
//    
//    __weak typeof(self) weakSelf = self;
//    
//    NSString *userID, *password;
//    [loginViewController getLastUserID:&userID lastPassword:&password];
//    
//    [[[YWAPI sharedInstance] getGlobalPushService] handleLaunchOptionsV2:aLaunchOptions completionBlock:^(NSDictionary *aAPS, NSString *aConversationId, __unsafe_unretained Class aConversationClass) {
//        [weakSelf exampleInitWithSuccessBlock:^{
//            [weakSelf exampleLoginWithUserID:userID password:password successBlock:^{
//                YWConversation *conversation = nil;
//                if (aConversationClass == [YWP2PConversation class]) {
//                    conversation = [YWP2PConversation fetchConversationByConversationId:aConversationId creatIfNotExist:YES baseContext:weakSelf.appDelegate.ywIMKit.IMCore];
//                } else if (aConversationClass == [YWTribeConversation class]) {
//                    conversation = [YWTribeConversation fetchConversationByConversationId:aConversationId creatIfNotExist:YES baseContext:weakSelf.appDelegate.ywIMKit.IMCore];
//                }
//                if (conversation) {
//                    UINavigationController *nvc = [weakSelf.appDelegate.window.rootViewController isKindOfClass:[UINavigationController class]] ? (UINavigationController *)(weakSelf.appDelegate.window.rootViewController) : nil;
//                    [weakSelf exampleOpenConversationViewControllerWithConversation:conversation fromNavigationController:nvc];
//                }
//            }];
//        }];
//    }];
//    
//}
//
///**
// *  处理运行时APNS消息
// */
//- (void)exampleHandleRunningAPNSWithUserInfo:(NSDictionary *)aUserInfo
//{
//    __weak typeof(self) weakSelf = self;
//
//    UIApplicationState state = [UIApplication sharedApplication].applicationState;
//    [[[YWAPI sharedInstance] getGlobalPushService] handlePushUserInfoV2:aUserInfo completionBlock:^(NSDictionary *aAPS, NSString *aConversationId, __unsafe_unretained Class aConversationClass) {
//        if (state != UIApplicationStateActive) {
//            /// 应用从后台划开
//            /// 直接打开会话
//            YWConversation *conversation = nil;
//            if (aConversationClass == [YWP2PConversation class]) {
//                conversation = [YWP2PConversation fetchConversationByConversationId:aConversationId creatIfNotExist:YES baseContext:weakSelf.appDelegate.ywIMKit.IMCore];
//            } else if (aConversationClass == [YWTribeConversation class]) {
//                conversation = [YWTribeConversation fetchConversationByConversationId:aConversationId creatIfNotExist:YES baseContext:weakSelf.appDelegate.ywIMKit.IMCore];
//            }
//            if (conversation) {
//                UINavigationController *nvc = [weakSelf.appDelegate.window.rootViewController isKindOfClass:[UINavigationController class]] ? (UINavigationController *)(weakSelf.appDelegate.window.rootViewController) : nil;
//                [weakSelf exampleOpenConversationViewControllerWithConversation:conversation fromNavigationController:nvc];
//            }
//        } else {
//            /// 应用处于前台
//            /// 建议不做处理，等待IM连接建立后，收取离线消息。
//        }
//    }];
//}


@end
