//
/**
* 所属系统: component
* 所属模块: 
* 功能描述: 
* 创建时间: 2020/9/16
* 维护人:  王伟
* Copyright © 2020 杰人软件. All rights reserved.
*┌─────────────────────────────────────────────────────┐
*│ 此技术信息为本公司机密信息，未经本公司书面同意禁止向第三方披露．│
*│ 版权所有：杰人软件(深圳)有限公司                          │
*└─────────────────────────────────────────────────────┘
*/

#import "JRAlertView.h"
#import <QuartzCore/QuartzCore.h>
#import "JRUIKit.h"

const static CGFloat kAlertViewDefaultButtonHeight       = 45;  // 按钮高度
const static CGFloat kAlertViewCornerRadius              = 5;   // 圆角半径

CGFloat buttonHeight = 0;
CGFloat buttonSpacerHeight = 0;

@interface JRAlertView() {
    
    CGFloat contentViewHeight; // 内容视图高度
    NSString *placeholder;
    NSString *warningStr;
    NSInteger styleFlag; // 样式
}

@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, assign) BOOL isWarning;
@property (nonatomic, assign) BOOL isRefuse;

@property (nonatomic,copy)NSString *warnImageName;
@end

@implementation JRAlertView

+ (instancetype)share {
    
    static JRAlertView *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
    });
    
    return instance;
}

+ (void)initWithTitle:(NSString *)msg
         ButtonTitles:(NSArray *)buttonArr
            IsWarning:(BOOL)isWarning
        warnImageName:(nullable NSString *)warnImageName
                Block:(OnButtonClickBlock)complete {
    [[JRAlertView share] setMsg:msg subTitle:nil ButtonTitles:buttonArr IsWarning:isWarning warnImageName:warnImageName Block:complete];
}

+ (void)initWithTitle:(NSString *)msg
             subTitle:(NSString *)subTitle
         ButtonTitles:(NSArray *)buttonArr
            IsWarning:(BOOL)isWarning
        warnImageName:(nullable NSString *)warnImageName
                Block:(OnButtonClickBlock)complete {
    [[JRAlertView share] setMsg:msg subTitle:subTitle ButtonTitles:buttonArr IsWarning:isWarning warnImageName:warnImageName Block:complete];
    
}


+ (void)initAlertWithTextfieldMsg:(NSString *)msg
                        PlaceHold:(NSString *)placehold
                     ButtonTitles:(NSArray *)buttonArr
                        IsWarning:(BOOL)isWarning
                       WorningStr:(NSString *)warningStr
                            Block:(OnButtonTextfieldClick)complete {
    
    [[JRAlertView share] setTextFieldMsg:msg PlaceHolder:(NSString *)placehold ButtonTitles:buttonArr IsWarning:isWarning WarningStr:warningStr Block:complete];
}


+ (void)initAlertWithTitleView:(UIView *)titleView
                   titleHeight:(CGFloat)titleHeight
                  ButtonTitles:(NSArray *)buttonArr
                     IsWarning:(BOOL)isWarning
                 warnImageName:(nullable NSString *)warnImageName
                         Block:(OnButtonClickBlock)complete {
    
    [[[JRAlertView alloc]init] setTitleView:titleView titleHeight:titleHeight ButtonTitles:buttonArr IsWarning:isWarning warnImageName:warnImageName Block:complete];
}

- (instancetype)init {
    
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    if (self) {
        placeholder = @"请输入内容";
        contentViewHeight = 80; // 100
        styleFlag = 0;
    }
    
    return self;
}

- (void)setMsg:(NSString *)msg subTitle:(NSString *)subTitle ButtonTitles:(NSArray *)buttonArr IsWarning:(BOOL)isWarning         warnImageName:(nullable NSString *)warnImageName Block:(OnButtonClickBlock)complete {
    
    styleFlag = 0; // 默认样式
    contentViewHeight = 80; // 100
    
    self.warnImageName = warnImageName;
    self.message = msg;
    self.subtitle = subTitle;
    self.buttonTitles = buttonArr;
    self.isWarning = isWarning; // 警告
    self.onButtonClickBlock = complete;
    
    [self buildUIWithWarning:isWarning];
}

- (void)setTitleView:(UIView *)titleView titleHeight:(CGFloat)titleHeight ButtonTitles:(NSArray *)buttonArr IsWarning:(BOOL)isWarning         warnImageName:(nullable NSString *)warnImageName Block:(OnButtonClickBlock)complete {
    _subtitle = nil;
    styleFlag = 0; // 默认样式
    contentViewHeight = 80; // 100
    self.warnImageName = warnImageName;
    self.titleView = titleView;
    self.titleHeight = titleHeight;
    self.buttonTitles = buttonArr;
    self.isWarning = isWarning; // 警告
    self.onButtonClickBlock = complete;
    
    [self buildUIWithWarning:isWarning];
}

- (void)setTextFieldMsg:(NSString *)msg PlaceHolder:(NSString *)placeholder ButtonTitles:(NSArray *)buttonArr IsWarning:(BOOL)isWarning WarningStr:(NSString *)warningstr Block:(OnButtonTextfieldClick)complete {
    
    styleFlag = 1;
    warningStr = warningstr;
    contentViewHeight = 130;
    placeholder = placeholder;
    
    self.message = msg;
    self.buttonTitles = buttonArr;
    self.isWarning = isWarning;
    self.onButtonTextFieldClick = complete;
    
    [self buildUIWithWarning:isWarning];
    
    [self.contentView addSubview:self.textField];
}

- (void)buildUIWithWarning:(BOOL)isWarning {

    if (isWarning) {
        _dialogView = [self createErrortView];
    }else{
        _dialogView = [self createContentView];
    }
    
    
    // layer光栅化，提高性能
    _dialogView.layer.shouldRasterize = YES;
    _dialogView.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    
    [self addSubview:_dialogView];
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    [[[[UIApplication sharedApplication] windows] firstObject] addSubview:self]; // keyWindows
    
    _dialogView.layer.opacity = 0.5f;
    WS(weakSelf)
    [UIView animateWithDuration:0.1f delay:0.0 options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
        
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5f];
        
        weakSelf.dialogView.layer.opacity = 1.0f;
        
    }
                     completion:nil
     ];
}

// 按钮点击
- (void)buttonClickHandle:(UIButton *)sender {
    if (styleFlag == 1) {
        
        if (sender.tag == 0) {
            [self dismiss];
            return;
        }
        
        if ([JRUIHelper TextIsEmpty:self.textField.text]) {
            [MBProgressHUD showHUD:warningStr?warningStr:@"请输入内容！"];
            return;
        }
        
        _onButtonTextFieldClick(self, [sender tag], self.textField.text);
    } else {
        if (_onButtonClickBlock) {
            _onButtonClickBlock(self, [sender tag]);
        }
    }
    [self dismiss];
}

- (void)setOnClickListerner:(OnButtonClickBlock)onButtonClickHandle {
    _onButtonClickBlock = onButtonClickHandle;
}

// 关闭AlertView并移除
- (void)dismiss {
    
    CATransform3D currentTransform = _dialogView.layer.transform;
    
    _dialogView.layer.opacity = 1.0f;
    WS(weakSelf);
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone
                     animations:^{
        self.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.0f];
        weakSelf.dialogView.layer.transform = CATransform3DConcat(currentTransform, CATransform3DMakeScale(0.6f, 0.6f, 1.0));
        weakSelf.dialogView.layer.opacity = 0.0f;
    }
                     completion:^(BOOL finished) {
        for (UIView *v in [self subviews]) {
            [v removeFromSuperview];
        }
        [self removeFromSuperview];
        
        weakSelf.contentView = nil;
        weakSelf.textField = nil;
    }
     ];
}

// 得到提示视图的size
- (CGSize)countDialogSize {
    CGFloat dialogWidth = _contentView.frame.size.width;
    CGFloat dialogHeight = _contentView.frame.size.height + buttonHeight + buttonSpacerHeight;
    
    return CGSizeMake(dialogWidth, dialogHeight);
}

// 得到屏幕的size
- (CGSize)courrentScreenSize {
    
    if (_buttonTitles && [_buttonTitles count] > 0) {
        buttonHeight       = kAlertViewDefaultButtonHeight;
        buttonSpacerHeight = [JRUIHelper pixelOne];
    } else {
        buttonHeight = 0;
        buttonSpacerHeight = 0;
    }
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    return CGSizeMake(screenWidth, screenHeight);
}

#pragma mark -

// 提示视图界面
- (UIView *)createErrortView {
    [_contentView removeFromSuperview];
    _contentView = nil;
    CGFloat lineMaxY = 0.0f;

    if (!_contentView) {
        CGFloat labelH = [_message sizeFont:[UIFont systemFontOfSize:18] lineSpacing:6 maxSize:CGSizeMake(280-50, MAXFLOAT)].height + 5;
        
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 100 + labelH)];
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(115.5, 24, 49, 49)];
        image.image = [JRUIHelper imageNamed:self.warnImageName ?: @"i_fail_card"];
        
        // 标题
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(25, 87, _contentView.width-50, labelH)];
        [label setText:_message lineSpacing:6];
//        label.text = _message;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor titleTextColor];
        label.numberOfLines = 0;
        label.font = [UIFont systemFontOfSize:18];
        // 割线
        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(label.frame) + 13, 280, PixelOne)];
        line1.backgroundColor = [UIColor colorWithHex:@"0xd6d8dd"];

        lineMaxY = CGRectGetMaxY(label.frame) + 14;
        
        [_contentView addSubview:image];
        [_contentView addSubview:label];
        [_contentView addSubview:line1];
    }
    
    NSInteger buttonCount = [_buttonTitles count];
    CGFloat buttonWidth = _contentView.width / buttonCount;
    if (buttonCount) {
        for (int i = 1; i < buttonCount ; i ++) {
            UIView *dividedView = [[UIView alloc] initWithFrame:CGRectMake(buttonWidth * i, lineMaxY, PixelOne, kAlertViewDefaultButtonHeight - 2 * PixelOne)];
            dividedView.backgroundColor = [UIColor colorWithHex:@"0xd6d8dd"];
            [_contentView addSubview:dividedView];
        }
    }
    
    CGSize screenSize = [self courrentScreenSize];
    CGSize dialogSize = [self countDialogSize];
    
    [self setFrame:CGRectMake(0, 0, screenSize.width, screenSize.height)];
    
    // 提示视图 居中
    UIView *dialogContainer = [[UIView alloc] initWithFrame:CGRectMake((screenSize.width - dialogSize.width) / 2, ((screenSize.height - dialogSize.height) / 2), dialogSize.width, dialogSize.height)];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = dialogContainer.bounds;
    gradient.colors = [NSArray arrayWithObjects:
                       (id)[[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0f] CGColor],
                       (id)[[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0f] CGColor],
                       (id)[[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0f] CGColor],
                       nil];
    
    CGFloat cornerRadius = kAlertViewCornerRadius;
    gradient.cornerRadius = cornerRadius;
    [dialogContainer.layer insertSublayer:gradient atIndex:0];
    
    dialogContainer.layer.cornerRadius = cornerRadius;
    dialogContainer.layer.shadowRadius = cornerRadius + 5;
    dialogContainer.layer.shadowOpacity = 0.1f;
    dialogContainer.layer.shadowOffset = CGSizeMake(0 - (cornerRadius + 5) / 2, 0 - (cornerRadius + 5) / 2);
    dialogContainer.layer.shadowColor = [UIColor blackColor].CGColor;
    dialogContainer.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:dialogContainer.bounds cornerRadius:dialogContainer.layer.cornerRadius].CGPath;
    
    // 添加子布局
    [dialogContainer addSubview:_contentView];
    
    // 添加按钮
    [self addErrorButtonsToView:dialogContainer];
    
    return dialogContainer;
}

// 提示视图界面
- (UIView *)createContentView {
    [_contentView removeFromSuperview];
    _contentView = nil;
    
    CGFloat lineMaxY = 0.0f;
    if (!_contentView) {

        if (_subtitle && _subtitle.length > 0) {
            CGFloat labelH = [_message sizeFont:[UIFont systemFontOfSize:16] lineSpacing:6 maxSize:CGSizeMake(280-50, MAXFLOAT)].height + 5;
            CGFloat subLabelH = [_subtitle sizeFont:[UIFont systemFontOfSize:14] lineSpacing:6 maxSize:CGSizeMake(280-50, MAXFLOAT)].height + 5;

            _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 32 + labelH + 6 + subLabelH + 20 )];
            
            // 标题
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(25, 32, _contentView.width-50, labelH)];
            [label setText:_message lineSpacing:6];

            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = [UIColor titleTextColor];
            label.numberOfLines = 0;
            label.font = [UIFont systemFontOfSize:16];
            
            //副标题
            UILabel *subLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, CGRectGetMaxY(label.frame) + 6, _contentView.width-50, subLabelH)];
            [subLabel setText:_subtitle lineSpacing:5];

            subLabel.textAlignment = NSTextAlignmentCenter;
            subLabel.textColor = [UIColor timeTextColor];
            subLabel.numberOfLines = 0;
            subLabel.font = [UIFont systemFontOfSize:14];

            // 割线

            UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(subLabel.frame) + 22, 280, PixelOne)];
            line1.backgroundColor = [UIColor colorWithHex:@"0xd6d8dd"];
            
            lineMaxY = CGRectGetMaxY(subLabel.frame) + 22;
            
            [_contentView addSubview:label];
            [_contentView addSubview:subLabel];
            [_contentView addSubview:line1];
            
            
        }else if (self.titleView){
            _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 294, _titleHeight)];
            [_contentView addSubview:_titleView];
            
            _titleView.centerX = _contentView.centerX;
            
            // 割线
            
            UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, _titleHeight + 2, 294, PixelOne)];
            line1.backgroundColor = [UIColor colorWithHex:@"0xd6d8dd"];
            
            lineMaxY = _titleHeight + 2;

            [_contentView addSubview:line1];
        }
        else{
            CGFloat labelH = [_message sizeFont:[UIFont systemFontOfSize:18] lineSpacing:6 maxSize:CGSizeMake(280-50, MAXFLOAT)].height + 20;

            _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 15+labelH +15 )];
            
            // 标题
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(25, 15, _contentView.width-50, labelH)];
            [label setText:_message lineSpacing:6];
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = [UIColor titleTextColor];
            label.numberOfLines = 0;
            label.font = [UIFont systemFontOfSize:18];
            // 割线
            UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_contentView.frame), 280, PixelOne)];
            line1.backgroundColor = [UIColor colorWithHex:@"0xd6d8dd"];
            
            lineMaxY = CGRectGetMaxY(_contentView.frame);
            
            [_contentView addSubview:label];
            [_contentView addSubview:line1];
        }
    }
    NSInteger buttonCount = [_buttonTitles count];
    CGFloat buttonWidth = _contentView.width / buttonCount;
    
    if (buttonCount) {
        for (int i = 1; i < buttonCount ; i ++) {
            UIView *dividedView = [[UIView alloc] initWithFrame:CGRectMake(buttonWidth * i, lineMaxY, PixelOne, kAlertViewDefaultButtonHeight - 2)];
            dividedView.backgroundColor = [UIColor colorWithHex:@"0xd6d8dd"];
            [_contentView addSubview:dividedView];
        }
    }
    
   
    CGSize screenSize = [self courrentScreenSize];
    CGSize dialogSize = [self countDialogSize];
    
    [self setFrame:CGRectMake(0, 0, screenSize.width, screenSize.height)];
    
    // 提示视图 居中
    UIView *dialogContainer = [[UIView alloc] initWithFrame:CGRectMake((screenSize.width - dialogSize.width) / 2, ((screenSize.height - dialogSize.height) / 2), dialogSize.width, dialogSize.height)];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = dialogContainer.bounds;
    gradient.colors = [NSArray arrayWithObjects:
                       (id)[[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0f] CGColor],
                       (id)[[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0f] CGColor],
                       (id)[[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0f] CGColor],
                       nil];
    
    CGFloat cornerRadius = kAlertViewCornerRadius;
    gradient.cornerRadius = cornerRadius;
    [dialogContainer.layer insertSublayer:gradient atIndex:0];
    
    dialogContainer.layer.cornerRadius = cornerRadius;
    dialogContainer.layer.shadowRadius = cornerRadius + 5;
    dialogContainer.layer.shadowOpacity = 0.1f;
    dialogContainer.layer.shadowOffset = CGSizeMake(0 - (cornerRadius + 5) / 2, 0 - (cornerRadius + 5) / 2);
    dialogContainer.layer.shadowColor = [UIColor blackColor].CGColor;
    dialogContainer.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:dialogContainer.bounds cornerRadius:dialogContainer.layer.cornerRadius].CGPath;
    
    // 添加子布局
    [dialogContainer addSubview:_contentView];
    
    // 添加按钮
    [self addButtonsToView:dialogContainer];
    
    return dialogContainer;
}

// 添加按钮
- (void)addErrorButtonsToView:(UIView *)container {
    if (!_buttonTitles) {
        return;
    }
    
    NSInteger buttonCount = [_buttonTitles count];
    CGFloat buttonWidth = container.bounds.size.width / buttonCount;
    for (int i = 0; i < buttonCount; i++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(i * buttonWidth, container.bounds.size.height - buttonHeight, buttonWidth, buttonHeight)];
        
        [button addTarget:self action:@selector(buttonClickHandle:) forControlEvents:UIControlEventTouchUpInside];
        [button setTag:i];
       
        [button setTitle:[_buttonTitles objectAtIndex:i] forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor clearColor]];
        
        // 设置按钮颜色
        if (buttonCount-1 == i) {
            
            [button setTitleColor:_isWarning?[UIColor colorWithHex:@"#1AAD19"]:[UIColor kDefaultGreenColor] forState:UIControlStateNormal];
        } else {
            [button setTitleColor:[UIColor titleTextColor] forState:UIControlStateNormal];
        }
        
        if (buttonCount == 0 && _isRefuse) {
            [button setTitleColor:[UIColor colorWithHex:@"#000000"] forState:UIControlStateNormal];
        }
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        
        [button.layer setCornerRadius:kAlertViewCornerRadius];
        [container addSubview:button];
    }
    
}

// 添加按钮
- (void)addButtonsToView:(UIView *)container {
    if (!_buttonTitles) {
        return;
    }
    
    NSInteger buttonCount = [_buttonTitles count];
    CGFloat buttonWidth = container.bounds.size.width / buttonCount;
    
    for (int i = 0; i < buttonCount; i++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(i * buttonWidth, container.bounds.size.height - buttonHeight, buttonWidth, buttonHeight)];
        
        [button addTarget:self action:@selector(buttonClickHandle:) forControlEvents:UIControlEventTouchUpInside];
        [button setTag:i];
       
        [button setTitle:[_buttonTitles objectAtIndex:i] forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor clearColor]];
        
        // 设置按钮颜色
        if (buttonCount-1 == i) {
            
            [button setTitleColor:_isWarning?[UIColor colorWithHex:@"#e03b37"]:[UIColor kDefaultGreenColor] forState:UIControlStateNormal];
        } else {
            [button setTitleColor:[UIColor titleTextColor] forState:UIControlStateNormal];
        }
        
        if (buttonCount == 0 && _isRefuse) {
            [button setTitleColor:[UIColor colorWithHex:@"#000000"] forState:UIControlStateNormal];
        }
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        
        [button.layer setCornerRadius:kAlertViewCornerRadius];
        [container addSubview:button];
    }
}

- (UITextField *)textField {
    
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(30, 80, 294-60, 21)];
        _textField.font = [UIFont systemFontOfSize:14];
        _textField.placeholder = placeholder;
    }
    return _textField;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
