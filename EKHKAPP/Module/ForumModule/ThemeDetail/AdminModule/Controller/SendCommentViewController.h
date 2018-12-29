 /**
 - BKMobile
 - SendCommentViewController.h
 - Copyright (c) 2015年 com.mobile-kingdom.bkapps All rights reserved.
 - Created by bowen on 16/4/1.
 - 说明：发布点评页面
 */

#import <UIKit/UIKit.h>
#import "EKBaseViewController.h"
#import "ThreadsDetailModel.h"
#import "InvitationDataModel.h"

@interface SendCommentViewController : EKBaseViewController

@property (nonatomic , copy) NSDictionary *dicInfo;

+(void)push:(UIViewController *)vc detailModel:(ThreadsDetailModel *)detailModel dataModel:(InvitationDataModel *)dataModel pwd:(NSInteger)pwd;
 
@end
