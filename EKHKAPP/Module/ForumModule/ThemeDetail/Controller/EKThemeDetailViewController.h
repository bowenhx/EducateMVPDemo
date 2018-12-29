/**
 - BKMobile
 - EKThemeDetailViewController.h
 - Copyright (c) 2015年 com.mobile-kingdom.bkapps All rights reserved.
 - Created by Guibin on 15/2/4.
 - 说明：帖子详情页面，该页面内容复杂度最高，涉及到banner，vpon 广告，分享，帖子展示用到contextview，图文混排处理等
 */
#import <UIKit/UIKit.h>
#import "EKADViewController.h"
#import "InvitationViewCell.h"
#import "ThreadsDetailModel.h"
#import "EKCornerSelectMenuView.h"

@interface EKThemeDetailViewController : EKADViewController {
    __weak IBOutlet UITableView      *_tableView;
    __weak IBOutlet UIView           *_toolbarView;    //底部toolbar 操作栏
    //选择页数的输入框
    __weak IBOutlet UITextField     *_pageTextField;
    //选择页数弹出view上label
    __weak IBOutlet UILabel         *_currentPageLabel;
    //选择页数的view距离屏幕下方的距离
    __weak IBOutlet NSLayoutConstraint *_chosePageView_bottom;
   
    //适配iphonex，底部view上移
    __weak IBOutlet NSLayoutConstraint *_bootomViewWithScreenHeight;
    
    __weak IBOutlet NSLayoutConstraint *_topSpaceHeight;

    NSMutableArray                   *_tempData;       //临时数据源
    NSInteger                         _pageInteger;    //记录页数
    NSInteger                         _ordertype;      //排序
    NSInteger                         _authorid;       //记录楼主id
    NSInteger                         _maxPageNum;     //记录最大页码数
    NSInteger                         _keyboardHeight; //记录键盘高度
    NSInteger                         _textSize;       //记录帖子字号大小
    BOOL                              _isRefreshPicture;//判断登陆后刷新帖子图片
    BOOL                              _isLoadMore;     //判断是否是加载更多数据
    ThreadType                        threadType;
    MJRefreshGifHeader                *gifHeader; //刷新（表头）
    MJRefreshBackGifFooter            *gifFooter; //刷新（表尾）
    dispatch_queue_t    _apiRequestQueue;/**<api请求队列*/
}
//记录选择顶部类型，全部，只看楼主
@property (nonatomic , strong) EKCornerSelectMenuView *navTitleView;
@property (nonatomic , assign) NSInteger              vSelectNavIndex;
@property (nonatomic , strong) NSMutableArray         *dataSource;      //数据源
@property (nonatomic , assign) NSInteger              pid;              //pid = 0 不需要定位楼层处理，否则需要定位到对应的楼层
@property (nonatomic , strong) NSNumber               *tid;             //tid 作为请求数据的重要参数
@property (nonatomic , assign) NSInteger              password;         //帖子密码
@property (nonatomic , strong) NSDictionary           *dictThreadacts;  /**<活动帖子的信息*/
@property (nonatomic , strong) NSDictionary           *dictThreadpolls; /**<投票帖子的信息*/
@property (nonatomic , strong) ThreadsDetailModel     *thModel;


- (void)loadMaxPage:(NSDictionary *)page;
//update head View data
- (void)changeHeadData:(NSDictionary *)dict;
- (void)addAlertViewAction;
- (void)updataCollectStatus;
- (dispatch_queue_t)apiRequestQueue;
@end


