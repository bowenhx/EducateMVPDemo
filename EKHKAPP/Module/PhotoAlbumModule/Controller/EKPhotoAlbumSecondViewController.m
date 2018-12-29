/**
 -  EKPhotoAlbumSecondViewController.m
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/11/1.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:这是相册界面的次级界面
 */

#import "EKPhotoAlbumSecondViewController.h"
#import "EKPhotoAlbumSecondCell.h"
#import "EKPhotoAlbumSecondModel.h"

@interface EKPhotoAlbumSecondViewController () <UICollectionViewDelegate,
                                                UICollectionViewDataSource,
                                                ZLPhotoPickerBrowserViewControllerDelegate>
//主体的collectionView
@property (nonatomic, strong) UICollectionView *vCollectionView;
//数据源数组
@property (nonatomic, strong) NSArray <EKPhotoAlbumSecondModel *> *vPhotoAlbumSecondDataSource;
@end

@implementation EKPhotoAlbumSecondViewController
#pragma mark - 初始化UI
- (void)mInitUI {
    self.title = _photoGalleryName;
    self.automaticallyAdjustsScrollViewInsets = NO;
    //布局
    UICollectionViewFlowLayout *galleryFlowLayout = UICollectionViewFlowLayout.new;
    galleryFlowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    galleryFlowLayout.sectionInset = UIEdgeInsetsMake(1, 1, 2, 1);
    galleryFlowLayout.minimumInteritemSpacing = 1;
    galleryFlowLayout.minimumLineSpacing = 2;
    galleryFlowLayout.itemSize = CGSizeMake(SCREEN_WIDTH / 4.1f, SCREEN_WIDTH / 4.1f);
    
    //创建UICollectionView
    _vCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:galleryFlowLayout];
    _vCollectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    [_vCollectionView setBackgroundColor:[UIColor EKColorTableBackgroundGray]];
    [_vCollectionView setDataSource:self];
    [_vCollectionView setDelegate:self];
    [_vCollectionView setScrollEnabled:YES];
    [_vCollectionView setShowsVerticalScrollIndicator:NO];
    //注册cell
    [_vCollectionView registerNib:[UINib nibWithNibName:@"EKPhotoAlbumSecondCell" bundle:nil]
      forCellWithReuseIdentifier:photoAlbumSecondCellID];
    [_vCollectionView setAlwaysBounceVertical:YES];
    [self.view addSubview:_vCollectionView];
    [_vCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(NAV_BAR_HEIGHT);
    }];
}


#pragma mark - 初始化数据
- (void)mInitData {
    [self.view showHUDActivityView:kStartLoadingText shade:NO];
    [EKPhotoAlbumSecondModel mRequestPhotoAlbumSecondDataSourceWithAlbumID:_albumid
                                                                       uid:_uid
                                                                  password:_password
                                                                  callBack:^(NSString *netErr, NSArray<EKPhotoAlbumSecondModel *> *data) {
                                                                      [self.view removeHUDActivity];
                                                                      if (netErr) {
                                                                          [self.view showError:netErr];
                                                                      } else {
                                                                          _vPhotoAlbumSecondDataSource = data;
                                                                          [_vCollectionView reloadData];
                                                                          if (!data.count) {
                                                                              [self.view showHUDTitleView:@"沒有更多圖片" image:nil];
                                                                          }
                                                                      }
                                                                  }];
}


#pragma mark - UICollectionViewDataSource
//返回组
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _vPhotoAlbumSecondDataSource.count;
}


//返回cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    EKPhotoAlbumSecondCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:photoAlbumSecondCellID forIndexPath:indexPath];
    cell.vPhotoAlbumSecondModel = _vPhotoAlbumSecondDataSource[indexPath.row];
    return cell;
}


#pragma mark -  UICollectionViewDelegate
//点击cell时调用
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //图片游览器
    ZLPhotoPickerBrowserViewController *pickerBrowser = [[ZLPhotoPickerBrowserViewController alloc] init];
    //淡入淡出效果
    pickerBrowser.status = UIViewAnimationAnimationStatusFade;
    //数据源/delegate
    pickerBrowser.editing = YES;
    pickerBrowser.editText = @"保存";
    
    NSMutableArray *photoArray = [NSMutableArray array];
    for (EKPhotoAlbumSecondModel *secondModel in _vPhotoAlbumSecondDataSource) {
        ZLPhotoPickerBrowserPhoto *photo = [[ZLPhotoPickerBrowserPhoto alloc] init];
        photo.photoURL = [NSURL URLWithString:secondModel.filepath];
        [photoArray addObject:photo];
    }
    pickerBrowser.photos = photoArray;
    
    //能够删除
    pickerBrowser.delegate = self;
    //当前选中的值
    pickerBrowser.currentIndex = indexPath.row;
    //展示控制器
    [pickerBrowser showPickerVc:self];
}


@end
