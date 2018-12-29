/**
 -  BKThemeListPresenter.m
 -  BKHKAPP
 -  Created by HY on 2017/8/22.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 */

#import "BKThemeListPresenter.h"
#import "EKADViewController.h"

//P是中介(职责是用于关联M和V)
@interface BKThemeListPresenter ()

@property (nonatomic, strong) BKThemeListModel *vThemeModel;

@end

@implementation BKThemeListPresenter

#pragma mark - 初始化
- (instancetype)init {
    self = [super init];
    if (self) {
        //持有M层的引用
        _vThemeModel = [[BKThemeListModel alloc] init];
    }
    return self;
}

#pragma mark - 请求主题列表数据
- (void)mRequestThemeListWithPage:(NSInteger)page fid:(NSString *)fid order:(NSString *)order typeId:(NSInteger)typeId password:(NSString *)password index:(NSInteger)index{
    
    [_vThemeModel mRequestThemeListWithPage:page fid:fid order:order typeId:typeId password:password callBack:^(NSInteger status, BKThemeListDataModel *dataModel, NSString *error) {
        if (self.vThemeListProtocol) {
            [self.vThemeListProtocol mReceiveThemeListData:dataModel status:status error:error index:index];
            
            //如果页面数据请求成功，则保存密码在本地
            if (status == 1 && password.length > 0) {
                [self mSaveForumPassword:password fid:fid];
            }
        }
    }];
}

#pragma mark - 合并列表和banner广告数据
- (NSMutableArray *)mMergingDataSource:(NSMutableArray *)dataSourceArray bannerList:(NSMutableArray *)bannerList {
    
    NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:0];
    __block int i = 0;
    [dataSourceArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        //判断在适当的位置插入数据
        if (idx >0 && idx % kADSpace == 0 ) {
            if ( bannerList.count > i ) {
                BKThemeListModel *model = [[BKThemeListModel alloc] init];
                model.type = kAD;
                model.data = bannerList[i];
                [tempArray addObject:model];
                i++;
            }
        }
        BKThemeListModel *model = (BKThemeListModel *)obj;
        model.type = kNormal;
        [tempArray addObject:model];
        if (i == bannerList.count) i = 0;
    }];
    
    return tempArray;
}

#pragma mark - 返回一个cell，该cell上放的是广告
- (UITableViewCell *)mInitBannerAdCellWithTableview:(UITableView *)tableView listModel:(BKThemeListModel *)listModel {
    
    static NSString * const definCell = @"adCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:definCell];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:definCell];
    }
    BADBannerView *bannerView = (BADBannerView *)[cell.contentView viewWithTag:199];
    if (bannerView != nil) {
        [bannerView removeFromSuperview];
    }
    //添加banner广告view
    bannerView  = (BADBannerView *)listModel.data;
    bannerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, bannerView.vBannerHeight);
    [bannerView setTag:199];
    [cell.contentView addSubview:bannerView];
    return cell;
}

- (void)mSaveForumPassword:(NSString *)password fid:(NSString *)fid {
    
    if (![BKTool isStringBlank:password]) {
        //進入該頁面后，當密碼不為空時，存到本地字典中
        NSString *forumID = [NSString stringWithFormat:@"%@_%@",kForumPasswordKey,fid];
        NSDictionary *dic = [BKSaveData getDictionary:kForumPasswordKey];
        NSMutableDictionary *addPawDic = [NSMutableDictionary dictionaryWithDictionary:dic];
        [addPawDic setObject:password forKey:forumID];
        [BKSaveData setDictionary:addPawDic key:kForumPasswordKey];
    }
    
}

#pragma mark - 计算cell的高度
- (CGFloat)mCalculateCellHeightWithIndexPath:(NSIndexPath *)indexPath totalModel:(BKThemeListDataModel*)totalModel dataArray:(NSMutableArray *)dataArray{
    
    if (indexPath.section == 0) {
        BKThemeListForumModel *forum = totalModel.forum;
        if (forum && forum.threadtypes.count > 0) {
            return kThemeListForumHeight_ShowMenu;
        } else {
            return kThemeListForumHeight;
        }
    } else {
        
        if (dataArray.count > 0) {
            BKThemeListModel *model = [dataArray objectAtIndex:indexPath.row];
            if ([model.type isEqualToString:kAD]){
                BADBannerView  *bannerView = model.data;
                return bannerView.vBannerHeight;
            }
        }
        return UITableViewAutomaticDimension;
    }

}




@end
