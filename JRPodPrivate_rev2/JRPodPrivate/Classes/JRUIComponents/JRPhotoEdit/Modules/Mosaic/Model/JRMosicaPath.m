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

#import "JRMosicaPath.h"

@interface JRPathItem : NSObject
@property (nonatomic, assign) CGPoint beginPoint;
@property (nonatomic, strong) NSMutableArray<NSValue *> *pointArray;
@property (nonatomic, strong) UIBezierPath *path;
@end

@implementation JRPathItem
- (instancetype)init
{
    if (self = [super init])
    {
        _pointArray = [NSMutableArray array];
    }
    
    return self;
}

@end

@interface JRMosicaPath ()
@property (nonatomic, strong) NSMutableArray<JRPathItem *> *pathArray;

@end

@implementation JRMosicaPath
- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        _pathArray = [NSMutableArray array];
    }
    
    return self;
}

- (void)beginNewDraw:(CGPoint)point
{
    JRPathItem *item = [JRPathItem new];
    item.beginPoint = point;
    item.path = [UIBezierPath bezierPath];
    [self.pathArray addObject:item];
    
    [self addPoint:point];
}

- (void)addPoint:(CGPoint)point
{
    JRPathItem *item = [self.pathArray lastObject];
    [item.pointArray addObject:@(point)];
    [item.path moveToPoint:point];
}

- (void)addLineToPoint:(CGPoint)point
{
    JRPathItem *item = [self.pathArray lastObject];
    [item.pointArray addObject:@(point)];
    [item.path addLineToPoint:point];
}

- (NSArray *)backToLastDraw
{
    [self.pathArray removeLastObject];
    return self.pathArray;
}

- (CGPathRef)makePath
{
    CGMutablePathRef pathRef = CGPathCreateMutable();
    
    for (JRPathItem *pathItem in _pathArray)
    {
        CGPathAddPath(pathRef, nil, pathItem.path.CGPath);
    }
    
    return pathRef;
}

@end
