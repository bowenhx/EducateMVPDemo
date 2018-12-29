/**
 -  BKSettingModel.h
 -  BKHKAPP
 -  Created by calvin_Tse on 2017/9/6.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:"设置"界面使用的model
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//主题列表字号
#define MotifSize_Max     (IS_IPAD ? 25 : 19)
#define MotifSize_Middle  (IS_IPAD ? 20 : 17)
#define MotifSize_Small   (IS_IPAD ? 17 : 15)
//帖子详情页面字号
#define DetailSize_Max     (IS_IPAD ? 25 : 25)
#define DetailSize_Middle  (IS_IPAD ? 22 : 20)
#define DetailSize_Small   (IS_IPAD ? 18 : 17)

@interface BKSettingModel : NSObject
+ (instancetype)sharedInstance;

@property (nonatomic, copy) NSString *author;
@property (nonatomic, assign) CGFloat lzWidth;
@property (nonatomic, assign) CGFloat font;//帖子字号调整
@property (nonatomic, assign) CGFloat motifFont;//主题列表字号调整
@end
