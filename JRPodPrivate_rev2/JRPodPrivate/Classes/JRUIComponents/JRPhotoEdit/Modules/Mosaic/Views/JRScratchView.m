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

#import "JRScratchView.h"
#import "JRGPath.h"
#import "JRMosicaPath.h"
#import "UIView+TouchBlock.h"
@interface JRScratchView ()

@property (nonatomic, strong) CALayer *imageLayer;
@property (nonatomic, strong) JRMosicaPath *mosicaPath;
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;
@end

@implementation JRScratchView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.surfaceImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:self.surfaceImageView];
        
        self.imageLayer = [CALayer layer];
        self.imageLayer.frame = self.bounds;
        [self.layer addSublayer:self.imageLayer];
        
        self.shapeLayer = [CAShapeLayer layer];
        self.shapeLayer.frame = self.bounds;
        self.shapeLayer.lineCap = kCALineCapRound;
        self.shapeLayer.lineJoin = kCALineJoinRound;
        self.shapeLayer.lineWidth = 13;
        self.shapeLayer.strokeColor = [UIColor blueColor].CGColor;
        self.shapeLayer.fillColor = nil;//此处必须设为nil，否则后边添加addLine的时候会自动填充

        self.imageLayer.mask = self.shapeLayer;
        
        self.mosicaPath = [JRMosicaPath new];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onViewTapped:)];
        [self addGestureRecognizer:tap];  // 屏蔽调点击手势
    }
    
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    self.surfaceImageView.frame = self.bounds;
    self.imageLayer.frame = self.bounds;
    self.shapeLayer.frame = self.bounds;
}

- (void)setMosaicImage:(UIImage *)mosaicImage
{
    _mosaicImage = mosaicImage;
    self.imageLayer.contents = (id)mosaicImage.CGImage;
}

- (void)setSurfaceImage:(UIImage *)surfaceImage
{
    _surfaceImage = surfaceImage;
    self.surfaceImageView.image = surfaceImage;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    if (self.touchesBeganBlock)
    {
        self.touchesBeganBlock();
    }
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    [self.mosicaPath beginNewDraw:point];
    
    [self draw];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    
    if (self.touchesMovedBlock)
    {
        self.touchesMovedBlock();
    }
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    [self.mosicaPath addLineToPoint:point];
    
    
    
    [self draw];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    if (self.touchesEndedBlock)
    {
        self.touchesEndedBlock();
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.touchesCancelledBlock)
    {
        self.touchesCancelledBlock();
    }
}

- (void)onViewTapped:(UITapGestureRecognizer *)gestureRecognizer
{
    if (self.tapGestureBlock)
    {
        self.tapGestureBlock(gestureRecognizer);
    }
    
}

- (void)draw
{
    CGPathRef path = [self.mosicaPath makePath];
    self.shapeLayer.path = path;
    CGPathRelease(path);
    path = NULL;
}

- (NSArray *)backToLastDraw
{
    NSArray *temAry = [self.mosicaPath backToLastDraw];
 
    CGPathRef path = [self.mosicaPath makePath];
    self.shapeLayer.path = path;
    self.imageLayer.mask = self.shapeLayer;
    CGPathRelease(path);
    path = NULL;
    return temAry;
}

@end
