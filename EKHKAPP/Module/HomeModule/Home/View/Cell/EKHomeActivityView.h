/**
 -  EKHomeActivityView.h
 -  EKHKAPP
 -  Created by ligb on 2017/9/18.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明：
 */

#import <UIKit/UIKit.h>

@interface EKHomeActivityView : UIView

@property (nonatomic, copy) void (^updataDate)(NSString *date);

+ (EKHomeActivityView *)getHomeActivityView;

@property (nonatomic, copy) NSString *vUpdate;

@end
