/**
 - BADRequest.m
 - BADSdk
 - Created by HY on 2017/12/13.
 - Copyright © 2017年 BaByKingdom. All rights reserved.
 */

#import "BADRequest.h"
#import "BADMobileAds.h"
#import "BADConfig.h"
#import "BADBaseView.h"
#import "BADWindow.h"
#import "BADSaveAdModel.h"

@interface BADRequest ()
@end


@implementation BADRequest

+ (instancetype)request {
    return [[BADRequest alloc] init];
}

#pragma mark - 请求广告
- (void)mADRequesWithUnitId:(NSString *)unitId finishAction:(void(^)(BADModel *adModel, NSString *netErr))action {
    BADMobileAds *mobile = [BADMobileAds sharedInstance];
    if (!mobile.vParames) {
        NSLog(@"please settings associated with the given application ID.");
        return;
    }
    
    //获取时间间隔未到的广告id
    NSArray *skipAdArray = [self mTimeInterval];
    
    //固定参数和可变参数组装
    NSDictionary *dicParameter = @{
                          @"device":mobile.vParames[@"device"],
                          @"app":mobile.vParames[@"app"],
                          @"user":@{
                                  @"username" : self.vUsername ? self.vUsername : @"none",
                                  @"userid" : self.vUserid ? self.vUserid : @"0",
                                  },
                          @"content":@{
                                  @"page_id" : self.vPageId ? self.vPageId : @"",
                                  @"ad_unitid" : unitId ? unitId : @"" ,
                                  @"display_type" : self.vDisplayType ? self.vDisplayType : @"",
                                  @"banner_size" :  @"", //TODO:这里暂时没有使用，后续可动态传递
                                  @"ad_width" : self.vAdWidth ? self.vAdWidth : @"",
                                  @"ad_height" : self.vAdHeight ? self.vAdHeight : @"",
                                  @"skipAd" : skipAdArray
                                  }
                          };
    
    NSLog(@"dicParameter = %@",dicParameter);
    
    [BADModel mRequestAdWithDic:dicParameter  block:action];
}

#pragma mark - 广告时间间隔逻辑
- (NSArray *)mTimeInterval {
    
    /** 广告间隔逻辑:需求说明
     1. 广告每次展示完成后需要保存上次的时间
     2. 再次请求前对比是否已经到达间隔的时间点(deliveryInterval)
     3.1 判断未到达间隔时间点的广告，在请求API时需要传递不显示bannerid给后台，这样后台就不会再返回对应的广告回来了
     3.2 判断间隔时间已经超过，删除当条广告间隔数据,对应的bannerid不提交在skipAd里面
     */
    
    //获取本地存储的广告数据
    NSMutableArray *saveAdArray = [BADSaveAdModel mGetAdModel];
    
    //新建数组，存储需要忽略的广告id
    NSMutableArray *skipAdArray = [NSMutableArray array];
    
    if (saveAdArray.count > 0) {
        
        //临时数组，用途：删除已经超过时间间隔的广告id数据后，重新保存
        NSMutableArray *tempArr = [NSMutableArray arrayWithArray:saveAdArray];
        
        //获取当前时间
        double todayTime = [[NSDate new] timeIntervalSince1970];
        
        for (BADDetailModel *adModel in saveAdArray) {
            
            NSInteger deliveryInterval = adModel.deliveryInterval;
            double lastShowTime = adModel.lastShowTime;
            
            if (todayTime - lastShowTime > deliveryInterval) {
                //删除超过时间间隔的广告数据
                [tempArr removeObject:adModel];
            } else {
                //未到达间隔时间点的广告，存储id给后台传过去
                [skipAdArray addObject:adModel.bannerid];
            }
        }

        //删除已经超出时间间隔的广告数据后，更新本地存储的广告数据
        [BADSaveAdModel mUpdataAdModel:tempArr];
    }
    
    //去掉相同的广告id
    NSSet *set = [NSSet setWithArray:skipAdArray];
    NSLog(@"%@",[set allObjects]);
    
    return [set  allObjects];
}

@end

