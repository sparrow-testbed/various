//
/**
* 所属系统: 移动组件
* 所属模块: 
* 功能描述: 
* 创建时间: 2020/9/19
* 维护人:  李志䶮
* Copyright © 2020 wni. All rights reserved.
*┌─────────────────────────────────────────────────────┐
*│ 此技术信息为本公司机密信息，未经本公司书面同意禁止向第三方披露．│
*│ 版权所有：杰人软件(深圳)有限公司                          │
*└─────────────────────────────────────────────────────┘
*/

#import "JRCalendarViewController.h"
#import "JRCalendar.h"
#import "JRAttendanceDIYCalendarCell.h"
#import "JRCalendarDynamicHeader.h"
#import "JRCalendarExtensions.h"
#import "JRAttendanceHelper.h"
#import "JRCalendarModel.h"
#import "JRCalendarView.h"
#import "JRUIKit.h"

@interface JRCalendarViewController ()
{
    void *_KVOContext;
    UIButton *_todayBtn;
    BOOL    _isPreOrNext;
}

@property (nonatomic,strong) JRCalendar *calendar;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic,strong)  UIView *titleView;
@property (nonatomic, strong) UILabel *titleTimeLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *currentWeekButton;
@property (nonatomic, strong) UIButton *nextWeekButton;

@property (nonatomic, strong) UIPanGestureRecognizer *scopeGesture;

@property (nonatomic, strong) NSDate *selectedDate;  // 选中日期
@property (nonatomic, strong) NSDate *minimumDate;  // 日期范围(最小)
@property (nonatomic, strong) NSDate *maximumDate;  // 日期范围(最大)

@property (nonatomic, strong) NSString *startDate; //请求课程起始时间
@property (nonatomic, strong) NSString *endDate;   //请求课程结束时间
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSDateFormatter *dateFormatter1;

@property (nonatomic, strong) NSMutableArray *customEventArr; // 异常日期


@end

@implementation JRCalendarViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    JRCalendarModel *model = [[JRCalendarModel alloc]init];
    model.dateString = @"2020-10-11";
    JRCalendarModel *model2 = [[JRCalendarModel alloc]init];
    model2.dateString = @"2020-10-12";
    JRCalendarModel *model3 = [[JRCalendarModel alloc]init];
    model3.dateString = @"2020-10-13";
    JRCalendarModel *model4 = [[JRCalendarModel alloc]init];
    model4.dateString = @"2020-10-14";
    JRCalendarModel *model5 = [[JRCalendarModel alloc]init];
    model5.dateString = @"2020-10-15";
    model5.mark = YES;
    JRCalendarModel *model6 = [[JRCalendarModel alloc]init];
    model6.dateString = @"2020-10-21";
    model6.mark = NO;
    JRCalendarModel *model7 = [[JRCalendarModel alloc]init];
    model7.dateString = @"2020-10-22";
    model7.mark = NO;
    self.courseArr = @[model,model2,model3,model4,model5,model6,model7];
    
    WS(weakSelf)
    if (!self.isWeekCalendar) {
        JRCalendarView *view = [[JRCalendarView alloc]initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, 44 + kStatusBarHeight + 400)];
        view.courseArr = self.courseArr;
        view.titleName = @"深圳罗湖校区";
        view.isWeekCalendar = NO;
        view.clickBackBlock = ^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        };
        view.choiceDay = ^(NSString * _Nonnull dateString) {
            JRLog(@"选择日期 === %@",dateString);
        };
        view.backgroundColor = [UIColor clearColor];
        [self.view addSubview:view];
    }
    else{
        JRCalendarView *view2 = [[JRCalendarView alloc]initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, 44 + kStatusBarHeight + 400)];
        view2.isWeekCalendar = YES;
        view2.courseArr = self.courseArr;
        view2.clickBackBlock = ^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        };
        view2.choiceDay = ^(NSString * _Nonnull dateString) {
            JRLog(@"选择日期 === %@",dateString);
        };
        view2.backgroundColor = [UIColor clearColor];
        [self.view addSubview:view2];
    }
}



@end
