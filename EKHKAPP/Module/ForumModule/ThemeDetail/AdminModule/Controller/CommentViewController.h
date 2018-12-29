/**
 - BKMobile
 - CommentViewController.h
 - Copyright (c) 2015年 com.mobile-kingdom.bkapps All rights reserved.
 - Created by Guibin on 15/8/7.
 - 说明：查看点评列表页,通过帖子详情进入该页面，该页面和帖子详情一样，都涉及到图文混排处理
 */

#import <UIKit/UIKit.h>
#import "EKBaseViewController.h"
@interface CommentViewController : EKBaseViewController

@property (nonatomic , assign)NSUInteger tid;
@property (nonatomic , assign)NSUInteger pid;

@property (nonatomic , copy) NSArray *dataArr;

+(void)pushCommentVC:(NSUInteger)tid pid:(NSUInteger)pid dataArr:(NSArray *)dataArr vc:(UIViewController *)vc;


@end
