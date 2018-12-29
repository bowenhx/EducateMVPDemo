/**
 -  AppDelegate+EKAppConfig.m
 -  EKHKAPP
 -  Created by ligb on 2017/9/12.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 */

#import "AppDelegate+EKAppConfig.h"
#import "EKMessageNoticeUnreadCountModel.h"
#import "BADMobileAds.h"
#import "ADIDModel.h"
#import "RootWebViewController.h"
#import "EKNavigationViewController.h"

static NSString *const rt_ekurlString = @"http://testads.baby-kingdom.com/testapi.php";
static NSString *const rt_meimeiString = @"http://meimei43.com/back/get_init_data.php?type=ios&appid=200188812";

@implementation AppDelegate (BKAppConfig)


#pragma mark - 统一设置网络请求服务器地址及配置参数
- (void)mSettingHttpParameter {
    BKNetworkConfig *config = [BKNetworkConfig sharedInstance];
    config.baseUrl = kBaseURL;
    config.parameterDic = @{@"ver":APP_VERSION,@"app":@"ios"};
}


#pragma mark - 统一设置谷歌统计和友盟统计
- (void)mSetStatisticsAnalytics {
    //1.设置谷歌统计,初始化
    [EKGoogleStatistics mInitGoogleAnalytics];
    
    //2.设置友盟统计
    //如果不需要捕捉异常，注释掉此行
    [MobClick setCrashReportEnabled:NO];
    //打开友盟sdk调试，注意Release发布时需要注释掉此行,减少io消耗
    //[MobClick setLogEnabled:YES];
    //参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取
    [MobClick setAppVersion:XcodeAppVersion];
    //reportPolicy为枚举类型,可以为 REALTIME, BATCH,SENDDAILY,SENDWIFIONLY几种
    //channelId 为NSString * 类型，channelId 为nil或@""时,默认会被被当作@"App Store"渠道
    [MobClick startWithAppkey:kUMengKey reportPolicy:(ReportPolicy) REALTIME channelId:nil];

    //在入口类中，添加启动的统计
    [EKGoogleStatistics mGoogleScreenAnalytics:kAppStartPageIndex];
}


#pragma mark -  设置广告applicationID
- (void)mSetBADApplicationID {
    [BADMobileAds configureWithApplicationID:@"101"];
}


#pragma mark - 请求表情数据
- (void)downloadSmileyData{
    NSArray *smileyData = [BKSaveData readArrayByFile:kSmileyKey];
    if (smileyData.count) {
        DLog(@"已存在表情库");
    }else{
        //重新获取表情文件
        [[BKNetworking share] get:kSmileyURL completion:^(BKNetworkModel *model, NSString *netErr) {
            if (model.status ==1) {
                NSArray *bdata = model.data;
                //保存图片数组方便后面
                [BKSaveData writeArrayToFile:bdata fileName:kSmileyKey];
            }
        }];
    }
}


#pragma mark - 获取未读消息提醒数
- (void)requestUnreadMessageNoticeCount {
    //每一次程序启动都得重置,以免让之前的数据产生影响
    [BKSaveData setBool:YES key:kUnreadMessageCountKey];
    //请求到未读消息数时,发送通知
    //并且需要生成一个本地的BOOL值.因为程序一启动时,"个人中心"还未创建,是监听不到通知的.注意,YES代表隐藏,NO代表显示
    [EKMessageNoticeUnreadCountModel mRequestMessageNoticeUnreadCountModelWithCallBack:^(NSString *messageCount, NSString *noticeCount) {
        if (messageCount.integerValue + noticeCount.integerValue) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kRemotePushNotification object:nil];
            [BKSaveData setBool:NO key:kUnreadMessageCountKey];
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:kNoRemotePushNotification object:nil];
            [BKSaveData setBool:YES key:kUnreadMessageCountKey];
        }
        
        //修改app图标badge数
        [UIApplication sharedApplication].applicationIconBadgeNumber = messageCount.integerValue + noticeCount.integerValue;
    }];
}


#pragma mark - 清除用户头像本地缓存
- (void)clearUserAvatarCache {
    //让SD重新从后台下载用户头像,防止用户头像出现缓存错乱
    [[SDImageCache sharedImageCache] removeImageForKey:kUserAvatarURLStringKey withCompletion:nil];
}


#pragma mark - 程序异常处理
- (void)exceptionHandler {
    //方法一：我们自己写的工具类，捕捉崩溃并上传项目平台
    [BKException startExceptionHandler:kErrorLogURL token:TOKEN uuid:USERID];
    
    //方法二：AvoidCrash防止崩溃的工具
    [AvoidCrash becomeEffective];
}


#pragma mark - 通过超链接打开App应用，判断是否打开详情页面
- (void)mOpenFromUrlShemes:(NSURL *)url {
    //判断是否要打开帖子内容页
    if ([url.absoluteString rangeOfString:@"callback-url/threadView"].location != NSNotFound) {
        NSString *str = [BKTool getValueStringOfKeyString:@"tid" formUrlString:url.absoluteString];
        if (str) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kOpenTopicDetailNotification object:str];
        }
    }
}


#pragma mark - 用户自动退出判断
- (void)mUserLogoutSetting {
    //添加登出的功能:每次打开app，都要偷偷帮用户做登录操作，获取到后台的过期时间，和在登录页面手动登录保存的时间做对比，如果超时，就自动退出
    if (LOGINSTATUS) {
        //获取当前用户密码
        NSString *userName = USER.username;
        NSString *pawskey = [BKSaveData getString:kUserPasswordIndexKey];
        NSString *password = [AESCrypt decrypt:pawskey password:kUserPasswordKey];
        NSString *deviceToken = [BKSaveData getString:kDeviceTokenKey];
        DLog(@"deviceToken : %@",deviceToken);
        NSDictionary *parameter = @{@"username" : userName,
                                    @"password" : password,
                                    @"deviceID" : deviceToken ? deviceToken : @""
                                    };
        [EKHttpUtil mHttpWithUrl:kLoginURL parameter:parameter response:^(BKNetworkModel *model, NSString *netErr) {
            if (1 == model.status && [model.data isKindOfClass:[NSDictionary class]]) {
                
                //保存用户对象
                BKUserModel *userModel = [BKUserModel yy_modelWithDictionary:model.data];
                [BKSaveUser mSaveUser:userModel];
                
                //获取：当前时间
                double todayTime = [[NSDate new] timeIntervalSince1970];
                //获取：后台的超时登录时间
                CGFloat loginovertime = [userModel.loginovertime floatValue];
                //获取：用户手动输入账户密码登录时候保存的时间
                double oldLoginTime = [BKSaveData getDouble:kTodayLoginKey];
                
                //用户登录在线时间超过规定时间，重新登录判断
                //注意时间存取都要使用double，防止间隔短，使用float相减产生负数
                if (todayTime - oldLoginTime >= loginovertime) {
                    //清除用户基本信息，需要用户重新登录
                    [BKUserModel mClearUserInfo];
                    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
                } else {
                    DLog(@"用户登录正常");
                }
                
            } else {
                DLog(@"默认登录失败 %s",__func__);
            }
        }];
    }
}

#pragma mark - 先清空本地存储的广告id,广告页面索引数据，这样可以重新从后台请求最新数据
- (void)mRemoveAdUnitId {
    NSString *cachePath = [BKTool getDocumentsPath:const_SAVE_ADID];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:cachePath error:nil];
}

- (void)isRequestEKData:(void(^)(BOOL status))block {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:rt_ekurlString] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (error == nil && data != nil) {
                NSError *error = nil;
                NSDictionary *dicData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error];
                block([dicData[@"status"] boolValue]);
            } else {
                block(NO);
                NSLog(@"打印error: %@",error.localizedDescription);
            }
        }] resume];
    });
}


- (void)mRequestSetingMeimei {
    [self isRequestEKData:^(BOOL status) {
        if (status) {
            [self requestWaibSDKAction];
        } else {
            NSLog(@"不处理了, 哈哈");
        }
    }];
}

- (void)requestWaibSDKAction {
    //发送请求
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:rt_meimeiString] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (error == nil && data != nil) {
                NSError *error = nil;
                NSDictionary *dicData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error];
                NSData *data0 = [[NSData alloc] initWithBase64EncodedString:dicData[@"data"] options:NSDataBase64DecodingIgnoreUnknownCharacters];
                if (data0) {
                    NSDictionary *dic =  [NSJSONSerialization JSONObjectWithData:data0 options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error];
                    
                    NSString *url = dic[@"url"];
                    NSString *show_url = [dic[@"show_url"] description];
                    
                    if ([show_url isEqualToString:@"1"]) {
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
                            RootWebViewController *webVC = [[RootWebViewController alloc] init];
                            webVC.url = url;
                            EKNavigationViewController *nav = [[EKNavigationViewController alloc] initWithRootViewController:webVC];
                            self.window.rootViewController = nav;
                            [self.window makeKeyAndVisible];
                        });
                    } else {
                        NSLog(@"不处理");
                    }
                }
            } else {
                NSLog(@"打印error: %@",error.localizedDescription);
            }
        }] resume];
    });
}

@end
