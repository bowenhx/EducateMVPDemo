/**
 -  EKSearchUserAlertController.m
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/9/25.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:这是搜索用户cell的"解除好友"按钮点击的时候的弹窗
 */

#import "EKSearchUserAlertController.h"
@implementation EKSearchUserAlertController
- (instancetype)initWithDelegate:(id<EKSearchUserAlertControllerDelegate>)delegate withRow:(NSInteger)row {
    EKSearchUserAlertController *alertController = (EKSearchUserAlertController *)[UIAlertController alertControllerWithTitle:@"是否解除好友關係"
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"確定"
                                                            style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                                                if (delegate && [delegate respondsToSelector:@selector(mSearchUserAlertControllerConfirmButtonDidClickWithRow:)]) {
                                                                    [delegate mSearchUserAlertControllerConfirmButtonDidClickWithRow:row];
                                                                }
                                                            }];
    [alertController addAction:cancelAction];
    [alertController addAction:confirmAction];
    return alertController;
}


- (instancetype)initWithDelegate:(id<EKSearchUserAlertControllerDelegate>)delegate {
    EKSearchUserAlertController *alertController = (EKSearchUserAlertController *)[UIAlertController alertControllerWithTitle:@"是否解除好友關係"
                                                                                                                      message:nil
                                                                                                               preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"確定"
                                                            style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                                                if (delegate && [delegate respondsToSelector:@selector(mSearchUserAlertControllerConfirmButtonDidClick)]) {
                                                                    [delegate mSearchUserAlertControllerConfirmButtonDidClick];
                                                                }
                                                            }];
    [alertController addAction:cancelAction];
    [alertController addAction:confirmAction];
    return alertController;
}
@end
