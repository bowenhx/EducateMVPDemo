/**
 - BKMobile
 - ShieldPostVC.h
 - Copyright (c) 2015年 com.mobile-kingdom.bkapps All rights reserved.
 - Created by Guibin on 15/12/18.
 - 说明： 屏蔽或解除屏蔽楼层
 */

#import "EKBaseViewController.h"
#import "ThreadsDetailModel.h"
#import "InvitationDataModel.h"

@interface ShieldPostVC : EKBaseViewController

@property (nonatomic) BOOL isShield;//已经屏蔽
@property (nonatomic, strong) NSDictionary *dictPost;
@property (nonatomic, strong) NSString *subject;
@property (nonatomic) BOOL isFromThread;

+(void)push:(UIViewController *)vc detailModel:(ThreadsDetailModel *)detailModel dataModel:(InvitationDataModel *)dataModel;
@end
