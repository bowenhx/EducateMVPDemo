//
//  ThreadPollsView.h
//  BKMobile
//
//  Created by 薇 颜 on 15/11/16.
//  Copyright © 2015年 com.mobile-kingdom.bkapps. All rights reserved.
//
/**
 *  帖子内容页的投票展示块
 */
#import <UIKit/UIKit.h>


@interface ThreadPollsView : UIView

@property (nonatomic, assign) NSInteger password;      /**<帖子密码*/
@property (nonatomic, strong) NSNumber *tid;            /**<帖子ID*/
@property (nonatomic, strong) NSDictionary *threadpolls;/**<投票贴传递过来的信息*/
@property (nonatomic, strong) UIViewController *viewController;
@end
