//
//  SmiliesModel.h
//  EKHKAPP
//
//  Created by calvin_Tse on 2017/11/6.
//  Copyright © 2017年 BaByKingdom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SmiliesModel : NSObject
//表情代码
@property (nonatomic , copy) NSString *search;
//表情本地的url
@property (nonatomic , copy) NSString *replace;
@end
