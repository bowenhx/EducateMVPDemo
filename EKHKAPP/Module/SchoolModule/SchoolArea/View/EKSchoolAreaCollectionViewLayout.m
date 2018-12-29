/**
 -  EKSchoolAreaCollectionViewLayout.m
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/9/11.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:这是"学校"的collectionView的布局对象
 */

#import "EKSchoolAreaCollectionViewLayout.h"

@implementation EKSchoolAreaCollectionViewLayout
- (void)prepareLayout {
    [super prepareLayout];
    
    //cell之间的间隔
    CGFloat margin = 1;
    //每一行cell的个数
    CGFloat count = 2;
    //cell的高度
    CGFloat height = 35;
    self.itemSize = CGSizeMake((SCREEN_WIDTH - margin) / count, height);
    self.minimumLineSpacing = margin;
    self.minimumInteritemSpacing = margin;
    //设置组头视图尺寸
    self.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, height);
}
@end
