/**
 -  EKSettingCellModel.h
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/11/7.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:这是管理"设置"界面cell的本地model
 */

#import <Foundation/Foundation.h>

@interface EKSettingCellModel : NSObject
//重用标识符
@property (nonatomic, copy) NSString *vReuseIdentifier;
//标题文字内容
@property (nonatomic, copy) NSString *vTitle;
//右侧的详细文字内容
@property (nonatomic, copy) NSString *vDetailText;
//点击时要执行的方法名
@property (nonatomic, copy) NSString *vSelectorName;

+ (NSArray <NSArray <EKSettingCellModel *> *> *)mGetSettingCellModelArray;

@end
