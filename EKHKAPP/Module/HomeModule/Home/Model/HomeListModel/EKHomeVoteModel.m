/**
 -  EKHomeVoteModel.m
 -  EKHKAPP
 -  Created by ligb on 2017/9/20.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 */

#import "EKHomeVoteModel.h"

@implementation EKHomeVoteModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"options" : [EKHomeVoteOptionsModel class] };
}

+ (void)mLoadVoteTabid:(NSString *)key block:(void(^)(EKHomeVoteModel *data, NSString *error))block {
    [EKHttpUtil mHttpWithUrl:kHomeVoteKeyURL
                   parameter:@{@"token": TOKEN, @"tabid": key}
                    response:^(BKNetworkModel *model, NSString *netErr) {
                        if (netErr) {
                            block(nil, netErr);
                        } else {
                            if (1 == model.status) {
                                NSDictionary *tempDict = model.data;
                                if (tempDict.count && [tempDict isKindOfClass:[NSDictionary class]]) {
                                    EKHomeVoteModel *voteModel = [EKHomeVoteModel yy_modelWithJSON:tempDict];
                                    block(voteModel, nil);
                                }
                            } else {
                                block( nil, model.message);
                            }
                        }
                    }];
}

+ (void)mBeginVoteActionTid:(NSInteger)tid selectVote:(NSString *)pollanswers block:(void(^)(NSString *error, BOOL status))block {
    [EKHttpUtil mHttpWithUrl:kVoteURL
                   parameter:@{@"token": TOKEN, @"tid": @(tid), @"pollanswers": pollanswers}
                    response:^(BKNetworkModel *model, NSString *netErr) {
                        if (netErr) {
                            block(netErr, NO);
                        } else {
                            if (1 == model.status) {
                                NSDictionary *tempDict = model.data;
                                block(model.message, YES);
                                NSLog(@"tempDict = %@",tempDict);
                            } else {
                                block(model.message, NO);
                            }
                        }
                    }];
}



@end
