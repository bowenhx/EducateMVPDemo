/**
 -  BKLGActionSheet.h
 -  EKHKAPP
 -  Created by ligb on 16/3/28.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明：actionSheet 选择器，用于选择字号大小
 */
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, LGActionSeetType) {
    InvitationDetailType = 0,       /**<帖子详情*/
    InvitationListType = 1,         /**<主题列表*/
};

@interface BKLGActionSheet : NSObject

+ (void)showActionSheet:(id)controller type:(LGActionSeetType)type defSize:(NSInteger)size;


/**
 获取默认字号大小

 @return value
 */
+ (NSInteger)getDetailSizeFont;


/**
 获取详情默认排序

 @return value
 */
+ (NSInteger)getDetailTaxis;

@end
