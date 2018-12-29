/**
 -  EKFirstLaunchForumViewController.m
 -  EKHKAPP
 -  Created by calvin_Tse on 2017/9/13.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明:"首次启动"界面的第二层界面,选择感兴趣的板块
 */

#import "EKFirstLaunchForumView.h"
#import "EKFirstLaunchForumCell.h"
#import "EKFirstLaunchForumCollectionViewLayout.h"
#import "BADGetparms.h"

static NSString * firstLaunchForumCellID = @"EKFirstLaunchForumCellID";

@interface EKFirstLaunchForumView () <UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *vContentView;
@property (strong, nonatomic) UICollectionView *vCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *vTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *vNextStepButton;
//用来适配ipX
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vTitleLabelTopMargin;
@end

@implementation EKFirstLaunchForumView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self mInitUI];
    }
    return self;
}


#pragma mark - 初始化UI
- (void)mInitUI {
    //1.加载xib视图
    [[NSBundle mainBundle] loadNibNamed:@"EKFirstLaunchForumView" owner:self options:nil];
    [self addSubview:self.vContentView];
    self.vContentView.frame = self.bounds;
    //适配ipX
    _vTitleLabelTopMargin.constant = NAV_BAR_HEIGHT - 28;
    
    //2.设置标题label的文字和文字间距
    NSDictionary *attributes = @{NSKernAttributeName : @(3)};
    _vTitleLabel.attributedText = [[NSAttributedString alloc] initWithString:@"請選擇你感興趣的討論區" attributes:attributes];
    
    //3.实例化collectionView
    EKFirstLaunchForumCollectionViewLayout *layout = [[EKFirstLaunchForumCollectionViewLayout alloc] initWthType:AlignWithCenter];
    _vCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    _vCollectionView.backgroundColor = [UIColor clearColor];
    _vCollectionView.dataSource = self;
    [self.vContentView addSubview:_vCollectionView];
    CGFloat collectionViewTopMargin = 7;
    CGFloat collectionViewBottonMargin = 44;
    [_vCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.vContentView);
        make.top.equalTo(_vTitleLabel.mas_bottom).offset(collectionViewTopMargin);
        make.bottom.equalTo(_vNextStepButton.mas_top).offset(-collectionViewBottonMargin);
    }];
    //注册cell
    UINib *cellNib = [UINib nibWithNibName:@"EKFirstLaunchForumCell" bundle:nil];
    [_vCollectionView registerNib:cellNib forCellWithReuseIdentifier:firstLaunchForumCellID];
}


#pragma mark - 更新UI
- (void)setVListModel:(EKFirstLaunchListModel *)vListModel {
    _vListModel = vListModel;
    [_vCollectionView reloadData];
}


#pragma mark - UICollectionViewDataSource
//返回组数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    NSInteger count = _vListModel.subforums.count;
    //显示规则:一行3个,一行2个,以此类推
    //两行,即5个,可设为1个单位,总数除以5再乘以2,可得到都被填充满cell的行的总数
    NSInteger baseCount = count / 5 * 2;
    //剩下未被填满cell的行,用取模的方式,可得行数
    NSInteger restCount = 0;
    if (count % 5 > 3) {
        restCount = 2;
    } else if (count % 5 > 1) {
        restCount = 1;
    } else {
        restCount = 0;
    }
    
    //最后以上两部分相加即可
    return baseCount + restCount;
}


//返回每组的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    //奇数行为2个,偶数行为3个
    return section % 2 ? 2 : 3;
}


//返回cell
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    EKFirstLaunchForumCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:firstLaunchForumCellID forIndexPath:indexPath];
    //抽取出两个索引
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    //计算出索引
    NSInteger baseIndex = (section / 2) * 5;
    NSInteger restIndex = 0;
    if (section % 2) {
        restIndex = row + 3;
    } else {
        restIndex = row;
    }
    NSInteger index = baseIndex + restIndex;
    cell.vSubforumModel = _vListModel.subforums[index];
    return cell;
}


#pragma mark - 按钮监听事件
//点击"完成"按钮
- (IBAction)mClickNextStepButton:(id)sender {
    //将选中的信息转成字典存储到本地
    NSArray *listDictArray = [_vListModel mChangeToArrayAndRemoveUnselectedForumModel];
    [BKSaveData setArray:listDictArray key:kPreferForumInfoKey];
    //本地记录用户已经完成了"首次启动"界面的选择
    [BKSaveData setBool:YES key:kIsFinishFirstLaunchChooseKey];
    //执行回调
    if (self.delegate && [self.delegate respondsToSelector:@selector(mClickForumViewNextStepButton)]) {
        [self.delegate mClickForumViewNextStepButton];
    }
}


@end
