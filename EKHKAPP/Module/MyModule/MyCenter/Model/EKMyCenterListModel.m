/**
 -  EKMyCenterListModel.h
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/10/23.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:这是"个人中心"的tableView的cell对应的model(基本资料model不是本地数据,其余的是本地数据)
 */

#import "EKMyCenterListModel.h"
#import "EKMyCenterListCell.h"
#import "EKMyCenterInformationCell.h"
#import "EKMyCenterNoLoginCell.h"

@implementation EKMyCenterListModel
/**
 获取到本地的包含"个人中心"cell的UI信息的model数组
 
 @return 包含"个人中心"cell的UI信息的model数组
 */
+ (NSArray <NSArray <EKMyCenterListModel *> *> *)mGetMyCenterListModelArray {
    //定义显示用户信息的cell的高度
    CGFloat myCenterInformationCellHeight = 157;
    //定义其他普通列表cell的高度
    CGFloat myCenterListCellHeight = 43;
    NSMutableArray <NSMutableArray <EKMyCenterListModel *> *> *myCenterListModelArray = [NSMutableArray arrayWithArray:@[
                                                                              @[
                                                                                  [self myCenterListModelWithReuseIdentifier:myCenterInformationCellID cellHeight:myCenterInformationCellHeight controllerName:nil imageName:nil title:nil]
                                                                                  ].mutableCopy,
//                                                                              @[
//                                                                                  [self myCenterListModelWithReuseIdentifier:myCenterListCellID cellHeight:myCenterListCellHeight controllerName:@"EKFriendViewController" imageName:@"personal_friends" title:@"我的好友"],
//                                                                                  [self myCenterListModelWithReuseIdentifier:myCenterListCellID cellHeight:myCenterListCellHeight controllerName:@"EKPhotoAlbumViewController" imageName:@"personal_photo" title:@"我的相冊"],
//                                                                                  ].mutableCopy,
//                                                                              @[
//                                                                                  [self myCenterListModelWithReuseIdentifier:myCenterListCellID cellHeight:myCenterListCellHeight controllerName:@"ManageReportViewController" imageName:@"personal_report" title:@"用戶舉報"]
//                                                                                  ].mutableCopy,
                                                                              @[
                                                                                  [self myCenterListModelWithReuseIdentifier:myCenterListCellID cellHeight:myCenterListCellHeight controllerName:@"EKSettingViewController" imageName:@"personal_set" title:@"設置"]
                                                                                  ].mutableCopy
                                                                              ]
                                              ];
    //判断登录状态,返回不同的第0个cell
    if (!LOGINSTATUS) {
        [myCenterListModelArray replaceObjectAtIndex:0 withObject:@[[self myCenterListModelWithReuseIdentifier:myCenterNoLoginCellID cellHeight:myCenterInformationCellHeight controllerName:nil imageName:nil title:nil]].mutableCopy];
    }
    
    //判断用户是否有管理权限.没有的话,移除掉"用户举报"
    if (!USER.groups.ismanagereport.boolValue) {
        [myCenterListModelArray removeObjectAtIndex:2];
    }
    //对显示用户信息cell的model,设置好用户信息model
    myCenterListModelArray.firstObject.firstObject.vUserModel = USER;
    return myCenterListModelArray.copy;
}


//内部使用的快速创建对象方法
+ (instancetype)myCenterListModelWithReuseIdentifier:(NSString *)reuseIdentifier
                                          cellHeight:(CGFloat)cellHeight
                                      controllerName:(NSString *)controllerName
                                           imageName:(NSString *)imageName
                                               title:(NSString *)title {
    EKMyCenterListModel *myCenterListModel = [[EKMyCenterListModel alloc] init];
    myCenterListModel.vReuseIdentifier = reuseIdentifier;
    myCenterListModel.vCellHeight = cellHeight;
    myCenterListModel.vControllerName = controllerName;
    myCenterListModel.vImageName = imageName;
    myCenterListModel.vTitle = title;
    return myCenterListModel;
}
@end
