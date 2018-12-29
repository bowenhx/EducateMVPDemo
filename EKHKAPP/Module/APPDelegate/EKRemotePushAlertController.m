/**
 -  EKRemotePushAlertController.m
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/12/21.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:这是接收到远程推送时候,如果推送类型为JX时,需要显示的弹窗
 */

#import "EKRemotePushAlertController.h"

@interface EKRemotePushAlertController ()

@end

@implementation EKRemotePushAlertController
+ (instancetype)remotePushAlertControllerWithMessage:(NSString *)message {
    EKRemotePushAlertController *alertController = [EKRemotePushAlertController alertControllerWithTitle:@"提醒"
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];
    [alertController addAction:cancelAction];
    return alertController;
}

- (void)setVCheckHandler:(void (^)(void))vCheckHandler {
    _vCheckHandler = vCheckHandler;
    UIAlertAction *checkAction = [UIAlertAction actionWithTitle:@"查看"
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * _Nonnull action) {
                                                            vCheckHandler();
                                                        }];
    [self addAction:checkAction];
}

@end
