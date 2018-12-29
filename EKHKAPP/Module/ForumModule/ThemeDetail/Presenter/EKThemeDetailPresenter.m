//
//  EKThemeDetailPresenter.m
//  EKHKAPP
//
//  Created by ligb on 2017/11/2.
//  Copyright © 2017年 BaByKingdom. All rights reserved.
//

#import "EKThemeDetailPresenter.h"
#import "ThreadsDetailModel.h"
@implementation EKThemeDetailPresenter


- (void)mRequestThemeDetailData:(NSInteger)page ordertype:(NSInteger)ordertype authorid:(NSInteger)authorid tid:(NSNumber *)tid password:(NSString *)password {
    NSDictionary *dict = @{@"token":TOKEN,
                           @"tid":tid,
                           @"page":@(page),
                           @"ordertype":@(ordertype),
                           @"authorid":@(authorid),
                           @"model":[BKTool getDeviceName],
                           @"pw":password};
    
    [EKHttpUtil mHttpWithUrl:kThemeDetailURL parameter:dict response:^(BKNetworkModel *model, NSString *netErr) {
        if (netErr) {
            [self.vProtocol mBackThemeDetailData:netErr data:nil];
        } else {
            if (model.status) {
                if ([model.data isKindOfClass:[NSDictionary class]]) {
                    NSArray *dataArray = model.data[@"lists"];
                    if ([dataArray isKindOfClass:[NSArray class]] && dataArray.count) {
                        //修改head 标题数据
                        NSDictionary *threadsDic = model.data[@"threads"];
                        if ( [threadsDic isKindOfClass:[NSDictionary class]] && threadsDic.allKeys.count) {
                            [self changeHeadData:threadsDic];
                        }
//                        //去合并数据显示数据
//                        [self uniteLoadData];
//
//                        //活动贴的数据
//                        selfWeak.dictThreadacts = model.data[@"threadacts"];
//                        //投票貼數據
//                        selfWeak.dictThreadpolls = model.data[@"threadpolls"];
//                        //当前数据页数和列表最大页数相等时变为没有更多数据状态
//                        if (_pageInteger == _pickerData.count) {
//                            [_tableView.footer noticeNoMoreData];
//                        }else{
//                            [_tableView.footer resetNoMoreData];
//                        }
                        
                    } else {
                         [self.vProtocol mBackThemeDetailData:@"沒有更多數據" data:nil];
                    }
                }
            }
        }
    }];
    
}

- (void)changeHeadData:(NSDictionary *)dict {
    ThreadsDetailModel *model = [ThreadsDetailModel new];
    [model setValuesForKeysWithDictionary:dict];
}

- (NSArray <NSString *> *)alertManageTitle:(InvitationDataModel *)model closed:(NSInteger)closed {
    NSMutableArray *mutabArr = [NSMutableArray array];
    //判断当前用户是否具有管理权限
    if ( model.ismoderator == 1 ) {
        if (!USERGROUPS) {
            return nil;
        }
        
        //移动主题权限判断
        if ([USERGROUPS.ismovethread integerValue] == 1) {
            [mutabArr addObject:@"移動整條主題"];
        }
        
        //关闭或开启主题权限判断
        if ([USERGROUPS.isclosethread integerValue] == 1){
            [mutabArr addObject:closed ? @"開啟主題" : @"關閉主題"];
        }
        
        //屏蔽或解除屏蔽帖子权限
        if ([USERGROUPS.isbanpost integerValue] == 1) {
            //status = 1 表示被屏蔽 = 2 表示被警告 ＝ 3 表示被屏蔽和警告 0 為正常
            if (model.status == 0 || model.status == 2) {
                [mutabArr addObject:@"屏蔽"];
            }else if (model.status == 1 || model.status == 3) {
                [mutabArr addObject:@"解除屏蔽"];
            }
        }
        
        //警告或解除警告帖子权限
        if ([USERGROUPS.iswarnpost integerValue] == 1) {
            //status = 1 表示被屏蔽 = 2 表示被警告 ＝ 3 表示被屏蔽和警告 0 為正常
            if (model.status == 0 || model.status == 1) {
                [mutabArr addObject:@"警告"];
            }else if (model.status == 2 || model.status == 3){
                [mutabArr addObject:@"解除警告"];
            }
        }
        
        //禁止用户或解禁用户权限（访问或发言）,
        if ([USERGROUPS.isbanuser integerValue] == 1) { //groupid = 4被禁止發言＝5被禁止訪問
            NSString *forbidStr;
            NSString *forbidStr1;
            if (model.groupid == 4 ) {
                forbidStr =  [NSString stringWithFormat:@"解除禁言：%@",model.author];
                forbidStr1 =  [NSString stringWithFormat:@"禁訪：%@",model.author];
            }else if (model.groupid == 5){
                forbidStr =  [NSString stringWithFormat:@"禁言：%@",model.author];
                forbidStr1 =  [NSString stringWithFormat:@"解除禁訪：%@",model.author];
            }else{
                forbidStr =  [NSString stringWithFormat:@"禁言：%@",model.author];
                forbidStr1 =  [NSString stringWithFormat:@"禁訪：%@",model.author];
            }
            [mutabArr addObject:forbidStr];
            [mutabArr addObject:forbidStr1];
        }
        //查看用户ip权限
        if ([USERGROUPS.isviewip integerValue] == 1) {
            [mutabArr addObject:@"查看用戶IP"];
        }
        [mutabArr addObject:@"點評"];
    }else{
        //ismoderator ==1 且isviewip ==1 或者 groupid=3可以使用查看ip选项
        if ([USER.groupid integerValue] == 3 || [USERGROUPS.isviewip integerValue] == 1) {
            [mutabArr addObject:@"查看用戶IP"];
            [mutabArr addObject:@"點評"];
        }
    }
    return mutabArr;
}

@end
