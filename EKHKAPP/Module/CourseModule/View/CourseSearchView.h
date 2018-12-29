//
//  CourseSearchView.h
//  EduKingdom
//
//  Created by HY on 16/7/7.
//  Copyright © 2016年 com.mobile-kingdom.ekapps. All rights reserved.
//

#import <UIKit/UIKit.h>
#define Course_Picker_Height 220    //盛放pickerView的view高度
//定义枚举类型,区分弹出的picker属于哪一类
typedef enum ENUM_Select_Type{
    ENUM_NULL,//初始值
    ENUM_CATEGORY,//课程目录列表
    ENUM_DISTRICT,//课程区域
    ENUM_FEE,//课程限额
    ENUM_BUSINESS,//商业等级列表
    ENUM_AGE//年龄选项列表
}Select_Type;

@protocol CourseSearchViewDelegate <NSObject>
-(void)mSearchResoultClick:(NSDictionary *)parameter; //点击搜索按钮的代理方法
@end

@interface CourseSearchView : UIView<UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate>{
    NSMutableArray *vSourceData;//中间值，存储picker数据源
    NSString *vSaveCategory; //存储选择的课程目录
    NSString *vSaveFee; //存储选择的课程限额
    NSString *vSaveAge;//存储选择年龄字段
    NSString *vSaveBusienss;//存储选择商业等级字段
    NSString *vSaveDistrict; //存储选择的课程区域
    NSString *vSaveTempId; //临时存储选中的id
    NSString *vSaveTempValue; //临时存储选中的值

}
@property (assign, nonatomic)Select_Type selectType;
@property (assign, nonatomic)id <CourseSearchViewDelegate> vDelegate;
//课程名称
@property (weak, nonatomic) IBOutlet UITextField *vCoverNameTF;
//主办单位
@property (weak, nonatomic) IBOutlet UITextField *vUnitTF;
//课程分类
@property (weak, nonatomic) IBOutlet UIButton *vCategoryBtn;
//课程区域
@property (weak, nonatomic) IBOutlet UIButton *vDistrictBtn;
//年龄
@property (weak, nonatomic) IBOutlet UIButton *vAgeBtn;
//课程限额
@property (weak, nonatomic) IBOutlet UIButton *vFeeBtn;
//商业登记
@property (weak, nonatomic) IBOutlet UIButton *vBusinessBtn;
//搜索按钮
@property (weak, nonatomic) IBOutlet UIButton *vSearchBtn;
//picker
@property (weak, nonatomic) IBOutlet UIPickerView *vPickerView;
//彈出的picker上得名字
@property (weak, nonatomic) IBOutlet UILabel *vPickerTitle;


//蒙版层view
@property (weak, nonatomic) IBOutlet UIView *vCoverView;
//pickerView底部距离底边屏幕的约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vPickerBg_bottom_space;
//搜索按钮点击事件
- (IBAction)mSearchBtnClick:(id)sender;
//课程目录，课程限额，课程区域点击弹出选择框事件
- (IBAction)mTapClick:(id)sender;
//pickerView上的确定和取消按钮
- (IBAction)mPickerBtnClick:(id)sender;
- (IBAction)mCoverViewClick:(id)sender;
+(CourseSearchView *)mGetInstance;

@end
