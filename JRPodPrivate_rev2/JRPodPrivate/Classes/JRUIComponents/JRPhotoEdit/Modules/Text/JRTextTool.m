//
/**
* 所属系统: YMMAD
* 所属模块: 
* 功能描述: 
* 创建时间: 2021/3/16
* 维护人:  马克
* 
*┌─────────────────────────────────────────────────────┐
*│ 此技术信息为本公司机密信息，未经本公司书面同意禁止向第三方披露．│
*│ 版权所有：杰人软件(深圳)有限公司                          │
*└─────────────────────────────────────────────────────┘
*/

#import "JRTextTool.h"
#import "FrameAccessor.h"
#import "JRTextColorPanel.h"
#import "EXTobjc.h"
#import <XXNibBridge/XXNibBridge.h>
#import "JRDrawView.h"
#import "JRUIKit.h"
#import "JRTextToolView.h"
#import "JRNavigationBarView.h"

static const CGFloat kTopOffset = 50.f;
static const CGFloat kTextTopOffset = 90.f;
static const NSInteger kTextMaxLimitNumber = 30;

@interface JRTextTool ()
@property (nonatomic, weak) JRDrawView *canvas;

@end

@implementation JRTextTool


- (void)setup
{
    _canvas = self.editor.drawingView;
    self.editor.scrollView.pinchGestureRecognizer.enabled = NO;
    
    
    if (self.isEditAgain) {
//        self.textColorPanel.isBagColorSelect =  self.isChangeTexbagColor;
        //颜色选中效果
//        [self editTextAgainAction];
        
    }else {
        self.textColorPanel.isBagColorSelect =  NO;
        self.isChangeTexbagColor = NO;
    }
    
    self.lastChangeBagColor = self.textColorPanel.isBagColorSelect;
  
    //初始化文字输入view
    self.textView = [[JRTextView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, HEIGHT_SCREEN)]; //HEIGHT_SCREEN
    self.textView.textTool = self;
    if (@available(iOS 8.2, *)) {
        self.textView.textView.font = [UIFont systemFontOfSize:24.f weight:UIFontWeightBold];
    } else {
        // Fallback on earlier versions
    }
    if (self.textColorPanel) {
        self.textView.colorPanel.currentColor = self.textColorPanel.currentColor;
    }
    
    self.textColorPanel = self.textView.colorPanel;
    
    //默认第一次颜色
    if (self.isEditAgain == NO) {
        self.textColorPanel.currentColor = [UIColor redColor];//self.textColorPanel.redButton.color;
    }
    self.textView.textView.textColor = self.textColorPanel.currentColor;//[UIColor whiteColor];
    if (self.textColorPanel.isBagColorSelect) {
        self.textView.textView.backgroundColor = self.textColorPanel.currentColor;
        self.textView.textView.textColor = [UIColor whiteColor];
    }
//    self.textColorPanel = self.textView.colorPanel;
      
    [self setupActions];
    
    [self.editor.view addSubview:self.textView];
}

- (void)editTextAgainAction {
    
    for (JRColorfullButton *colorButton in self.textColorPanel.colorButtons) {
        
        BOOL isColor = [self firstColor:self.textColorPanel.currentColor secondColor:colorButton.color];
        
        if (isColor) {
            // 如果颜色一致 就显示 颜色选中效果
            colorButton.isUse = YES;
            break;
        }
//        colorButton.isUse = NO;
    }
    
}


- (void)setupActions
{
    
    @weakify(self);
    self.textView.dissmissTextTool = ^(NSString *currentText, BOOL isUse)
    {
        @strongify(self);
        
        self.editor.scrollView.pinchGestureRecognizer.enabled = YES;
        
        if (self.isEditAgain)
        {
            if (self.editAgainCallback && isUse)
            {
                self.editAgainCallback(currentText,self.isChangeTexbagColor,self.textColorPanel.currentColor);
            }
            
            self.isEditAgain = NO;
        }
        else
        {
            if (isUse)
            {
                [self addNewText:currentText];
            }
        }
        
        if (self.dissmissTextTool)
        {
            self.dissmissTextTool(currentText);
        }
    };
    
#pragma mark - 改变文字颜色
    self.textColorPanel.onTextColorChange = ^(UIColor *color) {
        @strongify(self);
        
        [self changeColor:color];
    };
#pragma mark - 改变背景颜色
    //没改变一次背景色都要改变label
    self.textColorPanel.onTextBagColorChange = ^(UIColor * _Nonnull color,BOOL isSelectColor) {
        @strongify(self);
        self.isChangeTexbagColor = isSelectColor;
        if (isSelectColor) {
            self.textView.textView.textColor = [UIColor whiteColor];
            if (color == nil) {
                //第一次默认颜色取当前选择色
                color = self.textColorPanel.currentColor;
            }
            self.textView.textView.backgroundColor = color;
            self.bagroundColor = color;//记录当前选中的颜色

            // 判断选中的颜色是否白色背景 白色背景文字设为黑色
            BOOL isColor = [self firstColor:color secondColor:self.textView.colorPanel.whiteButton.color];
            
            if (isColor) {
                self.textView.textView.textColor = [UIColor blackColor];
            }

        }else {
            self.textView.textView.backgroundColor = [UIColor clearColor];
            self.textView.textView.textColor = self.textView.colorPanel.currentColor;//[UIColor whiteColor];

        }
        
        
        

    };
}

-(BOOL)firstColor:(UIColor*)firstColor secondColor:(UIColor*)secondColor
{
    if (CGColorEqualToColor(firstColor.CGColor, secondColor.CGColor))
    {
        NSLog(@"颜色相同");
        return YES;
    }
    else
    {
        NSLog(@"颜色不同");
        return NO;
    }
}

#pragma mark - implementation 重写父方法
- (void)cleanup
{
    [self.textView removeFromSuperview];
}

- (void)hideTools:(BOOL)hidden
{
    if (hidden)
    {
        self.editor.mainToolBarView.alpha = 0;
    }
    else
    {
        self.editor.mainToolBarView.alpha = 1.0f;
    }
}

- (UIView *)drawView
{
    return nil;
}

- (void)hideTextBorder
{
    [JRTextToolView hideTextBorder];
}
#pragma mark - 改变文字颜色
- (void)changeColor:(UIColor *)color
{
    if (color && self.textView)
    {
        self.textView.colorPanel.currentColor = color; // 同时修改当前文字颜色

        [self.textView.textView setTextColor:color];
    }
}

- (void)changeTextBagColor:(UIColor *)color
{
    if (color && self.textView)
    {
//        [self.textView.textView setTextColor:color];
        
    }
}

#pragma mark - 添加新的文字
- (void)addNewText:(NSString *)text
{
    if (text == nil || text.length <= 0)
    {
        return;
    }
    
    JRTextToolView *view = [[JRTextToolView alloc] initWithTool:self text:text font:self.textView.textView.font orImage:nil];
    view.fillColor = self.textColorPanel.currentColor;
    view.isBagColorSelect = self.textColorPanel.isBagColorSelect;
    view.borderColor = [UIColor whiteColor];
    view.font = self.textView.textView.font;
    view.text = text;
    view.center = [self.editor.imageView.superview convertPoint:self.editor.imageView.center toView:self.editor.drawingView];
//    view.top = SCREEN_HEIGHT/2;
    view.userInteractionEnabled = YES;
    
    [self.editor.drawingView addSubview:view]; // 文字视图添加到 绘画图层上在涂鸦的时候 图标像素失真
//    [self.editor.containerView addSubview:view];
    
    // 更新位置 不然旋转了
    CGFloat scale = [(NSNumber *)[self.editor.drawingView valueForKeyPath:@"layer.transform.rotation"] floatValue];
    [view rotate:-scale];
    
    [JRTextToolView setActiveTextView:view];
}

@end



#pragma mark - JRTextView
@interface JRTextView () <UITextViewDelegate>
@property (nonatomic, strong) NSString *needReplaceString;
@property (nonatomic, assign) NSRange   needReplaceRange;
@property (nonatomic, strong) JRNavigationBarView *navigationBarView;


@end

@implementation JRTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
                
        self.backgroundColor = [UIColor clearColor];
        
        self.effectView = [[UIView alloc] init];
        self.effectView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7f];
        self.effectView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        [self addSubview:self.effectView];
        
        
        [self gaussView:self.effectView];
        
        self.navigationBarView = [JRNavigationBarView xx_instantiateFromNib];
        self.navigationBarView.frame = CGRectMake(0, 16, WIDTH_SCREEN, [JRNavigationBarView fixedHeight]);
        self.navigationBarView.doneButton.enabled = YES;
        self.navigationBarView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.0];
        [self addSubview:self.navigationBarView];
                
        self.textView = [[UITextView alloc] initWithFrame:CGRectMake(20, kTextTopOffset+10, WIDTH_SCREEN - 20 * 2, 40)];//HEIGHT_SCREEN - kTopOffset
        self.textView.layer.cornerRadius = 5;
//        self.textView.top = kTextTopOffset;
        self.textView.scrollEnabled = YES;
        self.textView.returnKeyType = UIReturnKeyDone;
        self.textView.delegate = self;
        self.textView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.textView];
        
        JRTextColorPanel *colorPanel = [JRTextColorPanel xx_instantiateFromNib];
        colorPanel.frame = CGRectMake(0, HEIGHT_SCREEN, WIDTH_SCREEN, [JRTextColorPanel fixedHeight]);
        [self addSubview:colorPanel];
        self.colorPanel = colorPanel;
        
        [self setupActions];
        [self addNotify];
    }
    
    return self;
}

#pragma mark -  完成 取消 功能
- (void)setupActions
{
    __weak __typeof(self)weakSelf = self;
   
    self.navigationBarView.onDoneButtonClickBlock = ^(UIButton *btn) {
        
        if (self.textTool.editor.isTextTool == NO) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"REATOREACURRENTTOOLBAR" object:@(self.textTool.editor.currentMode)];
        }
        

        //点击确定按钮完成文字颜色更换
        if (weakSelf.textTool.changeTextBagColorCallback) {
            weakSelf.textTool.changeTextBagColorCallback(weakSelf.textTool.textView.textView.backgroundColor,weakSelf.textTool.isChangeTexbagColor);
        }


        [weakSelf dismissTextEditing:YES];
    };
//
    self.navigationBarView.onCancelButtonClickBlock = ^(UIButton *btn) {
        
        weakSelf.textTool.isChangeTexbagColor = weakSelf.textTool.lastChangeBagColor;
        
        weakSelf.textTool.textColorPanel.isBagColorSelect = weakSelf.textTool.lastChangeBagColor;
        
        
        
        if (self.textTool.editor.isTextTool == NO) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"REATOREACURRENTTOOLBAR" object:@(weakSelf.textTool.editor.currentMode)];
        }
        weakSelf.textTool.textColorPanel.currentColor = [UIColor redColor];//weakSelf.textTool.textColorPanel.redButton.color;
        
        [weakSelf dismissTextEditing:NO];
    };
}

- (void)addNotify
{
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(keyboardWillShow:)
     name:UIKeyboardWillShowNotification
     object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(keyboardWillHide:)
     name:UIKeyboardWillHideNotification
     object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *userinfo = notification.userInfo;
    CGRect  keyboardRect              = [[userinfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardAnimationDuration = [[userinfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationOptions keyboardAnimationCurve = [[userinfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    self.hidden = YES;
    
    [UIView
     animateWithDuration:keyboardAnimationDuration
     delay:keyboardAnimationDuration
     options:keyboardAnimationCurve
     animations:^{
//        self.textView.height = HEIGHT_SCREEN - keyboardRect.size.height - kTextTopOffset;
        // 键盘弹窗重新计算选择颜色板的frame
        self.colorPanel.frame = CGRectMake(0, HEIGHT_SCREEN - [JRTextColorPanel fixedHeight] - keyboardRect.size.height, WIDTH_SCREEN, [JRTextColorPanel fixedHeight]);
        
//        self.colorPanel.whiteButton.isUse = YES;

        
                // 更新颜色板的背景色状态
        [self updateTextViewBagroundColor];
        
        // 更新文字输入框的frame
        [self updateTextViewFrame];

        
    } completion:NULL];
    
//    self.colorPanel.greenButton.isUse = YES;

//    if (self.colorPanel.currentButton) {
////            self.colorPanel.currentButton.isUse = YES;
////        self.colorPanel.whiteButton.isUse = YES;
//
//
//
//        switch (self.colorPanel.currentButton.tag) {
//            case 990:
//                self.colorPanel.redButton.isUse = YES;
//                break;
//            case 991:
//                self.colorPanel.whiteButton.isUse = YES;
//                break;
//            case 992:
//                self.colorPanel.blackButton.isUse = YES;
//                break;
//            case 993:
//                self.colorPanel.yellowButton.isUse = YES;
//                break;
//            case 994:
//                self.colorPanel.greenButton.isUse = YES;
//                break;
//            case 995:
//                self.colorPanel.blueButton.isUse = YES;
//                break;
//            case 996:
//                self.colorPanel.purpleButton.isUse = YES;
//                break;
//
//            default:
//                break;
//        }
//
//
//            for (JRColorfullButton *but in self.colorPanel.subviews) {
//
//                if ([but isKindOfClass:[JRColorfullButton class]]) {
//                    if (![but isEqual:self.colorPanel.currentButton]) {
//                        but.isUse = NO;
//                    }
//                }
//
//            }
//
//
////            [self.colorPanel buttonAction:self.colorPanel.currentButton];
//    }

    
    [UIView animateWithDuration:3 animations:^{
        self.hidden = NO;
    }];
    
}

/**
 *  高斯模糊（毛玻璃效果）
 *
 *  @param view 传入需要进行高斯模糊的视图
 *
 *  @return 返回经过处理后的视图
 */
- (UIView *)gaussView:(UIView *)view
{
    view.contentMode = UIViewContentModeScaleAspectFit;
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
    effectview.frame = view.bounds;
    [view addSubview:effectview];
    return view;
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    NSDictionary *userinfo = notification.userInfo;
    CGFloat keyboardAnimationDuration = [[userinfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationOptions keyboardAnimationCurve = [[userinfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    
    [UIView animateWithDuration:keyboardAnimationDuration delay:0.f options:keyboardAnimationCurve animations:^{
        self.top = self.effectView.height + kTopOffset;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)dismissTextEditing:(BOOL)done
{
    [self.textView resignFirstResponder];
    
    if (self.dissmissTextTool)
    {
        self.dissmissTextTool(self.textView.text, done);
    }
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (newSuperview)
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.textView becomeFirstResponder];
            [self.textView scrollRangeToVisible:NSMakeRange(self.textView.text.length-1, 0)];
        });
    }
}
// 自适应文字背景色
- (void)updateTextViewBagroundColor {
    self.colorPanel.isBagColorSelect = self.textTool.isChangeTexbagColor;
    
    [self buttonSelectColor];// 临时用这个方法解决记录上一次选择颜色问题

    //判断是否有背景色
    if (self.textTool.isChangeTexbagColor) {
        self.textView.backgroundColor = self.textTool.textColorPanel.currentColor;
        self.textView.textColor = [UIColor whiteColor];
                
        // 判断选中的颜色是否白色背景 白色背景文字设为黑色
        BOOL isColor = [self.textTool firstColor:self.textTool.bagroundColor secondColor:self.textTool.textColorPanel.whiteButton.color];//self.textTool.textColorPanel.orangeButton.color
        
        if (isColor) {
            self.textTool.textView.textView.textColor = [UIColor blackColor];
        }

    }else {
        self.textView.textColor = self.textTool.textColorPanel.currentColor;//self.colorPanel.currentColor;

    }
}
//临时记录颜色
- (void)buttonSelectColor {
    BOOL isColor = [self.textTool firstColor:self.textTool.textColorPanel.currentColor secondColor:self.textTool.textColorPanel.redButton.color];
    if (isColor == YES) {
        self.colorPanel.redButton.isUse = YES;
        
        self.colorPanel.greenButton.isUse = NO;
        self.colorPanel.whiteButton.isUse = NO;
        self.colorPanel.yellowButton.isUse = NO;
        self.colorPanel.blackButton.isUse = NO;
        self.colorPanel.blueButton.isUse = NO;
        self.colorPanel.purpleButton.isUse = NO;
    }
    
    BOOL isColor1 = [self.textTool firstColor:self.textTool.textColorPanel.currentColor secondColor:self.textTool.textColorPanel.blackButton.color];
    if (isColor1 == YES) {
        self.colorPanel.blackButton.isUse = YES;
        
        self.colorPanel.redButton.isUse = NO;
        self.colorPanel.whiteButton.isUse = NO;
        self.colorPanel.yellowButton.isUse = NO;
        self.colorPanel.greenButton.isUse = NO;
        self.colorPanel.blueButton.isUse = NO;
        self.colorPanel.purpleButton.isUse = NO;
        
    }

    BOOL isColor2 = [self.textTool firstColor:self.textTool.textColorPanel.currentColor secondColor:self.textTool.textColorPanel.yellowButton.color];
    if (isColor2 == YES) {
        self.colorPanel.yellowButton.isUse = YES;
        
        self.colorPanel.redButton.isUse = NO;
        self.colorPanel.whiteButton.isUse = NO;
        self.colorPanel.greenButton.isUse = NO;
        self.colorPanel.blackButton.isUse = NO;
        self.colorPanel.blueButton.isUse = NO;
        self.colorPanel.purpleButton.isUse = NO;
        
    }

    BOOL isColor3 = [self.textTool firstColor:self.textTool.textColorPanel.currentColor secondColor:self.textTool.textColorPanel.greenButton.color];
    if (isColor3 == YES) {
        self.colorPanel.greenButton.isUse = YES;
        
        self.colorPanel.redButton.isUse = NO;
        self.colorPanel.whiteButton.isUse = NO;
        self.colorPanel.yellowButton.isUse = NO;
        self.colorPanel.blackButton.isUse = NO;
        self.colorPanel.blueButton.isUse = NO;
        self.colorPanel.purpleButton.isUse = NO;
        
    }

    BOOL isColor4 = [self.textTool firstColor:self.textTool.textColorPanel.currentColor secondColor:self.textTool.textColorPanel.blueButton.color];
    if (isColor4 == YES) {
        self.colorPanel.blueButton.isUse = YES;
        
        self.colorPanel.redButton.isUse = NO;
        self.colorPanel.whiteButton.isUse = NO;
        self.colorPanel.yellowButton.isUse = NO;
        self.colorPanel.blackButton.isUse = NO;
        self.colorPanel.greenButton.isUse = NO;
        self.colorPanel.purpleButton.isUse = NO;
        
    }

    BOOL isColor5 = [self.textTool firstColor:self.textTool.textColorPanel.currentColor secondColor:self.textTool.textColorPanel.purpleButton.color];
    if (isColor5 == YES) {
        self.colorPanel.purpleButton.isUse = YES;
        
        self.colorPanel.redButton.isUse = NO;
        self.colorPanel.whiteButton.isUse = NO;
        self.colorPanel.yellowButton.isUse = NO;
        self.colorPanel.blackButton.isUse = NO;
        self.colorPanel.blueButton.isUse = NO;
        self.colorPanel.greenButton.isUse = NO;
        
    }
}

// 更新textViewFrame
- (void)updateTextViewFrame {
    self.textView.frame = CGRectMake(20, kTextTopOffset + 10, WIDTH_SCREEN - 20 * 2, 40);
    
    //如果文字不为空
    if (self.textView.text.length > 0) {
        // 动态获取文字的高度
        NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
            style.lineBreakMode = NSLineBreakByWordWrapping;
        NSAttributedString *string = [[NSAttributedString alloc]initWithString:self.textView.text attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:24], NSParagraphStyleAttributeName:style}];

        CGSize size =  [string boundingRectWithSize:CGSizeMake(WIDTH_SCREEN - 16 * 2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
        
        CGSize size_news = [self.textView sizeThatFits:size];

        
        float  height = size_news.height;
        if (height < 40) {
            height = 40;
        }
        //重设输入框高度
        self.textView.frame = CGRectMake(16, kTextTopOffset+10, WIDTH_SCREEN - 16 * 2, height+5);
        
        //激活完成按钮
        self.navigationBarView.doneButton.enabled = YES;
    }
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView
{
    // 选中范围的标记
    UITextRange *textSelectedRange = [textView markedTextRange];
    // 获取高亮部分
    UITextPosition *textPosition = [textView positionFromPosition:textSelectedRange.start offset:0];
    // 如果在变化中是高亮部分在变, 就不要计算字符了
    if (textSelectedRange && textPosition)
    {
        return;
    }
    
    self.navigationBarView.doneButton.enabled = YES;

    // 文本内容
    NSString *textContentStr = textView.text;
    
    //如果文字为0 完成按钮不可用
    if (textContentStr.length == 0) {
        self.navigationBarView.doneButton.enabled = YES;
    }
    // 判断文字最大值不超过30
    if (textContentStr.length > kTextMaxLimitNumber)
    {
        // 截取到最大位置的字符(由于超出截取部分在should时被处理了,所以在这里为了提高效率不在判断)
        NSString *str = [textContentStr substringToIndex:kTextMaxLimitNumber];
        [textView setText:str];
    }
    
    static CGFloat maxHeight =60.0f;

    CGRect frame = textView.frame;

    CGSize constraintSize = CGSizeMake(frame.size.width, MAXFLOAT);

    CGSize size = [textView sizeThatFits:constraintSize];

    if (size.height <= frame.size.height) {
        
//        size.height = frame.size.height;
        
    }else{
        
        if (size.height >= maxHeight)
            
        {
            
//            size.height = maxHeight;
            
           // textView.scrollEnabled = YES;  // 允许滚动
            
        }
        
        else
            
        {
            
            textView.scrollEnabled = NO;    // 不允许滚动
            
        }
        
    }
    
    textView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, size.height);


    
    
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [self dismissTextEditing:YES];
        return NO;
    }
    
    NSString *newText = [self.textView.text stringByReplacingCharactersInRange:range withString:text];
    NSInteger newTextLength = [self countString:newText];
    
    if (text.length > kTextMaxLimitNumber)
    {
        
        __block NSInteger idx = 0;
        __block NSMutableString *trimString = [NSMutableString string]; // 截取出的字串
        
        [newText
         enumerateSubstringsInRange:NSMakeRange(0, [newText length])
         options:NSStringEnumerationByComposedCharacterSequences
         usingBlock: ^(NSString* substring, NSRange substringRange, NSRange enclosingRange, BOOL* stop)
         {
             NSInteger steplen = substring.length;
             if ([substring canBeConvertedToEncoding:NSASCIIStringEncoding])
             {
                 steplen = 1;
             }
             else
             {
                 steplen = steplen * 2;
             }
             
             idx = idx + steplen;
             
             if (idx > kTextMaxLimitNumber)
             {
                 *stop = YES; // 取出所需要就break，提高效率
             }
             else
             {
                 [trimString appendString:substring];
             }
         }];
        
        self.textView.text = trimString;
        
        return NO;
    }
    else
    {
        return YES;
    }
}
// 字符串长度判断
- (int)convertToInt:(NSString*)strtemp
{
    int strlength = 0;
    char* p = (char*)[strtemp cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
        
    }
    return strlength;
    
}

- (NSInteger)countString:(NSString *)string
{
    __block NSInteger length = 0;
    
    [string
     enumerateSubstringsInRange:NSMakeRange(0, [string length])
     options:NSStringEnumerationByComposedCharacterSequences
     usingBlock:^(NSString* substring, NSRange substringRange, NSRange enclosingRange, BOOL* stop)
    {
        NSInteger steplen = substring.length;
        
        if ([substring canBeConvertedToEncoding:NSASCIIStringEncoding])
        {
            length += 1;
        }
        else
        {
            length += steplen * 2;
        }
    }];
    
    return length;
}
@end

