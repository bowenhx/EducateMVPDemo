/**
 -  BKFaceView.m
 -  BKHKAPP
 -  Created by ligb on 2017/8/24.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 */

#import "BKFaceView.h"
#import "BKFaceManage.h"
#import "SmiliesButton.h"
#import "SmiliesModel.h"

@implementation BKFaceView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
    }
    return self;
}


- (void)mAddFaceItem {
    NSInteger page = self.tag;
    
    NSArray *smilies = [BKFaceManage sharedInstance].vSmiliesArray;
    
    
    float sSize = SCREEN_WIDTH / 7;
    
    for (int i=0; i<4; i++) {
        //column numer
        for (int y=0; y<7; y++) {
            int num = i * 7 + y + (int)( page * 28 );
            
            if (num >= smilies.count) {
                return;
            }
            SmiliesButton *button=[SmiliesButton buttonWithType:UIButtonTypeCustom];
            SmiliesModel *model = smilies[num];
            button.search = model.search;
            [button setImage:[UIImage imageWithContentsOfFile:model.replace] forState:UIControlStateNormal];
            [button setFrame:CGRectMake(y*sSize, i*sSize, sSize, sSize)];
            [button addTarget:self action:@selector(selected:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
        }
    }

}
- (void)selected:(SmiliesButton *)btn {
    if (_delegate) {
        [_delegate selectedSmiliesWithItem:btn];
    }
}
@end
