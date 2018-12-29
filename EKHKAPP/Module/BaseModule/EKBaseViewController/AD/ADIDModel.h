//
//  ADIDModel.h
//  EKHKAPP
//
//  Created by HY on 2018/3/15.
//  Copyright © 2018年 BaByKingdom. All rights reserved.
//

#import <Foundation/Foundation.h>

//广告id和广告页面索引值的请求地址
static NSString * const_ADID_REQUEST_URL = @"http://202.67.195.120/reqadulist?appid=101";

static NSString * const_SAVE_ADID = @"saveAdID";


@interface ADIDModel : NSObject <NSCoding>

//页面索引值
@property (nonatomic, copy) NSString *page_id;

//全屏广告id
@property (nonatomic, copy) NSString *fullscreen;

//popup广告id
@property (nonatomic, copy) NSString *popup;

//banner广告id
@property (nonatomic, strong) NSArray *banner;


//附加参数，用于记录请求页面的名称
@property (nonatomic, copy) NSString *pageID;



/**
 请求广告id和页面索引值，用于请求广告内容

 @param block 返回请求到的广告id数组
 */
- (void)mRequestAdID:(void(^)(NSArray <ADIDModel *> *adArray))block;

@end




