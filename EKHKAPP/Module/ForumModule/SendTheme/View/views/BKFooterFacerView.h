/**
 -  BKFooterFacerView.h
 -  BKHKAPP
 -  Created by ligb on 2017/8/29.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明：发送表情view
 */

#import <UIKit/UIKit.h>
@class SmiliesButton;

@interface BKFooterFacerView : UIView
@property (nonatomic, strong) UIScrollView *vScrollView;
@property (nonatomic, copy) void (^mSelectFooterBtn)(UIButton *faceBtn);
@property (nonatomic, copy) void (^mSelectFaceAction)(SmiliesButton *smilies);

+ (BKFooterFacerView *)getFooterFaceView;

@end
