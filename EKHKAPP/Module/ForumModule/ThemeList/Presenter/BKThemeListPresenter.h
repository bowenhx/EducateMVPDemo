/**
 -  BKThemeListPresenter.h
 -  BKHKAPP
 -  Created by HY on 2017/8/22.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明：主题列表的Presenter
 */

#import <Foundation/Foundation.h>
#import "BKThemeListProtocol.h"
#import "BKThemeListModel.h"
#import "BKThemeListHeaderCell.h"

@interface BKThemeListPresenter : NSObject

@property (nonatomic, weak) id <BKThemeListProtocol> vThemeListProtocol;

/**
 请求主题列表页面数据

 @param page     分页请求使用的页码值，page从1开始
 @param fid      板块id
 @param order    order为排序过滤参数，默认为空获取全部，当order=dateline最新，当order=digest精华。
 @param typeId   板块下面有一横列可滑动的分类选项，分类id
 @param password 板块密码，加密板块需要该参数
 */
- (void)mRequestThemeListWithPage:(NSInteger)page fid:(NSString *)fid order:(NSString *)order typeId:(NSInteger)typeId password:(NSString *)password index:(NSInteger)index;

/**
 保存不同板块所对应的密码

 @param password 板块密码
 @param fid 板块id
 */
- (void)mSaveForumPassword:(NSString *)password fid:(NSString *)fid;


/**
 合并主题列表页面数据和广告数据
 
 @param dataSourceArray 页面数据源
 @param bannerList 广告数据
 @return 返回合并后的数据源
 */
- (NSMutableArray *)mMergingDataSource:(NSMutableArray *)dataSourceArray bannerList:(NSMutableArray *)bannerList;


/**
 返回一个cell，该cell上放的是广告

 @param tableView 当前tableview
 @param listModel 列表数据
 @return 返回生成好的cell
 */
- (UITableViewCell *)mInitBannerAdCellWithTableview:(UITableView *)tableView listModel:(BKThemeListModel *)listModel;


/**
 计算cell的高度
 
 @param indexPath 当前cell的的indexPath
 @param totalModel 主题列表页面所有model数据源，需要使用其中的forummodel
 @param dataArray 放表的array
 @return 返回计算出来的cell高度
 */
-(CGFloat)mCalculateCellHeightWithIndexPath:(NSIndexPath *)indexPath totalModel:(BKThemeListDataModel*)totalModel dataArray:(NSMutableArray *)dataArray;



@end
