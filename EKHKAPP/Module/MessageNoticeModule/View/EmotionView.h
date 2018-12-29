//
//  EmotionView.h
//  BKMobile
//
//  Created by 薇 颜 on 15/6/26.
//  Copyright (c) 2015年 com.mobile-kingdom.bkapps All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BKFaceView.h"
@protocol EmotionViewDelegate <NSObject>

@optional
/**
 *  表情被点击的回调事件
 *
 *  @param emotion   被点击的gif表情Model
 */
- (void)didSelecteEmotion:(SmiliesButton *)emotion;

@end

@protocol EmotionViewDataSource <NSObject>

@required


/**
 *  通过数据源获取表情的数组
 *
 *  @return 返回表情的数组
 */
- (NSArray *)emotionList;

@end

@interface EmotionView : UIView

@property (nonatomic, weak) id <EmotionViewDelegate> delegate;

@property (nonatomic, weak) id <EmotionViewDataSource> dataSource;


@end
