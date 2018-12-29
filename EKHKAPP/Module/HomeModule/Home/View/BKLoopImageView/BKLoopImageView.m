/**
 - BKLoopImageView.m
 - BKMobile
 - Created by HY on 2017/8/16.
 - Copyright © 2017年 com.mobile-kingdom.bkapps. All rights reserved.
 */

#import <objc/runtime.h>
#import "BKLoopImageView.h"
#import "BKLoopViewModel.h"
#import "EKHomePresenter.h"

@interface BKLoopImageView () {
    UIScrollView    *_scrollView;
    CGFloat         _showTime;
}
@end

//用于记录滑动view的数据源
static char kSaveLoopViewKey;

@implementation BKLoopImageView

#pragma mark - dealloc
- (void)dealloc {
    objc_setAssociatedObject(self, &kSaveLoopViewKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    _scrollView.delegate = nil;
}

#pragma mark - 初始化
- (instancetype)initWithImageItems:(NSArray *)items delegate:(id<BKLoopImageViewDelegate>)delegate {
    
    //轮播图的高度=首页cell高度 注意：轮播图片宽高比是1.375
    CGFloat scale = 1.375;
    CGFloat vHeight = [EKHomePresenter mFirstCellHeight];
    CGFloat vWidth = vHeight * scale;
    
    self = [super initWithFrame:CGRectMake(SCREEN_WIDTH - vWidth, 0, vWidth, vHeight)];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:240/255.0f green:239/255.0f blue:245/255.0f alpha:1.0];
        NSMutableArray *imageItems = [NSMutableArray arrayWithArray:items];
        objc_setAssociatedObject(self, &kSaveLoopViewKey, imageItems, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        _isAutoPlay = YES; //默认自动滑动播放
        [self mSetupViews];
        [self setDelegate:delegate];
    }
    return self;
}

#pragma mark - 设置轮播view数据
- (void)setItemsArr:(NSArray *)itemsArr {
    
    //添加最后一张图 用于循环
    int length = (unsigned)itemsArr.count;
    NSMutableArray *itemArray = [NSMutableArray arrayWithCapacity:length+2];
  
    if (length > 1) {
        BKLoopViewModel *model = itemsArr[length-1];
        [itemArray addObject:model];
    }
    
    for (int i = 0; i < length; i++) {
        BKLoopViewModel *model = itemsArr[i];
        [itemArray addObject:model];
    }
    
    //添加第一张图 用于循环
    if (length > 1) {
        BKLoopViewModel *model = itemsArr[0];
        [itemArray addObject:model];
    }
    
    //赋值
    _itemsArr = itemArray;
    objc_setAssociatedObject(self, &kSaveLoopViewKey, itemArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self mSetupViews];
}

#pragma mark - 设置轮播view的UI及赋值
- (void)mSetupViews {
    
    NSArray *imageItems = objc_getAssociatedObject(self, &kSaveLoopViewKey);
    if (imageItems.count == 0) return;
    
    //设置UIScrollView
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _scrollView.scrollsToTop = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    [self addSubview:_scrollView];
    
    //添加点击手势
    UITapGestureRecognizer *tapGestureRecognize = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mSingleTapGestureRecognizer:)];
    tapGestureRecognize.delegate = self;
    tapGestureRecognize.numberOfTapsRequired = 1;
    [_scrollView addGestureRecognizer:tapGestureRecognize];
    _scrollView.contentSize = CGSizeMake(WIDTH(_scrollView) * imageItems.count, _scrollView.frame.size.height);
 
    //定义一个循环播放的默认时间间隔
    _showTime = 5.0;
    
    for (int i = 0; i < imageItems.count; i++) {
       
        BKLoopViewModel *model = [imageItems objectAtIndex:i];
        
        //设置图片
        if (i == 0) {
            _showTime = model.residencetime;
        }
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * WIDTH(_scrollView), 0, WIDTH(_scrollView), _scrollView.frame.size.height)];
        //判断如果是gif，播放
        if ([model.imgurl hasSuffix:@"gif"]) {
            [imageView getImage:model.imgurl result:^(NSData *data) {
                if (data) {
                    imageView.gifData = data;
                    [imageView startGIF];
                }
            }];
        } else {
            NSURL *imageURL = [NSURL URLWithString:model.imgurl];
            [imageView sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:kPlaceHolderWhite]];
        }
        [_scrollView addSubview:imageView];
    }

    //判断是否循环播放view
    if ([imageItems count]>1) {
        [_scrollView setContentOffset:CGPointMake(WIDTH(_scrollView), 0) animated:NO] ;
        if (_isAutoPlay) {
            [self performSelector:@selector(mSwitchFocusImageItems) withObject:nil afterDelay:_showTime];
        }
    }
}

- (void)mSwitchFocusImageItems {
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(mSwitchFocusImageItems) object:nil];
    
    CGFloat targetX = _scrollView.contentOffset.x + WIDTH(_scrollView);
    NSArray *imageItems = objc_getAssociatedObject(self, &kSaveLoopViewKey);
    targetX = (int)(targetX / WIDTH(_scrollView)) * WIDTH(_scrollView);
    [self moveToTargetPosition:targetX];
    
    if ([imageItems count] > 1 && _isAutoPlay) {
        [self performSelector:@selector(mSwitchFocusImageItems) withObject:nil afterDelay:_showTime];
    }
}

#pragma mark - 点击item事件
- (void)mSingleTapGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer {
    NSLog(@"%s", __FUNCTION__);
    NSArray *imageItems = objc_getAssociatedObject(self, &kSaveLoopViewKey);
    int page = (int)(_scrollView.contentOffset.x /WIDTH(_scrollView));
    if (page > -1 && page < imageItems.count) {
        BKLoopViewModel *model = [imageItems objectAtIndex:page];
        if ([_delegate respondsToSelector:@selector(mTouchLoopImageView:didSelectItem:)]) {
            [_delegate mTouchLoopImageView:self didSelectItem:model];
        }
    }
}

- (void)moveToTargetPosition:(CGFloat)targetX {
    BOOL animated = YES;
    [_scrollView setContentOffset:CGPointMake(targetX, 0) animated:animated];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!_isAutoPlay) {
        NSLog(@"停止循环图片");
        return;
    }
    float targetX = scrollView.contentOffset.x;
    NSArray *imageItems = objc_getAssociatedObject(self, &kSaveLoopViewKey);
    if ([imageItems count] >= 3) {
        if (targetX >= WIDTH(_scrollView) * ([imageItems count] -1)) {
            targetX = WIDTH(_scrollView);
            [_scrollView setContentOffset:CGPointMake(targetX, 0) animated:NO];
        } else if(targetX <= 0) {
            targetX = WIDTH(_scrollView) *([imageItems count]-2);
            [_scrollView setContentOffset:CGPointMake(targetX, 0) animated:NO];
        }
    }
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        CGFloat targetX = _scrollView.contentOffset.x + _scrollView.frame.size.width;
        targetX = (int)(targetX/WIDTH(_scrollView)) * WIDTH(_scrollView);
        [self moveToTargetPosition:targetX];
    }
}

- (void)scrollToIndex:(NSInteger)aIndex {
    NSArray *imageItems = objc_getAssociatedObject(self, &kSaveLoopViewKey);
    if ([imageItems count]>1) {
        if (aIndex >= ([imageItems count]-2)) {
            aIndex = [imageItems count]-3;
        }
        [self moveToTargetPosition:WIDTH(_scrollView) * (aIndex+1)];
    } else {
        [self moveToTargetPosition:0];
    }
    [self scrollViewDidScroll:_scrollView];
}

@end
