/**
 * 所属系统: TIM
 * 所属模块: 聊天类：录制视频
 * 功能描述: 自定义视频录制进度倒计时界面
 * 创建时间: 2019/9/17.
 * 维护人:  石拓
 * Copyright @ Jerrisoft 2019. All rights reserved.
 *┌─────────────────────────────────────────────────────┐
 *│ 此技术信息为本公司机密信息，未经本公司书面同意禁止向第三方披露．│
 *│ 版权所有：杰人软件(深圳)有限公司                          │
 *└─────────────────────────────────────────────────────┘
 */

#import "JRVideoRecordProgressView.h"
#import "JRUIKit.h"
@implementation JRVideoRecordProgressView

#pragma -mark 初始化对象
-(instancetype)init {
    
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


/**
 @desc 初始化尺寸
 @author Scott
 @date 2019/9/16
 @param frame 尺寸大小
 @return 返回本类对象
 */
-(instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = NO;
    }
    
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super initWithCoder:aDecoder]) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


/**
 @desc 倒计时 圆圈绘制
 @author Scott
 @date 2019/9/16
 @param rect 绘制尺寸
 */
- (void)drawRect:(CGRect)rect {
    
    [super drawRect:rect];
    CGContextRef ctx = UIGraphicsGetCurrentContext();//获取上下文
    
    CGPoint center = CGPointMake(self.width/2, self.height/2); //设置圆心位置
    CGFloat radius = self.width/2 - 2; //设置半径
    CGFloat startA = - M_PI_2; //圆起点位置
    CGFloat endA = -M_PI_2 + M_PI * 2 * _progress/self.totolProgress; //圆终点位置
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startA endAngle:endA clockwise:YES];
    
    CGContextSetLineWidth(ctx, 4); //设置线条宽度
    //设置描边颜色
    [[UIColor jk_colorWithHexString:@"0EA856"] setStroke];

    CGContextAddPath(ctx, path.CGPath); //把路径添加到上下文
    
    CGContextStrokePath(ctx); //渲染
}


/**
 @desc 设置进度
 @author Scott
 @date 2019/9/16
 @param progress 进度参数
 */
-(void)setProgress:(CGFloat)progress{
    _progress = progress;
    [self setNeedsDisplay];
}

@end
