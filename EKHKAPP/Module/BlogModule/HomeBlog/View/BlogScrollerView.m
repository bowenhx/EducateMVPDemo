/**
 -  BlogScrollerView.h
 -  EKHKAPP
 -  Created by HY on 2017/11/1.
 -  Copyright © 2017年 BaByKingdom. All rights reserved.
 -  说明：日志页面滑动列表view
 */

static CGFloat HEAD_HEIGHT =  40;   //头部滑动view的高度
static CGFloat LINE_HEIGHT =  10;    //头部滑动view下方的分割线高度

#pragma mark - CustomHeadView

@interface CustomHeadView : UIView

@property (nonatomic , strong) UILabel *itemLab;

@end

@implementation CustomHeadView

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title{
    self = [super initWithFrame:frame];
    if (self) {
        self.itemLab.text = title;
        [_itemLab setX:title.length > 2 ? -15 : -10];
    }
    return self;
}

- (UILabel *)itemLab{
    if (!_itemLab) {
        _itemLab = [[UILabel alloc] initWithFrame:self.bounds];
        _itemLab.textColor = [UIColor EKColorTitleBlack];
        _itemLab.font = [UIFont systemFontOfSize:15];
        _itemLab.textAlignment = NSTextAlignmentCenter;
        [_itemLab setY:-5];
        [self addSubview:_itemLab];
    }
    return _itemLab;
}

@end






#import "BlogScrollerView.h"

@interface BlogScrollerView()<UIScrollViewDelegate,HTHorizontalSelectionListDataSource, HTHorizontalSelectionListDelegate>
@property (nonatomic , strong) HTHorizontalSelectionList *headView;
@property (nonatomic , strong) NSMutableArray *items;
@end

@implementation BlogScrollerView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return self;
}

#pragma mark - scrollView
- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = [UIColor EKColorBackground];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.scrollEnabled = YES;
        _scrollView.delegate = self;
        [self addSubview:_scrollView];

        [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.top.equalTo(self).offset(HEAD_HEIGHT + LINE_HEIGHT);
        }];
    }
    return _scrollView;
}

#pragma mark - 头部滑动view
- (HTHorizontalSelectionList *)headView{
    if (!_headView) {
        _headView = [[HTHorizontalSelectionList alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, HEAD_HEIGHT)];
        _headView.delegate = self;
        _headView.dataSource = self;
        _headView.selectionIdicatorAnimationMode = HTHorizontalSelectionIndicatorStyleButtonCustomRound;
        _headView.selectionIndicatorStyle = HTHorizontalSelectionIndicatorAnimationModeNoBounce;
        _headView.selectionIndicatorColor = [UIColor EKColorBackground];
        [self addSubview:_headView];
    }
    return _headView;
}

#pragma mark - 添加滑动表头item，布局下方对应view
- (void)addItemView:(NSArray *)views title:(NSArray *)titles{
    _items = [NSMutableArray arrayWithCapacity:titles.count];
    for (int i=0;i<titles.count;i++) {
        NSString *length = titles[i];
        float width = length.length > 2 ? 120 : 80;
        CustomHeadView *item = [[CustomHeadView alloc] initWithFrame:CGRectMake(0, 0, width, HEAD_HEIGHT) title:length];
        if (i == 0) {
            item.itemLab.textColor = [UIColor whiteColor];
            item.backgroundColor = [UIColor EKColorYellow];
        }
        [_items addObject:item];
    }
    
    [self.headView reloadData];
   
    //设置contentSize
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * views.count, self.scrollView.h);
    
    CGFloat height = SCREEN_HEIGHT - NAV_BAR_HEIGHT - BOTTOM_TABBAR_HEIGHT - HEAD_HEIGHT - 10;
    //生成view
    for (int i= 0; i< views.count; i++) {
        UIView *iView = views[i];
        iView.frame = CGRectMake(i*[UIScreen mainScreen].bounds.size.width, 0, [UIScreen mainScreen].bounds.size.width, height);
        [self.scrollView addSubview:iView];
    }
}

#pragma mark - 改变选中item的状态
- (void)loadItemsStatus:(NSInteger)index{
    //记录item
    self.itemIndex = index;
    if (_itemsTouchAction) {
        //block 返回item index
        _itemsTouchAction (index);
    }
    
    //改变item title 状态
    for (int i= 0; i< _items.count; i++) {
        CustomHeadView *iView = _items[i];
        if (i == index) {
            iView.itemLab.textColor = [UIColor whiteColor];
            iView.backgroundColor = [UIColor EKColorYellow];
        }else{
            iView.itemLab.textColor = [UIColor EKColorTitleBlack];
            iView.backgroundColor = [UIColor clearColor];
        }
    }
}

#pragma mark - ScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    // 得到每页宽度
    CGFloat pageWidth = scrollView.frame.size.width;
    // 根据当前的x坐标和页宽度计算出当前页数
    int currentPage = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;

    //滑动判断如果滑动的page 没有变化就不去改变页面
    if (self.itemIndex == currentPage) return;
    
    //改变item 选择状态
    _headView.selectedButtonIndex = currentPage;
   
    [self loadItemsStatus:currentPage];
}

#pragma mark - HTHorizontalSelectionListDataSource Protocol Methods
- (NSInteger)numberOfItemsInSelectionList:(HTHorizontalSelectionList *)selectionList {
    return _items.count;
}

- (UIView *)selectionList:(HTHorizontalSelectionList *)selectionList viewForItemWithIndex:(NSInteger)index{
    return _items[index];
}

#pragma mark - HTHorizontalSelectionListDelegate Protocol Methods
- (void)selectionList:(HTHorizontalSelectionList *)selectionList didSelectButtonWithIndex:(NSInteger)index {
    [self.scrollView setContentOffset:CGPointMake(index * self.frame.size.width, 0) animated:YES];
    [self loadItemsStatus:index];
}

@end


