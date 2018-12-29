//
//  EKThemeDetailPresenter.h
//  EKHKAPP
//
//  Created by ligb on 2017/11/2.
//  Copyright © 2017年 BaByKingdom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InvitationDataModel.h"
#import "EKThemeDetailProtocol.h"

@interface EKThemeDetailPresenter : NSObject

@property (nonatomic, weak) id <EKThemeDetailProtocol> vProtocol;

- (void)mRequestThemeDetailData:(NSInteger)page ordertype:(NSInteger)ordertype authorid:(NSInteger)authorid tid:(NSNumber *)tid password:(NSString *)password;


- (NSArray <NSString *> *)alertManageTitle:(InvitationDataModel *)model closed:(NSInteger)closed;

@end
