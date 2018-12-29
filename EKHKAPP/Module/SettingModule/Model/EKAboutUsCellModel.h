/**
 -  EKAboutUsCellModel.h
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/11/8.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:这是管理"关于我们"界面的cell的model
 */

#import <Foundation/Foundation.h>

@interface EKAboutUsCellModel : NSObject
//标题
@property (nonatomic, copy) NSString *vTitle;
//执行的方法名
@property (nonatomic, copy) NSString *vSelectorName;

/**
 获取"关于我们"界面的cell的信息数组

 @return cell的信息数组
 */
+ (NSArray <EKAboutUsCellModel *>*)mGetAboutUsCellModelArray;

@end
