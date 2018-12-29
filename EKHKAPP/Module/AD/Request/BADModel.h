/**
 - BADModel.h
 - BADSdk
 - Created by HY on 2017/12/15.
 - Copyright © 2017年 BaByKingdom. All rights reserved.
 - 广告请求返回的model，广告的外层信息
 */

#import <Foundation/Foundation.h>
#import "BADDetailModel.h"


@interface BADModel : NSObject

//广告单元位置别码
@property (nonatomic, assign) NSInteger ad_unitid;

//请求的广告显示类型banner,popup,fullscreen
@property (nonatomic, copy) NSString *display_type;

//广告显示动画[0:沒有 1:溶入 2:由左入 3:由右入 4:向上入 5:向下入]
@property (nonatomic, assign) NSInteger animation;

//广告的动画展示所用的速度。默认：500
@property (nonatomic, assign) NSInteger action_duration;

//广告信息
@property (nonatomic, strong) BADDetailModel *ad_detail;

//pop放大尺寸的广告信息
@property (nonatomic, strong) BADDetailModel *bannerinfo_pop;

//扩展参数，popup广告，距离屏幕底部的距离
// 例如：弹窗广告如果在一级界面，不能遮挡底部tabbar，需要传递距离底部高度
@property (nonatomic, assign) CGFloat vPopupBottomHeight;


/**
 请求广告数据

 @param dicParameter   post请求参数
 @param block 返回请求到的数据模型，和网络错误信息
 */
+ (void)mRequestAdWithDic:(NSDictionary *)dicParameter
                      block:(void(^) (BADModel *adModel, NSString *netErr))block;

@end
