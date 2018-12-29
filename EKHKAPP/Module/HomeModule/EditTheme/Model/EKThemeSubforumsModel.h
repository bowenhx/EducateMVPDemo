//
//  EKThemeSubforumsModel.h
//  EKHKAPP
//
//  Created by ligb on 2017/9/30.
//  Copyright © 2017年 BaByKingdom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EKThemeSubforumsModel : NSObject
@property (nonatomic , copy) NSString *Description;

@property (nonatomic , copy) NSString *icon;

@property (nonatomic , copy) NSString *lastauthor;

@property (nonatomic , copy) NSString *lastsubject;

@property (nonatomic , copy) NSString *name;

@property (nonatomic , copy) NSString *moderators;

@property (nonatomic , copy) NSString *type;

@property (nonatomic , copy) NSString *viewperm;

@property (nonatomic , copy) NSArray *subforum;

@property (nonatomic , assign) NSInteger favid;
@property (nonatomic , assign) NSInteger fid;
@property (nonatomic , assign) NSInteger groupid;
@property (nonatomic , assign) NSInteger fup;
@property (nonatomic , assign) NSInteger isfavorite;
@property (nonatomic , assign) NSInteger ispassword;
@property (nonatomic , assign) NSInteger orderid;
@property (nonatomic , assign) NSInteger posts;
@property (nonatomic , assign) NSInteger threads;
@property (nonatomic , assign) NSInteger todayposts;
@end

/*
"subforums": [
              {
                  "fid": "490",
                  "fup": "322",
                  "type": "forum",
                  "name": "使用意見",
                  "threads": "939",
                  "posts": "4529",
                  "todayposts": "0",
                  "viewperm": "    21    9    10    48    11    12    13    14    15    16    17    29    30    31    32    33    34    35    36    51    57    63    19    20    37    41    45    72    73    47    49    1    2    3    4    7    8    ",
                  "orderid": 0,
                  "description": "歡迎會員在此討論區發表使用「教育王國」時遇上的問題，或是提供改善「教育王國」的意見。我們會細心聽取，並盡力跟進。",
                  "ispassword": 0,
                  "isfavorite": 0,
                  "favid": "0",
                  "lastauthor": "bktcc",
                  "lastsubject": "昨天download 左新iOS , 不能登入BK",
                  "icon": "http://www.edu-kingdom.com/data/attachment/common/c4/common_490_icon.png",
                  "moderators": "小草, 小倩",
                  "subforum": [ ],
                  "groupid": 7
              },
 */
