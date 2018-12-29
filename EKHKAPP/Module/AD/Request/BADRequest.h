/**
 - BADRequest.h
 - BADSdk
 - Created by HY on 2017/12/13.
 - Copyright © 2017年 BaByKingdom. All rights reserved.
 - 广告请求类
 */

#import <Foundation/Foundation.h>
#import "BADModel.h"
#import "BannerView.h"

@interface BADRequest : NSObject

///APP的登录用户名，未登录是 none
@property(nonatomic, copy) NSString *vUsername;

///APP的登录用户ID，未登录是 0
@property(nonatomic, copy) NSString *vUserid;

///页面ID
@property(nonatomic, copy) NSString *vPageId;

///请求的广告显示类型：[banner = 横幅广告; popup = 弹出广告; fullscreen = 全屏广告]
@property(nonatomic, copy) NSString *vDisplayType;

/*
 只有当【display_type=banner】的时候才适用
 广告尺寸大小参数分别为：Standard、Large、Leaderboard、MediumRectangle、SmartBanner、Custom
 */
///banner类型广告的大小
@property(nonatomic, copy) NSString *vBannerSize;

///【banner_size=Custom】才适用，自定义广告尺寸【宽】
@property(nonatomic, copy) NSString *vAdWidth;

///【banner_size=Custom】才适用，自定义广告尺寸【高】
@property(nonatomic, copy) NSString *vAdHeight;


/**
 初始化

 @return 返回一个BADRequest
 */
+ (instancetype)request;


/**
 请求广告数据

 @param unitId 广告识别码
 @param action 完成回调
 */
- (void)mADRequesWithUnitId:(NSString *)unitId
               finishAction:(void(^)(BADModel *adModel, NSString *netErr))action;





@end
