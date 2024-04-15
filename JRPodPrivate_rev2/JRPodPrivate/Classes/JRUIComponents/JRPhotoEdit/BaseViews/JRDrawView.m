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

#import "JRDrawView.h"

@implementation JRDrawView

+ (Class)layerClass
{
    return [CAShapeLayer class];
}

+ (dispatch_queue_t)drawQueue
{
    static dispatch_queue_t _drawQueue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _drawQueue = dispatch_queue_create("com.image.editor.queue", DISPATCH_QUEUE_SERIAL);
    });
    
    return _drawQueue;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setBackgroundColor:[UIColor clearColor]];
        self.layer.contentsScale = [[UIScreen mainScreen] scale];
    }
    
    return self;
}

- (void)setNeedDraw
{
    CGSize originSize = self.originSize;
    dispatch_async([self.class drawQueue], ^{
        [self draw:originSize];
    });
}

- (void)draw:(CGSize)size
{
    if (self.drawViewBlock)
    {
        CGFloat scale = [[UIScreen mainScreen] scale];
        UIGraphicsBeginImageContextWithOptions(size, NO, scale);
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        //去掉锯齿
//        CGContextSetAllowsAntialiasing(context, true);
        CGContextSetShouldAntialias(context, true);
        
        self.drawViewBlock(context);
        
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.layer.contents = (__bridge id _Nullable)(image.CGImage);
        });
    }
}

@end
