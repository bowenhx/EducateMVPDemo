/**
 -  BKFooterFacerView.m
 -  BKHKAPP
 -  Created by ligb on 2017/8/29.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 */

#import "BKFooterFacerView.h"
#import "BKFaceView.h"
#import "BKFaceManage.h"

const float kEmotionNumberOfPage                     = 28.0; //每页显示多少个表情


@interface BKFooterFacerView ()<BKFaceViewDelegate,UIScrollViewDelegate>
{

}

@property (nonatomic, strong) UIPageControl *vPageontrol;

@end

@implementation BKFooterFacerView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self mAddFaceView];
    }
    return self;
}

+ (BKFooterFacerView *)getFooterFaceView {
    float sSize = ceilf(SCREEN_WIDTH / 7);
    float height = 4 * sSize + 75;
    BKFooterFacerView *footerView = [[BKFooterFacerView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - BOTTOM_TABBAR_HEIGHT, SCREEN_WIDTH, height)];
    
    return footerView;
}

- (void)mAddFaceView {
    UIView *faceHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.w, 50)];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"def_btn_bg"]];
    imgView.frame = faceHeadView.bounds;
    [faceHeadView addSubview:imgView];

    UIButton *faceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    faceButton.frame = CGRectMake(0, 0, 50, 50);
    [faceButton setImage:[UIImage imageNamed:@"Chat_iv_Expression_unpressed"] forState:UIControlStateNormal];
    [faceButton setImage:[UIImage imageNamed:@"Chat_iv_Expression_pressed"] forState:UIControlStateHighlighted];
    [faceButton setImage:[UIImage imageNamed:@"Chat_iv_Expression_pressed"] forState:UIControlStateSelected];
    [faceHeadView addSubview:faceButton];
    [faceButton addTarget:self action:@selector(mSelectFaceAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:faceHeadView];
    

    //获取表情存储对象
    NSInteger smiliesNum = [[BKFaceManage sharedInstance].vSmiliesArray count];
    NSInteger facePage = ceilf(smiliesNum / kEmotionNumberOfPage); //分页显示表情，每页有28个表情
    for (int i= 0; i<facePage; i++) {
        BKFaceView *faceView = [[BKFaceView alloc] initWithFrame:CGRectMake(i*SCREEN_WIDTH, 0, self.w, self.vScrollView.h)];
        faceView.tag = i;
        [faceView mAddFaceItem];
        faceView.delegate = self;
        [self.vScrollView addSubview:faceView];
    }
    
    self.vScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * facePage, _vScrollView.h);
    self.vPageontrol.numberOfPages = facePage;
}

- (void)mSelectFaceAction:(UIButton *)btn{
    if (_mSelectFooterBtn) {
        _mSelectFooterBtn (btn);
    }
}

- (void)selectedSmiliesWithItem:(SmiliesButton *)item {
    if (_mSelectFaceAction) {
        _mSelectFaceAction (item);
    }
}

- (UIScrollView *)vScrollView{
    if (!_vScrollView) {
        _vScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, self.h - 50 - 20)];
        _vScrollView.showsVerticalScrollIndicator = NO;
        _vScrollView.showsHorizontalScrollIndicator = NO;
        _vScrollView.delegate = self;
        _vScrollView.pagingEnabled = YES;
        [self addSubview:_vScrollView];
        
        _vPageontrol = [[UIPageControl alloc] initWithFrame:CGRectMake((self.w - 50 )/2, self.h -25, 50, 20)];
        _vPageontrol.userInteractionEnabled = NO;
        [_vPageontrol setPageIndicatorTintColor:[UIColor grayColor]];
        [_vPageontrol setCurrentPageIndicatorTintColor:[@"12939E" color]];
        [self addSubview:_vPageontrol];
    }
    return _vScrollView;
}


#pragma mark ScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int page = scrollView.contentOffset.x / SCREEN_WIDTH;
    _vPageontrol.currentPage = page;
}

@end
