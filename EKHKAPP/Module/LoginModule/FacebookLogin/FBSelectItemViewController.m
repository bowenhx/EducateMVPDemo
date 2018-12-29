//
//  FBSelectItemViewController.m
//  BKMobile
//
//  Created by ligb on 2017/8/11.
//  Copyright © 2017年 com.mobile-kingdom.bkapps. All rights reserved.
//

#import "FBSelectItemViewController.h"
#import "FBItemCollectionViewCell.h"
#import "FBItemFooterReusableView.h"
#import "FBEditUserInfoPersenter.h"
#import "FBItemHeaderReusableView.h"

@interface FBSelectItemViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *vCollectionView;
@property (nonatomic, strong) NSMutableArray *itemArray;
@end

@implementation FBSelectItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"選擇你感興趣的分類";
    
    [self loadNewView];
}

- (void)loadNewView{
    
    [self.vCollectionView registerNib:[UINib nibWithNibName:@"FBItemCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"itemCell"];
    
    [self.vCollectionView registerNib:
     [UINib nibWithNibName:@"FBItemHeaderReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"fBItemHeaderView"];
    
    [self.vCollectionView registerNib:
     [UINib nibWithNibName:@"FBItemFooterReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"fBItemFooterView"];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing = 0.0f;
    flowLayout.minimumLineSpacing = 15.0f;
    flowLayout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, 75);
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 20, 10, 20);
    CGSize size = SCREEN_WIDTH > 320 ? CGSizeMake(SCREEN_WIDTH / 3 - 40, 50) : CGSizeMake(SCREEN_WIDTH / 3 - 20, 50);
    flowLayout.itemSize = size;
    [self.vCollectionView setCollectionViewLayout:flowLayout];
    
}

- (void)didSelectCommitAction{
    NSString *category = [self.itemArray componentsJoinedByString:@"-"];
    self.dicCommit[@"category"] = category;
//    self.dicCommit[@"test"] = @1;
    FBEditUserInfoPersenter *persenter = [[FBEditUserInfoPersenter alloc] init];
    [persenter commitFBEditInfo:self.dicCommit block:^(BKNetworkModel *model, NSString *message) {
        if (message) {
            [self.view showHUDTitleView:message image:nil];
        } else{
            if (model.status ==1) {
                [self.navigationController popToRootViewControllerAnimated:YES];
                [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSuccessNotification object:nil];
            } else {
                [self.view showHUDTitleView:model.message image:nil];
            }
        }
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.category.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FBItemCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"itemCell" forIndexPath:indexPath];
    [cell.vSelectBtn addTarget:self action:@selector(didSelectItemAction:) forControlEvents:UIControlEventTouchUpInside];
    FBItemModel *model = self.category[indexPath.row];
    [cell.vSelectBtn setTitle:model.text forState:UIControlStateNormal];
    cell.vSelectBtn.tag = model.value.integerValue;
    if (indexPath.row < 3) {
        cell.vSelectBtn.selected = YES;
        [self.itemArray addObject:@(model.value.integerValue)];
    }
   
    return cell;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (kind == UICollectionElementKindSectionHeader) {
        FBItemHeaderReusableView *iView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"fBItemHeaderView" forIndexPath:indexPath];
        return iView;
    } else if (kind == UICollectionElementKindSectionFooter) {
        FBItemFooterReusableView *iView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"fBItemFooterView" forIndexPath:indexPath];
        [iView.vFooterBtn addTarget:self action:@selector(didSelectCommitAction) forControlEvents:UIControlEventTouchUpInside];
        return iView;
    }
    return nil;
}

//返回头footerView的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeMake(SCREEN_WIDTH,70.f);
}



- (void)didSelectItemAction:(UIButton *)btn{
    btn.selected = !btn.selected;
    
    if (btn.selected) {
        [self.itemArray addObject:@(btn.tag)];
    } else {
        
        NSMutableArray *arrTemp = [self.itemArray mutableCopy];
        for (int i = 0; i < self.itemArray.count; i++) {
            if (btn.tag == [self.itemArray[i] integerValue]) {
                [arrTemp removeObject:@(btn.tag)];
            }
        }
        self.itemArray = arrTemp;
    }
}
- (NSMutableDictionary *)dicCommit{
    if (!_dicCommit) {
        _dicCommit = [NSMutableDictionary dictionary];
    }
    return _dicCommit;
}
- (NSMutableArray *)itemArray{
    if (!_itemArray) {
        _itemArray = [NSMutableArray array];
    }
    return _itemArray;
}
@end
