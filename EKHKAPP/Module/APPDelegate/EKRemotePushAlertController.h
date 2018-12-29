/**
 -  EKRemotePushAlertController.h
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/12/21.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:这是接收到远程推送时候,如果推送类型为JX时,需要显示的弹窗
 */

#import <UIKit/UIKit.h>

@interface EKRemotePushAlertController : UIAlertController
+ (instancetype)remotePushAlertControllerWithMessage:(NSString *)message;
@property (nonatomic, copy) void(^vCheckHandler)(void);
@end
