//
/**
* 所属系统: YMMAD
* 所属模块: 
* 功能描述: 
* 创建时间: 2021/3/12
* 维护人:  马克
* 
*┌─────────────────────────────────────────────────────┐
*│ 此技术信息为本公司机密信息，未经本公司书面同意禁止向第三方披露．│
*│ 版权所有：杰人软件(深圳)有限公司                          │
*└─────────────────────────────────────────────────────┘
*/

#import "JRGPath.h"

@interface JRGPath ()
@property (nonatomic, strong) UIBezierPath *bezierPath;
@property (nonatomic, assign) CGPoint beginPoint;
@property (nonatomic, assign) CGFloat pathWidth;
@property (nonatomic, strong) NSMutableArray<NSValue *> *pointArray;
@end

@implementation JRGPath
+ (instancetype)pathToPoint:(CGPoint)beginPoint pathWidth:(CGFloat)pathWidth
{
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    bezierPath.lineWidth     = pathWidth;
    bezierPath.lineCapStyle  = kCGLineCapButt;//kCGLineCapRound;
    bezierPath.lineJoinStyle = kCGLineJoinRound;
//    bezierPath.flatness = 0.5;;   
    [bezierPath moveToPoint:beginPoint];
    
    JRGPath *path   = [[JRGPath alloc] init];
    path.beginPoint = beginPoint;
    path.pathWidth  = pathWidth;
    path.bezierPath = bezierPath;
    path.pointArray = [NSMutableArray array];
    
    return path;
}

//曲线
- (void)pathLineToPoint:(CGPoint)movePoint;
{
    //判断绘图类型
    [self.pointArray addObject:@(movePoint)];
    
    [self.bezierPath addLineToPoint:movePoint];
    
//    [self.bezierPath addQuadCurveToPoint:movePoint controlPoint:movePoint];

}

- (void)drawPath
{
    [self.pathColor set];
    [self.bezierPath stroke];
}

@end
