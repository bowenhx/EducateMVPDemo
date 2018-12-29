//
//  EKLoginPresenter.m
//  EKHKAPP
//
//  Created by ligb on 2017/10/16.
//  Copyright © 2017年 BaByKingdom. All rights reserved.
//

#import "EKLoginPresenter.h"

@interface EKLoginPresenter ()

@property (nonatomic, strong) BKUserModel *vUserModel;

@end

@implementation EKLoginPresenter

#pragma mark - 初始化
- (instancetype)init {
    self = [super init];
    if (self) {
        //持有M层的引用
        _vUserModel = [[BKUserModel alloc] init];
    }
    return self;
}

#pragma mark - 登录操作
- (void)mLoginWithWithUserName:(NSString*)userName password:(NSString*)password {
    
    if ([BKTool isStringBlank:userName]) {
        [self.vLoginViewProtocol mLoginResultWithSuccess:NO message:kLoginModule_UserNameIsNullText];
        return;
    }else if ([BKTool isStringBlank:password]){
        [self.vLoginViewProtocol mLoginResultWithSuccess:NO message:kLoginModule_PasswordIsNullText];
        return;
    }
    
    userName = [BKTool stringByUrlEncoding:userName];
    password = [BKTool stringByUrlEncoding:password];
    
    [self.vLoginViewProtocol mShowHUDActivity];
    [_vUserModel mLoginWithWithUserName:userName password:password callBack:^(NSString *message) {
        
        if ([message isEqualToString:kLoginModule_LoginSuccessText]) {
            
            [self.vLoginViewProtocol mLoginResultWithSuccess:YES message:kLoginModule_LoginSuccessText];
            
        } else {
            [self.vLoginViewProtocol mLoginResultWithSuccess:NO message:message];
        }
    }];
}

- (void)mSaveUserInfo:(NSDictionary *)info password:(NSString *)password isHome:(BOOL)isHome{
     [_vUserModel mLoginSuccessWithData:info password:password isHome:isHome];
}


@end
