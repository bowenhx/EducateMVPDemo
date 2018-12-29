/**
 -  UIColor+app.m
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/9/8.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:香港EK项目的颜色配置文件
 */

#import "UIColor+app.h"
#import "NSString+UIColor.h"

@implementation UIColor (AppUIColor)

#pragma mark - 主色调颜色
//App背景颜色
+ (UIColor *)EKColorBackground {
    return @"e4e4e4".color;
}

//导航栏&标签栏颜色
+ (UIColor *)EKColorNavigation {
    return @"109a8e".color;
}

//黄色醒目按钮等提醒色
+ (UIColor *)EKColorYellow {
    return @"fac000".color;
}

//活动head 色
+ (UIColor *)EKHeadColorYellow {
    return @"fbc100".color;
}

//活动cell 色
+ (UIColor *)EKHomeCellYeallow {
    return @"fdd233".color;
}


+ (UIColor *)EKColorGray {
    return @"c5c5c6".color;
}

//设置帖子中楼层的背景颜色
+ (UIColor *)EKColorMemberFBg{
    return @"#f0c9ca".color;
}
#pragma mark - 文字颜色 - 黑灰白
//主要文字颜色
+ (UIColor *)EKColorTitleBlack {
    return @"333333".color;
}

//帖子详情楼层文字颜色
+ (UIColor *)EKColorCellLabel {
    return @"888888".color;
}

//辅助文字颜色
+ (UIColor *)EKColorTitleGray {
    return @"8d8d8d".color;
}

//导航栏文字&按钮文字颜色
+ (UIColor *)EKColorTitleWhite {
    return @"FFFFFF".color;
}


#pragma mark - UITableView背景颜色
//列表背景色白色
+ (UIColor *)EKColorTableBackgroundWhite {
    return @"FFFFFF".color;
}

//列表背景色灰色
+ (UIColor *)EKColorTableBackgroundGray {
    return @"f4f4f4".color;
}


#pragma mark - 文字颜色 - 青黄
//列表标签选中文字
+ (UIColor *)EKColorTableTitleCyan {
    return @"07645c".color;
}

//说明提示/选框颜色
+ (UIColor *)EKColorTableTitleDarkCyan {
    return @"356e6b".color;
}

//菜单标签选中色
+ (UIColor *)EKColorTableTitleYellow {
    return @"fac000".color;
}


#pragma mark - 分割线颜色
//全部分割线颜色
+ (UIColor *)EKColorSeperateWhite {
    return @"e4e4e4".color;
}

//列表置顶分割线
+ (UIColor *)EKColorSeperateYellow {
    return @"fcd033".color;
}

//侧滑菜单分割线
+ (UIColor *)EKColorSeperateCyan {
    return @"0c8e83".color;
}


#pragma mark - 按钮颜色
//首次登陆按钮
+ (UIColor *)EKColorButtonYellow {
    return @"fac000".color;
}

//余下所有按钮
+ (UIColor *)EKColorButtonCyan {
    return @"109a8e".color;
}

//课程搜索按钮 -  浅棕
+ (UIColor *)EKColorButtonLightBrown {
    return @"C5AA90".color;
}

//课程搜索按钮 -  深棕
+ (UIColor *)EKColorButtonDarkBrown {
    return @"B18C69".color;
}


#pragma mark - "课程"使用的颜色
+ (UIColor *)EKColorCourseGreen {
    return @"336a68".color;
}


#pragma mark - 自定义圆形选择器使用的颜色
+ (UIColor *)EKColorCornerSelectMenuViewTitleColor {
    return @"336a68".color;
}


+ (UIColor *)EKColorCornerSelectMenuViewBorderColor {
    return @"109B8F".color;
}

+ (UIColor *)cellSpace:(BOOL)status {
    return status ? @"#f4f4f4".color : @"#ffffff".color;
}


#pragma mark - WebView进度条使用的颜色
+ (UIColor *)EKColorWebViewProgressTrackTintColor {
    return @"a1e2dc".color;
}


+ (UIColor *)EKColorWebViewProgressTintColor {
    return @"ecfffd".color;
}
@end
