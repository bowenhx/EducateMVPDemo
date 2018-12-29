//
//  CourseTableViewCell.m
//  EduKingdom
//
//  Created by HY on 16/7/6.
//  Copyright © 2016年 com.mobile-kingdom.ekapps. All rights reserved.
//

#import "CourseTableViewCell.h"
#import "UIColor+app.h"

@implementation CourseTableViewCell

-(void)mRefreshCourseCell:(NSInteger)row data:(CourseSearchModel *)data{
    self.vTitle.text = data.name;
    self.vAge.text = data.agegroup;
    self.vDistrict.text = data.district;
    self.vPrise.text = data.fee;
    self.vLocal.text = data.company;
    
    //cell背景顏色賦值
    self.contentView.backgroundColor = [UIColor cellSpace:row % 2];
}

@end
