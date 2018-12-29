/**
 - BKMobile
 - WarningPostVC.h
 - Copyright (c) 2015年 com.mobile-kingdom.bkapps All rights reserved.
 - Created by 颜 薇 on 15/12/18.
 - 说明：警告和解除警告楼层
 */

#import "EKBaseViewController.h"
#import "ThreadsDetailModel.h"
#import "InvitationDataModel.h"

@interface WarningPostVC : EKBaseViewController

@property (nonatomic) BOOL isWarning;//已经警告
@property (nonatomic, strong) NSDictionary *dictPost;
@property (nonatomic, strong) NSString *subject;
@property (nonatomic) BOOL isFromThread;

+(void)push:(UIViewController *)vc detailModel:(ThreadsDetailModel *)detailModel dataModel:(InvitationDataModel *)dataModel;
@end
