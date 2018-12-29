/**
 -  EKHomeActivityModel.m
 -  EKHKAPP
 -  Created by ligb on 2017/9/20.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 */

#import "EKHomeActivityModel.h"


@implementation EKHomeActivityModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"events" : [EKHomeActivityEventModel class] };
}

+ (void)mLoadActivityDate:(NSString *)date block:(void(^)(NSArray <EKHomeActivityModel *> *data, NSString *error))block {
    [EKHttpUtil mHttpWithUrl:kParentChildActivityURL
                   parameter:@{@"token": TOKEN, @"date": date, @"page":@(1)}
                    response:^(BKNetworkModel *model, NSString *netErr) {
                        if (netErr) {
                            block(nil, netErr);
                        } else {
                            if (1 == model.status) {
                                if (model.data && [model.data isKindOfClass:[NSArray class]]) {
                                    NSMutableArray <EKHomeActivityModel *> *tempArray = [NSMutableArray array];
                                    for (NSDictionary *dictionary in model.data) {
                                        [tempArray addObject:[EKHomeActivityModel yy_modelWithDictionary:dictionary]];
                                    }
                                    block(tempArray, nil);
                                }
                            } else {
                                block( nil, model.message);
                            }
                        }
                    }];

}

+ (NSString *)monthChangeAction:(NSString *)month {
    if ([month isEqualToString:@"01"]) {
        return @"Jan";
    } else if ([month isEqualToString:@"02"]) {
        return @"Feb";
    }else if ([month isEqualToString:@"03"]) {
        return @"Mar";
    }else if ([month isEqualToString:@"04"]) {
        return @"Apr";
    }else if ([month isEqualToString:@"05"]) {
        return @"May";
    }else if ([month isEqualToString:@"06"]) {
        return @"Jun";
    }else if ([month isEqualToString:@"07"]) {
        return @"Jul";
    }else if ([month isEqualToString:@"08"]) {
        return @"Aug";
    }else if ([month isEqualToString:@"09"]) {
        return @"Sep";
    }else if ([month isEqualToString:@"10"]) {
        return @"Oct";
    }else if ([month isEqualToString:@"11"]) {
        return @"Nov";
    }else if ([month isEqualToString:@"12"]) {
        return @"Dec";
    }
    return @"";
}


+ (NSInteger)mGetManyDaysInThisYear:(NSInteger)year withMonth:(NSInteger)month {
    if((month == 1) || (month == 3) || (month == 5) || (month == 7) || (month == 8) || (month == 10) || (month == 12))
        return 31 ;
    
    if((month == 4) || (month == 6) || (month == 9) || (month == 11))
        return 30;
    
    if((year % 4 == 1) || (year % 4 == 2) || (year % 4 == 3))
        return 28;
    
    if(year % 400 == 0)
        return 29;
    
    if(year % 100 == 0)
        return 28;
    
    return 29;
}


@end
