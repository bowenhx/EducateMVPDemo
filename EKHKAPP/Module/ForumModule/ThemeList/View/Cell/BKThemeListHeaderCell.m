/**
 -  BKThemeListHeaderCell.m
 -  BKHKAPP
 -  Created by HY on 2017/8/24.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 */

#import "BKThemeListHeaderCell.h"
#import "BKScrollSelectMenuView.h"
#import "EKColumnView.h"

@interface BKThemeListHeaderCell () <BKScrollSelectMenuViewDelegate>

//板块图标
@property (weak, nonatomic) IBOutlet UIImageView *vIconImage;

//板块名称
@property (weak, nonatomic) IBOutlet UILabel *vTitleLaebl;

//主题
@property (weak, nonatomic) IBOutlet UILabel *vThemeLabel;

//今日主题
@property (weak, nonatomic) IBOutlet UILabel *vTodayLabel;

//收藏按钮
@property (weak, nonatomic) IBOutlet UIButton *vCollectBtn;

//滑动menu，上面显示该板块下的主题
@property (weak, nonatomic) IBOutlet BKScrollSelectMenuView *vMenuView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vMenuHeightConstraint;


//盛放menu的array
@property (nonatomic, strong) NSMutableArray *vThemeMenuArray;


@end

@implementation BKThemeListHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _vThemeMenuArray = [[NSMutableArray alloc] init];
    _vIconImage.layer.masksToBounds = YES;
    _vIconImage.layer.cornerRadius = _vIconImage.frame.size.width/2;
}

- (void)mRefreshForumHeadCell:(BKThemeListForumModel *)model viewType:(BKThemeListViewControllerType)viewType selectClassIndex:(NSInteger)selectClassIndex {
    
    _vForumModel = model;
    
    [self.vIconImage sd_setImageWithURL:[NSURL URLWithString:model.icon]
                       placeholderImage:[UIImage imageNamed:kPlaceHolderForumAvatar]];
    self.vTitleLaebl.text = model.name;
    self.vThemeLabel.text = [NSString stringWithFormat:@"%ld",(long)model.threads];
    self.vTodayLabel.text = [NSString stringWithFormat:@"%ld",(long)model.todayposts];
    
    //根据页面类型，显示不同ui
    if (viewType == BKThemeListViewController_Forum) {
     
        //从板块进入该页面显示版主lable
        NSArray *modlist = model.modlist;
        if (modlist.count) {
            self.vMemberButton.hidden = NO;
            [self.vMemberButton setTitle:@"版主 >" forState:UIControlStateNormal];
        }else{
            self.vMemberButton.hidden = YES;
        }
        
        //收藏按钮逻辑 
        NSInteger favid = _vForumModel.favid;
        if (favid == 0) {
            favid = model.fid;
            self.vCollectBtn.selected = NO;
        }else{
            self.vCollectBtn.selected = YES;
        }
    }

    [_vThemeMenuArray removeAllObjects];
    //初始化滑动小标签view
    if (model.threadtypes.count > 0) {
        NSMutableArray *themeTitle = [[NSMutableArray alloc] init];
        for (int i = 0; i < model.threadtypes.count; i++) {
            BKThemeMenuModel *menumodel = [model.threadtypes objectAtIndex:i];
            [themeTitle addObject:menumodel.name];
            [_vThemeMenuArray addObject:menumodel];
        }
        
        //在数组的第一个位置插入，“全部”
        BKThemeMenuModel *tempmodel = [[BKThemeMenuModel alloc] init];
        tempmodel.vid = 0;
        tempmodel.name = @"全部";
        tempmodel.icon = @"";
        
        [_vThemeMenuArray insertObject:tempmodel atIndex:0];
        [themeTitle insertObject:tempmodel.name atIndex:0];
        
        //生成滑动menu
        _vMenuView.titleArray = themeTitle;
        _vMenuView.delegate = self;
        _vMenuView.vSelectedIndex = selectClassIndex;

    } else {
        self.vMenuHeightConstraint.constant = 0;
        self.vMenuView.hidden = YES;
    }
}

#pragma mark - 点击头部BKScrollSelectMenuView
- (void)mScrollSelectMenuViewDidSelectWithIndex:(NSInteger)index {
    BKThemeMenuModel *model = [_vThemeMenuArray objectAtIndex:index];
    if (self.delegate && [self.delegate respondsToSelector:@selector(mTouchSlideThemeMenuWithModel:tableIndex:selectClassIndex:)]) {
        [self.delegate mTouchSlideThemeMenuWithModel:model tableIndex:self.vCurrentTableIndex selectClassIndex:index];
    }
}


#pragma mark - 表头按钮点击事件

//点击收藏按钮
- (IBAction)mTouchCollectBtn:(id)sender {
    
    if (!LOGINSTATUS) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(mTouchCollectBtnWithNotLogin)]) {
            [self.delegate mTouchCollectBtnWithNotLogin];
        }
        return;
    }
    
    UIButton *btn = sender;
    btn.enabled = NO;

    //取消收藏
    if (btn.selected) {
        [EKHttpUtil mHttpWithUrl:kUserCancelCollectURL parameter:@{@"token":TOKEN,@"favid":@(_vForumModel.favid)} response:^(BKNetworkModel *model, NSString *netErr) {
            btn.enabled = YES;
            if (netErr) {
                [self showHUDTitleView:netErr image:nil];
                
            } else if ( model.status == 1 ) {
                btn.selected = !btn.selected;
                
                //修改数据源
                _vForumModel.favid = 0;
                [self showSuccess:model.message];
                [EKColumnView mReloadData]; //更新侧边栏收藏列表

            } else {
                [self showError:model.message];
            }
        }];
        
    } else {
        
        //添加收藏
        [EKHttpUtil mHttpWithUrl:kUserAddCollectURL parameter:@{@"token":TOKEN,@"type":@"forum",@"id":@(_vForumModel.fid)}  response:^(BKNetworkModel *model, NSString *netErr) {
            btn.enabled = YES;
            if (netErr) {
                [self showHUDTitleView:netErr image:nil];
                
            } else  if (model.status == 1) {
                btn.selected = !btn.selected;
                
                //修改数据源
                _vForumModel.fid = [model.data[@"id"] integerValue];
                _vForumModel.favid = [model.data[@"favid"] integerValue];;
                [self showSuccess:model.message];
                [EKColumnView mReloadData]; //更新侧边栏收藏列表

            } else {
                [self showError:model.message];
            }
        }];
    }
    
}

//点击版主
- (IBAction)mTouchMemberClick:(id)sender {

    if (self.delegate && [self.delegate respondsToSelector:@selector(mTouchForumModeratorClick:)]) {
        [self.delegate mTouchForumModeratorClick:_vForumModel];
    }
    
}

@end
