/**
 -  EKHomeVoteModel.h
 -  EKHKAPP
 -  Created by ligb on 2017/9/20.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明： 获取首页投票数据信息
 */

#import <Foundation/Foundation.h>
#import "EKHomeVoteOptionsModel.h"

@interface EKHomeVoteModel : NSObject
@property (nonatomic, copy) NSString *subject;
@property (nonatomic, copy) NSString *statusmsg;

@property (nonatomic, assign) NSInteger voterscount;
@property (nonatomic, assign) NSInteger tid;
@property (nonatomic, assign) NSInteger overt;
@property (nonatomic, assign) BOOL multiple;       //是否可多选1：多选，0：单选
@property (nonatomic, assign) NSInteger maxchoices;// 最多可选值
@property (nonatomic, assign) NSInteger expiration;
@property (nonatomic, assign) BOOL overdue;//1: 标示未关闭未过期，0：已经关闭或者过期
@property (nonatomic, assign) BOOL myselect; // 是否参与过1：参与过，0未参与
@property (nonatomic, assign) NSInteger visible;

@property (nonatomic, copy) NSArray <EKHomeVoteOptionsModel *> * options;

+ (void)mLoadVoteTabid:(NSString *)key block:(void(^)(EKHomeVoteModel *data, NSString *error))block;

+ (void)mBeginVoteActionTid:(NSInteger)tid selectVote:(NSString *)pollanswers block:(void(^)(NSString *error, BOOL status))block;


@end

/**
"data": {
    "tid": "3009052",
    "overt": "0",
    "multiple": "1",
    "visible": "0",
    "maxchoices": "3",
    "expiration": "1429505754",
    "myselect": "0",
    "voterscount": "34",
    "subject": "你如何讓幼兒愛上閱讀？",
    "statusmsg": "",
    "options": [
                {
                    "polloptionid": "2302",
                    "polloption": "挑選多圖畫，少文字的故事。",
                    "votes": "12",
                    "width": "15%",
                    "percent": "15.38",
                    "color": "E92725",
                    "displayorder": "1",
                    "myselect": "0"
                },
                {
                    "polloptionid": "2308",
                    "polloption": "從孩子喜歡的東西為開始閱讀的題材。",
                    "votes": "26",
                    "width": "33%",
                    "percent": "33.33",
                    "color": "F27B21",
                    "displayorder": "2",
                    "myselect": "0"
                },
*/
