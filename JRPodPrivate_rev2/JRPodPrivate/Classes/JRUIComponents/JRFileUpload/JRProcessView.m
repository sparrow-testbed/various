//
/**
* 所属系统: YMMAD
* 所属模块: 
* 功能描述: 
* 创建时间: 2021/1/18
* 维护人:  马克
* 
*┌─────────────────────────────────────────────────────┐
*│ 此技术信息为本公司机密信息，未经本公司书面同意禁止向第三方披露．│
*│ 版权所有：杰人软件(深圳)有限公司                          │
*└─────────────────────────────────────────────────────┘
*/

#import "JRProcessView.h"

@interface JRProcessView ()

@property (nonatomic, strong) UIView *progressView;

@property (nonatomic) CGRect rect_progressView;

@property (nonatomic, strong) CAShapeLayer *circleLayer;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIBezierPath *path;

- (void)_setHeightRestrictionOfFrame:(CGFloat)height;

@end

@implementation JRProcessView

- (instancetype)initWithFrame:(CGRect)frame withProcessType:(JRProcessType)processType
{
    self = [super initWithFrame:frame];
    if (self) {
        
        if (processType == 0) {
            [self setupSubviews];
        }else {
            self.backgroundColor =[UIColor greenColor];
            [self _setHeightRestrictionOfFrame:frame.size.height];
        }
    }
    return self;
}

#pragma mark - 环形进度条
- (void)setupSubviews {
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = width/2.0;
    self.circleLayer = [CAShapeLayer layer];
    self.circleLayer.frame = self.bounds;
    self.circleLayer.strokeEnd = 0;
    self.circleLayer.lineWidth = 3;
    self.circleLayer.strokeColor = [UIColor colorWithHex:@"#FFFFFF"].CGColor;
    self.circleLayer.fillColor = [UIColor clearColor].CGColor;
    CGPoint center = CGPointMake(width/2, height/2);
    [self.layer addSublayer:self.circleLayer];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
    self.titleLabel.center = center;
//    self.titleLabel.hidden = YES;
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont systemFontOfSize:8];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.titleLabel];
}

/// 设置文字颜色
- (void)setTitleColor:(UIColor *)titleColor {
    self.titleLabel.textColor =  titleColor;
}
/// 设置进度条颜色
- (void)setProgressColor:(UIColor *)progressColor {
    self.circleLayer.strokeColor = progressColor.CGColor;
}
/// 设置进度值
- (void)setProgress:(CGFloat)progress {
    _progress = MIN(1, MAX(0, progress));
    float endProcess = progress/ 100.0;
    self.circleLayer.strokeEnd = endProcess;
    NSString *progressStr = [NSString stringWithFormat:@"%.0f%%",progress];
    self.titleLabel.text = progressStr;
    if (progress >= 100) {
        if (self.completionBlock) {
            self.completionBlock();
            self.completionBlock = nil;
        }
    } else {
        self.titleLabel.hidden = NO;
    }
}
///设置进度宽
- (void)setProgressWidth:(CGFloat)progressWidth {
    if (!_path) {
        CGFloat width = self.frame.size.width;
        CGPoint center = CGPointMake(width/2, width/2);
        _path = [UIBezierPath bezierPathWithArcCenter:center radius:(width/2 - progressWidth/2) startAngle:-M_PI_2 endAngle:3*M_PI/2 clockwise:YES];
        self.circleLayer.path = _path.CGPath;
    }
    self.circleLayer.lineWidth = progressWidth;
}

#pragma mark - 线条进度条
- (void)_setHeightRestrictionOfFrame:(CGFloat)height
{
    CGRect rect = self.frame;
    
    _progressHeight = MIN(height, 3.0);
    _progressHeight = MAX(_progressHeight, 1.0);
    
    self.frame = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, _progressHeight);
    
    self.rect_progressView = CGRectZero;
    _rect_progressView.size.height = _progressHeight;
    self.progressView.frame = self.rect_progressView;
    
    self.layer.cornerRadius = self.progressView.layer.cornerRadius =  _progressHeight / 2.0;
}

- (void)setProgressHeight:(CGFloat)progressHeight
{
    [self _setHeightRestrictionOfFrame:progressHeight];
}

- (void)setProgressTintColor:(UIColor *)progressTintColor
{
    _progressTintColor = progressTintColor;
    
    self.backgroundColor = _progressTintColor;
}

-(void)setChangeTintColor:(UIColor *)changeTintColor{
    _changeTintColor = changeTintColor;
    self.progressView.backgroundColor = _changeTintColor;
}

- (void)setProgressValue:(CGFloat)progressValue
{
    _progressValue = progressValue;
    
    _progressValue = MIN(progressValue, self.bounds.size.width);
    
    _rect_progressView.size.width = _progressValue;
    
    
    CGFloat maxValue = self.bounds.size.width;
    
    double durationValue = (_progressValue/2.0) / maxValue + .5;
    
    [UIView animateWithDuration:durationValue animations:^{
        self.progressView.frame = self->_rect_progressView;
    }];
}

- (UIView *)progressView
{
    if (!_progressView) {
        _progressView = [[UIView alloc] initWithFrame:CGRectZero];
        _progressView.backgroundColor = [UIColor greenColor];
        [self addSubview:self.progressView];
    }
    return _progressView;
}


@end
