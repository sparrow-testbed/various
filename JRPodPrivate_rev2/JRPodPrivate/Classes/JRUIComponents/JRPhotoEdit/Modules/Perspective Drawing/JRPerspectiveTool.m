//
/**
* 所属系统: YMMAD
* 所属模块: 
* 功能描述: 
* 创建时间: 2021/3/25
* 维护人:  马克
* 
*┌─────────────────────────────────────────────────────┐
*│ 此技术信息为本公司机密信息，未经本公司书面同意禁止向第三方披露．│
*│ 版权所有：杰人软件(深圳)有限公司                          │
*└─────────────────────────────────────────────────────┘
*/

#import "JRPerspectiveTool.h"
#import "JRUIKit.h"
#import <AGGeometryKit/AGGeometryKit.h>
#import <CoreImage/CoreImage.h>
#import <ImageIO/ImageIO.h>
#import <GLKit/GLKit.h>
#import "MADCGTransfromHelper.h"
#import "TOCropOverlayView.h"
#import "JRPerspectiveToolBar.h"

#define kButtonWidth 150
#define kCenterOffset 0
#define kScaleW 0.8
#define kScaleH 0.6
#define kButtonAlpha 0.05

@interface JRPerspectiveTool ()

@property (nonatomic, strong)UIImageView *sourceImage;
@property (nonatomic, strong)TOCropOverlayView *gridOverlayView;
@property (nonatomic, strong)JRPerspectiveToolBar *perspectiveToolBar;
@property (nonatomic, strong) NSUndoManager *undoManager;


@property (nonatomic, strong)NSMutableArray *topLTXArray;
@property (nonatomic, strong)NSMutableArray *topLTYArray;

@property (nonatomic, strong)NSMutableArray *topRTXArray;
@property (nonatomic, strong)NSMutableArray *topRTYArray;

@property (nonatomic, strong)NSMutableArray *bottomLTXArray;
@property (nonatomic, strong)NSMutableArray *bottomLTYArray;

@property (nonatomic, strong)NSMutableArray *bottomRTXArray;
@property (nonatomic, strong)NSMutableArray *bottomRTYArray;


@end

@implementation JRPerspectiveTool
{
    CIRectangleFeature *_borderDetectLastRectangleFeature;
    CAShapeLayer *_rectOverlay;//边缘识别遮盖
    CGFloat _imageDedectionConfidence;

    CGFloat _topLTX ;
    CGFloat _topLTY ;
    
    CGFloat _topRTX ;
    CGFloat _topRTY ;
    
    CGFloat _bottomLTX ;
    CGFloat _bottomLTY ;
    
    CGFloat _bottomRTX ;
    CGFloat _bottomRTY ;
    

    CGFloat _topLCenterX ;
    CGFloat _topLCenterY ;
    
    CGFloat _topRCenterX ;
    CGFloat _topRCenterY ;
    
    CGFloat _bottomLCenterX ;
    CGFloat _bottomLCenterY ;
    
    CGFloat _bottomRCenterX ;
    CGFloat _bottomRCenterY ;

    int _topLIndex;
    int _topRIndex;
    int _bottomLIndex;
    int _bottomRIndex;

    
}

@synthesize undoManager;

- (instancetype)initWithImageEditor:(JRPhotoImageEditorViewController *)editor
{
    self = [super init];
    
    if (self) {
        
        self.editor = editor;
        
        self.topLTXArray = [NSMutableArray array];
        self.topLTYArray = [NSMutableArray array];
        
        self.topRTXArray = [NSMutableArray array];
        self.topRTYArray = [NSMutableArray array];
        
        self.bottomLTXArray = [NSMutableArray array];
        self.bottomLTYArray = [NSMutableArray array];
        
        self.bottomRTXArray = [NSMutableArray array];
        self.bottomRTYArray = [NSMutableArray array];
        
        // 初始化 工具栏
        self.perspectiveToolBar = [[JRPerspectiveToolBar alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        self.perspectiveToolBar.backButton.alpha = 0.5;
        self.perspectiveToolBar.backButton.userInteractionEnabled = NO;
        [editor.view addSubview:self.perspectiveToolBar];
        [self.perspectiveToolBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo([JRPerspectiveToolBar fixedHeight]);
            make.bottom.mas_equalTo(editor.mainToolBarView.mas_top).mas_offset(0);
        }];
        WS(weakSelf);
        self.perspectiveToolBar.backupStep = ^{
//            weakSelf.sourceImage.frame = CGRectMake(0, 0, weakSelf.editor.originSize.width, weakSelf.editor.originSize.height);
            
            [weakSelf undo];
            
        };
        
        // 获取原始图像
        self.sourceImage = editor.mosicaView.surfaceImageView;
        
        [self.sourceImage.layer ensureAnchorPointIsSetToZero];
        
        editor.imageView.alpha = 0;
        
        _imageDedectionConfidence = 0.0;
        
        //创建网格标识
        [self creatGrideView];
        // 创建虚拟触控点
        [self createControlTapView];
        // 设置触控点范围
        [self SetTheRangeOfTouchPoint];
        
        [self creatunDoManger];

    }
    return self;
    
}



- (void)setup
{
    self.perspectiveToolBar.hidden = NO;

    // 获取原始图像
    self.sourceImage = self.editor.mosicaView.surfaceImageView;
    
    [self.sourceImage.layer ensureAnchorPointIsSetToZero];

    // 设置触控点范围
    [self SetTheRangeOfTouchPoint];
    
    //恢复透明度
    self.gridOverlayView.alpha = 1.0;
    //触控手势恢复可用状态
    self.editor.topLeftControl.userInteractionEnabled = YES;
    self.editor.topRightControl.userInteractionEnabled = YES;
    self.editor.bottomLeftControl.userInteractionEnabled = YES;
    self.editor.bottomRightControl.userInteractionEnabled = YES;
    //虚拟触控按钮
    self.editor.topLeftControl.alpha = kButtonAlpha;
    self.editor.topRightControl.alpha = kButtonAlpha;
    self.editor.bottomLeftControl.alpha = kButtonAlpha;
    self.editor.bottomRightControl.alpha = kButtonAlpha;
    // 寻找最大矩形
//    [self findlargestRectangle];
    
}

- (void)cleanup
{
    self.perspectiveToolBar.hidden = YES;
    self.editor.imageView.userInteractionEnabled = NO;
    self.editor.scrollView.panGestureRecognizer.minimumNumberOfTouches = 1;
    // 隐藏网格线
    self.gridOverlayView.alpha = 0;
    //设置拖拽手势不可用
    self.editor.topLeftControl.userInteractionEnabled = NO;
    self.editor.topRightControl.userInteractionEnabled = NO;
    self.editor.bottomLeftControl.userInteractionEnabled = NO;
    self.editor.bottomRightControl.userInteractionEnabled = NO;
    //虚拟触控按钮
    self.editor.topLeftControl.alpha = 0;
    self.editor.topRightControl.alpha = 0;
    self.editor.bottomLeftControl.alpha = 0;
    self.editor.bottomRightControl.alpha = 0;
 
}

//创建网格遮罩层
- (void)creatGrideView {
    // The white grid overlay view
    CGRect customRect = CGRectMake((SCREEN_WIDTH - SCREEN_WIDTH*kScaleW)/2 ,(SCREEN_HEIGHT - SCREEN_HEIGHT*kScaleH)/2 - 30, SCREEN_WIDTH*kScaleW, SCREEN_HEIGHT*kScaleH);
    self.gridOverlayView = [[TOCropOverlayView alloc] initWithFrame:customRect];
    self.gridOverlayView.userInteractionEnabled = NO;
    self.gridOverlayView.gridHidden = YES;
    [self.editor.view addSubview:self.gridOverlayView];
    
    self.sourceImage.frame = customRect;

}

//撤销恢复
- (void)creatunDoManger {
    undoManager = [[NSUndoManager alloc] init];     // 初始化UndoManager
    [undoManager setLevelsOfUndo:999];      // 设置最大极限，当达到极限时扔掉旧的撤销
}

#pragma mark - NSUndoManager 操作
//  在我们的程序中有add以及这个方法的逆方法substract，我们可以这样来实现撤销功能。
-(void)substract:(UIPanGestureRecognizer *)recognizer{
    
    UIImageView *controlPointView = (UIImageView *)[recognizer view];
    controlPointView.highlighted = recognizer.state == UIGestureRecognizerStateChanged;


    switch (controlPointView.tag) {
        case 990:
        {
            _topLCenterX -= [self.topLTXArray[_topLIndex-1] floatValue];
            _topLCenterY -= [self.topLTYArray[_topLIndex-1] floatValue];

            
            controlPointView.centerX = _topLCenterX;
            controlPointView.centerY = _topLCenterY;
            
            _topLIndex -- ;
            if (_topLIndex == 1) {
                [self.topLTXArray removeAllObjects];
                [self.topLTYArray removeAllObjects];
//                _topLIndex = 0;
                _topLCenterX = 0;
                _topLCenterY = 0;
            }
            
            break;
        }
            
        case 991:
        {
            _topRCenterX -= [self.topRTXArray[_topRIndex-1] floatValue];
            _topRCenterY -= [self.topRTYArray[_topRIndex-1] floatValue];

            
            controlPointView.centerX = _topRCenterX;
            controlPointView.centerY = _topRCenterY;
            
            _topRIndex -- ;
            if (_topRIndex == 1) {
                [self.topRTXArray removeAllObjects];
                [self.topRTYArray removeAllObjects];
//                _topRIndex = 0;
                _topRCenterX = 0;
                _topRCenterY = 0;

            }
            
            break;
        }
            
        case 992:
        {
            _bottomLCenterX -= [self.bottomLTXArray[_bottomLIndex-1] floatValue];
            _bottomLCenterY -= [self.bottomLTYArray[_bottomLIndex-1] floatValue];

            
            controlPointView.centerX = _bottomLCenterX;
            controlPointView.centerY = _bottomLCenterY;
            

            _bottomLIndex -- ;
            
            if (_bottomLIndex == 1) {
                [self.bottomLTXArray removeAllObjects];
                [self.bottomLTYArray removeAllObjects];
//                _bottomLIndex = 0;
                _bottomLCenterX = 0;
                _bottomLCenterY = 0;
            }

            break;
        }
            
        case 993:
        {
            _bottomRCenterX -= [self.bottomRTXArray[_bottomRIndex-1] floatValue];
            _bottomRCenterY -= [self.bottomRTYArray[_bottomRIndex-1] floatValue];

            
            controlPointView.centerX = _bottomRCenterX;
            controlPointView.centerY = _bottomRCenterY;
            

            _bottomRIndex -- ;
            
            
            if (_bottomRIndex == 1) {
                [self.bottomRTYArray removeAllObjects];
                [self.bottomRTYArray removeAllObjects];
//                _bottomRIndex = 0;
                _bottomRCenterX = 0;
                _bottomRCenterY = 0;
            }

            break;
        }
    }

    [recognizer setTranslation:CGPointZero inView:self.editor.view];
    // 手势移动的时候 触控随着一起改变
    [self SetTheRangeOfTouchPoint];

    [[undoManager prepareWithInvocationTarget:self] addGesture:recognizer];

}

-(void)addGesture:(UIPanGestureRecognizer *)recognizer{
    
    //prepareWithInvocationTarget:方法记录了target并返回UndoManager，然后UndoManager重载了forwardInvocation方法，也就将substract方法的Invocation添加到undo栈中了。
    [[undoManager prepareWithInvocationTarget:self] substract:recognizer];  // 基于NSInvocation触发undo

}

-(void)undo{
    
    // 执行撤销
    [self.undoManager undo];    //注意这里不是[self undo];
    
}

- (void)tapView:(UIPanGestureRecognizer *)recognizer
{

    //设置返回按钮可用
    self.perspectiveToolBar.backButton.alpha = 1.0;
    self.perspectiveToolBar.backButton.userInteractionEnabled = YES;
    UIImageView *controlPointView = (UIImageView *)[recognizer view];
    controlPointView.highlighted = recognizer.state == UIGestureRecognizerStateChanged;
    CGPoint translation = [recognizer translationInView:self.editor.view];
    
    controlPointView.centerX += translation.x;
    controlPointView.centerY += translation.y;
    //记录偏移量数据
//    translationX += translation.x;
//    translationY += translation.y;
    
    switch (controlPointView.tag) {
        case 990:
        {
            //记录偏移量数据
            _topLTX += translation.x;
            _topLTY += translation.y;
            
            if (recognizer.state == UIGestureRecognizerStateEnded) {

                // 记录结束之后的值
                _topLCenterX = controlPointView.centerX;
                _topLCenterY = controlPointView.centerY;

                NSLog(@"当前的移动数据_topLTX==%.2f",_topLTX);
                NSLog(@"当前的移动数据_topLTY==%.2f",_topLTY);

                NSLog(@"之前的centerX==%.2f",_topLCenterX);
                NSLog(@"之前的centerY==%.2f",_topLCenterY);
                
                
                [self.topLTXArray addObject:[NSNumber numberWithFloat:_topLTX]];
                [self.topLTYArray addObject:[NSNumber numberWithFloat:_topLTY]];
                
                _topLTX = 0.0;
                _topLTY = 0.0;
                
                _topLIndex ++;
                
                //触发undo逻辑
                [self addGesture:recognizer];

            }

            
            break;
        }
        case 991:
        {
            //记录偏移量数据
            _topRTX += translation.x;
            _topRTY += translation.y;
            
            if (recognizer.state == UIGestureRecognizerStateEnded) {

                // 记录结束之后的值
                _topRCenterX = controlPointView.centerX;
                _topRCenterY = controlPointView.centerY;

                NSLog(@"当前的移动数据_topLTX==%.2f",_topRTX);
                NSLog(@"当前的移动数据_topLTY==%.2f",_topRTY);

                NSLog(@"之前的centerX==%.2f",_topRCenterX);
                NSLog(@"之前的centerY==%.2f",_topRCenterY);
                
                
                [self.topRTXArray addObject:[NSNumber numberWithFloat:_topRTX]];
                [self.topRTYArray addObject:[NSNumber numberWithFloat:_topRTY]];
                
                _topRTX = 0.0;
                _topRTY = 0.0;
                
                _topRIndex ++;
                
                //触发undo逻辑
                [self addGesture:recognizer];

            }
            
            
            break;
        }
        case 992:
        {
            //记录偏移量数据
            _bottomLTX += translation.x;
            _bottomLTY += translation.y;
            
            if (recognizer.state == UIGestureRecognizerStateEnded) {

                // 记录结束之后的值
                _bottomLCenterX = controlPointView.centerX;
                _bottomLCenterY = controlPointView.centerY;

                NSLog(@"当前的移动数据_topLTX==%.2f",_bottomLTX);
                NSLog(@"当前的移动数据_topLTY==%.2f",_bottomLTY);

                NSLog(@"之前的centerX==%.2f",_bottomLCenterX);
                NSLog(@"之前的centerY==%.2f",_bottomLCenterY);
                
                
                [self.bottomLTXArray addObject:[NSNumber numberWithFloat:_bottomLTX]];
                [self.bottomLTYArray addObject:[NSNumber numberWithFloat:_bottomLTY]];
                
                //偏移数据记录之后一定要清0
                _bottomLTX = 0.0;
                _bottomLTY = 0.0;
                
                _bottomLIndex ++;
                
                //触发undo逻辑
                [self addGesture:recognizer];

            }
            
            
            break;
        }
        case 993:
        {
            //记录偏移量数据
            _bottomRTX += translation.x;
            _bottomRTY += translation.y;
            
            if (recognizer.state == UIGestureRecognizerStateEnded) {

                // 记录结束之后的值
                _bottomRCenterX = controlPointView.centerX;
                _bottomRCenterY = controlPointView.centerY;

                NSLog(@"当前的移动数据_topLTX==%.2f",_bottomRTX);
                NSLog(@"当前的移动数据_topLTY==%.2f",_bottomRTY);

                NSLog(@"之前的centerX==%.2f",_bottomRCenterX);
                NSLog(@"之前的centerY==%.2f",_bottomRCenterY);
                
                
                [self.bottomRTXArray addObject:[NSNumber numberWithFloat:_bottomRTX]];
                [self.bottomRTYArray addObject:[NSNumber numberWithFloat:_bottomRTY]];
                
                //偏移数据记录之后一定要清0
                _bottomRTX = 0.0;
                _bottomRTY = 0.0;
                
                _bottomRIndex ++;
                
                //触发undo逻辑
                [self addGesture:recognizer];

            }
            
            break;
        }
    }
    [recognizer setTranslation:CGPointZero inView:self.editor.view];

    // 手势移动的时候 触控随着一起改变
    [self SetTheRangeOfTouchPoint];
        

}

//   创建触控点范围
- (void)createControlTapView {
    
    float topLeft_x = self.sourceImage.frame.origin.x;
    float topLeft_y = self.sourceImage.frame.origin.y;
    float topRight_x = topLeft_x + SCREEN_WIDTH*kScaleW - kButtonWidth;
    float topRight_y = topLeft_y;
    float bottomLeft_x = topLeft_x;
    float bottomLeft_y = topLeft_y + SCREEN_HEIGHT*kScaleH - kButtonWidth;
    float bottomRight_x = topRight_x ;
    float bottomRight_y = bottomLeft_y ;
    
    self.editor.topLeftControl = [[UIImageView alloc]initWithFrame:CGRectMake(topLeft_x, topLeft_y, kButtonWidth, kButtonWidth)];
    [self.editor.topLeftControl setImage:[JRUIHelper imageNamed:@"controlpoint.png"]];
    [self.editor.topLeftControl setHighlightedImage:[JRUIHelper imageNamed:@"controlpoint_h.png"]];
    self.editor.topLeftControl.tag = 990;
    self.editor.topLeftControl.backgroundColor = [UIColor whiteColor];
    
    self.editor.topRightControl = [[UIImageView alloc]initWithFrame:CGRectMake(topRight_x, topRight_y, kButtonWidth, kButtonWidth)];
    self.editor.topRightControl.backgroundColor = [UIColor whiteColor];
    [self.editor.topRightControl setImage:[JRUIHelper imageNamed:@"controlpoint.png"]];
    [self.editor.topRightControl setHighlightedImage:[JRUIHelper imageNamed:@"controlpoint_h.png"]];

    self.editor.topRightControl.tag = 991;
    
    self.editor.bottomLeftControl = [[UIImageView alloc]initWithFrame:CGRectMake(bottomLeft_x, bottomLeft_y, kButtonWidth, kButtonWidth)];
    self.editor.bottomLeftControl.backgroundColor = [UIColor whiteColor];
    [self.editor.bottomLeftControl setImage:[JRUIHelper imageNamed:@"controlpoint.png"]];
    [self.editor.bottomLeftControl setHighlightedImage:[JRUIHelper imageNamed:@"controlpoint_h.png"]];

    self.editor.bottomLeftControl.tag = 992;
    
    self.editor.bottomRightControl = [[UIImageView alloc]initWithFrame:CGRectMake(bottomRight_x, bottomRight_y, kButtonWidth, kButtonWidth)];
    self.editor.bottomRightControl.backgroundColor = [UIColor whiteColor];
    [self.editor.bottomRightControl setImage:[JRUIHelper imageNamed:@"controlpoint.png"]];
    [self.editor.bottomRightControl setHighlightedImage:[JRUIHelper imageNamed:@"controlpoint_h.png"]];
    self.editor.bottomRightControl.tag = 993;
    
    [self.editor.view addSubview:self.editor.topLeftControl];
    [self.editor.view addSubview:self.editor.topRightControl];
    [self.editor.view addSubview:self.editor.bottomLeftControl];
    [self.editor.view addSubview:self.editor.bottomRightControl];
    
    self.editor.topLeftControl.alpha = kButtonAlpha;
    self.editor.topRightControl.alpha = kButtonAlpha;
    self.editor.bottomLeftControl.alpha = kButtonAlpha;
    self.editor.bottomRightControl.alpha = kButtonAlpha;

    self.editor.topLeftControl.userInteractionEnabled = YES;
    self.editor.topRightControl.userInteractionEnabled = YES;
    self.editor.bottomLeftControl.userInteractionEnabled = YES;
    self.editor.bottomRightControl.userInteractionEnabled = YES;
    
    UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(tapView:)];
    UIPanGestureRecognizer *gesture1 = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(tapView:)];
    UIPanGestureRecognizer *gesture2 = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(tapView:)];
    UIPanGestureRecognizer *gesture3 = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(tapView:)];

    [self.editor.topLeftControl addGestureRecognizer:gesture];
    [self.editor.topRightControl addGestureRecognizer:gesture1];
    [self.editor.bottomLeftControl addGestureRecognizer:gesture2];
    [self.editor.bottomRightControl addGestureRecognizer:gesture3];
}



// 设置触控点范围
- (void)SetTheRangeOfTouchPoint {
    CGPoint topLeftPoint = CGPointMake(self.editor.topLeftControl.centerX-kButtonWidth, self.editor.topLeftControl.centerY-kButtonWidth);
    
    CGPoint topRightPoint = CGPointMake(self.editor.topRightControl.centerX+kButtonWidth, self.editor.topRightControl.centerY-kButtonWidth);
    
  
    CGPoint bottomRightPoint = CGPointMake(self.editor.bottomRightControl.centerX+kButtonWidth, self.editor.bottomRightControl.centerY+kButtonWidth);
    
    CGPoint bottomLeftPoint = CGPointMake(self.editor.bottomLeftControl.centerX-kButtonWidth, self.editor.bottomLeftControl.centerY+kButtonWidth);

    self.sourceImage.layer.quadrilateral = AGKQuadMake(topLeftPoint,
                                                     topRightPoint,
                                                     bottomRightPoint,
                                                     bottomLeftPoint);
}

#pragma mark - 以下是OpenCV的实现 方案 暂时需求不需要
// 选取feagure rectangles中最大的矩形
- (CIRectangleFeature *)biggestRectangleInRectangles:(NSArray *)rectangles
{
    if (![rectangles count]) return nil;
    
    float halfPerimiterValue = 0;
    
    CIRectangleFeature *biggestRectangle = [rectangles firstObject];
    
    for (CIRectangleFeature *rect in rectangles)
    {
        CGPoint p1 = rect.topLeft;
        CGPoint p2 = rect.topRight;
        CGFloat width = hypotf(p1.x - p2.x, p1.y - p2.y);
        
        CGPoint p3 = rect.topLeft;
        CGPoint p4 = rect.bottomLeft;
        CGFloat height = hypotf(p3.x - p4.x, p3.y - p4.y);
        
        CGFloat currentHalfPerimiterValue = height + width;
        
        if (halfPerimiterValue < currentHalfPerimiterValue)
        {
            halfPerimiterValue = currentHalfPerimiterValue;
            biggestRectangle = rect;
        }
    }
    
    return biggestRectangle;
}

// 高精度边缘识别器
- (CIDetector *)highAccuracyRectangleDetector
{
    static CIDetector *detector = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
                  {
                      detector = [CIDetector detectorOfType:CIDetectorTypeRectangle context:nil options:@{CIDetectorAccuracy : CIDetectorAccuracyHigh}];
                  });
    return detector;
}
// 低精度边缘识别器
- (CIDetector *)rectangleDetetor
{
    static CIDetector *detector = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
                  {
                      detector = [CIDetector detectorOfType:CIDetectorTypeRectangle context:nil options:@{CIDetectorAccuracy : CIDetectorAccuracyLow,CIDetectorTracking : @(YES)}];
                  });
    return detector;
}
// 判断边缘识别
BOOL rectangleDetectionConfidenceHighEnough(float confidence)
{
    return (confidence > 1.0);
}


// 寻找矩形
- (void)findlargestRectangle {
    
    CIImage *ciimg = [CIImage imageWithCGImage:self.sourceImage.image.CGImage];
    // 用高精度边缘识别器 识别特征
    NSArray <CIFeature *>*features = [[self highAccuracyRectangleDetector] featuresInImage:ciimg];
    // 选取特征列表中最大的矩形
    _borderDetectLastRectangleFeature = [self biggestRectangleInRectangles:features];
    
    
    if (_borderDetectLastRectangleFeature) {
        _imageDedectionConfidence += 1.5;
        // draw border layer
        if (rectangleDetectionConfidenceHighEnough(_imageDedectionConfidence))
        {
            [self drawBorderDetectRectWithImageRect:ciimg.extent topLeft:_borderDetectLastRectangleFeature.topLeft topRight:_borderDetectLastRectangleFeature.topRight bottomLeft:_borderDetectLastRectangleFeature.bottomLeft bottomRight:_borderDetectLastRectangleFeature.bottomRight];
        }
    }

}

// 绘制边缘检测图层
- (void)drawBorderDetectRectWithImageRect:(CGRect)imageRect topLeft:(CGPoint)topLeft topRight:(CGPoint)topRight bottomLeft:(CGPoint)bottomLeft bottomRight:(CGPoint)bottomRight
{
    
    if (!_rectOverlay) {
        _rectOverlay = [CAShapeLayer layer];
        _rectOverlay.fillRule = kCAFillRuleEvenOdd;
        _rectOverlay.fillColor = [UIColor colorWithRed:73/255.0 green:130/255.0 blue:180/255.0 alpha:0.4].CGColor;
        _rectOverlay.strokeColor = [UIColor whiteColor].CGColor;
        _rectOverlay.lineWidth = 5.0f;
    }
    if (!_rectOverlay.superlayer) {
        self.editor.view.layer.masksToBounds = YES;
        [self.editor.view.layer addSublayer:_rectOverlay];
    }

    // 将图像空间的坐标系转换成uikit坐标系
    TransformCIFeatureRect featureRect = [self transfromRealRectWithImageRect:imageRect topLeft:topLeft topRight:topRight bottomLeft:bottomLeft bottomRight:bottomRight];
    
    // 边缘识别路径
    UIBezierPath *path = [UIBezierPath new];
    [path moveToPoint:featureRect.topLeft];
    [path addLineToPoint:featureRect.topRight];
    [path addLineToPoint:featureRect.bottomRight];
    [path addLineToPoint:featureRect.bottomLeft];
    [path closePath];
    // 背景遮罩路径
    UIBezierPath *rectPath  = [UIBezierPath bezierPathWithRect:CGRectMake(-5,
                                                                          -5,
                                                                          self.sourceImage.frame.size.width + 10,
                                                                          self.sourceImage.frame.size.height + 10)];
    [rectPath setUsesEvenOddFillRule:YES];
    [rectPath appendPath:path];
    _rectOverlay.path = rectPath.CGPath;
}

/// 坐标系转换
- (TransformCIFeatureRect)transfromRealRectWithImageRect:(CGRect)imageRect topLeft:(CGPoint)topLeft topRight:(CGPoint)topRight bottomLeft:(CGPoint)bottomLeft bottomRight:(CGPoint)bottomRight
{
    CGRect previewRect = self.sourceImage.frame;
    
    return [MADCGTransfromHelper transfromRealCIRectInPreviewRect:previewRect imageRect:imageRect topLeft:topLeft topRight:topRight bottomLeft:bottomLeft bottomRight:bottomRight];
}


@end
