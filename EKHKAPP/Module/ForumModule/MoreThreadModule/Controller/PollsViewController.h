/**
 - BKMobile
 - PollsViewController.h
 - Copyright (c) 2015年 com.mobile-kingdom.bkapps All rights reserved.
 - Created by 薇 颜 on 15/11/16.
 - 说明： 投票页面
 */

#import "EKBaseViewController.h"
#import "ThreadPollsView.h"
@interface PollsViewController : EKBaseViewController

@property (nonatomic, assign) NSInteger password;      /**<帖子密码*/
@property (nonatomic, strong) NSNumber *tid;            /**<帖子ID*/
@property (nonatomic, strong) ThreadPollsView *pollsView;   /**<帖子內容頁投票塊的view*/
@end
