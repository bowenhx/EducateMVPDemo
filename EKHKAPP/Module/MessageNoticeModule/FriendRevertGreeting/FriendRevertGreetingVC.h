//
//  FriendRevertGreetingVC.h
//  BKMobile
//
//  Created by 薇 颜 on 15/8/1.
//  Copyright (c) 2015年 com.mobile-kingdom.bkapps. All rights reserved.
//
/**
 *  回覆打招呼
 */
#import "EKBaseViewController.h"
#import "EKNoticeListModel.h"

@protocol FriendRevertGreetingVCDelegate;

@interface FriendRevertGreetingVC : EKBaseViewController
@property (nonatomic, strong) EKNoticeListModel *vNoticeListModel;
@property (nonatomic, weak) id <FriendRevertGreetingVCDelegate> vDelegate;
@end

@protocol FriendRevertGreetingVCDelegate <NSObject>
//当用户点击完"忽略"/"发送"并完成数据上传后进行的回调
- (void)mFriendRevertGreetingVCDidFinish:(FriendRevertGreetingVC *)friendRevertGreetingVC;
@end
