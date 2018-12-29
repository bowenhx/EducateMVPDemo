/**
 -  BKFaceView.h
 -  BKHKAPP
 -  Created by ligb on 2017/8/24.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明：表情view
 */

#import <UIKit/UIKit.h>
#import "SmiliesButton.h"

@protocol BKFaceViewDelegate <NSObject>
- (void)selectedSmiliesWithItem:(SmiliesButton *)item;
@end


@interface BKFaceView : UIView

@property (nonatomic, weak) id<BKFaceViewDelegate> delegate;

- (void)mAddFaceItem;
@end
