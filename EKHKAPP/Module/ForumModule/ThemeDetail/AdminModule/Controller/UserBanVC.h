//
//  UserBanVC.h
//  BKMobile
//
//  Created by 颜 薇 on 15/12/18.
//  Copyright © 2015年 com.mobile-kingdom.bkapps. All rights reserved.
//
/**禁止和解除禁止访问（针对用户）*/
/**禁止和解除禁止发言（针对用户）*/
#import "EKBaseViewController.h"
#import "InvitationDataModel.h"

typedef enum{
    UserBanTypeOfNoAccess,/**<禁止访问*/
    UserBanTypeOfNoSpeak/**<禁止发言*/
}UserBanType;
@interface UserBanVC : EKBaseViewController

@property (nonatomic) BOOL isBan;//已经禁止
@property (nonatomic, strong) NSString *author;
@property (nonatomic) NSInteger authorid;
@property (nonatomic) BOOL isFromThread;
@property (nonatomic) UserBanType userBanType;

+(void)push:(UIViewController *)vc dataModel:(InvitationDataModel *)dataModel groupid:(NSInteger)groupid userBanType:(UserBanType)userBanType;

@end
