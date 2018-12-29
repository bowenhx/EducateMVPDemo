//
//  EKHomeADModel.h
//  EKHKAPP
//
//  Created by HY on 2017/11/15.
//  Copyright © 2017年 BaByKingdom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EKHomeADModel : NSObject

@property (nonatomic, copy) NSString *order;
@property (nonatomic, copy) NSString *webview;

+ (void)mRequestHomeAD:(void(^)(NSString *netErr, NSArray<EKHomeADModel *>*homeADSource))callBack;


@end
