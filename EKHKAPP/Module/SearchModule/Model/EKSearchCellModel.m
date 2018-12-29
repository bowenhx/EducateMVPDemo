/**
 -  EKSearchCellModel.m
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/9/22.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:这是"搜索"模块的用来管理cell信息的自定义本地model
 */

#import "EKSearchCellModel.h"
#import "EKSearchUserModel.h"
#import "EKSearchForumModel.h"

@implementation EKSearchCellModel
+ (void)mRequestSearchCellModelArrayWithType:(EKSearchType)type
                              withSearchText:(NSString *)text
                                    withPage:(NSInteger)page
                                withCallBack:(void(^)(NSString *netErr, NSArray <EKSearchCellModel *>*searchCellModelArray, NSString *message))callBack {
    NSArray *typeArray = @[@"forum", @"user"];
    NSDictionary *parameter = @{@"token" : TOKEN,
                                @"type" : typeArray[type],
                                @"srchtxt" : text,
                                @"page" : @(page)
                                };
    [EKHttpUtil mHttpWithUrl:kHomeSearchForumOrUserURL
                   parameter:parameter
                    response:^(BKNetworkModel *model, NSString *netErr) {
                        if (netErr) {
                            callBack(netErr, nil, nil);
                        } else {
                            if (1 == model.status) {
                                if (model.data && [model.data isKindOfClass:[NSDictionary class]]) {
                                    id lists = model.data[@"lists"];
                                    if (lists && [lists isKindOfClass:[NSArray class]]) {
                                        NSMutableArray *tempArray = [NSMutableArray array];
                                        for (NSDictionary *dictionary in lists) {
                                            EKSearchCellModel *searchCellModel = [[EKSearchCellModel alloc] init];
                                            id vModel = nil;
                                            switch (type) {
                                                case EKSearchTypeForum: {
                                                    vModel = [EKSearchForumModel yy_modelWithDictionary:dictionary];
                                                    break;
                                                }
                                                case EKSearchTypeUser: {
                                                    vModel = [EKSearchUserModel yy_modelWithDictionary:dictionary];
                                                    break;
                                                }
                                            }
                                            searchCellModel.vModel = vModel;
                                            [tempArray addObject:searchCellModel];
                                        }
                                        callBack(nil, tempArray.copy, nil);
                                    }
                                }
                            } else {
                                callBack(nil, nil, model.message);
                            }
                        }
                    }];
}


- (void)setVModel:(id)vModel {
    _vModel = vModel;
    if ([vModel isKindOfClass:[EKSearchForumModel class]]) {
        _vRowHeight = 66;
        _vReuseIdentifier = searchForumCellID;
        _vSelectorName = @"mClickSearchForumCell";
    } else if ([vModel isKindOfClass:[EKSearchUserModel class]]) {
        _vRowHeight = 61;
        _vReuseIdentifier = searchUserCellID;
        _vSelectorName = @"mClickSearchUserCell";
    }
}


- (NSString *)description {
    return [self yy_modelDescription];
}


@end
