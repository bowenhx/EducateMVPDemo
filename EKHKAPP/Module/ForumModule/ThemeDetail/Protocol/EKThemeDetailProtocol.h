//
//  EKThemeDetailProtocol.h
//  EKHKAPP
//
//  Created by ligb on 2017/11/2.
//  Copyright © 2017年 BaByKingdom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ThreadsDetailModel.h"
@protocol EKThemeDetailProtocol <NSObject>

- (void)mBackThemeHeadListModel:(ThreadsDetailModel *)model;

- (void)mBackThemeDetailData:(NSString *)message data:(NSArray *)data;

@end
