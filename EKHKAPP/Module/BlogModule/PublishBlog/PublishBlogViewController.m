/**
 -  PublishBlogViewController.m
 -  EKHKAPP
 -  Created by HY on 2017/11/8.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 */

#import "PublishBlogViewController.h"

static CGFloat WIDGET_SPACE = 15; //定义上下控件之间间距为10
static CGFloat PHOTOS_WIDTH = 75; //照片图片的宽，高
#define PHOTOS_SPACE (SCREEN_WIDTH - PHOTOS_WIDTH * 4 ) / 5  //图片的间距

#import "PublishBlogViewController.h"
#import "BlogTypeTableViewController.h"
#import "BKUserHelper.h"

@interface PublishBlogViewController ()<
UIActionSheetDelegate,
UIImagePickerControllerDelegate,
ZLPhotoPickerBrowserViewControllerDelegate,
UIPopoverControllerDelegate,
UINavigationControllerDelegate
> {
    __weak IBOutlet UIScrollView *_scrollView;
    __weak IBOutlet UITextField *_textField;
    __weak IBOutlet UITextView *_textView;
    __weak IBOutlet UILabel *textLab;
    __weak IBOutlet UITableView *_tableView;
    __weak IBOutlet NSLayoutConstraint *_tableViewConstraintY;
    
    NSArray     *_listData; //@"站點分類",@"隱私設置"
}

@property (nonatomic , strong) UIButton *photoBtn; //添加照片btn
@property (nonatomic , strong) NSMutableArray *assets;//照片数据源
@property (strong , nonatomic) UIPopoverController* imagePickerPopover;
@property (nonatomic , strong) NSMutableArray *typeNames; //存储日志小分类名字
@property (nonatomic , assign) NSUInteger tempTypeIndex;//临时标记站贴分类选中的index
@property (nonatomic , assign) NSUInteger tempTypeSetIndex;//临时标记隐私设置选中的index
@property (nonatomic , copy) NSArray *usernames;//好友名字
@property (nonatomic , copy) NSString *password;//密码
@property (nonatomic , assign) NSUInteger catid;//分类id

@end

@implementation PublishBlogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)mInitUI {
    self.title = @"寫日誌";
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.vRightBarButton setTitle:@"發佈" forState:UIControlStateNormal];
    _tableViewConstraintY.constant = self.photoBtn.h + 3*WIDGET_SPACE;
}

- (void)mInitData {
    _password = @"";
    _listData = @[@"站點分類",@"隱私設置"];
    [_tableView reloadData];
}

#pragma mark - 发布日志
- (void)mTouchRightBarButton {
    if ([BKTool isStringBlank:_textField.text]) {
        [self.view showHUDTitleView:@"日誌標題不能為空" image:nil];
        return;
    }
    
    NSString *target_names = @"";
    if (_tempTypeSetIndex == 2) {
        target_names = [_usernames componentsJoinedByString:@","];
    }
    
    NSDictionary *dicInfo = @{@"token":TOKEN,
                              @"catid":@(_catid),
                              @"subject":_textField.text,
                              @"message":_textView.text,
                              @"friend":@(_tempTypeSetIndex),
                              @"target_names":target_names,
                              @"password":_password};
    DLog(@"dicInfo = %@",dicInfo);
    
    __weak typeof(self) bself = self;
    [self showActivityView:@"0%"];
    MBProgressHUD *HUDpro = (MBProgressHUD *)[self.view viewWithTag:0xffff];
    NSArray *files = [self uploadingImageFiles:self.assets];

    [[BKNetworking share] upload:kBlogPostURL params:dicInfo files:files precent:^(float precent) {
        
        NSString *progressStr = [NSString stringWithFormat:@"%.1f", precent * 100];
        progressStr = [progressStr stringByAppendingString:@"%"];
        if (HUDpro) HUDpro.labelText = progressStr;
 
    } completion:^(BKNetworkModel *model, NSString *netErr) {
       
        self.navigationItem.rightBarButtonItem.enabled = YES;
        if (HUDpro) [HUDpro removeFromSuperview];
       
        if (netErr) {
            [self.view showHUDTitleView:netErr image:nil];
        
        } else if (model.status == 1) {
            if (self.assets.count >0) {
                [bself.view showSuccess:model.message];
            } else {
                [bself.view showHUDTitleView:model.message image:nil];
            }
            
            //延迟一秒返回上级页面
            [self backViewController];

        } else {
            [bself.view showHUDTitleView:model.message image:nil];
        }
    }];
}

#pragma mark - 发布日志，上传照片方法
- (NSArray *)uploadingImageFiles:(NSArray *)files {
    NSMutableArray *imageArr = [NSMutableArray arrayWithCapacity:files.count];
    [files enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImage *image = nil;
        if ([obj isKindOfClass:[ZLPhotoPickerBrowserPhoto class]]) {
            ZLPhotoPickerBrowserPhoto *photo = (ZLPhotoPickerBrowserPhoto *)obj;
            ZLPhotoAssets *asset = photo.asset;
            if (asset && [asset isKindOfClass:[ZLPhotoAssets class]]) {
                image = asset.originImage;
            } else {
                image = photo.photoImage;
            }
            if (image) {
                NSString *name = [NSString stringWithFormat:@"attach%lu",(unsigned long)++idx];
                [imageArr addObject:@[name , image]];
            }
        }
    }];
    return imageArr;
}

#pragma mark - TableVeiwDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _listData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *defineCell = @"defineCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:defineCell];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:defineCell];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    [self cellForRowSurplusTableViewCell:cell indexPath:indexPath];
    return cell;
}

- (void)cellForRowSurplusTableViewCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath {
    cell.textLabel.text = _listData[indexPath.row];
    cell.detailTextLabel.text = self.typeNames.count ? self.typeNames[indexPath.row] : @"";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BlogTypeTableViewController *blogTypeVC = [[BlogTypeTableViewController alloc] initWithNibName:@"BlogTypeTableViewController" bundle:nil];
    blogTypeVC.title = _listData[indexPath.row];
    blogTypeVC.blogSetting = indexPath.row;
    //记录选中的index
    blogTypeVC.selectIndex = indexPath.row == 0 ? _tempTypeIndex : _tempTypeSetIndex;
    [self.navigationController pushViewController:blogTypeVC animated:YES];
    
    blogTypeVC.typeObj = ^(BlogTypeModel *obj,NSString *setName,NSUInteger index){
        if (indexPath.row == 0) {//分类
            [_typeNames replaceObjectAtIndex:0 withObject:setName];
            _tempTypeIndex = index;//标记设置页面
            _catid = obj.catid;
        } else {//隐私设置
            [_typeNames replaceObjectAtIndex:1 withObject:setName];
            _tempTypeSetIndex = index;//标记设置页面
        }
        [_tableView reloadData];
    };
    
    blogTypeVC.freendsPw = ^(NSArray *usernames,NSString *password) {
        if (usernames.count) {
            //好友名字
            _usernames = [usernames copy];
        } else {
            //密码设置
            _password = password;
        }
    };
}

#pragma mark ----------------------- 选择照片模块 ----------------------

#pragma mark - 点击选择照片按钮
- (void)selectPhotoAction:(UIButton *)sender {
    [self cancelResponder];
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"手機相冊",@"系統拍照", nil];
    [sheet showInView:self.view];
}

#pragma mark - ActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0://手机相册
            [self localPhoto];
            break;
        case 1://拍照
            [self takePhoto];
            break;
        default:
            break;
    }
}

#pragma mark - 点击 选择相册
- (void)localPhoto{
    ZLPhotoPickerViewController *pickerVc = [[ZLPhotoPickerViewController alloc] init];
    pickerVc.status = PickerViewShowStatusCameraRoll;
    pickerVc.maxCount = 9;
    pickerVc.selectPickers = self.assets;
    pickerVc.photoStatus = PickerPhotoStatusPhotos;
    pickerVc.topShowPhotoPicker = YES;

    __weak typeof(self) bself = self;
    pickerVc.callBack = ^(NSArray<ZLPhotoAssets *> *status){
        if (_assets.count) [_assets removeAllObjects];
        for (ZLPhotoAssets *asset in status) {
            ZLPhotoPickerBrowserPhoto *photo = [[ZLPhotoPickerBrowserPhoto alloc] init];
            if ([asset isKindOfClass:[ZLPhotoAssets class]]) {
                photo.asset = asset;
                //当asset 找不到图片时可以取photoImage/ photoURL
                photo.photoImage = asset.originImage;
                photo.photoURL = asset.assetURL;
            } else if ([asset isKindOfClass:[ZLCamera class]]) {
                ZLCamera *camera = (ZLCamera *)asset;
                photo.photoImage = [camera photoImage];
            }
            [_assets addObject:photo];
        }
        [bself removeScrollViewSuperViewBtn];
    };
    
    if (IS_IPAD) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self presentViewController:pickerVc animated:YES completion:nil];
        }];
    } else {
        [self presentViewController:pickerVc animated:YES completion:nil];
    }
}

#pragma mark - 点击 拍照
- (void)takePhoto {
    if (self.assets.count >= 9) {
        [self.view showHUDTitleView:@"只能選擇9張圖片上傳" image:nil];
        return;
    }
    
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        //    imagePicker.allowsEditing = YES;
        //拍照
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.videoQuality = UIImagePickerControllerQualityTypeIFrame960x540;
        
        __weak typeof(self) weakSelf = self;
        
        if (IS_IPAD) {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [weakSelf presentViewController:imagePicker animated:YES completion:nil];
            }];
        } else{
            [weakSelf presentViewController:imagePicker animated:YES completion:nil];
        }
    } else {
        DLog(@"模拟其中无法打开照相机,请在真机中使用");
    }
}

//拍照后，会调用下面代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    image = [image scalingImageByRatio];
    image = [image normalizedImageOrientation];//调整图片
    
    //把牌照图片存储到本地
    NSString *path = [BKUserHelper saveImagePath:image];
    NSData *data = UIImageJPEGRepresentation(image, 0.6);
    image = [UIImage imageWithData:data];
    
    ZLPhotoAssets *assets = [[ZLPhotoAssets alloc] init];
    assets.originImage = image;
    assets.assetURL = [NSURL URLWithString:path];
    
    ZLPhotoPickerBrowserPhoto *photo = [[ZLPhotoPickerBrowserPhoto alloc] init];
    photo.asset = assets;
    photo.photoImage = image;
    photo.thumbImage = image;
    photo.photoURL = [NSURL URLWithString:path];
    
    [self.assets addObject:photo];
    
    [self removeScrollViewSuperViewBtn];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - <ZLPhotoPickerBrowserViewControllerDelegate>
- (void)photoBrowser:(ZLPhotoPickerBrowserViewController *)photoBrowser removePhotoAtIndex:(NSInteger)index{
    if (self.assets.count > index) {
        [self.assets removeObjectAtIndex:index];
        [self removeScrollViewSuperViewBtn];
    }
}

- (void)removeScrollViewSuperViewBtn {
    for (UIButton *buttonView in [_scrollView subviews]) {
        if ([buttonView isKindOfClass:[UIButton class]]) {
            //判断，不要把选择主题分类按钮删除掉
            if ([buttonView backgroundImageForState:UIControlStateNormal]) {
                [buttonView removeFromSuperview];
            }
        }
    }
    [self addPhotosImage];
}

- (void)addPhotosImage{
    DLog(@"width  = %f",SCREEN_WIDTH);
    float Y = CGRectGetMaxY(_textView.frame) + WIDGET_SPACE;
    // 加一是为了有个添加button
    NSInteger count = self.assets.count +1;
    for (int i = 0; i < count; i++) {
        float addBtnX = PHOTOS_SPACE + (PHOTOS_SPACE + PHOTOS_WIDTH) * (i%4);
        float addBtnY = Y + (WIDGET_SPACE + PHOTOS_WIDTH) * (i/4);
        //多算一个frame确定添加按钮的坐标位置
        if (i == self.assets.count) {
            if (i > 8) {
                self.photoBtn.hidden = YES;
            } else {
                self.photoBtn.hidden = NO;
                self.photoBtn.frame = CGRectMake(addBtnX, addBtnY, PHOTOS_WIDTH, PHOTOS_WIDTH);
                [_scrollView addSubview:_photoBtn];
            }
            break;
        }
        
        UIButton *btnImage = [UIButton buttonWithType:UIButtonTypeCustom];
        btnImage.frame = CGRectMake(addBtnX, addBtnY, PHOTOS_WIDTH, PHOTOS_WIDTH);
        btnImage.tag = i;
        UIImage *image = [self.assets[i] thumbImage];
        [btnImage setBackgroundImage:image forState:UIControlStateNormal];
        [_scrollView addSubview:btnImage];
        [btnImage addTarget:self action:@selector(didSelectPhotoImage:) forControlEvents:UIControlEventTouchUpInside];
    }
    NSInteger spaceH = ceilf(count / 4.0);
    _tableViewConstraintY.constant = (_photoBtn.h + WIDGET_SPACE) * spaceH + 2*WIDGET_SPACE;
}

- (void)didSelectPhotoImage:(UIButton *)btn {
    // 图片游览器
    ZLPhotoPickerBrowserViewController *pickerBrowser = [[ZLPhotoPickerBrowserViewController alloc] init];
    
    // 淡入淡出效果
    // pickerBrowser.status = UIViewAnimationAnimationStatusFade;
    // 数据源/delegate
    pickerBrowser.delegate = self;
    pickerBrowser.editing = YES;
    pickerBrowser.photos = self.assets;
    // 当前选中的值
    pickerBrowser.currentIndex = btn.tag;
    // 展示控制器
    [pickerBrowser showPickerVc:self];
    
}

#pragma mark ----------------------- 选择照片模块  end ----------------------

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView{
    textLab.hidden = textView.text.length ? YES: NO;
}

#pragma mark - 懒加载

- (NSMutableArray *)assets {
    if (!_assets) {
        _assets = [NSMutableArray array];
    }
    return _assets;
}

- (UIButton *)photoBtn{
    if (!_photoBtn) {
        _photoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _photoBtn.frame = CGRectMake(PHOTOS_SPACE, CGRectGetMaxY(_textView.frame) + WIDGET_SPACE, PHOTOS_WIDTH, PHOTOS_WIDTH);
        [_photoBtn setBackgroundImage:[UIImage imageNamed:@"Post_vi_Add"] forState:UIControlStateNormal];
        [_photoBtn addTarget:self action:@selector(selectPhotoAction:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:_photoBtn];
    }
    return _photoBtn;
}

- (NSMutableArray *)typeNames {
    if (!_typeNames) {
        
        NSData *saveData = [BKSaveData readDataByFile:SAVE_BLOG_TYPE];
        if (saveData) {
            NSArray *arr = [NSKeyedUnarchiver unarchiveObjectWithData:saveData];
            BlogTypeModel *listObj = arr[0];
            _catid = listObj.catid;
            _typeNames = [[NSMutableArray alloc] initWithObjects:listObj.catname,@"全站用戶可見", nil];
        } else {
            [BlogTypeModel mRequestBlogTypeListBlock:^(NSArray *data, NSString *netErr) {
                [self.view removeHUDActivity];
                if (netErr) {
                    [self.view showHUDTitleView:netErr image:nil];
                }else{
                    if (data.count > 0) {
                        BlogTypeModel *listObj = data[0];
                        _catid = listObj.catid;
                        if (!_typeNames) {
                            _typeNames = [NSMutableArray array];
                        }
                        [_typeNames addObject:listObj.catname];
                        [_typeNames addObject:@"全站用戶可見"];
                        [_tableView reloadData];
                    }
                }
            }];
            _typeNames = [NSMutableArray array];
        }
    }
    return _typeNames;
}

#pragma mark - 其他逻辑


//显示发布进度
- (void)showActivityView:(NSString *)message {
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = message;
    hud.tag = 0xffff;
    hud.alpha = .6;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // YES代表需要蒙层效果
    hud.dimBackground = YES;
}

//退出键盘action
- (void)cancelResponder {
    if ([_textField isFirstResponder]) {
        [_textField resignFirstResponder];
    }else if ([_textView isFirstResponder]){
        [_textView resignFirstResponder];
    }
}

//键盘消失方法,由于页面底部是UIScrollerView,无法响应touch，添加了类别UIScrollView+Touch来解决
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

//发布日志完成后，返回上级页面
- (void)backViewController {

    //通知我的日志页面，刷新ui
    [[NSNotificationCenter defaultCenter] postNotificationName:kPublishBlogSuccessNotification object:nil];
    
    // 立即返回后，发布成功的message显示短看不到，所以延迟一秒返回
    int64_t delayInSeconds = 1.0;  
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self mTouchBackBarButton];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}




@end
