//
//  EmotionView.m
//  BKMobile
//
//  Created by 薇 颜 on 15/6/26.
//  Copyright (c) 2015年 com.mobile-kingdom.bkapps All rights reserved.
//

#import "EmotionView.h"
#import "NSString+UIColor.h"
#define kEmotionNumberOfPage 28.0 //每页显示多少个
@interface EmotionView() <UIScrollViewDelegate, BKFaceViewDelegate>

/**
 *  显示页码的控件
 */
@property (nonatomic, strong) UIPageControl *emotionPageControl;

/**
 *  ScrollView
 */
@property (nonatomic, strong) UIScrollView *emotionScrollView;

@property (nonatomic, strong) NSArray *emotionList;
@end
@implementation EmotionView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [self setupEmotionView];
}

- (void)setupEmotionView{
    //每页显示多少个
    _emotionList = [self.dataSource emotionList];
    NSInteger pageTotal = ceilf(_emotionList.count / kEmotionNumberOfPage); //分页显示表情，每页有_numberOfPage个表情
    
    _emotionPageControl = [[UIPageControl alloc] init];
    [_emotionPageControl setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_emotionPageControl setPageIndicatorTintColor:[UIColor grayColor]];
    [_emotionPageControl setCurrentPageIndicatorTintColor:[@"12939E" color]];
    [_emotionPageControl setCurrentPage:0];
    [self addSubview:_emotionPageControl];
    //宽度，水平居中
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_emotionPageControl]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_emotionPageControl)]];
    //底部距离
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_emotionPageControl attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    
    //必须写入高度，不然height = 0 button无法点击，这里待完善
    CGFloat faceViewHeight = ([UIScreen mainScreen].bounds.size.width / 7) * 4;
    //(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? (264-37) : (216-37);
    
    _emotionScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, faceViewHeight)];
    [_emotionScrollView setDelegate:self];
    [_emotionScrollView setShowsHorizontalScrollIndicator:NO];
    [_emotionScrollView setShowsVerticalScrollIndicator:NO];
    [_emotionScrollView setPagingEnabled:YES];
    [self addSubview:_emotionScrollView];
    
    //设置内容宽度
    _emotionScrollView.contentSize = CGSizeMake( self.frame.size.width * pageTotal, _emotionScrollView.frame.size.height);
    //
    _emotionPageControl.numberOfPages = pageTotal;
        
    
    for (int i= 0; i<pageTotal; i++) {
        BKFaceView *faceView = [[BKFaceView alloc] initWithFrame:CGRectMake(i*self.frame.size.width, 0, self.frame.size.width, faceViewHeight)];
        faceView.tag = i;
        [faceView mAddFaceItem];
        faceView.delegate = self;
        [_emotionScrollView addSubview:faceView];
        
    }
}
#pragma mark FaceViewDelegate
- (void)selectedSmiliesWithItem:(SmiliesButton *)item{
    if ([self.delegate respondsToSelector:@selector(didSelecteEmotion:)]) {
        [self.delegate didSelecteEmotion:item];
    }
}
#pragma mark ScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int page = scrollView.contentOffset.x / self.frame.size.width;
    _emotionPageControl.currentPage = page;
}
@end
