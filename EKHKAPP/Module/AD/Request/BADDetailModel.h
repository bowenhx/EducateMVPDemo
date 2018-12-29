/**
 - BADDetailModel.h
 - BADSdk
 - Created by HY on 2017/12/15.
 - Copyright © 2017年 BaByKingdom. All rights reserved.
 - 广告请求返回的model，一条广告的详细数据
 */

#import <Foundation/Foundation.h>

//实现NSCoding协议，因为要做本地存储广告对象
@interface BADDetailModel : NSObject <NSCoding>

//广告识别码
@property (nonatomic, copy) NSString *bannerid;

//当前返回的广告类型：[1:image  2:html  3:text, 4:video]
@property (nonatomic, copy) NSString *ad_type;

//广告内容的高度
@property (nonatomic, assign) NSInteger  height;

//广告内容的宽度
@property (nonatomic, assign) NSInteger  width;

//广告内容
@property (nonatomic, copy) NSString *content;

//点击后跳转的地址
@property (nonatomic, copy) NSString *landing;

//多少秒钟后自动隐藏广告, = 0 时不需要处理
@property (nonatomic, assign) NSInteger expirytime;

//当广告成功加载完成后，请求返回的URL，告诉服务器广告显示成功
@property (nonatomic, strong) NSArray *imptracker;

//是否把广告缓存到本地[0=不缓存；1=缓存]
@property (nonatomic, assign) NSInteger cache;

//一串hash碼，用来判断广告内容是否有更新，如果有变动则更新缓存内容
@property (nonatomic, copy) NSString *hashcheck;

//广告时间间隔，单位秒
@property (nonatomic, assign) NSInteger deliveryInterval;

//广告显示动画[0:沒有 1:溶入 2:由左入 3:由右入 4:向上入 5:向下入]
@property (nonatomic, assign) NSInteger  animation;

//关闭按钮的位置0=不显示；1=左上角；2=右上；3=左下；4=右下]
@property (nonatomic, assign) NSInteger  cbposition;

//关闭按钮延迟显示的时间（秒）：[-1=不显示关闭按钮；0=不延迟显示]
@property (nonatomic, assign) NSInteger  cbdelay;

//广告的动画展示所用的速度。默认：500
@property (nonatomic, assign) NSInteger  action_duration;


#pragma mark -  下面为扩展字段
//用来存储广告显示完成后的时间戳
@property (nonatomic, assign) double lastShowTime;

//popup广告，距离屏幕底部的距离v
// 例如：弹窗广告如果在一级界面，不能遮挡底部tabbar，需要传递距离底部高度
@property (nonatomic, assign) CGFloat vPopupBottomHeight;

@end
