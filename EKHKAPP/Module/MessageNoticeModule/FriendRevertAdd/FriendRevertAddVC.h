//
//  FriendRevertAddVC.h
//  BKMobile
//
//  Created by 薇 颜 on 15/7/31.
//  Copyright (c) 2015年 com.mobile-kingdom.bkapps. All rights reserved.
//
/**
 *  回应好友请求
 */
#import "EKBaseViewController.h"
#import "EKNoticeListModel.h"

@protocol FriendRevertAddVCDelegate;

@interface FriendRevertAddVC : EKBaseViewController
@property (nonatomic, strong) EKNoticeListModel *vNoticeListModel;
@property (nonatomic, weak) id <FriendRevertAddVCDelegate> vDelegate;
@end


@protocol FriendRevertAddVCDelegate <NSObject>
//当用户点击完"忽略"/"批准"并完成数据上传后进行的回调
- (void)mFriendRevertAddVCDidFinish:(FriendRevertAddVC *)friendRevertAddVC;
@end

