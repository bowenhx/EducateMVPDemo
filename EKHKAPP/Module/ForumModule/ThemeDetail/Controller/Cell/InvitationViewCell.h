//
//  InvitationViewCell.h
//  BKMobile
//
//  Created by Guibin on 15/8/3.
//  Copyright (c) 2015年 com.mobile-kingdom.bkapps. All rights reserved.
//
/**
 *  帖子详情Cell
 */
#import <UIKit/UIKit.h>
#import "InvitationDataModel.h"
#import "ThreadActivityView.h"
#import "ThreadPollsView.h"
#define kActivityViewHeight  350
#define kPollsViewHeight    40
typedef NS_ENUM(NSInteger, ThreadType) {
    ThreadTypeNormal = 0,   /**<正常*/
    ThreadTypePolls = 1,    /**<投票*/
    ThreadTypeActivity = 4  /**<活动*/
};

@interface InvitationViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *iconBtn;

@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (weak, nonatomic) IBOutlet UIButton *commentBtn;

@property (weak, nonatomic) IBOutlet UIButton *reportBtn;

@property (weak, nonatomic) IBOutlet UIButton *manageBtn;

@property (weak, nonatomic) IBOutlet UIButton *editBtn;

@property (weak, nonatomic) IBOutlet UIButton *revertBtn;

@property (nonatomic , strong) InvitationDataModel *item;

@property (nonatomic, assign) ThreadType threadType;

@property (nonatomic, strong) ThreadActivityView *activityView;
@property (nonatomic, assign) NSDictionary *threadacts;/**<活动贴传递过来的信息*/

@property (nonatomic, strong) ThreadPollsView *pollsView;
@property (nonatomic, assign) NSDictionary  *threadpolls;/**<投票贴传递过来的信息*/

@end
