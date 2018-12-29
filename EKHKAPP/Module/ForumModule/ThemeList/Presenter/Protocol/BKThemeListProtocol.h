/**
 - BKThemeListProtocol.h
 - BKMobile
 - Created by HY on 2017/8/1.
 - Copyright © 2017年 com.mobile-kingdom.bkapps. All rights reserved.
 - 说明：主题列表Presenter的协议方法，主题列表View层通过遵循协议来更新UI
 */

#import <Foundation/Foundation.h>
#import "BKThemeListDataModel.h"

@protocol BKThemeListProtocol <NSObject>

/**
 接收到主题列表页面的数据,用于刷新界面
 
 @param dataModel 主题列表页面，整体的数据源
 @param status 网络请求状态码
 @param error 网络请求错误信息
 */
- (void)mReceiveThemeListData:(BKThemeListDataModel *)dataModel status:(NSInteger)status error:(NSString *)error index:(NSInteger)index;


@end
