/**
 -  BKFaceManage.h
 -  BKHKAPP
 -  Created by ligb on 2017/8/24.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明：该类主要是表情的管理类，用作详情，发贴，发送消息表情模型数据处理
 */

#import <Foundation/Foundation.h>

@interface BKFaceManage : NSObject

+ (BKFaceManage *)sharedInstance;

@property (nonatomic , strong) NSMutableArray * vSmiliesArray;

/**
 根据表情代码，返回本地表情图片
 @param str 传入表情代码
 @return 返回表情UIImage
 */
- (UIImage *)mCoreImageRuleMate:(NSString *)str;


/**
 根据表情代码，返回本地表情路径
 @param str 传入表情代码
 @return 返回表情表情路径
 */
- (NSString *)mCoreImagePath:(NSString *)str;

@end



