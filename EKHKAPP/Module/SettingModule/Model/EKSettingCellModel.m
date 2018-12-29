/**
 -  EKSettingCellModel.m
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/11/7.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:这是管理"设置"界面cell的本地model
 */

#import "EKSettingCellModel.h"
#import "EKSettingNormalCell.h"
#import "EKSettingSwitchCell.h"

@implementation EKSettingCellModel
+ (NSArray <NSArray <EKSettingCellModel *> *> *)mGetSettingCellModelArray {
    NSMutableArray <NSMutableArray <EKSettingCellModel *> *> * settingCellModelArray= @[
                                                                          @[
                                                                              [self settingCellModelWithReuseIdentifier:settingSwitchCellID title:@"消息提醒" detailText:nil selectorName:nil],
                                                                              [self settingCellModelWithReuseIdentifier:settingNormalCell title:@"默認排序" detailText:nil selectorName:@"mSetRank"],
                                                                              [self settingCellModelWithReuseIdentifier:settingNormalCell title:@"默認文字大小" detailText:nil selectorName:@"mSetFont"],
                                                                              [self settingCellModelWithReuseIdentifier:settingNormalCell title:@"清理緩存" detailText:nil selectorName:@"mClearCache"]
                                                                              ].mutableCopy,
                                                                          @[
                                                                              [self settingCellModelWithReuseIdentifier:settingNormalCell title:@"關於我們" detailText:nil selectorName:@"mPushToAboutUsViewController"],
                                                                              ].mutableCopy
                                                                          ].mutableCopy;
    //处理默认排序的详细文字内容
    settingCellModelArray[0][1].vDetailText = [BKSaveData getInteger:kTopicDetailOrderKey] ? @"倒序" : @"順序";
    
    //处理默认字体大小的详细文字内容
    NSArray <NSString *> *fontDetailTextArray = @[@"中號", @"小號", @"大號"];
    settingCellModelArray[0][2].vDetailText = fontDetailTextArray[[BKSaveData getInteger:kTopicDetailFontSizeKey]];
    return settingCellModelArray.copy;
}


+ (instancetype)settingCellModelWithReuseIdentifier:(NSString *)reuseIdentifier
                                              title:(NSString *)title
                                         detailText:(NSString *)detailText
                                       selectorName:(NSString *)selectorName {
    EKSettingCellModel *settingCellModel = [[EKSettingCellModel alloc] init];
    settingCellModel.vReuseIdentifier = reuseIdentifier;
    settingCellModel.vTitle = title;
    settingCellModel.vDetailText = detailText;
    settingCellModel.vSelectorName = selectorName;
    return settingCellModel;
}
@end
