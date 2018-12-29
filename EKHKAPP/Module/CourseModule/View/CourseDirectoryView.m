//
//  CourseDirectoryView.m
//  EduKingdom
//
//  Created by HY on 16/7/7.
//  Copyright © 2016年 com.mobile-kingdom.ekapps. All rights reserved.
//

#import "CourseDirectoryView.h"
#import "CourseSearchModel.h"
#define DEF_LeftCell_Height  60
#define DEF_RightCell_Height 50

@implementation CourseDirectoryView

+(CourseDirectoryView *)mGetInstance{
    CourseDirectoryView *view = [[[NSBundle mainBundle] loadNibNamed:@"CourseDirectoryView" owner:nil options:nil] firstObject];
    if (view) {
        [view mInit];
    }
    return view;
}

//初始化
- (void)mInit {

    vLeftTable.delegate = self;
    vLeftTable.dataSource = self;
    vRightTable.delegate = self;
    vRightTable.dataSource = self;
    [self mReloadData];
    
}

//课程目录数据
-(void)mReloadData{
    [self showHUDActivityView:@"正在加載..." shade:NO];
    [CourseCategoryModel loadDirectoryListResultData:^(NSArray *data, NSString *netErr) {
        [self removeHUDActivity];
        if (data) {
            NSLog(@"data = %@",data);
            vSourceArray = [NSArray arrayWithArray:data];
            [vLeftTable reloadData];
            [vRightTable reloadData];
        }else{
            [self showHUDTitleView:netErr image:nil];
        }
    }];
}

#pragma mark -
#pragma mark UITableViewDelegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"aaa";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    cell.backgroundColor = [UIColor clearColor];
    
    //删除之前存在的label
    for (UILabel *label in cell.contentView.subviews) {
        [label removeFromSuperview];
    }

    if (tableView == vLeftTable) {
        CourseCategoryModel *model = [vSourceArray objectAtIndex:indexPath.row];
        [cell.contentView addSubview:[self mCreateLabel:model.name table:vLeftTable]];
    }else{
        CourseCategoryModel *model = [vSourceArray objectAtIndex:indexPath.section];
        NSArray *arr = model.cs;
        [cell.contentView addSubview:[self mCreateLabel:[arr objectAtIndex:indexPath.row][@"name"] table:vRightTable]];
    }
    return cell;
}

//返回多少个区
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == vLeftTable) {
        return 1;
    }else{
        return vSourceArray.count;
    }
}

//返回个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == vLeftTable) {
        return vSourceArray.count;
    }else{
        CourseCategoryModel *model = [vSourceArray objectAtIndex:section];
        return model.cs.count;
    }
}

//返回高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == vLeftTable) {
        return DEF_LeftCell_Height;
    }else{
        return DEF_RightCell_Height;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == vRightTable) {
        return DEF_RightCell_Height;
    }
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView == vRightTable) {
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, vRightTable.w, 40)];
        headView.backgroundColor = [UIColor EKColorTableBackgroundGray];
        headView.tag = section; //标示index
        //新建tap手势
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
        [headView addGestureRecognizer:tapGesture];
        
        //标题图片
        UIImageView *iconImage = [[UIImageView alloc] init];
        iconImage.contentMode = UIViewContentModeCenter;
        iconImage.image = [UIImage imageNamed:@"vi_starsv"];
        [headView addSubview:iconImage];
        CGFloat iconImageLeftMargin = 9;
        [iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(headView).offset(iconImageLeftMargin);
            make.centerY.equalTo(headView);
            make.size.mas_equalTo(iconImage.image.size);
        }];
        
        //板块标题
        CourseCategoryModel *model = [vSourceArray objectAtIndex:section];
        UILabel *labText = [[UILabel alloc] init];
        if (model.name) {
            NSDictionary *attributes = @{NSKernAttributeName : @(1.5)};
            labText.attributedText = [[NSAttributedString alloc] initWithString:model.name attributes:attributes];
        }
        labText.textColor = [UIColor EKColorCourseGreen];
        labText.font = [UIFont systemFontOfSize:15];
        [headView addSubview:labText];
        CGFloat labTextLeftMargin = 7;
        CGFloat labTextRightMargin = -10;
        [labText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(headView);
            make.left.equalTo(iconImage.mas_right).offset(labTextLeftMargin);
            make.right.equalTo(headView).offset(labTextRightMargin);
        }];
        return headView;
    }
    return nil;
}

//点击单元格
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == vLeftTable) {
        _selectIndex = indexPath.row;
        [vLeftTable reloadData];
        //设置二级section显示到顶部
        CGRect rectSet = [vRightTable rectForSection:_selectIndex];
        [vRightTable setContentOffset:CGPointMake(0, rectSet.origin.y) animated:YES];
    }else{
        [tableView  deselectRowAtIndexPath:indexPath animated:YES];
        
        CourseCategoryModel *model = [vSourceArray objectAtIndex:indexPath.section];
        NSString *strId = [model.cs objectAtIndex:indexPath.row][@"id"];
        NSString *strName = [model.cs objectAtIndex:indexPath.row][@"name"];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:strId.length>0?strId:@"" forKey:@"categoryid"];//课程目录
        //点击子分类，跳转到对应的课程列表
        if (self.vDelegate && [self.vDelegate respondsToSelector:@selector(mSelectDirectoryRowClick:title:)]) {
            [self.vDelegate mSelectDirectoryRowClick:dic title:strName];
        }
    }
    
}

#pragma  mark  点击表头
-(void)tapGesture:(id)sender{
    UITapGestureRecognizer *tap = sender;
    CourseCategoryModel *model = [vSourceArray objectAtIndex:tap.view.tag];
    NSString *strId = [NSString stringWithFormat:@"%zd",model.vId];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:strId.length>0?strId:@"" forKey:@"categoryid"];//课程目录
    //点击大分类，跳转到对应的课程列表
    if (self.vDelegate && [self.vDelegate respondsToSelector:@selector(mSelectDirectoryRowClick:title:)]) {
        [self.vDelegate mSelectDirectoryRowClick:dic title:model.name];
    }
}

#pragma  mark ScrollViewDelegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self refreshTabOne:scrollView];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self refreshTabOne:scrollView];
}
- (void)refreshTabOne:(UIScrollView *)scrollView
{
    if (scrollView == vRightTable) {
        /**
         *  标示一级cell row 中箭头指向位置 ，这里通过坐标获取scrollView的contentOffset来返回对应的head section
         */
        NSIndexPath *indexPath = [vRightTable indexPathForRowAtPoint:scrollView.contentOffset];
        _selectIndex = indexPath.section;
        [vLeftTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_selectIndex inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        [vLeftTable reloadData];
    }
}

//创建居中的cell
-(UILabel *)mCreateLabel:(NSString *)text table:(UITableView *)table{
    UILabel *label = [[UILabel alloc] init];
    if (text) {
        NSDictionary *attributes = @{NSKernAttributeName : @(2)};
        label.attributedText = [[NSAttributedString alloc] initWithString:text attributes:attributes];
    }
    label.textColor = [UIColor EKColorTitleBlack];
    if (table == vLeftTable) {
        label.textAlignment = NSTextAlignmentCenter;
        label.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width/3, DEF_LeftCell_Height);
        label.font = [UIFont systemFontOfSize:15];
    }else{
        label.textAlignment = NSTextAlignmentLeft;
        label.frame = CGRectMake(35, 0, [UIScreen mainScreen].bounds.size.width/2, DEF_RightCell_Height);
        label.font = [UIFont systemFontOfSize:15];
    }
    return label;
}


@end
