/**
 -  EKPhotoAlbumViewController.h
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/11/1.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:这是"相册"界面
 */

#import "EKPhotoAlbumViewController.h"
#import "EKPhotoAlbumModel.h"
#import "EKPhotoAlbumCell.h"
#import "EKPhotoAlbumSecondViewController.h"

@interface EKPhotoAlbumViewController () <UICollectionViewDelegate,
                                          UICollectionViewDataSource,
                                          UIAlertViewDelegate>
//主体的collectionView
@property (nonatomic, strong) UICollectionView *vCollectionView;
//后台返回的数据源数组
@property (nonatomic, strong) NSArray <EKPhotoAlbumModel *> *vPhotoAlbumDataSource;
//用来记录当前点击的相册对应的model
@property (nonatomic, strong) EKPhotoAlbumModel *vCurrentPhotoAlbumModel;
//用来相册ID
@property (nonatomic, copy) NSString *vCurrentAlbumid;
//用来记录相册密码
@property (nonatomic, copy) NSString *vCurrentPassword;
@end

@implementation EKPhotoAlbumViewController

#pragma mark - 初始化UI
- (void)mInitUI {
    //判断是否从用户资料页进入
    if (_username) {
        self.title = [NSString stringWithFormat:@"%@的相冊", _username];
    } else {
        self.title = @"我的相册";
    }
    
    //创建collectionView布局对象
    UICollectionViewFlowLayout *collectionViewFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    collectionViewFlowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    collectionViewFlowLayout.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20);
    collectionViewFlowLayout.minimumInteritemSpacing = 4;
    collectionViewFlowLayout.minimumLineSpacing = 10;
    collectionViewFlowLayout.itemSize = CGSizeMake(SCREEN_WIDTH / 2.4, SCREEN_WIDTH / 2.4 + 45.0f);
    
    //创建collectionView
    _vCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:collectionViewFlowLayout];
    [self.view addSubview:_vCollectionView];
    _vCollectionView.backgroundColor = [UIColor EKColorTableBackgroundGray];
    [_vCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.right.bottom.equalTo(self.view);
    }];
    _vCollectionView.dataSource = self;
    _vCollectionView.delegate = self;
    UINib *collectionViewNib = [UINib nibWithNibName:@"EKPhotoAlbumCell" bundle:nil];
    [_vCollectionView registerNib:collectionViewNib forCellWithReuseIdentifier:photoAlbumCellID];
}


#pragma mark - 初始化数据
- (void)mInitData {
    //请求后台数据
    [self.view showHUDActivityView:kStartLoadingText shade:NO];
    [EKPhotoAlbumModel mRequestPhotoAlbumDataWithUserID:_uid
                                               callBack:^(NSString *netErr, NSArray<EKPhotoAlbumModel *> *data) {
                                                   [self.view removeHUDActivity];
                                                   if (netErr) {
                                                       [self.view showError:netErr];
                                                   } else {
                                                       _vPhotoAlbumDataSource = data;
                                                       [_vCollectionView reloadData];
                                                   }
                                               }];
}


#pragma mark - UICollectionViewDataSource
//返回个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _vPhotoAlbumDataSource.count;
}


//返回cell
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    EKPhotoAlbumCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:photoAlbumCellID forIndexPath:indexPath];
    cell.vPhotoAlbumModel = _vPhotoAlbumDataSource[indexPath.row];
    return cell;
}


#pragma mark - UICollectionViewDelegate
//点击时候调用
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    EKPhotoAlbumModel *photoAlbumModel = _vPhotoAlbumDataSource[indexPath.row];
    NSString *password = photoAlbumModel.password;
    _vCurrentPhotoAlbumModel = photoAlbumModel;
    if (password.length) {
        _vCurrentPassword = password;
        _vCurrentAlbumid = photoAlbumModel.albumid;
        
        //判断是否之前有输入过密码
        NSDictionary *albumDict = [BKSaveData getDictionary:kPhotoAlbumPasswordKey];
        if (albumDict) {
            NSString *savePassword = albumDict[[NSString stringWithFormat:@"album_pw_%@",_vCurrentAlbumid]];
            if ([savePassword isEqualToString:password]) {//保存的密码和相册密码配对
                //打开到相册
                [self mPushToSecondViewController];
                return;
            }
        }
        
        //当前查看用户不是自己 && 不是管理员
        if (_uid
            && ![_uid isEqualToString:USERID]
            && ([USER.groupid integerValue] != 1)) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"請輸入相冊密碼" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"確定", nil];
            alertView.alertViewStyle = UIAlertViewStyleSecureTextInput;
            [alertView show];
            UITextField *textField = [alertView textFieldAtIndex:0];
            textField.backgroundColor = [UIColor whiteColor];
            textField.textAlignment = NSTextAlignmentCenter;
            textField.borderStyle = UITextBorderStyleNone;
        } else {
            [self mPushToSecondViewController];
        }
    } else {
        [self mPushToSecondViewController];
    }
}


#pragma mark - 私有方法
//打开到相册图片列表页面
- (void)mPushToSecondViewController {
    EKPhotoAlbumSecondViewController *photoAlbumSecondViewController = [[EKPhotoAlbumSecondViewController alloc] init];
    if (_uid) {
        photoAlbumSecondViewController.uid = _uid;
    }
    photoAlbumSecondViewController.albumid = _vCurrentPhotoAlbumModel.albumid;
    photoAlbumSecondViewController.photoGalleryName = _vCurrentPhotoAlbumModel.albumname;
    photoAlbumSecondViewController.password = _vCurrentPassword ? _vCurrentPassword : @"";
    [self.navigationController pushViewController:photoAlbumSecondViewController animated:YES];
}


#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    UITextField *textField = [alertView textFieldAtIndex:0];
    if ([BKTool isStringBlank:textField.text]) {
        [self.view showHUDTitleView:@"输入密码才能訪問" image:nil];
    } else {
        if ([_vCurrentPassword isEqualToString:textField.text]) {
            //密码正确
            [self mPushToSecondViewController];
            //進入該頁面后，當密碼不為空時，存到本地字典中
            NSDictionary *dic = [BKSaveData getDictionary:kPhotoAlbumPasswordKey];
            NSMutableDictionary *addPawDic = [NSMutableDictionary dictionaryWithDictionary:dic];
            NSString *albumKey = [NSString stringWithFormat:@"album_pw_%@",_vCurrentAlbumid];
            [addPawDic setObject:_vCurrentPassword forKey:albumKey];
            [BKSaveData setDictionary:addPawDic key:kPhotoAlbumPasswordKey];
        } else {
            [self.view showHUDTitleView:@"密碼不正確，請重新輸入！" image:nil];
        }
    }
}


@end
