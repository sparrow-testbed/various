//
//  JRCalendarView.m
//  JRPodPrivate_Example
//
//  Created by 李志龑 on 2020/9/27.
//  Copyright © 2020 wni. All rights reserved.
//

#import "JRCalendarView.h"
#import "JRCalendar.h"
#import "JRAttendanceDIYCalendarCell.h"
#import "JRCalendarDynamicHeader.h"
#import "JRCalendarExtensions.h"
#import "JRAttendanceHelper.h"
#import "JRCalendarModel.h"
#import "JRUIKit.h"
//#import <NSDate+JKReporting.h>

@interface JRCalendarView ()
<JRCalendarDelegate,JRCalendarDataSource,UIGestureRecognizerDelegate>
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

@implementation JRCalendarView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

-(instancetype)init{
    self = [super init];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI{
    self.minimumDate = [self.dateFormatter dateFromString:@"1990-01-01"];
    self.maximumDate = [self.dateFormatter dateFromString:@"2100-01-01"];
}

- (void)setIsWeekCalendar:(BOOL)isWeekCalendar{
    _isWeekCalendar = isWeekCalendar;
    
    if (self.isWeekCalendar) {
        [self initWeekHeaderView];
    }
    else
    {
        [self initHeadView];
        
    }
    
    [self initBackAndTodayView];
    [self initCalendar];
}

- (void)initHeadView {
    self.backgroundColor = [UIColor whiteColor];
    
    CGFloat height = 44;
    self.titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, height + 8 + 37 + kStatusBarHeight)];
    [self addSubview:self.titleView];

    self.titleView.backgroundColor = [UIColor colorWithHex:@"#184C30"];
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(MAIN_SCREEN_WIDTH/2.0 - 75, kStatusBarHeight, 150, height)];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont systemFontOfSize:18];
    self.titleLabel.textColor = [UIColor colorWithHex:@"#ffffff"];
    //@"学生考勤"
    self.titleLabel.text = self.titleName ? self.titleName: @"深圳华强校区";
    self.titleLabel.userInteractionEnabled = YES;
    [self.titleView addSubview:self.titleLabel];
    
    // 设置年月
    self.titleTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(MAIN_SCREEN_WIDTH/2.0 - 75, height + kStatusBarHeight + 8, 150, 20)];
    self.titleTimeLabel.font = [UIFont systemFontOfSize:15];
    self.titleTimeLabel.textColor = [UIColor colorWithHex:@"#ffffff"];
    self.titleTimeLabel.text = [self.dateFormatter1 stringFromDate:[NSDate date]];
    self.titleTimeLabel.textAlignment = NSTextAlignmentCenter;
    [self.titleView addSubview:self.titleTimeLabel];
}

- (void)initWeekHeaderView{
    self.backgroundColor = [UIColor whiteColor];
    
    CGFloat height = 44;
    self.titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, height + kStatusBarHeight + 15)];
    self.titleView.backgroundColor = [UIColor colorWithHex:@"#184C30"];
    [self addSubview:self.titleView];
    
    UIView *weekView = [[UIView alloc]initWithFrame:CGRectMake((MAIN_SCREEN_WIDTH - 134)/2, kStatusBarHeight + 10, 134, 34)];
    weekView.backgroundColor = [UIColor colorWithHex:@"#000000" alpha:0.35];
    weekView.layer.masksToBounds = YES;
    weekView.layer.cornerRadius = 17;
    [self.titleView addSubview:weekView];
    
    UIButton *currentWeekButton = [[UIButton alloc]initWithFrame:CGRectMake(4, 3, 63, 28)];
    [currentWeekButton setBackgroundColor:[UIColor whiteColor]];
    [currentWeekButton setTitle:@"本周" forState:UIControlStateNormal];
    [currentWeekButton setTitleColor:[UIColor colorWithHex:@"#184C30"] forState:UIControlStateNormal];
    currentWeekButton.titleLabel.font = [UIFont systemFontOfSize:16];
    currentWeekButton.layer.masksToBounds = YES;
    currentWeekButton.layer.cornerRadius = 14;
    [currentWeekButton addTarget:self action:@selector(currentWeekClick) forControlEvents:UIControlEventTouchUpInside];
    self.currentWeekButton = currentWeekButton;
    [weekView addSubview:self.currentWeekButton];
    
    UIButton *nextWeekButton = [[UIButton alloc]initWithFrame:CGRectMake(67, 3, 63, 28)];
    [nextWeekButton setBackgroundColor:[UIColor clearColor]];
    [nextWeekButton setTitle:@"下周" forState:UIControlStateNormal];
    [nextWeekButton setTitleColor:[UIColor colorWithHex:@"#FFFFFF"] forState:UIControlStateNormal];
    nextWeekButton.titleLabel.font = [UIFont systemFontOfSize:16];
    nextWeekButton.layer.masksToBounds = YES;
    nextWeekButton.layer.cornerRadius = 14;
    [nextWeekButton addTarget:self action:@selector(nextWeekClick) forControlEvents:UIControlEventTouchUpInside];
    self.nextWeekButton = nextWeekButton;
    [weekView addSubview:self.nextWeekButton];
}

- (void)initBackAndTodayView{
    
    //设置今天按钮
    _todayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_todayBtn setImage:[JRUIHelper imageNamed:@"i_today_nav"] forState:UIControlStateNormal];
    [_todayBtn addTarget:self action:@selector(showTodayDate) forControlEvents:UIControlEventTouchUpInside];
    _todayBtn.hidden = YES;
    _todayBtn.frame = CGRectMake(MAIN_SCREEN_WIDTH - 15 - 28, 7 + kStatusBarHeight, 28, 28);
    if (!self.isWeekCalendar) {
        [self.titleView addSubview:_todayBtn];
    }
    
    //设置返回按钮
    XYButton *navButton = [[XYButton alloc] initWithFrame:CGRectMake(15, (self.isWeekCalendar ? 10 : 7) + kStatusBarHeight, 27, 27)];
    [navButton setImage:[JRUIHelper imageNamed:@"i_back_nav_nor"] forState:UIControlStateNormal];
    [navButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.titleView addSubview:navButton];
    
}

- (void)initCalendar {
    self.calendar.backgroundColor = [UIColor colorWithHex:@"#184C30"];
    [self addSubview:self.calendar];
    
    self.calendar.delegate = self;
    self.calendar.dataSource = self;
    
    self.calendar.headerHeight = 0;
    self.calendar.weekdayHeight = 20;
    self.calendar.firstWeekday = 2;
    
    self.calendar.placeholderType = JRCalendarPlaceholderTypeNone;

    // 日历展示类型
    self.calendar.appearance.caseOptions = JRCalendarCaseOptionsHeaderUsesUpperCase|JRCalendarCaseOptionsWeekdayUsesUpperCase;
    
    // 周
    self.calendar.appearance.weekdayTextColor = WhiteColor;
    self.calendar.appearance.weekdayFont = [UIFont boldSystemFontOfSize:11];
    
    // 今天
    self.calendar.appearance.todayColor = [UIColor clearColor];
    self.calendar.appearance.titleTodayColor = [[UIColor whiteColor]colorWithAlphaComponent:0.3];
    
    // 文字
    self.calendar.appearance.titleFont = [UIFont boldSystemFontOfSize:14];
    self.calendar.appearance.titleOffset = CGPointMake(0, 0);
    //默认字体颜色
    self.calendar.appearance.titleDefaultColor = [[UIColor whiteColor]colorWithAlphaComponent:0.3];
    
    // 选中状态
    self.calendar.appearance.selectionColor = [UIColor colorWithHex:@"#0EA856"];
    self.calendar.appearance.titleSelectionColor =  [UIColor colorWithHex:@"#ffffff"];
    self.calendar.appearance.subtitleSelectionColor = [UIColor colorWithHex:@"#ffffff"];
    
    // 圆点事件
    self.calendar.appearance.eventDefaultColor = [UIColor colorWithHex:@"#ffffff"];
//    self.calendar.appearance.eventSelectionColor = [UIColor clearColor];
    self.calendar.appearance.eventOffset = CGPointMake(0, 1);
    
    // 默认选中今天
    [self.calendar selectDate:[NSDate date] scrollToDate:YES];
    self.selectedDate = [NSDate date];
    
    [self.calendar registerClass:[JRAttendanceDIYCalendarCell class] forCellReuseIdentifier:@"cell"];
    
    self.calendar.scope = JRCalendarScopeWeek;
    [self.calendar addObserver:self forKeyPath:@"scope" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:_KVOContext];
    
    if (!self.isWeekCalendar) {
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self.calendar action:@selector(handleScopeGesture:)];
        panGesture.delegate = self;
        panGesture.minimumNumberOfTouches = 1;
        panGesture.maximumNumberOfTouches = 2;
        [self addGestureRecognizer:panGesture];
        self.scopeGesture = panGesture;
        
        self.calendar.scrollEnabled = YES;
    }
    else
    {
        self.calendar.scrollEnabled = NO;
    }
    
    NSDate *today = [NSDate date];
    self.endDate = [self.dateFormatter stringFromDate:[[today jk_nextMonth:6] jk_endOfMonth]];
    self.startDate = [self.dateFormatter stringFromDate:[[today jk_previousMonth:6] jk_endOfMonth]];
    [self calendar:self.calendar didSelectDate:[NSDate date] atMonthPosition:JRCalendarMonthPositionCurrent];
}

- (void)setTitleTimeLabel {
    
    NSString *selectDateStr;
    if (!_titleTimeLabel.text) {
        if (self.calendar.selectedDate) {
            selectDateStr = [NSString stringWithFormat:@"%@",self.calendar.selectedDate];
        } else {
            selectDateStr = [self.dateFormatter1 stringFromDate:[self.calendar.currentPage jk_nextWeek]];
        }
        
        self.titleTimeLabel.text = selectDateStr;
    }
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:_titleTimeLabel.text];
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 5)];
    
    [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, _titleTimeLabel.text.length)];
    
    BOOL isThisMontn = [_titleTimeLabel.text isEqualToString:[self.dateFormatter1 stringFromDate:[NSDate date]]];
    
    if ([self.calendar.selectedDate isToday] && isThisMontn) {
        [string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:@"#ffffff"] range:NSMakeRange(0, _titleTimeLabel.text.length)];
    } else {
        [string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:@"#ffffff"] range:NSMakeRange(0, _titleTimeLabel.text.length)];
    }
    
    _titleTimeLabel.attributedText = string;
}

// 回到今天
- (void)showTodayDate {
    
    // 当前页
    [self.calendar setCurrentPage:[NSDate date] animated:YES];
    
    // 会执行一个代理方法 选择获取课程
    [self.calendar selectDate:[NSDate date]];
    
    // 调用方法
    [self calendar:self.calendar didSelectDate:[NSDate date] atMonthPosition:JRCalendarMonthPositionCurrent];
}

- (void)currentWeekClick{
    if (self.currentWeekButton.backgroundColor == [UIColor clearColor]) {
        self.calendar.scrollEnabled = YES;
        [self.currentWeekButton setBackgroundColor:[UIColor whiteColor]];
        [self.currentWeekButton setTitleColor:[UIColor colorWithHex:@"#184C30"] forState:UIControlStateNormal];
        [self.nextWeekButton setBackgroundColor:[UIColor clearColor]];
        [self.nextWeekButton setTitleColor:[UIColor colorWithHex:@"#FFFFFF"] forState:UIControlStateNormal];
        [self.calendar selectDate:[self.calendar.currentPage jk_previousWeek] scrollToDate:YES];
    }
}

- (void)nextWeekClick{
    if (self.nextWeekButton.backgroundColor == [UIColor clearColor]) {
        self.calendar.scrollEnabled = YES;
        [self.nextWeekButton setBackgroundColor:[UIColor whiteColor]];
        [self.nextWeekButton setTitleColor:[UIColor colorWithHex:@"#184C30"] forState:UIControlStateNormal];
        [self.currentWeekButton setBackgroundColor:[UIColor clearColor]];
        [self.currentWeekButton setTitleColor:[UIColor colorWithHex:@"#FFFFFF"] forState:UIControlStateNormal];
        [self.calendar selectDate:[self.calendar.currentPage jk_nextWeek] scrollToDate:YES];
    }
}

- (void)back {
    if (self.clickBackBlock) {
        self.clickBackBlock();
    }
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (context == _KVOContext) {
        JRCalendarScope oldScope = [change[NSKeyValueChangeOldKey] unsignedIntegerValue];
        JRCalendarScope newScope = [change[NSKeyValueChangeNewKey] unsignedIntegerValue];
        
        JRLog(@"From %@ to %@",(oldScope==JRCalendarScopeWeek?@"week":@"month"),(newScope==JRCalendarScopeWeek?@"week":@"month"));
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - <UIGestureRecognizerDelegate>

// Whether scope gesture should begin
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
//    BOOL shouldBegin = self.tableView.contentOffset.y <= -self.tableView.contentInset.top;
//    if (shouldBegin) {
        CGPoint velocity = [self.scopeGesture velocityInView:self];
        switch (self.calendar.scope) {
            case JRCalendarScopeMonth:
                return velocity.y < 0;
            case JRCalendarScopeWeek:
                return velocity.y > 0;
        }
//    }
//    return shouldBegin;
}

#pragma mark - <JRCalendarDelegate>

- (BOOL)calendar:(JRCalendar *)calendar shouldSelectDate:(NSDate *)date atMonthPosition:(JRCalendarMonthPosition)monthPosition {

    JRLog(@"should select date %@",[self.dateFormatter stringFromDate:date]);
    return YES;
}

// 选中日期时调用
- (void)calendar:(JRCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(JRCalendarMonthPosition)monthPosition {
    
    _todayBtn.hidden = [date isToday];
    
    self.titleTimeLabel.text = [self.dateFormatter1 stringFromDate:self.calendar.selectedDate];
    if (!self.isWeekCalendar) {
        [self setTitleTimeLabel];
    }
    
    self.selectedDate = date;
    
    // 遍历所有日期 查找选中日期 标记看过
    NSString *dateString = [self.dateFormatter stringFromDate:self.calendar.selectedDate];
    for (int i = 0; i < self.courseArr.count; i++) {
        JRCalendarModel *model = [self.courseArr objectAtIndex:i];
        if ([model.dateString isEqualToString:dateString] && !model.mark) {
            //标记看过
            model.mark = YES;
//            [self.calendar.collectionView reloadData];
            
//            NSMutableArray *selectedDates = [NSMutableArray arrayWithCapacity:calendar.selectedDates.count];
//
//            [calendar.selectedDates enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//                [selectedDates addObject:[self.dateFormatter stringFromDate:obj]];
//            }];
//
//            [self.calendar reloadData];
            break;
        }
    }
    
    if (self.choiceDay) {
        self.choiceDay(dateString);
    }
    
}

// 切换日期月份时调用
- (void)calendarCurrentPageDidChange:(JRCalendar *)calendar {
    
    // 如果点返回当天 不进行滑动
    // 显示当前页第一天
    // In week mode, current page represents the current visible week; In month mode, it means current visible month.
    JRLog(@"--------calendar.currentPage--------- %@",calendar.currentPage);
    JRLog(@"did change to page %@",[self.dateFormatter stringFromDate:calendar.currentPage]);
    
    int flag = [JRAttendanceHelper compareDateWithDate1:self.selectedDate date2:calendar.currentPage];
    
    if (calendar.scope == JRCalendarScopeWeek) {
        if (flag == 1) { // 左滑   显示周日
      
            self.selectedDate = [[calendar.currentPage jk_endOfWeek] jk_dateAfterDay:1];
          
            [self currentWeekClick];
        }
        
        if (flag == -1) { // 右滑   显示周一
            self.selectedDate = calendar.currentPage;
            [self nextWeekClick];
        }
        
        if (_isPreOrNext) {
            _isPreOrNext = NO;
           // self.selectedDate = [calendar.currentPage jk_startOfMonth];
        }
        
        if (self.isWeekCalendar) {
            self.calendar.collectionView.scrollEnabled = NO;
        }
        
    } else {
        self.selectedDate = calendar.currentPage;
        self.calendar.collectionView.scrollEnabled = YES;
    }
    
    // Selects a given date in the calendar
    [self.calendar selectDate:self.selectedDate];
    
    _todayBtn.hidden = [calendar.selectedDate isToday];
    
    if (!self.isWeekCalendar) {
        self.titleTimeLabel.text = [self.dateFormatter1 stringFromDate:self.selectedDate];
        [self setTitleTimeLabel];
    }
    
    [self checkGetCalendar:self.selectedDate]; //检查是否需要属性日历接口数据
    if (self.choiceDay) {
        self.choiceDay([self.dateFormatter stringFromDate:self.selectedDate]);
    }
}

//检查是否更新日历信息
- (void)checkGetCalendar:(NSDate *)selectedDate {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMM"];

    NSDate *oldStartDate = [self.dateFormatter dateFromString:self.startDate];
    NSDate *oldEndDate   = [self.dateFormatter dateFromString:self.endDate];
    
    NSInteger oldStartDateInt = [[dateFormatter stringFromDate:oldStartDate] integerValue];
    NSInteger oldEndDateInt = [[dateFormatter stringFromDate:oldEndDate] integerValue];
    NSInteger selectedDateInt = [[dateFormatter stringFromDate:selectedDate] integerValue];

    if (selectedDateInt <= oldStartDateInt  || selectedDateInt >= oldEndDateInt) {
        self.endDate = [self.dateFormatter stringFromDate:[[selectedDate jk_nextMonth:6] jk_endOfMonth]];
        self.startDate = [self.dateFormatter stringFromDate:[[selectedDate jk_previousMonth:6] jk_endOfMonth]];
    }

}

- (void)calendar:(JRCalendar *)calendar boundingRectWillChange:(CGRect)bounds animated:(BOOL)animated {
    JRLog(@"------------- %@",(calendar.scope==JRCalendarScopeWeek?@"week":@"month"));
    self.calendar.height = CGRectGetHeight(bounds);
    [self layoutIfNeeded];
    if (self.reloadHeight) {
        self.reloadHeight(CGRectGetMaxY(self.calendar.frame));
    }
}

#pragma mark - JRCalendarDataSource

// 标记特殊位置方法(圆点)
- (NSInteger)calendar:(JRCalendar *)calendar numberOfEventsForDate:(NSDate *)date {
    
    NSString *dateStr = [self.dateFormatter stringFromDate:date];
    for (int i = 0; i < self.courseArr.count; i++) {
        JRCalendarModel *model = [self.courseArr objectAtIndex:i];
        if ([model.dateString isEqualToString:dateStr] && !model.mark) {
            //显示白点
            return 1;
        }
    }
    //不显示白点
    return 0;
}

// 设置可选择的时间范围(在最小和最大日期之外的日期不能被选中,日期范围如果大于一个月,则日历可翻动)
// 最小时间
- (NSDate *)minimumDateForCalendar:(JRCalendar *)calendar {
    // 学期课程时间
    return [self.minimumDate jk_begindayOfMonth];//self.minimumDate;
}

// 最大时间
- (NSDate *)maximumDateForCalendar:(JRCalendar *)calendar {
    // 学期课程最后一天
    return [self.maximumDate jk_lastdayOfMonth]; // self.maximumDate
}

- (JRCalendarCell *)calendar:(JRCalendar *)calendar cellForDate:(NSDate *)date atMonthPosition:(JRCalendarMonthPosition)monthPosition {

    JRAttendanceDIYCalendarCell *cell = [calendar dequeueReusableCellWithIdentifier:@"cell" forDate:date atMonthPosition:monthPosition];

    cell.titleLabel.textColor = [UIColor whiteColor];
    NSString *dateString = [self.dateFormatter stringFromDate:date];
    BOOL isExist = NO;
    for (int i = 0; i < self.courseArr.count; i++) {
        JRCalendarModel *model = [self.courseArr objectAtIndex:i];
        if ([model.dateString isEqualToString:dateString]) {
            //显示白点
            isExist = YES;
        }
    }
    cell.mark =  isExist ? YES :NO;

    return cell;
}

#pragma mark getter
-(JRCalendar *)calendar{
    if (!_calendar) {
        _calendar = [[JRCalendar alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleView.frame), MAIN_SCREEN_WIDTH, 280)];
//        [_calendar registerClass:[JRAttendanceDIYCalendarCell class] forCellReuseIdentifier:@"cell"];
    }
    return _calendar;
}

- (NSMutableArray *)customEventArr {
    if (!_customEventArr) {
        _customEventArr = [NSMutableArray array];
    }
    return _customEventArr;
}

- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"yyyy-MM-dd";
    }
    return _dateFormatter;
}

- (NSDateFormatter *)dateFormatter1 {
    if (!_dateFormatter1) {
        _dateFormatter1 = [[NSDateFormatter alloc] init];
        _dateFormatter1.dateFormat = @"yyyy年MM月";
    }
    return _dateFormatter1;
}


@end
