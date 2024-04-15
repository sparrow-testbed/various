//
/**
* 所属系统: YMMAD
* 所属模块: 
* 功能描述: 
* 创建时间: 2021/3/12
* 维护人:  朱俊标
* 
*┌─────────────────────────────────────────────────────┐
*│ 此技术信息为本公司机密信息，未经本公司书面同意禁止向第三方披露．│
*│ 版权所有：杰人软件(深圳)有限公司                          │
*└─────────────────────────────────────────────────────┘
*/

#import "JRPhotoImageEditorViewController.h"
#import "JRDrawTool.h"
#import "JRTextTool.h"
#import "JRUIKit.h"
#import "JRMosicaTool.h"
#import "JRMoreKeyboard.h"
#import "JRPerspectiveTool.h"
#import "TOCropViewController.h"
#import "JRTextToolView.h"
#import "FrameAccessor.h"
#import "JRAdjustTool.h"
#import "UIImage+CropRotate.h"
#import "JRImageToolBase.h"
#import "JRPhotoImageEditorViewController+CropView.h"
#import "JRPhotoImageEditorViewController+CorrectView.h"

@interface JRPhotoImageEditorViewController ()<UIScrollViewDelegate,JRKeyboardDelegate,JRMoreKeyBoardDelegate,TOCropViewDelegate,JRHitTestDelegate,UIGestureRecognizerDelegate,TOCropViewControllerDelegate>

//@property (weak, nonatomic) UIView *containerView;
//@property (weak, nonatomic) UIImageView *imageView;
@property (nonatomic, assign) CGSize originSize;
@property (nonatomic, assign) CGSize originCorrectSize;
@property (nonatomic, strong) JRImageToolBase *currentTool;
@property (nonatomic, strong) JRDrawTool *drawTool;
@property (nonatomic, strong) JRTextTool *textTool;
@property (nonatomic, strong) JRMosicaTool *mosicaTool;
@property (nonatomic, strong) JRAdjustTool *adjustTool;
@property (nonatomic, strong) JRPerspectiveTool *perSpectiveTool;
@property (nonatomic, strong) JRMoreKeyboard *keyboard;
@property (nonatomic, assign) CGFloat clipInitScale;



@end

@implementation JRPhotoImageEditorViewController
//  初始化视图第三种方式
- (id)initWithImage:(UIImage *)image
           delegate:(id<JRImageEditorDelegate>)delegate
{
    self = [super init];
    if (self)
    {
        _originImage = image;
        self.delegate = delegate;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化面板view
    [self initViews];
    //设置imageview的frame
    [self setupImageViewFrame];
    [self resetZoomScaleWithAnimated:NO];
    //初始化尺寸
    self.imageView.frame = self.containerView.bounds;
    self.drawingView.frame = self.imageView.frame;
    self.drawingView.originSize = self.originSize;
    self.mosicaView.frame = self.imageView.frame;
}

- (void)initViews
{
    self.scrollView = [[TOCropScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.delegate = self;
    self.scrollView.hitTestDelegate = self;
    self.scrollView.clipsToBounds = NO;
    self.scrollView.backgroundColor = [UIColor blackColor];
    self.scrollView.contentInset = UIEdgeInsetsZero;
    self.scrollView.contentOffset = CGPointZero;
    if (@available(iOS 11.0, *)) {
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [self.view addSubview:self.scrollView];
    
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.scrollView addSubview:containerView];
    self.containerView = containerView;
    self.containerView.clipsToBounds = YES;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    imageView.image = self.originImage;
    [self.containerView addSubview:imageView];
    //更新当前的iamgeView
    self.imageView = imageView;
     
    // 创建图片编辑面板
    WS(weakSelf)
    _mainToolBarView = [[JRMainToolBarView alloc]init];
    [_mainToolBarView.confirmButton setTitle:self.confirmTitle forState:UIControlStateNormal];
    _mainToolBarView.editType = self.editType;
    [_mainToolBarView buildLayout];
    _mainToolBarView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    [self.view addSubview:_mainToolBarView];
    //点击编辑工具栏按钮
    _mainToolBarView.selectItemClick = ^(NSUInteger index) {
        [weakSelf selectItemEvent:index];
    };

    [_mainToolBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom);
        make.left.mas_equalTo(self.view.mas_left);
        make.width.mas_equalTo(self.view.mas_width);
        make.height.equalTo(@102);
    }];
    //点击完成按钮
    _mainToolBarView.selectDoneClick = ^{
      
        [self buildClipImageWithBorder:NO complete:^(UIImage *clipedImage)
        {
            UIImage *newImage = [clipedImage croppedImageWithFrame:self.lastCropRect angle:self.lastAngle circularClip:NO];
            
            if ([self.delegate respondsToSelector:@selector(imageEditor:didFinishEdittingWithImage:)])
            {
                [self.delegate imageEditor:self didFinishEdittingWithImage:newImage];
            }
        }];
        
    };
    
    //创建取消按钮
    [self.view addSubview:self.cancelButton];
    //创建mosicaView
    self.mosicaView = [[JRScratchView alloc] initWithFrame:CGRectZero];
    self.mosicaView.surfaceImage = self.originImage;
    self.mosicaView.backgroundColor = [UIColor clearColor];
    [self.containerView addSubview:self.mosicaView];
    if (self.editType == kImageEditNormal) { // 非矫正模式下 添加绘画view
        //创建绘画视图
        self.drawingView = [[JRDrawView alloc] initWithFrame:CGRectZero];
        self.drawingView.clipsToBounds = YES;
        [self.containerView addSubview:self.drawingView];
        self.drawingView.userInteractionEnabled = YES;
    }
    // 原始尺寸
    CGSize imageSize = self.imageView.image.size;
    CGSize scrollViewSize = self.scrollView.frame.size;
    CGSize originSize = CGSizeMake(scrollViewSize.width, imageSize.height*scrollViewSize.width/imageSize.width);
    self.originSize = originSize;
    self.originCorrectSize = originSize;
    self.lastCropRect = CGRectMake(0, 0, self.originSize.width, self.originSize.height);

}


- (void)setupImageViewFrame
{
    CGSize size = (_imageView.image) ? _imageView.image.size : _imageView.frame.size;
    if(size.width > 0 && size.height > 0 )
    {
        CGSize imageSize = self.imageView.image.size;
        CGSize scrollViewSize = self.scrollView.frame.size;
        
        self.containerView.frame = CGRectMake(0, 0, scrollViewSize.width, imageSize.height*scrollViewSize.width/imageSize.width);
        
        // 设置scrollView的缩小比例;
        CGSize newImageSize = self.containerView.frame.size;
        CGFloat widthRatio = 1.0f; // 宽已经缩放了
        CGFloat heightRatio = scrollViewSize.height/newImageSize.height;
        if (heightRatio >= 1.0f) heightRatio = 3.0f;
        
        self.scrollView.minimumZoomScale = MIN(widthRatio, heightRatio);
        self.scrollView.maximumZoomScale = MAX(widthRatio, heightRatio);
        self.scrollView.zoomScale = widthRatio;
    }
}

- (void)refreshImageView {
    if (self.imageView.image == nil) {
        self.imageView.image = self.originImage;
    }
//    self.mosicaView.alpha = 0;
    [self resetImageViewFrame];
    [self resetZoomScaleWithAnimated:NO];
    [self viewDidLayoutSubviews];
}

- (void)resetImageViewFrame {
    CGSize size = (_imageView.image) ? _imageView.image.size : _imageView.frame.size;
    if(size.width > 0 && size.height > 0 ) {
        CGFloat ratio = MIN(_scrollView.frame.size.width / size.width, _scrollView.frame.size.height / size.height);
        CGFloat W = ratio * size.width * _scrollView.zoomScale;
        CGFloat H = ratio * size.height * _scrollView.zoomScale;
        
        _imageView.frame = CGRectMake(MAX(0, (_scrollView.width-W)/2), MAX(0, (_scrollView.height-H)/2), W, H);
    }
}

#pragma mark - 图片编辑方法
- (void)selectItemEvent:(NSUInteger)index {
    switch (index) {
        case 990:
            [self panAction];
            break;
        case 991:
            [self clipAction];
            break;
        case 992:
            [self brightnessAdjust];
            break;
        case 993:
            [self textAction];
            break;
        case 994:
            [self paperAction];
            break;
        case 995:
            [self persPetiveCorrection];//透视矫正
            break;
        default:
            break;
    }
}

#pragma mark - Actions
- (void)setDisSelect
{
    UIButton *panleButton = [self.mainToolBarView.scrollView viewWithTag:990];
    UIButton *cropButton = [self.mainToolBarView.scrollView viewWithTag:991];
    UIButton *adjustButton = [self.mainToolBarView.scrollView viewWithTag:992];
    UIButton *textutton = [self.mainToolBarView.scrollView viewWithTag:993];
    UIButton *masicoButton = [self.mainToolBarView.scrollView viewWithTag:994];
    UIButton *perspectiveButton = [self.mainToolBarView.scrollView viewWithTag:995];


    panleButton.selected = NO;
    cropButton.selected = NO;
    adjustButton.selected = NO;
    textutton.selected = NO;
    masicoButton.selected = NO;
    perspectiveButton.selected = NO;
//    [self.textTool hideTextBorder];
    
}
// 涂鸦
- (void)panAction {
    
    self.isTextTool = NO;

    [self setDisSelect];
    UIButton *panleButton = [self.mainToolBarView.scrollView viewWithTag:990];
    panleButton.selected = YES;
    if (_currentMode == JREditorModeDraw)
    {
        [self resetCurrentTool];
    }
    else
    {
        //先设置状态，然后在干别的
        self.currentMode = JREditorModeDraw;
        self.currentTool = self.drawTool;
    }
}

///裁剪模式
- (void)clipAction
{
    [self setDisSelect];
    [self resetCurrentTool];
    //开始裁剪
    [self beginCropView];
        
}
//亮度调节
- (void)brightnessAdjust {
    [self setDisSelect];
    
    UIButton *panleButton = [self.mainToolBarView.scrollView viewWithTag:992];
    panleButton.selected = YES;
    if (_currentMode == JREditorModeAdjust)
    {
        [self resetCurrentTool];
    }
    else
    {
        //先设置状态，然后在干别的
        self.currentMode = JREditorModeAdjust;
        self.currentTool = self.adjustTool;
//        [self.adjustTool adjustBrightNessView:self];
    }

}
//文字模式
- (void)textAction
{
    self.isTextTool = YES;
    [self setDisSelect];
    
    //先设置状态，然后在干别的
    self.currentMode = JREditorModeText;
    
    self.currentTool = self.textTool;
}
// 文字再次编辑
- (void)editTextAgain
{
    //再次文字编辑的时候 先不改变model
//    self.currentMode = JREditorModeText;
    [_currentTool cleanup];
    _currentTool = self.textTool;
    [_currentTool setup];
}
//马赛克模式
- (void)paperAction
{
    self.isTextTool = NO;
    [self setDisSelect];
    UIButton *paperButton = [self.mainToolBarView.scrollView viewWithTag:994];
    paperButton.selected = YES;
    
    if (_currentMode == JREditorModeMosica)
    {
        [self resetCurrentTool];
    }else {
        self.currentMode = JREditorModeMosica;
        self.currentTool = self.mosicaTool;
    }
  
}

//图片透视矫正
- (void)persPetiveCorrection
{
    [self setDisSelect];
//    UIButton *paperButton = [self.mainToolBarView.scrollView viewWithTag:995];
//    paperButton.selected = YES;
    if (_currentMode == JREditorModePerspective)
    {
        [self resetCurrentTool];
        return;
    }
    
    [self beginCorrectView];
    
    self.currentMode = JREditorModePerspective;
}



#pragma mark -  重拍 method event
- (void)clickCancel:(UIButton *)sender {
    //创建动画
    CATransition *animation = [CATransition animation];
    //设置运动轨迹的速度
//    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    //设置动画类型为立方体动画
    animation.type = @"Fade";
    //设置动画时长
    animation.duration =0.5f;
    //设置运动的方向
    animation.subtype =kCATransitionFromRight;
    //控制器间跳转动画
    [super.view.layer addAnimation:animation forKey:nil];
    
    [super dismissViewControllerAnimated:NO completion:nil];
        
    if (self.delegate != nil  && [self.delegate respondsToSelector:@selector(imageEditorDidCancel:)]) {
        [self.delegate imageEditorDidCancel:nil];
    }
    
}

#pragma mark -

- (void)swapToolBarWithEditting
{
    switch (_currentMode)
    {
        case JREditorModeDraw:
        {
        
            UIButton *panleButton = [self.mainToolBarView.scrollView viewWithTag:990];
            panleButton.selected = YES;
            break;

        }
        case JREditorModeAdjust:
        {
            UIButton *panleButton2 = [self.mainToolBarView.scrollView viewWithTag:992];
            panleButton2.selected = YES;
            break;
        }
        case JREditorModeClip:
        case JREditorModeText:
        case JREditorModePerspective:
        {
            break;
        }
        case JREditorModeNone:
        {
            UIButton *panleButton = [self.mainToolBarView.scrollView viewWithTag:990];
            panleButton.selected = NO;
            UIButton *panleButton2 = [self.mainToolBarView.scrollView viewWithTag:992];
            panleButton2.selected = NO;
            UIButton *panleButton3 = [self.mainToolBarView.scrollView viewWithTag:994];
            panleButton3.selected = NO;
            break;
        }
        default:
            break;
    }
}

- (void)hiddenTopAndBottomBar:(BOOL)isHide
                    animation:(BOOL)animation
{
    if (self.keyboard.isShow)
    {
        [self.keyboard dismissWithAnimation:YES];
        return;
    }
    
    CGFloat time = animation ? .4f : 0.f;
    [UIView animateWithDuration:time animations:^{
        [self.currentTool hideTools:isHide];
        self.cancelButton.alpha = (isHide ? 0 : 1);
        self.mainToolBarView.alpha = (isHide ? 0 : 1);
//        self.barsHiddenStatus = isHide;
//        self.topBar.alpha = (isHide ? 0 : 1);
    }];
}

#pragma mark - ScrollView delegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.containerView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGSize size = scrollView.bounds.size;
    CGSize contentSize = scrollView.contentSize;
    
    CGFloat offsetX = (size.width > contentSize.width) ?
    (size.width - contentSize.width) * 0.5 : 0.0;
    
    CGFloat offsetY = (size.height > contentSize.height) ?
    (size.height - contentSize.height) * 0.5 : 0.0;
    
    self.containerView.center = CGPointMake(contentSize.width * 0.5 + offsetX, contentSize.height * 0.5 + offsetY);
}

#pragma mark - JRHitTestDelegate
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
//    UIView *view = [self.currentTool drawView];
//    if (view)
//    {
//        return view;
//    }
//    else
//    {
//         return nil;
//    }
    return nil; //不要向上传递响应链
}

#pragma mark - JRMoreKeyboardDelegate
- (void)moreKeyboard:(id)keyboard didSelectedFunctionItem:(JRMoreKeyboardItem *)funcItem
{
    JRMoreKeyboard *kb = (JRMoreKeyboard *)keyboard;
    [kb dismissWithAnimation:YES];
    
    JRTextToolView *view = [[JRTextToolView alloc] initWithTool:self.textTool text:@"" font:nil orImage:funcItem.image];
    view.borderColor = [UIColor whiteColor];
    view.image = funcItem.image;
    view.center = [self.imageView.superview convertPoint:self.imageView.center toView:self.drawingView];
    view.userInteractionEnabled = YES;
    [self.drawingView addSubview:view];
    [JRTextToolView setActiveTextView:view];
    
}


#pragma mark - 裁剪取消取消代理
- (void)cropViewController:(TOCropViewController *)cropViewController didFinishCancelled:(BOOL)cancelled
{
    __weak JRPhotoImageEditorViewController *weakSelf = self;
    
    [cropViewController
     dismissAnimatedFromParentViewController:self
     withCroppedImage:[self buildTransitionImage]
     toView:self.containerView
     toFrame:self.containerView.frame
     setup:^{
         __weak JRPhotoImageEditorViewController *strongSelf = weakSelf;
         strongSelf.imageView.hidden = YES;
     } completion:^{
         __weak JRPhotoImageEditorViewController *strongSelf = weakSelf;
         strongSelf.imageView.hidden = NO;
     }];
}

#pragma mark - Clipe
- (void)buildClipImageWithBorder:(BOOL)border
                        complete:(void(^)(UIImage *clipedImage))complete
{
    if (!border)
    {
        [self.textTool hideTextBorder];
    }
    
    [self buildCategoryClipImageWithBorder:border complete:complete];
    
}

- (void)buildCorrectImageWithBorder:(BOOL)border complete:(void(^)(UIImage *correctImage))complete
{
    if (!border)
    {
        [self.textTool hideTextBorder];
    }
    
    [self buildCorrectCategoryImageWithBorder:border complete:complete];
    
}



- (void)resetCurrentTool
{
    self.currentMode = JREditorModeNone;
    self.currentTool = nil;
}


#pragma  mark - lazy method

- (JRMoreKeyboard *)keyboard
{
    if (!_keyboard)
    {
        JRMoreKeyboard *keyboard = [JRMoreKeyboard keyboard];
        [keyboard setKeyboardDelegate:self];
        [keyboard setDelegate:self];
        _keyboard = keyboard;
    }
    
    return _keyboard;
}

- (UIButton *)cancelButton {
    if (_cancelButton == nil) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setImage:[JRUIHelper imageNamed:@"i_back_camera"] forState:UIControlStateNormal];
        _cancelButton.frame = CGRectMake(16, StateHeight+10, 40, 40);
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:18];
        _cancelButton.titleLabel.textColor = [UIColor jk_colorWithHexString:@"#FFFFFF"];
        [_cancelButton addTarget:self action:@selector(clickCancel:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (JRDrawTool *)drawTool
{
    if (_drawTool == nil)
    {
        _drawTool = [[JRDrawTool alloc] initWithImageEditor:self];
        _drawTool.pathWidth = 5.0f;//[self.dataSource respondsToSelector:@selector(imageEditorDrawPathWidth)] ? [self.dataSource imageEditorDrawPathWidth].floatValue : 5.0f;
    }

    return _drawTool;
}

- (JRTextTool *)textTool
{
    if (_textTool == nil)
    {
        _textTool = [[JRTextTool alloc] initWithImageEditor:self];
    }
    
    return _textTool;
}

- (JRMosicaTool *)mosicaTool
{
    if (_mosicaTool == nil)
    {
        _mosicaTool = [[JRMosicaTool alloc] initWithImageEditor:self];
    }
    
    return _mosicaTool;
}

- (JRAdjustTool *)adjustTool {
    if (_adjustTool == nil) {
        _adjustTool = [[JRAdjustTool alloc]initWithImageEditor:self];
    }
    return _adjustTool;
}

- (JRPerspectiveTool *)perSpectiveTool {
    if (_perSpectiveTool == nil) {
        _perSpectiveTool = [[JRPerspectiveTool alloc]initWithImageEditor:self];
    }
    return _perSpectiveTool;
}

- (void)setCurrentTool:(JRImageToolBase *)currentTool
{
    [_currentTool cleanup];
    _currentTool = currentTool;
    [_currentTool setup];
    
    [self swapToolBarWithEditting];
}


@end
