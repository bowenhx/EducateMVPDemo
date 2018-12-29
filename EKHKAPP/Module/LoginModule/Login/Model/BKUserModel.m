/**
 -  BKUserModel.m
 -  BKHKAPP
 -  Created by HY on 2017/8/9.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 */

#import "BKUserModel.h"
#import "BKUserHelper.h"
#import "AppDelegate.h"
#import "EKColumnView.h"
#import "EKMessageNoticeUnreadCountModel.h"

@implementation BKUserModel

#pragma mark - 编码 对user属性进行编码处理
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self yy_modelEncodeWithCoder:aCoder];
}

#pragma mark - 解码 解码归档数据来初始化对象
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    return [self yy_modelInitWithCoder:aDecoder];
}

#pragma mrak - 登录操作
- (void)mLoginWithWithUserName:(NSString*)userName password:(NSString*)password callBack:(void (^)(NSString *message))callBack {
   
    NSString *deviceToken = [BKSaveData getString:kDeviceTokenKey];
    
    NSDictionary *parameterDic = @{@"username" : userName,
                                   @"password" : password,
                                   @"deviceID" : deviceToken ? deviceToken : @""
                                   };
    [EKHttpUtil mHttpWithUrl:kLoginURL parameter:parameterDic response:^(BKNetworkModel *model, NSString *netErr) {
        if (netErr) {
            callBack(netErr);
        } else {
            NSString *message = model.message;
            if (1 == model.status) {
                NSDictionary *userDic = model.data;
                [self mLoginSuccessWithData:userDic password:password isHome:YES];
                callBack(kLoginModule_LoginSuccessText);
            } else {
                callBack(message);
            }
        }
    }];
}

#pragma mark - 用户登录成功后，保存数据等操作
- (void)mLoginSuccessWithData:(NSDictionary *)userData password:(NSString*)password isHome:(BOOL)isHome{
    //保存当前登录的用户对象
    BKUserModel *userModel = [BKUserModel yy_modelWithJSON:userData];
    [BKSaveUser mSaveUser:userModel];
    
    //google统计
    NSString *gLabel = [NSString stringWithFormat:@"uid=%@", USERID];
    [EKGoogleStatistics mGoogleActionAnalytics:kLoginPageIndex label:gLabel];
    
    //umeng统计
    [MobClick event:kLoginPageIndex attributes:@{@"uid": USERID}];
   
    //用户统计
    [BKUserHelper trackingUserDataForType:kLoginPageIndex dicExtraData:nil];
    
    //让SD重新从后台下载用户头像,防止用户头像出现缓存错乱
    [[SDImageCache sharedImageCache] removeImageForKey:kUserAvatarURLStringKey withCompletion:nil];
    
    //生成1个新的用户头像URL地址保存起来
    int randomNumber = arc4random() % 100;
    NSString *avatarUrlString = [NSString stringWithFormat:@"%@&random=%d",userModel.avatar,randomNumber];
    [BKSaveData setString:avatarUrlString key:kUserAvatarURLStringKey];
    
    //保存当前登录时间
    double loginTime =  [[NSDate new] timeIntervalSince1970];
    [BKSaveData setDouble:loginTime  key:kTodayLoginKey];
    
    //保存用户密码，并生成加密文件
    NSString *pass = [AESCrypt encrypt:password password:kUserPasswordKey];
    [BKSaveData setString:pass key:kUserPasswordIndexKey];
    
    //登录成功以后，发送一个通知，供其他页面监听登录状态，刷新页面
    if (isHome) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSuccessNotification object:nil];
    }
    
    //注册推送消息
    [[AppDelegate share] registerNotification];
    
    //本地收藏数据清空
    //[EKColumnView mReloadData];
    
    //请求到未读消息数时,发送通知,供其他界面更新UI
    [EKMessageNoticeUnreadCountModel mRequestMessageNoticeUnreadCountModelWithCallBack:^(NSString *messageCount, NSString *noticeCount) {
        if (messageCount.integerValue + noticeCount.integerValue) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kRemotePushNotification object:nil];
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:kNoRemotePushNotification object:nil];
        }
        //修改app图标badge数
        [UIApplication sharedApplication].applicationIconBadgeNumber = messageCount.integerValue + noticeCount.integerValue;
    }];
}


/**
 用户退出登录的处理
 
 @param callBack 退出登录后完成的回调
 */
+ (void)mLogOutWithCallBack:(void(^)(NSString *netErr))callBack {
    NSDictionary *parameter = @{@"token" : TOKEN};
    [EKHttpUtil mHttpWithUrl:kLoginoutURL
                   parameter:parameter
                    response:^(BKNetworkModel *model, NSString *netErr) {
                        if (netErr) {
                            callBack(netErr);
                        } else {
                            if (1 == model.status) {
                                //删除用户信息
                                [self mClearUserInfo];
                                //发送登出的通知
                                [[NSNotificationCenter defaultCenter] postNotificationName:kQuitLoginNotifation object:nil];
                                //发送没有推送通知的通知
                                [[NSNotificationCenter defaultCenter] postNotificationName:kNoRemotePushNotification object:nil];
                                //修改app图标badge数
                                [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
                                callBack(nil);
                            } else {
                                callBack(model.message);
                            }
                        }
                    }];
}


/**
 用户退出后，清空当前用户信息
 */
+ (void)mClearUserInfo {

    //清除编辑帖子保存的本地图片, 注意：这个清空用到了userid，所以要在清空用户之前写
    [BKUserHelper removeImagePath];
    
    //清除用户对象数据
    [BKSaveUser mSaveUser:nil];
    
    //清除用户登录密码
    [BKSaveData setString:@"" key:kUserPasswordIndexKey];
    
    //清除帖子密码
    [BKSaveData setDictionary:nil key:kForumPasswordKey];
    
    //清除相册保存密码
    [BKSaveData setDictionary:nil key:kPhotoAlbumPasswordKey];
    
    //清除表情
    [BKSaveData deleteArrayFromFile:kSmileyKey];
    
    //清除缓存编辑发帖信息
    [BKSaveData setArray:nil key:kCommentKey];
    
    //修改帖子排序
    [BKSaveData setInteger:0 key:kTopicDetailOrderKey];
    
    /**
     * 设置默认推送打开
     */
    [BKSaveData setString:@"1" key:kNotificationsSwitchKey];
    
    //清除启动页面广告缓存
    [BKSaveData writeDicToFile:@{} fileName:kStartAdLaunchKey];
    
    //清空底部tabbar上，个人中心按钮的小红点
    [[NSNotificationCenter defaultCenter] postNotificationName:kNoRemotePushNotification object:nil];
    
    //清除推送消息表示
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
}

@end

