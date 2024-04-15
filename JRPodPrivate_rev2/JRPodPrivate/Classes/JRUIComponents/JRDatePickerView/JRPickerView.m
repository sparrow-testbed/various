//
/**
* 所属系统: component
* 所属模块: 
* 功能描述: 
* 创建时间: 2020/9/25
* 维护人:  李志䶮
* Copyright © 2020 wni. All rights reserved.
*┌─────────────────────────────────────────────────────┐
*│ 此技术信息为本公司机密信息，未经本公司书面同意禁止向第三方披露．│
*│ 版权所有：杰人软件(深圳)有限公司                          │
*└─────────────────────────────────────────────────────┘
*/

#import "JRPickerView.h"
#import "JRUIKit.h"

static CGFloat const kDatePickerHeight = 220 ;
static CGFloat const kDateViewHeight = 272   ; // 工具栏高40

@interface JRPickerView ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic, strong) UIButton *leftButton; // 取消
@property (nonatomic, strong) UIButton *rightButton; // 确认
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UIView *toolView; // 工具栏
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) NSMutableArray *yearArray;
@property (nonatomic, strong) NSMutableArray *monthArray;
@property (nonatomic, strong) NSMutableArray *days31Array;
@property (nonatomic, strong) NSMutableArray *days30Array;
@property (nonatomic, strong) NSMutableArray *days29Array;
@property (nonatomic, strong) NSMutableArray *days28Array;
@property (nonatomic, strong) NSArray *otherArray;
@property (nonatomic, assign) PickerViewType pickerViewType;
@property (nonatomic, assign) NSInteger yearIndex;
@property (nonatomic, assign) NSInteger monthIndex;
@property (nonatomic, assign) NSInteger otherIndex;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) NSInteger maxYear;
@property (nonatomic, assign) NSInteger minYear;
@property (nonatomic, strong) NSArray *currentDaysArray;
@property (nonatomic, assign) NSInteger dayIndex;

@end

@implementation JRPickerView

+ (JRPickerView *)shareInstance {
    
    static JRPickerView *instance;
    instance = [[JRPickerView alloc] init];
    return instance;
}

- (void)showInView:(UIView *)superView type:(PickerViewType)type currentContent:(NSString *)currentContent title:(NSString *)title selectCompleteHander:(SelectPickerCallback)dateCallback{
    
    [self showInView:superView type:type currentContent:currentContent title:title contentArray:nil selectCompleteHander:dateCallback];
}

- (void)showInView:(UIView *)superView type:(PickerViewType)type currentContent:(NSString *)currentContent title:(NSString *)title maxYear:(NSInteger)maxYear minYear:(NSInteger)minYear selectCompleteHander:(SelectPickerCallback)dateCallback{
    
    if (type != PickerViewTypeOther) {
        self.maxYear = maxYear;
        self.minYear = minYear;
    }
    
    [self showInView:superView type:type currentContent:currentContent title:title contentArray:nil selectCompleteHander:dateCallback];
}

- (void)showInView:(UIView *)superView type:(PickerViewType)type currentContent:(NSString *)currentContent title:(NSString *)title contentArray:(NSArray *)contentArray selectCompleteHander:(SelectPickerCallback)dateCallback{
    selectCompleteHander = dateCallback;
    
    self.pickerViewType = type;
    self.title = title ? title : @"请选择日期";
    if (type == PickerViewTypeOther) {
        self.otherArray = contentArray;
    }
    
    [self initYearMonthData];
    [self initDayData];
    [self initUI];
    [self setCurrentContent:currentContent];
    
    [superView addSubview:self];
    [superView bringSubviewToFront:self];
    [superView insertSubview:self.cancelButton belowSubview:self]; // 蒙版
    
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGRect rect = superView.frame; // 0 0 375 667 无导航栏  0 64 375 603 有导航栏
        CGRect selfRect = self.frame;
        if (@available(iOS 11.0, *)) {
            selfRect.origin.y = rect.size.height - kDateViewHeight - BottomHeight;
        } else {
            selfRect.origin.y = rect.size.height - kDateViewHeight;
        }// SCREEN_HEIGHT - kDateViewHeight - 64; // 导航栏高度
        self.frame = selfRect;
    } completion:^(BOOL finished) {
        
    }];
}

- (instancetype)initWithFrame:(CGRect)frame {
   self = [super initWithFrame:frame];
    if (self) {
        CGRect rect = CGRectZero;
        if (@available(iOS 11.0, *)) {
            rect.size.height  = kDateViewHeight + BottomHeight;
        } else {
            rect.size.height  = kDateViewHeight;
        }
        rect.size.width   = MAIN_SCREEN_WIDTH;
        rect.origin.y     = MAIN_SCREEN_HEIGHT;
        self.frame = rect;
    }
    return self;
}

- (void)initUI{
    self.backgroundColor = [UIColor whiteColor];

    [self.toolView addSubview:self.leftButton];
    [self.toolView addSubview:self.rightButton];
    [self.toolView addSubview:self.titleLabel];

    UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(0, 52 - 0.5, MAIN_SCREEN_WIDTH, PixelOne)];
    lineV.backgroundColor = [UIColor colorWithHex:@"#d6d8dd"];
    [self.toolView addSubview:lineV];
    
    self.titleLabel.text = self.title;

    [self addSubview:self.toolView];
    
    [self addSubview:self.pickerView];
}

- (void)initYearMonthData{
    self.yearArray = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < 100; i++) {
        int year = 1970 + i;
        if (self.maxYear != 0 && self.minYear != 0 && self.maxYear >= year && self.minYear <= year) {
            [self.yearArray addObject:@(year)];
        }
    }
    
    self.monthArray = [[NSMutableArray alloc]init];
    for (int i = 1; i < 13; i++) {
        [self.monthArray addObject:@(i)];
    }
}

- (void)initDayData{
    self.days28Array = [[NSMutableArray alloc]init];
    self.days29Array = [[NSMutableArray alloc]init];
    self.days30Array = [[NSMutableArray alloc]init];
    self.days31Array = [[NSMutableArray alloc]init];
    for (int i = 1; i < 32; i++) {
        if (i <= 28) {
            [self.days28Array addObject:@(i)];
            [self.days29Array addObject:@(i)];
            [self.days30Array addObject:@(i)];
        }
        else if (i <= 29){
            [self.days29Array addObject:@(i)];
            [self.days30Array addObject:@(i)];
        }
        else if (i <= 30){
            [self.days30Array addObject:@(i)];
        }
        [self.days31Array addObject:@(i)];
    }
    
    self.currentDaysArray = self.days31Array;
}

- (void)setCurrentContent:(NSString *)content{
    if (content.length <= 0) {
        return;
    }
    
    if (self.pickerViewType == PickerViewTypeYearMonthDay) {
        NSArray *array;
        if ([content containsString:@"-"]) {
            array = [content componentsSeparatedByString:@"-"];
        }
        if ([content containsString:@"."]) {
            array = [content componentsSeparatedByString:@"."];
        }
        
        if (array.count > 2) {
            NSInteger year = [array.firstObject integerValue];
            NSInteger month = [[array objectAtIndex:1] integerValue];
            NSInteger day = [array.lastObject integerValue];
            NSInteger yearIndex = [self.yearArray indexOfObject:@(year)];
            NSInteger monthIndex = [self.monthArray indexOfObject:@(month)];
            self.yearIndex = yearIndex;
            self.monthIndex = monthIndex;
            [self.pickerView selectRow:yearIndex inComponent:0 animated:YES];
            [self.pickerView selectRow:monthIndex inComponent:1 animated:YES];
            
            //根据年月 获得显示天数
            [self getShowDays:month year:year];
            NSInteger dayIndex = [self.currentDaysArray indexOfObject:@(day)];
            self.dayIndex = dayIndex;
            [self.pickerView selectRow:dayIndex inComponent:2 animated:YES];
        }
    }
    else if (self.pickerViewType == PickerViewTypeYearMonth) {
        NSArray *array;
        if ([content containsString:@"-"]) {
            array = [content componentsSeparatedByString:@"-"];
        }
        if ([content containsString:@"."]) {
            array = [content componentsSeparatedByString:@"."];
        }
        
        if (array.count > 1) {
            NSInteger year = [array.firstObject integerValue];
            NSInteger month = [array.lastObject integerValue];
            NSInteger yearIndex = [self.yearArray indexOfObject:@(year)];
            NSInteger monthIndex = [self.monthArray indexOfObject:@(month)];
            self.yearIndex = yearIndex;
            self.monthIndex = monthIndex;
            [self.pickerView selectRow:yearIndex inComponent:0 animated:YES];
            [self.pickerView selectRow:monthIndex inComponent:1 animated:YES];
        }
    }
    else if (self.pickerViewType == PickerViewTypeYear){
        NSInteger year =  [content integerValue];
        NSInteger yearIndex = [self.yearArray indexOfObject:@(year)];
        self.yearIndex = yearIndex;
        [self.pickerView selectRow:yearIndex inComponent:0 animated:YES];
    }
    else{
        NSInteger index = [self.otherArray indexOfObject:content];
        [self.pickerView selectRow:index inComponent:0 animated:YES];
    }
    
}

- (void)getShowDays:(NSInteger)month year:(NSInteger)year{
    //定位当前天
    //2月份 区分闰年
    //其他月份 对应天数 1,3,5,7,8,10,12 显示31天 4,6,9,11
    NSArray *day31OfMonth = @[@(1),@(3),@(5),@(7),@(8),@(10),@(12)];
    NSArray *day30OfMonth = @[@(4),@(6),@(9),@(11)];
    if ([day31OfMonth containsObject:@(month)]) {
        self.currentDaysArray = self.days31Array;
    }
    else if ([day30OfMonth containsObject:@(month)]){
        self.currentDaysArray = self.days30Array;
    }
    else{
        if (year % 4 == 0) {
            self.currentDaysArray = self.days29Array;
        }
        else{
            self.currentDaysArray = self.days28Array;
        }
    }
}

#pragma mark UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if (self.pickerViewType == PickerViewTypeYearMonthDay) {
        return 3;
    }
    if (self.pickerViewType == PickerViewTypeYearMonth) {
        return 2;
    }
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (self.pickerViewType == PickerViewTypeYearMonthDay) {
        if (component == 0) {
            return self.yearArray.count;
        }
        else if (component == 1){
            return self.monthArray.count;
        }
        else{
            return self.currentDaysArray.count;
        }
    }
    else if (self.pickerViewType == PickerViewTypeYearMonth) {
        if (component == 0) {
            return self.yearArray.count;
        }
        else{
            return self.monthArray.count;
        }
    }
    else if (self.pickerViewType == PickerViewTypeYear){
        return self.yearArray.count;
    }
    else{
        return self.otherArray.count;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if (self.pickerViewType == PickerViewTypeYearMonthDay) {
        return 100;
    }
    if (self.pickerViewType == PickerViewTypeYearMonth) {
        return 120;;
    }
    return MAIN_SCREEN_WIDTH;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 41;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component __TVOS_PROHIBITED{
    if (self.pickerViewType == PickerViewTypeYearMonthDay) {
        if (component == 0) {
            NSString *year = [NSString stringWithFormat:@"%@年",[self.yearArray objectAtIndex:row]];
            return year;
        }
        else if (component == 1){
            NSString *month = [NSString stringWithFormat:@"%@月",[self.monthArray objectAtIndex:row]];
            return month;
        }
        else{
            NSString *day = [NSString stringWithFormat:@"%@日",[self.currentDaysArray objectAtIndex:row]];
            return day;
        }
    }
    
    else if (self.pickerViewType == PickerViewTypeYearMonth) {
        if (component == 0) {
            NSString *year = [NSString stringWithFormat:@"%@年",[self.yearArray objectAtIndex:row]];
            return year;
        }
        else{
            NSString *month = [NSString stringWithFormat:@"%@月",[self.monthArray objectAtIndex:row]];
            return month;
        }
    }
    else if (self.pickerViewType == PickerViewTypeYear){
        NSString *year = [NSString stringWithFormat:@"%@年",[self.yearArray objectAtIndex:row]];
        return year;
    }
    else{
        return [self.otherArray objectAtIndex:row];;
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    //设置分割线的颜色
    for(UIView *singleLine in pickerView.subviews)
    {
        if (singleLine.frame.size.height < 1)
        {
            singleLine.backgroundColor = [UIColor colorWithHex:@"#ACC0BA"];
            singleLine.height = PixelOne;
        }
    }
    UILabel *genderLabel = (UILabel *)view;
    if (genderLabel == nil) {
        genderLabel = [[UILabel alloc]init];
        [genderLabel setTextAlignment:NSTextAlignmentCenter];
        [genderLabel setBackgroundColor:[UIColor clearColor]];
    }
    //设置文字的属性
    genderLabel.textAlignment = NSTextAlignmentCenter;
    genderLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    genderLabel.textColor = [UIColor colorWithHex:@"#000000"];
    genderLabel.font = [UIFont systemFontOfSize:21];
    return genderLabel;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component API_UNAVAILABLE(tvos){
//    NSLog(@"component == %li,row == %li",component,row);
    if (self.pickerViewType == PickerViewTypeYearMonthDay) {
        if (component == 0) {
            self.yearIndex = row;
            NSInteger month = [[self.monthArray objectAtIndex:self.monthIndex] integerValue];
            NSInteger year = [[self.yearArray objectAtIndex:self.yearIndex] integerValue];
            [self getShowDays:month year:year];
            [self.pickerView reloadComponent:2];
        }
        else if(component == 1){
            self.monthIndex = row;
            NSInteger month = [[self.monthArray objectAtIndex:self.monthIndex] integerValue];
            NSInteger year = [[self.yearArray objectAtIndex:self.yearIndex] integerValue];
            [self getShowDays:month year:year];
            [self.pickerView reloadComponent:2];
        }
        else{
            self.dayIndex = row;
        }
    }
    else if (self.pickerViewType == PickerViewTypeYearMonth) {
        if (component == 0) {
            self.yearIndex = row;
        }
        else{
            self.monthIndex = row;
        }
    }
    else if (self.pickerViewType == PickerViewTypeYear){
        self.yearIndex = row;
    }
    else{
        self.otherIndex = row;
    }
}

- (void)cancelDatePicker:(UIButton *)sender {
    [self dismissDatePicker];
}

- (void)conformDatePicker:(UIButton *)sender {
    if (sender.isTouchInside) {
        [self dismissDatePicker];
        
        if (self.pickerViewType == PickerViewTypeYearMonthDay) {
            NSInteger year = [[self.yearArray objectAtIndex:self.yearIndex] integerValue];
            NSInteger month = [[self.monthArray objectAtIndex:self.monthIndex] integerValue];
            NSInteger day = [[self.currentDaysArray objectAtIndex:self.dayIndex] integerValue];
            NSString *yearMonthDay = [NSString stringWithFormat:@"%li-%li-%li",year,month,day];
            if (selectCompleteHander) {
                selectCompleteHander(yearMonthDay,self.yearIndex);
            }
        }
        
        else if (self.pickerViewType == PickerViewTypeYearMonth) {
            NSInteger year = [[self.yearArray objectAtIndex:self.yearIndex] integerValue];
            NSInteger month = [[self.monthArray objectAtIndex:self.monthIndex] integerValue];
            NSString *yearMonth = [NSString stringWithFormat:@"%li-%li",year,month];
            if (selectCompleteHander) {
                selectCompleteHander(yearMonth,self.yearIndex);
            }
        }
        else if (self.pickerViewType == PickerViewTypeYear){
            NSInteger year = [[self.yearArray objectAtIndex:self.yearIndex] integerValue];
            if (selectCompleteHander) {
                selectCompleteHander([NSString stringWithFormat:@"%li",year],self.yearIndex);
            }
        }
        else{
            NSString *content = [self.otherArray objectAtIndex:self.otherIndex];
            if (selectCompleteHander) {
                selectCompleteHander(content,self.otherIndex);
            }
        }
    }
}

- (void)dismissDatePicker {
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGRect selfRect = self.frame;
        selfRect.origin.y = MAIN_SCREEN_HEIGHT;
        self.frame = selfRect;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self.cancelButton removeFromSuperview];
        [self.rightButton setTitleColor:[UIColor colorWithHex:@"#1aad19"] forState:UIControlStateNormal];
        self.rightButton.userInteractionEnabled = YES;
    }];
}

-(UIPickerView *)pickerView{
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 52, MAIN_SCREEN_WIDTH, kDatePickerHeight)];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        _pickerView.backgroundColor = [UIColor whiteColor];
        [_pickerView selectRow:30 inComponent:0 animated:YES];
        
    }
    
    for(UIView *speartorView in _pickerView.subviews)
    {
        if (speartorView.frame.size.height < 1)//取出分割线view
        {
            speartorView.backgroundColor = [UIColor colorWithHex:@"#D6D8DD"];//隐藏分割线
        }
    }
    return _pickerView;
}

- (UIView *)toolView {
    if (!_toolView) {
        _toolView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, 52)];
    }
    return _toolView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(MAIN_SCREEN_WIDTH/2-120, 0, 240, 52)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = @"请选择日期";
        _titleLabel.font = [UIFont systemFontOfSize:18];
    }
    return _titleLabel;
}

- (UIButton *)leftButton {
    if (!_leftButton) {
        _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftButton.frame = CGRectMake(5, 0, 60, 52);
        [_leftButton setTitle:@"取消" forState:UIControlStateNormal];
        [_leftButton setTitleColor:[UIColor colorWithHex:@"#666666"] forState:UIControlStateNormal];
        [_leftButton addTarget:self action:@selector(cancelDatePicker:) forControlEvents:UIControlEventTouchUpInside];
        _leftButton.titleLabel.font = [UIFont systemFontOfSize:18];
    }
    return _leftButton;
}

- (UIButton *)rightButton {
    if (!_rightButton) {
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightButton.frame = CGRectMake(MAIN_SCREEN_WIDTH - 65, 0, 60, 52);
        [_rightButton setTitle:@"确定" forState:UIControlStateNormal];
        [_rightButton setTitleColor:[UIColor colorWithHex:@"#1aad19"] forState:UIControlStateNormal];
        [_rightButton addTarget:self action:@selector(conformDatePicker:) forControlEvents:UIControlEventTouchUpInside];
        _rightButton.titleLabel.font = [UIFont systemFontOfSize:18];
    }
    return _rightButton;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, MAIN_SCREEN_HEIGHT)];
        _cancelButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        [_cancelButton addTarget:self action:@selector(dismissDatePicker) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

@end
