//
//  EKHomeFifthlyCell.m
//  EKHKAPP
//
//  Created by ligb on 2017/9/15.
//  Copyright © 2017年 BaByKingdom. All rights reserved.
//

#import "EKHomeFifthlyCell.h"
#import "EKHomeFifthCollectionViewCell.h"
//collectionView的cell的缓存标识符
static NSString *homeFifthCollectionViewCellID = @"EKHomeFifthCollectionViewCellID";

@interface EKHomeFifthlyCell() <UICollectionViewDelegate, UICollectionViewDataSource>
//主体的collectionView
@property (strong, nonatomic) UICollectionView *vCollectionView;
@end


@implementation EKHomeFifthlyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self mInitUI];
    }
    return self;
}


- (void)mInitUI {
    //1.创建collectionView布局对象
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(155, 200);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    //声明cell之间的间隔
    CGFloat margin = 10;
    flowLayout.minimumLineSpacing = margin;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, margin, 0, margin);
    
    //2.创建collectionView
    _vCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                          collectionViewLayout:flowLayout];
    _vCollectionView.backgroundColor = [UIColor EKColorYellow];
    [self.contentView addSubview:_vCollectionView];
    [_vCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    _vCollectionView.dataSource = self;
    _vCollectionView.delegate = self;
    [_vCollectionView registerNib:[UINib nibWithNibName:@"EKHomeFifthCollectionViewCell" bundle:nil]
       forCellWithReuseIdentifier:homeFifthCollectionViewCellID];
}


- (void)setVHomeKMallModelDataSource:(NSArray<EKHomeKMallModel *> *)vHomeKMallModelDataSource {
    _vHomeKMallModelDataSource = vHomeKMallModelDataSource;
    [_vCollectionView reloadData];
}

#pragma mark - UICollectionViewDataSource
//返回个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _vHomeKMallModelDataSource.count;
}


//返回cell
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    EKHomeFifthCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:homeFifthCollectionViewCellID forIndexPath:indexPath];
    cell.vHomeKMallModel = _vHomeKMallModelDataSource[indexPath.row];
    return cell;
}


#pragma mark - UICollectionViewDelegate
//选中cell时调用
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //回传当前点击的cell的索引
    if (self.delegate && [self.delegate respondsToSelector:@selector(mCollectionViewDidClickItemWithIndex:)]) {
        [self.delegate mCollectionViewDidClickItemWithIndex:indexPath.row];
    }
}

@end
