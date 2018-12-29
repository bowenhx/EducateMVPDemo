/**
 -  UIColor+app.h
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/9/8.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:香港EK项目的颜色配置文件
 */

#import <UIKit/UIKit.h>

@interface UIColor (AppUIColor)

#pragma mark - 主色调颜色
//App背景颜色
+ (UIColor *)EKColorBackground;

//导航栏&标签栏颜色
+ (UIColor *)EKColorNavigation;

//黄色醒目按钮等提醒色
+ (UIColor *)EKColorYellow;

//活动head 色
+ (UIColor *)EKHeadColorYellow;

//活动cell 色
+ (UIColor *)EKHomeCellYeallow;

//灰色背景
+ (UIColor *)EKColorGray;
#pragma mark - 文字颜色 - 黑灰白
//主要文字颜色
+ (UIColor *)EKColorTitleBlack;

//帖子详情楼层文字颜色
+ (UIColor *)EKColorCellLabel;

//辅助文字颜色
+ (UIColor *)EKColorTitleGray;

//导航栏文字&按钮文字颜色
+ (UIColor *)EKColorTitleWhite;

//设置帖子中楼层的背景颜色
+ (UIColor *)EKColorMemberFBg;
#pragma mark - UITableView背景颜色
//列表背景色白色
+ (UIColor *)EKColorTableBackgroundWhite;

//列表背景色灰色
+ (UIColor *)EKColorTableBackgroundGray;


#pragma mark - 文字颜色 - 青黄
//列表标签选中文字
+ (UIColor *)EKColorTableTitleCyan;

//说明提示/选框颜色
+ (UIColor *)EKColorTableTitleDarkCyan;

//菜单标签选中色
+ (UIColor *)EKColorTableTitleYellow;


#pragma mark - 分割线颜色
//全部分割线颜色
+ (UIColor *)EKColorSeperateWhite;

//列表置顶分割线
+ (UIColor *)EKColorSeperateYellow;

//侧滑菜单分割线
+ (UIColor *)EKColorSeperateCyan;


#pragma mark - 按钮颜色
//首次登陆按钮
+ (UIColor *)EKColorButtonYellow;

//余下所有按钮
+ (UIColor *)EKColorButtonCyan;

//课程搜索按钮 -  浅棕
+ (UIColor *)EKColorButtonLightBrown;

//课程搜索按钮 -  深棕
+ (UIColor *)EKColorButtonDarkBrown;


#pragma mark - "课程"使用的颜色
+ (UIColor *)EKColorCourseGreen;


#pragma mark - 自定义圆形选择器使用的颜色
+ (UIColor *)EKColorCornerSelectMenuViewTitleColor;

+ (UIColor *)EKColorCornerSelectMenuViewBorderColor;

+ (UIColor *)cellSpace:(BOOL)status;


#pragma mark - WebView进度条使用的颜色
+ (UIColor *)EKColorWebViewProgressTrackTintColor;

+ (UIColor *)EKColorWebViewProgressTintColor;
@end
