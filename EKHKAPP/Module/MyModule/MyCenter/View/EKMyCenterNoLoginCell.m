/**
 -  EKMyCenterNoLoginCell.m
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/10/26.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:"个人中心"未登录时显示的cell
 */

#import "EKMyCenterNoLoginCell.h"

@implementation EKMyCenterNoLoginCell
//界面中所有按钮的监听事件
- (IBAction)mPopToLoginViewController:(id)sender {
    if (self.vDelegate && [self.vDelegate respondsToSelector:@selector(mPopToLoginViewController)]) {
        [self.vDelegate mPopToLoginViewController];
    }
}

@end
