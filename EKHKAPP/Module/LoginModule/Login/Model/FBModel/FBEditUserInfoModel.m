/**
 -  FBEditUserInfoModel.m
 -  BKMobile
 -  Created by ligb on 2017/8/9.
 -  Copyright © 2017年 com.mobile-kingdom.bkapps. All rights reserved.
 */

#import "FBEditUserInfoModel.h"

@interface FBEditUserInfoModel ()

@end

@implementation FBEditUserInfoModel

/**
 该api用于用户完善资料，注意该api适用所有登录用户，并不局限fb用户，这里的token是用户的登录token。
 注意，当mode=1时，其它参数不填，即表示该api获取完善信息里面的所有下拉框和多选框的选项值。
 反之，忽略mode参数，表示该api用于完善信息。
 在提交资料的时候，需要注意处理的。
 预产期年月 birthday = 年值-月值 如 2017-10
 第n名子女信息 childn = 年值-月值-性别值-上学地区值 如 2017-10月-f-九龍城區
 兴趣爱好 category = c1-c2-c3-n 如 1-2-4
 */



//首次登陆facebook
+ (void)facebookUserInfoEidt:(NSDictionary *)info back:(void(^)(BKNetworkModel *fbmodel, NSString *error))block{
    [EKHttpUtil mHttpWithUrl:kFacebookUserInfo parameter:info response:^(BKNetworkModel *model, NSString *netErr) {
        if (netErr) {
            block (nil , netErr);
        }else{
            block (model, nil);
        }
    }];
}

@end
