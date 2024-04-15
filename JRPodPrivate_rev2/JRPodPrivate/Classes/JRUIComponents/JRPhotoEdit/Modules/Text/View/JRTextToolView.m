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

#import "JRTextToolView.h"
#import "JRTextTool.h"
#import "JRImageEditorGestureManager.h"
#import "FrameAccessor.h"
#import "JRUIKit.h"

#define IMAGE_MAXSIZE 200

static const CGFloat MAX_FONT_SIZE = 50.0f;
static const CGFloat MIN_TEXT_SCAL = 0.01f;
static const CGFloat MAX_TEXT_SCAL = 4.0f;
static const CGFloat LABEL_OFFSET  = 13.f;
static const CGFloat DELETEBUTTON_BOUNDS = 36.f;

@interface JRTextToolView ()<UIGestureRecognizerDelegate>
@property (nonatomic, weak) JRTextTool *textTool;
@property (nonatomic, strong)JRTextLabel  *label;

@end

@implementation JRTextToolView
{
//    JRTextLabel  *_label;
    UIButton *_deleteButton;
    
    CGFloat _scale;
    CGFloat _angle;
    
    CGPoint _initialPoint;
    CGFloat _initialArg;
    CGFloat _initialScale;
    
    CALayer *rectLayer1;
    CALayer *rectLayer2;
    CALayer *rectLayer3;
    
    CGFloat _rotation;
    
    BOOL _isAvtive;
}
static JRTextToolView *activeView = nil;
+ (void)setActiveTextView:(JRTextToolView *)view
{
    if(view != activeView || (view == activeView && !activeView->_isAvtive))
    {
        [activeView setAvtive:NO];
        activeView = view;
        [activeView setAvtive:YES];
        
        [activeView.archerBGView.superview bringSubviewToFront:activeView.archerBGView];
        [activeView.superview bringSubviewToFront:activeView];
        
    }
}

+ (void)hideTextBorder
{
    [activeView setAvtive:NO];
}

+ (void)setInactiveTextView:(JRTextToolView *)view
{
    if (activeView)
    {
        activeView = nil;
    }
    
    [view setAvtive:NO];
}

+ (void)setNewActiveTextView:(JRTextToolView *)view withGesture:(UITapGestureRecognizer *)sender
{
    [activeView setAvtive:NO];
    activeView = view;
    [activeView setAvtive:YES];
    
    [activeView.archerBGView.superview bringSubviewToFront:activeView.archerBGView];
    [activeView.superview bringSubviewToFront:activeView];
    
    [activeView editTextAgain:sender];

    
}

- (instancetype)initWithTool:(JRTextTool *)tool
                        text:(NSString *)text
                        font:(UIFont *)font
                     orImage:(UIImage *)image
{
    self = [super initWithFrame:CGRectMake(0, 0, 132, 132)];
    if (self)
    {
        _archerBGView = [[JRTextToolOverlapView alloc] initWithFrame:CGRectMake(0, 0, 132, 132)];
        _archerBGView.backgroundColor = [UIColor clearColor];
        _archerBGView.layer.borderColor = [UIColor whiteColor].CGColor;;
        _archerBGView.layer.borderWidth = 1.0f;
        

        _label = [[JRTextLabel alloc] init];
        _label.numberOfLines = 0;
        _label.backgroundColor = [UIColor clearColor];
        _label.font = font;
        _label.minimumScaleFactor = font.pointSize * 0.8f;
        _label.adjustsFontSizeToFitWidth = YES;
        _label.textAlignment = NSTextAlignmentLeft;
        _label.text = text;
        _label.textColor = [UIColor blackColor];
        _label.layer.allowsEdgeAntialiasing = true;
        self.text = text;
        self.label.contentInset = UIEdgeInsetsMake(0, 10, 0, 10);
        NSMutableParagraphStyle  *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        // 行间距设置为30
        [paragraphStyle  setLineSpacing:4];
        NSString  *testString = text;
        NSMutableAttributedString  *setString = [[NSMutableAttributedString alloc] initWithString:testString];
        [setString  addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [testString length])];

        // 设置Label要显示的text
        [_label  setAttributedText:setString];
        [self addSubview:_label];
        
        _textTool = tool;
        //旧的计算宽度逻辑
//        CGSize size = [_label sizeThatFits:CGSizeMake(tool.editor.drawingView.width - 2*LABEL_OFFSET, FLT_MAX)];
        //新的宽度计算逻辑
        CGSize size = [_label sizeThatFits:CGSizeMake(tool.editor.drawingView.width - 2*30, FLT_MAX)];

        _label.frame = CGRectMake(LABEL_OFFSET, LABEL_OFFSET, size.width + 2*30, size.height + _label.font.pointSize);
//        _label.frame = CGRectMake(LABEL_OFFSET, LABEL_OFFSET, size.width, size.height + _label.font.pointSize);

        if (image)
        {
            CGSize imageSize = image.size;
            CGFloat DI = imageSize.width / imageSize.height; //宽高比例
            CGFloat maxLength = MAX(imageSize.width, imageSize.height);
            
            if (maxLength > IMAGE_MAXSIZE) {
                maxLength = IMAGE_MAXSIZE;
                if (maxLength == imageSize.height) {
                    imageSize.height = maxLength;
                    imageSize.width = maxLength * DI;
                } else if (maxLength == imageSize.width) {
                    imageSize.width = maxLength;
                    imageSize.height = maxLength / DI;
                }
            }

            
            _label.frame = CGRectMake(LABEL_OFFSET, LABEL_OFFSET, imageSize.width, imageSize.height);
        }
//        2*LABEL_OFFSET
        self.frame = CGRectMake(0, SCREEN_HEIGHT/2, _label.width + 2*30, _label.height + 2*LABEL_OFFSET);
        
        
        self.center = self.textTool.editor.view.center;
        
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteButton setImage:[JRUIHelper imageNamed:@"i_delete_pic"] forState:UIControlStateNormal];
        _deleteButton.frame = CGRectMake(size.width + 20, 0, DELETEBUTTON_BOUNDS, DELETEBUTTON_BOUNDS);
        [_deleteButton addTarget:self action:@selector(pushedDeleteBtn:) forControlEvents:UIControlEventTouchUpInside];
        _archerBGView.userInteractionEnabled = YES;
        [self addSubview:_deleteButton];

        [_deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_right).offset(-23);
            make.top.mas_equalTo(self.mas_top).offset(-12);
            make.width.height.equalTo(@(DELETEBUTTON_BOUNDS));
        }];
        
        _angle = 0;
        [self setScale:1];
        //初始化手势
        [self initGestures];
        //延迟消失文字显示
        [self visableAndHideBordLine];
        
    }
    
    return self;
}

- (UIView *)clickTest:(CGPoint)point withEvent:(UIEvent *)event {

    UIView *result = [super hitTest:point withEvent:event];
    CGPoint butttonClickPoint = [_deleteButton convertPoint:point fromView:self];
//    if ([_deleteButton pointInside:buttonPoint withEvent:event]) {
//        return _deleteButton;
//    }
    return result;
}

- (void)initGestures
{
    _label.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewDidTap:)];

    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(drawingViewDidDoubleTap:)];
    doubleTap.numberOfTapsRequired = 2;
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(viewDidPan:)];
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(viewDidPinch:)];
    UIRotationGestureRecognizer *rotation = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(viewDidRotation:)];
    
    [pinch requireGestureRecognizerToFail:tap];
    [rotation requireGestureRecognizerToFail:tap];
    [pinch requireGestureRecognizerToFail:doubleTap];
    [rotation requireGestureRecognizerToFail:doubleTap];
    
    [self.textTool.editor.scrollView.panGestureRecognizer requireGestureRecognizerToFail:pan];

    doubleTap.delegate = [JRImageEditorGestureManager instance];
    tap.delegate = [JRImageEditorGestureManager instance];
    pan.delegate = [JRImageEditorGestureManager instance];
    pinch.delegate = [JRImageEditorGestureManager instance];
    rotation.delegate = [JRImageEditorGestureManager instance];
    
    [self addGestureRecognizer:tap];
    [self addGestureRecognizer:doubleTap];
    [self addGestureRecognizer:pan];
    [self addGestureRecognizer:pinch];
    [self addGestureRecognizer:rotation];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *view = [super hitTest:point withEvent:event];
    if(view == self) {
        return self;
    }
    return view;
}

- (void)rotate:(CGFloat)angle
{
    if (angle == 0)
    {
        return;
    }
    
    _archerBGView.transform = CGAffineTransformRotate(_archerBGView.transform, angle);
    _rotation = _rotation + angle;
    
    [self layoutSubviews];
}

#pragma mark- gesture events
- (void)pushedDeleteBtn:(id)sender
{
    JRTextToolView *nextTarget = nil;
    
    const NSInteger index = [self.superview.subviews indexOfObject:self];
    
    for(NSInteger i=index+1; i<self.superview.subviews.count; ++i){
        UIView *view = [self.superview.subviews objectAtIndex:i];
        if([view isKindOfClass:[JRTextToolView class]]){
            nextTarget = (JRTextToolView *)view;
            break;
        }
    }
    
    if(nextTarget==nil){
        for(NSInteger i=index-1; i>=0; --i){
            UIView *view = [self.superview.subviews objectAtIndex:i];
            if([view isKindOfClass:[JRTextToolView class]]){
                nextTarget = (JRTextToolView *)view;
                break;
            }
        }
    }
    
//    [[self class] setActiveTextView:nextTarget];// 删除的时候 自动选择下一个状态
    [self removeFromSuperview];
    [_archerBGView removeFromSuperview];
}
//延迟消失文字显示
- (void)visableAndHideBordLine {
    _archerBGView.layer.borderWidth = 1.0f;
    _deleteButton.alpha = 1.0f;
    // 第一个参数:延迟的时间
    // 可以通过改变队列来改变线程
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
       // 需要延迟执行的代码
        self->_archerBGView.layer.borderWidth = 0.0f;
        self->_deleteButton.alpha = 0;
    });

}



- (void)drawingViewDidDoubleTap:(UITapGestureRecognizer*)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        if(self.active){
            [self editTextAgain:sender];
        } else {
            //取消当前
            [self.textTool.editor resetCurrentTool];

        }
        [[self class] setActiveTextView:self];
        [self.textTool.editor hiddenTopAndBottomBar:NO animation:YES];
        
    }

}


- (void)viewDidTap:(UITapGestureRecognizer*)sender
{
    [self tapViewMethod:sender];
}

- (void)tapViewMethod:(UITapGestureRecognizer *)sender
{
    [[self class] setActiveTextView:self];
    
    if (sender.state == UIGestureRecognizerStateBegan ||
        sender.state == UIGestureRecognizerStateChanged)
    {
        //移动的时候 边框线上
        _archerBGView.layer.borderWidth = 1.0f;
        _deleteButton.alpha = 1.0f;
        
        [self.textTool.editor hiddenTopAndBottomBar:YES animation:YES];
    }else if (sender.state == UIGestureRecognizerStateEnded ||
              sender.state == UIGestureRecognizerStateFailed ||
              sender.state == UIGestureRecognizerStateCancelled)
    {
        [self visableAndHideBordLine];

    }
}

- (void)panViewMethod:(UIPanGestureRecognizer*)recognizer
{
    //平移
    [[self class] setActiveTextView:self];
    UIView *piece = _archerBGView;
    CGPoint translation = [recognizer translationInView:piece.superview];
    piece.center = CGPointMake(piece.center.x + translation.x, piece.center.y + translation.y);
    [recognizer setTranslation:CGPointZero inView:piece.superview];

    if (recognizer.state == UIGestureRecognizerStateBegan ||
        recognizer.state == UIGestureRecognizerStateChanged)
    {
        //移动的时候 边框线上
        _archerBGView.layer.borderWidth = 1.0f;
        _deleteButton.alpha = 1.0f;
        
        [self.textTool.editor hiddenTopAndBottomBar:YES animation:YES];
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded ||
               recognizer.state == UIGestureRecognizerStateFailed ||
               recognizer.state == UIGestureRecognizerStateCancelled)
    {
        [self visableAndHideBordLine];
        
        CGRect rectCoordinate = [piece.superview convertRect:piece.frame toView:self.textTool.editor.imageView.superview];
        if (!CGRectIntersectsRect(CGRectInset(self.textTool.editor.imageView.frame, 30, 30), rectCoordinate))
        {
            [UIView animateWithDuration:.2f animations:^{
                piece.center = piece.superview.center;
                self.center = piece.center;
                
            }];
        }
    
        [self.textTool.editor hiddenTopAndBottomBar:NO animation:YES];
    }
    [self layoutSubviews];
}

- (void)viewDidPan:(UIPanGestureRecognizer*)recognizer
{
    [self panViewMethod:recognizer];
}

- (void)viewDidPinch:(UIPinchGestureRecognizer *)recognizer
{
    //缩放
    [[self class] setActiveTextView:self];
    
    if (recognizer.state == UIGestureRecognizerStateBegan ||
        recognizer.state == UIGestureRecognizerStateChanged) {
        //坑点：recognizer.scale是相对原图片大小的scal
        
        CGFloat scale = [(NSNumber *)[_archerBGView valueForKeyPath:@"layer.transform.scale.x"] floatValue];
        NSLog(@"scale = %f", scale);
        
        //取消当前
        [self.textTool.editor resetCurrentTool];
        
        CGFloat currentScale = recognizer.scale;
        
        if (scale > MAX_TEXT_SCAL && currentScale > 1) {
            return;
        }
        
        if (scale < MIN_TEXT_SCAL && currentScale < 1) {
            return;
        }
        
        //调整label 字体大小
//        _label.font = [UIFont systemFontOfSize:scale*16];
        
        
        _archerBGView.transform = CGAffineTransformScale(_archerBGView.transform, currentScale, currentScale);
        _label.transform = CGAffineTransformScale(_label.transform, currentScale, currentScale);
        
        recognizer.scale = 1;
        [self layoutSubviews];
        
        [self.textTool.editor hiddenTopAndBottomBar:YES animation:YES];
    } else if (recognizer.state == UIGestureRecognizerStateEnded ||
               recognizer.state == UIGestureRecognizerStateFailed ||
               recognizer.state == UIGestureRecognizerStateCancelled) {
        [self.textTool.editor hiddenTopAndBottomBar:NO animation:YES];
    }
}

- (void)viewDidRotation:(UIRotationGestureRecognizer *)recognizer
{
    //旋转
    if (recognizer.state == UIGestureRecognizerStateBegan ||
        recognizer.state == UIGestureRecognizerStateChanged) {
        
        _archerBGView.transform = CGAffineTransformRotate(_archerBGView.transform, recognizer.rotation);
        _rotation = _rotation + recognizer.rotation;
        recognizer.rotation = 0;
        [self layoutSubviews];
        
        [self.textTool.editor hiddenTopAndBottomBar:YES animation:YES];
        //取消当前
        [self.textTool.editor resetCurrentTool];
    } else if (recognizer.state == UIGestureRecognizerStateEnded ||
               recognizer.state == UIGestureRecognizerStateFailed ||
               recognizer.state == UIGestureRecognizerStateCancelled) {
        [self.textTool.editor hiddenTopAndBottomBar:NO animation:YES];
    }
}

#pragma mark - Edit it again
- (void)editTextAgain:(UITapGestureRecognizer *)recognizer
{
   //1.再次编辑的时候 重置再次编辑状态
    self.textTool.isEditAgain = YES;

    //2.更新当前背景选中的状态
    BOOL isColorSelect = [self.textTool firstColor:_label.backgroundColor secondColor:[UIColor clearColor]];
    NSLog(@"当前背景色---%d",isColorSelect);
    if (isColorSelect) {
        self.textTool.textColorPanel.isBagColorSelect = NO;
        self.textTool.isChangeTexbagColor = NO;
    }else {
        self.textTool.textColorPanel.isBagColorSelect = YES;
        self.textTool.isChangeTexbagColor = YES;
    }

    //3.更新当前文字的颜色 文字颜色和文字内容进行回传
    if (self.textTool.isChangeTexbagColor) {
        self.textTool.textColorPanel.currentColor = _label.backgroundColor;
    }else {
        self.textTool.textColorPanel.currentColor = self.fillColor;
    }
    
    //事件源
    [self.textTool.editor editTextAgain];
    
    self.textTool.textView.textView.text = self.text;
    self.textTool.textView.textView.font = self.font;
    
    __weak JRTextToolView *weakSelf = self;
    self.textTool.editAgainCallback = ^(NSString *text,BOOL isChangeBagColor,UIColor *currentColor){
        //如果文字为空直接删除
        if (text == nil || text.length == 0) {
            [weakSelf pushedDeleteBtn:self->_deleteButton];
            return;
        }
        
        weakSelf.text = text;
        [weakSelf resizeSelf];
        weakSelf.font = weakSelf.textTool.textView.textView.font;
        //根据背景色标识来改变背景色
        [weakSelf changeBagroundColorWithLabel:isChangeBagColor];
    };
    
 
}

//根据是否包含背景色来进行更换
- (void)changeBagroundColorWithLabel:(BOOL)isChangeBagColor {
    if (isChangeBagColor) {
        self->_label.backgroundColor = self.textTool.textView.textView.backgroundColor;
        self->_label.textColor = [UIColor whiteColor];
        
        // 判断选中的颜色是否白色背景 白色背景文字设为黑色
        BOOL isColor = [self.textTool firstColor:self.textTool.textView.textView.backgroundColor secondColor:self.textTool.textColorPanel.whiteButton.color];
        
        if (isColor) {
            self->_label.textColor = [UIColor blackColor];
        }
        
    }else {
        self->_label.backgroundColor = [UIColor clearColor];
        self.fillColor = self.textTool.textView.textView.textColor;
    }
}

- (void)resizeSelf
{
//    CGSize size = [_label sizeThatFits:CGSizeMake(self.textTool.editor.drawingView.width - 2*LABEL_OFFSET, FLT_MAX)];
    CGSize size = [_label sizeThatFits:CGSizeMake(self.textTool.editor.drawingView.width - 2*30, FLT_MAX)];

    _label.frame = CGRectMake(LABEL_OFFSET, LABEL_OFFSET, size.width , size.height + _label.font.pointSize);

    self.bounds = CGRectMake(0, 0, _label.width + 2*30, _label.height + 2*LABEL_OFFSET);
    _archerBGView.bounds = self.bounds;
    
    rectLayer1.frame = CGRectMake(_label.width - 2 - _scale/2.f, - 2, 4, 4);
    rectLayer2.frame = CGRectMake(_scale/2.f - 2, _scale/2.f + _label.height - 2, 4, 4);
    rectLayer3.frame = CGRectMake(_label.width - 2 - _scale/2.f, _label.height - 2 - _scale/2.f, 4, 4);
    
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect boundss;
    if (!_archerBGView.superview)
    {
        [self.superview insertSubview:_archerBGView belowSubview:self];
        _archerBGView.bounds = CGRectMake(30, 0, _label.width, _label.height + 2*LABEL_OFFSET);//self.bounds;//self.bounds;
        _archerBGView.center = self.center;
    }
    
    boundss = _archerBGView.bounds;
    self.transform = CGAffineTransformMakeRotation(_rotation);
    
    CGFloat w = boundss.size.width;
    CGFloat h = boundss.size.height;
    CGFloat scale = [(NSNumber *)[_archerBGView valueForKeyPath:@"layer.transform.scale.x"] floatValue];

    self.bounds = CGRectMake(0, 0, w*scale, h*scale);
    self.center = _archerBGView.center;
//    2*LABEL_OFFSET
    _label.frame = CGRectMake(LABEL_OFFSET, LABEL_OFFSET, self.bounds.size.width - 2*LABEL_OFFSET, self.bounds.size.height - 2*LABEL_OFFSET);
    
//    [self setupBorders];
}

- (void)setupBorders
{
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    
    if (!rectLayer1)
    {
        rectLayer1 = [CALayer layer];
        rectLayer1.backgroundColor = [UIColor whiteColor].CGColor;
        [_label.layer addSublayer:rectLayer1];
    }
    
    rectLayer1.frame = CGRectMake(_label.width - 2 - _scale/2.f, - 2, 4, 4);
    
    
    if (!rectLayer2)
    {
        rectLayer2 = [CALayer layer];
        rectLayer2.backgroundColor = [UIColor whiteColor].CGColor;
        [_label.layer addSublayer:rectLayer2];
    }
    
    rectLayer2.frame = CGRectMake(_scale/2.f - 2, _label.height - 2 - _scale/2.f, 4, 4);
    
    
    if (!rectLayer3)
    {
        rectLayer3 = [CALayer layer];
        rectLayer3.backgroundColor = [UIColor whiteColor].CGColor;
        [_label.layer addSublayer:rectLayer3];
    }
    
    rectLayer3.frame = CGRectMake(_label.width - 2 - _scale/2.f, _label.height - 2 - _scale/2.f, 4, 4);
    
    [CATransaction commit];
}

#pragma mark- Properties

- (void)setAvtive:(BOOL)active
{
//    return;
    _isAvtive = active;
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    _deleteButton.hidden = !active;
    _archerBGView.layer.borderWidth = active;
//    _label.layer.borderWidth = (active) ? 1/_scale : 0;
//    _label.layer.shadowColor = [UIColor grayColor].CGColor;
//    _label.layer.shadowOffset= CGSizeMake(0, 0);
//    _label.layer.shadowOpacity = .6f;
//    _label.layer.shadowRadius = 2.f;
    
    _deleteButton.layer.shadowColor = [UIColor grayColor].CGColor;
    _deleteButton.layer.shadowOffset= CGSizeMake(0, 0);
    _deleteButton.layer.shadowOpacity = .6f;
    _deleteButton.layer.shadowRadius = 2.f;
    
    rectLayer1.hidden = rectLayer2.hidden = rectLayer3.hidden = !active;
    [CATransaction commit];
}

- (void)changeColor:(NSNotification *)notification {
    UIColor *currentColor = (UIColor *)notification.object;
    self.fillColor = currentColor;
}

- (BOOL)active
{
    return !_deleteButton.hidden;
}

- (void)sizeToFitWithMaxWidth:(CGFloat)width lineHeight:(CGFloat)lineHeight
{
    self.transform = CGAffineTransformIdentity;
    _label.transform = CGAffineTransformIdentity;
    
    CGSize size = [_label sizeThatFits:CGSizeMake(width / (20/MAX_FONT_SIZE), FLT_MAX)];
    _label.frame = CGRectMake(16, 16, size.width, size.height);
    
    CGFloat viewW = (_label.width + 32);
    CGFloat viewH = _label.font.lineHeight;
    
    CGFloat ratio = MIN(width / viewW, lineHeight / viewH);
    [self setScale:ratio];
}

- (void)setScale:(CGFloat)scale
{
    _scale = scale;
    
    self.transform = CGAffineTransformIdentity;
    
    _label.transform = CGAffineTransformMakeScale(_scale, _scale);
    
    CGRect rct = self.frame;
    rct.origin.x += (rct.size.width - (_label.width + 32)) / 2;
    rct.origin.y += (rct.size.height - (_label.height + 32)) / 2;
    rct.size.width  = _label.width + 32;
    rct.size.height = _label.height + 32;
    self.frame = rct;
    
    _label.center = CGPointMake(rct.size.width/2, rct.size.height/2);
    
    self.transform = CGAffineTransformMakeRotation(_angle);
    //屏蔽调label的边框
//    _label.layer.borderWidth = 1/_scale;
    
    _archerBGView.layer.borderWidth = 1/_scale;
    _archerBGView.layer.cornerRadius = 2.0f;
//    _label.layer.backgroundColor = [UIColor redColor].CGColor;
    _label.clipsToBounds = YES;
    _label.layer.cornerRadius = 5.0f;
}

- (void)setFillColor:(UIColor *)fillColor
{
    _label.textColor = fillColor;//[UIColor clearColor];
    _archerBGView.textColor = fillColor;
}

- (void)setIsBagColorSelect:(BOOL)isBagColorSelect {
    if (isBagColorSelect ) {
        _label.backgroundColor = self.textTool.bagroundColor;
        _label.textColor = [UIColor whiteColor];
        
        bool isColor =  [self.textTool firstColor:self.textTool.bagroundColor secondColor:self.textTool.textColorPanel.whiteButton.color];
        
        if (isColor) {
            _label.textColor = [UIColor blackColor];
        }
        
    }else {
        _label.backgroundColor = [UIColor clearColor];
        _label.textColor = self.fillColor;
    }
}

- (UIColor*)fillColor
{
//    return _label.textColor;
    return _archerBGView.textColor;
}

- (void)setBorderColor:(UIColor *)borderColor
{
    _label.layer.borderColor = borderColor.CGColor;
}

- (UIColor*)borderColor
{
    return [UIColor colorWithCGColor:_label.layer.borderColor];
}

- (void)setBorderWidth:(CGFloat)borderWidth
{
    _label.layer.borderWidth = borderWidth;
}

- (CGFloat)borderWidth
{
    return _label.layer.borderWidth;
}

- (void)setFont:(UIFont *)font
{
    _label.font = font;
    _archerBGView.textFont = font;
}

- (UIFont*)font
{
    return _label.font;
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment
{
    _label.textAlignment = textAlignment;
}

- (NSTextAlignment)textAlignment
{
    return _label.textAlignment;
}

- (void)setText:(NSString *)text
{
    if(![text isEqualToString:_text]){
        _text = text;
        _label.text = (_text.length>0) ? _text : @"";
        _archerBGView.text = _label.text;
    }
}

- (void)setImage:(UIImage *)image {
    if (_image != image) {
        _image = image;
        _archerBGView.image = image;
    }
}



@end

@implementation JRTextLabel
- (void)setContentInset:(UIEdgeInsets)contentInset {
    _contentInset = contentInset;
    NSString *tempString = self.text;
    self.text = @"";
    self.text = tempString;
}

-(void)drawTextInRect:(CGRect)rect {
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.contentInset)];
}
@end
