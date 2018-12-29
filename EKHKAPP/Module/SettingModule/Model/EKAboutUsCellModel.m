/**
 -  EKAboutUsCellModel.m
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/11/8.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:这是管理"关于我们"界面的cell的model
 */

#import "EKAboutUsCellModel.h"

@implementation EKAboutUsCellModel
+ (NSArray <EKAboutUsCellModel *>*)mGetAboutUsCellModelArray {
    return @[
             [self aboutUsCellWithTitle:@"喜歡我們，評分鼓勵" selectorName:@"mLikeUs"],
             [self aboutUsCellWithTitle:@"分享給朋友" selectorName:@"mShare"],
             [self aboutUsCellWithTitle:@"關於 Edu Kingdom" selectorName:@"mAboutEduKingdom"],
             [self aboutUsCellWithTitle:@"隱私條例" selectorName:@"mPrivacy"]
             ];
}


+ (instancetype)aboutUsCellWithTitle:(NSString *)title
                        selectorName:(NSString *)selectorName {
    EKAboutUsCellModel *model = [[EKAboutUsCellModel alloc] init];
    model.vTitle = title;
    model.vSelectorName = selectorName;
    return model;
}
@end
