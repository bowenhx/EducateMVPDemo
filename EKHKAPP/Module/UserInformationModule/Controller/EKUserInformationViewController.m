/**
 -  EKUserInformationViewController.m
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/10/31.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:这是查看别的用户的基本资料的界面
 */

#import "EKUserInformationViewController.h"
#import "EKBasicInformationModel.h"
#import "EKPhotoAlbumViewController.h"
#import "EKPhotoAlbumModel.h"
#import "EKSearchUserAlertController.h"
#import "EKSearchUserModel.h"
#import "EKUserInformationDeleteFriendButton.h"
#import "EKSearchAddFriendViewController.h"
#import "MessageWebViewController.h"
#import "EKMyThemeViewController.h"
#import "EKLoginViewController.h"

@interface EKUserInformationViewController () <EKSearchUserAlertControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *vAvatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *vNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *vGroupLabel;
@property (weak, nonatomic) IBOutlet UILabel *vCreditLabel;
@property (weak, nonatomic) IBOutlet UILabel *vThreadLabel;
//"删除好友""解除好友"按钮
@property (weak, nonatomic) IBOutlet EKUserInformationDeleteFriendButton *vDeleteFriendButton;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray <UIImageView *> *vImageViewArray;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vTopViewTopConstraint;
//后台返回的用户model
@property (nonatomic, strong) EKBasicInformationModel *vBasicFriendInformationModel;
//后台返回的相册model数组
@property (nonatomic, strong) NSArray <EKPhotoAlbumModel *> *vPhotoAlbumDataSource;
//本地字段,用来记录当前是否是好友关系.当调用setter方法的时候,会同时改变"删除好友"的按钮状态
@property (nonatomic, assign) BOOL vIsFriend;
@end

@implementation EKUserInformationViewController
//监听登录状态通知
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mInitData) name:kLoginSuccessNotification object:nil];
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kLoginSuccessNotification object:nil];
}


#pragma mark - 初始化UI
- (void)mInitUI {
    self.title = _name;
    [self.vRightBarButton setTitle:@"發私訊" forState:UIControlStateNormal];
    NSURL *imageURL = [NSURL URLWithString:_userImageURLString];
    [_vAvatarImageView sd_setImageWithURL:imageURL
                         placeholderImage:[UIImage imageNamed:kPlaceHolderAvatar]];
    _vNameLabel.text = _name;
    //默认一开始进来的时候,"删除好友"按钮隐藏
    _vDeleteFriendButton.hidden = YES;
    //适配ipX
    _vTopViewTopConstraint.constant = NAV_BAR_HEIGHT;
}


#pragma mark - 初始化数据
- (void)mInitData {
    [self.view showHUDActivityView:kStartLoadingText shade:NO];
    //请求指定好友的基本资料
    [EKBasicInformationModel mRequestFriendBasicInformationModelWithUid:_uid callBack:^(NSString *netErr, EKBasicInformationModel *friendBasicInformationModel) {
        [self.view removeHUDActivity];
        if (netErr) {
            [self.view showError:netErr];
        } else {
            self.vBasicFriendInformationModel = friendBasicInformationModel;
        }
    }];
    
    //请求指定好友的相册资料
    [EKPhotoAlbumModel mRequestPhotoAlbumDataWithUserID:_uid callBack:^(NSString *netErr, NSArray<EKPhotoAlbumModel *> *data) {
        if (!netErr) {
            _vPhotoAlbumDataSource = data;
            //更新UI,显示3张缩略图
            for (NSInteger i = 0; i < _vImageViewArray.count; i++) {
                if (i == data.count) {
                    break;
                }
                NSURL *imageURL = [NSURL URLWithString:data[i].pic];
                [_vImageViewArray[i] sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:kPlaceHolderWhite]];
            }
        }
    }];
}


#pragma mark - 重写setter方法,更新UI
- (void)setVBasicFriendInformationModel:(EKBasicInformationModel *)vBasicFriendInformationModel {
    _vBasicFriendInformationModel = vBasicFriendInformationModel;
    
    _vGroupLabel.text = vBasicFriendInformationModel.group;
    _vCreditLabel.text = vBasicFriendInformationModel.credits;
    _vThreadLabel.text = [NSString stringWithFormat:@"(%@)",vBasicFriendInformationModel.threads];
    
    //后台返回0,表明不是好友.
    //后台返回1,表明已经是好友.
    //后台返回2,表明已经发送请求,正在等待对方验证
    self.vIsFriend = (1 == vBasicFriendInformationModel.isfriend.integerValue);
}


- (void)setVIsFriend:(BOOL)vIsFriend {
    _vIsFriend = vIsFriend;
    //在获得后台返回的是否是好友的字段之后,再显示按钮(默认一进入的时候是隐藏的)
    //但是注意,如果当前登录用户查看自己的信息,则按钮需要隐藏起来
    _vDeleteFriendButton.hidden = [_uid isEqualToString:USERID];
    
    _vDeleteFriendButton.selected = !vIsFriend;
}


#pragma mark - 按钮监听事件
//导航栏右侧按钮的点击方法,跳转到"聊天详情"
- (void)mTouchRightBarButton {
    if ([EKLoginViewController showLoginVC:self from:@"inPage"]) {
        return;
    }
    MessageWebViewController *messageWebViewController = [[MessageWebViewController alloc] init];
    messageWebViewController.webURL = _vBasicFriendInformationModel.weburl;
    messageWebViewController.friendUID = _uid;
    messageWebViewController.friendName = _name;
    [self.navigationController pushViewController:messageWebViewController animated:YES];
}


//跳转到"话题"界面
- (IBAction)mPushToTopicViewController:(id)sender {
    if ([EKLoginViewController showLoginVC:self from:@"inPage"]) {
        return;
    }
    EKMyThemeViewController *myThemeViewController = [[EKMyThemeViewController alloc] init];
    myThemeViewController.vUserName = _name;
    myThemeViewController.vUid = _uid;
    [self.navigationController pushViewController:myThemeViewController animated:YES];
}


//跳转到"相册"界面
- (IBAction)mPushToPhotoAlbumViewController:(id)sender {
    if ([EKLoginViewController showLoginVC:self from:@"inPage"]) {
        return;
    }
    EKPhotoAlbumViewController *photoAlbumViewController = [[EKPhotoAlbumViewController alloc] init];
    photoAlbumViewController.uid = _uid;
    photoAlbumViewController.username = _name;
    [self.navigationController pushViewController:photoAlbumViewController animated:YES];
}


//点击"解除好友"/"加为好友"按钮
- (IBAction)mDeleteFriend:(id)sender {
    if ([EKLoginViewController showLoginVC:self from:@"inPage"]) {
        return;
    }
    //如果当前是朋友,则弹出弹窗询问是否解除好友
    if (_vIsFriend) {
        //弹出弹窗控制器
        EKSearchUserAlertController *alertController = [[EKSearchUserAlertController alloc] initWithDelegate:self];
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        //如果当前不是好友,则跳转到添加好友的界面
        EKSearchAddFriendViewController *addFriendViewController = [[EKSearchAddFriendViewController alloc] init];
        addFriendViewController.vUserName = _name;
        addFriendViewController.vUid = _uid;
        [self.navigationController pushViewController:addFriendViewController animated:YES];
    }
    
}


#pragma mark - EKSearchUserAlertControllerDelegate - 解除好友的弹窗控制器的代理方法
//解除好友的"确定"按钮点击的时候调用
- (void)mSearchUserAlertControllerConfirmButtonDidClick {
    [self.view showHUDActivityView:kStartLoadingText shade:NO];
    [EKSearchUserModel mRequestDeleteFriendWithUid:_uid callBack:^(BOOL isSuccess, NSString *message) {
        [self.view removeHUDActivity];
        [self.view showSuccess:message];
        if (isSuccess) {
            self.vIsFriend = NO;
            //告诉上一层控制器朋友关系解除,得刷新UI
            if (_delegate && [_delegate respondsToSelector:@selector(mDeleteFriendWithUID:)]) {
                [_delegate mDeleteFriendWithUID:_uid];
            }
        }
    }];
}


@end
