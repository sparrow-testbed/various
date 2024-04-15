//
/**
* 所属系统: YMMAD
* 所属模块: 
* 功能描述: 
* 创建时间: 2021/4/8
* 维护人:  马克
* 
*┌─────────────────────────────────────────────────────┐
*│ 此技术信息为本公司机密信息，未经本公司书面同意禁止向第三方披露．│
*│ 版权所有：杰人软件(深圳)有限公司                          │
*└─────────────────────────────────────────────────────┘
*/

#import "TOCropView+CorrectView.h"
#import <objc/runtime.h>
#import "JRUIKit.h"

#define kButtonWidth 0
#define kCenterOffset 0
#define kScaleW 0.8
#define kScaleH 0.6
#define kButtonAlpha 0.0
#define kMoveOffset 4



@implementation TOCropView (CorrectView)

- (void)setTopLeftControl:(UIView *)topLeftControl {
    objc_setAssociatedObject(self, @selector(topLeftControl), topLeftControl, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)topLeftControl {
    return objc_getAssociatedObject(self, @selector(topLeftControl));
}

- (void)setTopRightControl:(UIView *)topRightControl {
    objc_setAssociatedObject(self, @selector(topRightControl), topRightControl, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)topRightControl {
    return objc_getAssociatedObject(self, @selector(topRightControl));
}

- (void)setBottomLeftControl:(UIView *)bottomLeftControl {
    objc_setAssociatedObject(self, @selector(bottomLeftControl), bottomLeftControl, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)bottomLeftControl {
    return objc_getAssociatedObject(self, @selector(bottomLeftControl));
}

- (void)setBottomRightControl:(UIView *)bottomRightControl {
    objc_setAssociatedObject(self, @selector(bottomRightControl), bottomRightControl, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)bottomRightControl {
    return objc_getAssociatedObject(self, @selector(bottomRightControl));
}

- (void)setButtonWidth:(float)buttonWidth {
    
    objc_setAssociatedObject(self, @selector(buttonWidth), @(buttonWidth), OBJC_ASSOCIATION_ASSIGN);
}

- (float)buttonWidth {
    return [objc_getAssociatedObject(self,@selector(buttonWidth)) floatValue];
//    return self.cropBoxFrame.size.width/2; //objc_getAssociatedObject(self, @selector(buttonWidth));
}


- (void)buildCorrectView {
    
    //移除网格移动手势
    [self.gridPanGestureRecognizer removeTarget:self action:@selector(gridPanGestureRecognized:)];
        
    // 创建虚拟触控点
    [self createControlTapView];
    // 重置视图锚点 否则会视图跳动
    [self.foregroundContainerView.layer ensureAnchorPointIsSetToZero];
    //初始化校正坐标点
    self.foregroundContainerView.layer.quadrilateral = AGKQuadMake(self.topLeftControl.center,
                                                     self.topRightControl.center,
                                                     self.bottomRightControl.center,
                                                     self.bottomLeftControl.center);
    //使用scrollview状态不可用
    self.scrollView.scrollEnabled = NO;

}

//  创建图片四角标识点位图标
- (void)createControlTapView {

    float widthButton = 30;//self.foregroundContainerView.frame.size.width/2;
    
    float topLeft_x =  self.foregroundContainerView.frame.origin.x-widthButton/2; // x轴点的初始值需要减去触控view的宽度防止矩形图片内收效果
    float topLeft_y =  self.foregroundContainerView.frame.origin.y - widthButton/2;
    float topRight_x = topLeft_x + self.foregroundContainerView.frame.size.width ;
    float topRight_y = topLeft_y ;
    float bottomLeft_x = topLeft_x;
    float bottomLeft_y = topLeft_y + self.foregroundContainerView.frame.size.height ;
    float bottomRight_x = topRight_x ;
    float bottomRight_y = bottomLeft_y; //y轴触控点初始值

    self.topLeftControl = [[UIView alloc]initWithFrame:CGRectMake(topLeft_x, topLeft_y, widthButton, widthButton)];
    self.topLeftControl.tag = 990;
    self.topLeftControl.backgroundColor = [UIColor whiteColor];
    self.topLeftControl.layer.cornerRadius = 15;

    self.topRightControl = [[UIView alloc]initWithFrame:CGRectMake(topRight_x, topRight_y, widthButton, widthButton)];
    self.topRightControl.backgroundColor = [UIColor whiteColor];
    self.topRightControl.tag = 991;
    self.topRightControl.layer.cornerRadius = 15;


    self.bottomLeftControl = [[UIView alloc]initWithFrame:CGRectMake(bottomLeft_x, bottomLeft_y, widthButton, widthButton)];
    self.bottomLeftControl.backgroundColor = [UIColor whiteColor];
    self.bottomLeftControl.tag = 992;
    self.bottomLeftControl.layer.cornerRadius = 15;


    self.bottomRightControl = [[UIView alloc]initWithFrame:CGRectMake(bottomRight_x, bottomRight_y, widthButton, widthButton)];
    self.bottomRightControl.backgroundColor = [UIColor whiteColor];
    self.bottomRightControl.tag = 993;
    self.bottomRightControl.layer.cornerRadius = 15;


    [self addSubview:self.topLeftControl];
    [self addSubview:self.topRightControl];
    [self addSubview:self.bottomLeftControl];
    [self addSubview:self.bottomRightControl];

    self.topLeftControl.alpha = kButtonAlpha;
    self.topRightControl.alpha = kButtonAlpha;
    self.bottomLeftControl.alpha = kButtonAlpha;
    self.bottomRightControl.alpha = kButtonAlpha;

    // 给当前需要校正的view添加手势操作
    UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(tapView:)];
    [self.foregroundContainerView addGestureRecognizer:gesture];
    self.foregroundContainerView.userInteractionEnabled = YES;
    //记录一下初始值point用与还原坐标点
    self.topLeftCenter_X = self.topLeftControl.centerX;
    self.topLeftCenter_Y = self.topLeftControl.centerY;

    self.topRightCenter_X = self.topRightControl.centerX;
    self.topRightCenter_Y = self.topRightControl.centerY;

    self.bottomLeftCenter_X = self.bottomLeftControl.centerX;
    self.bottomLeftCenter_Y = self.bottomLeftControl.centerY;

    self.bottomRightCenter_X = self.bottomRightControl.centerX;
    self.bottomRightCenter_Y = self.bottomRightControl.centerY;
    
    //初始化每个顶点point 用与计算累加移动坐标偏移距离
    self.topLeftPoint = self.topLeftControl.center;
    self.topRightPoint = self.topRightControl.center;
    self.bottomRightPoint = self.bottomRightControl.center;
    self.bottomLeftPoint = self.bottomLeftControl.center;
    
}

- (void)tapView:(UIPanGestureRecognizer *)recognizer
{
    UIView *controlPointView = (UIView *)[recognizer view];
    
    CGPoint translation = [recognizer translationInView:controlPointView];
        
    CGPoint locationPoint =  [recognizer locationInView:controlPointView];
    // 通过当前触摸范围 来判断矩形的四个区域 位置
    if (CGRectContainsPoint(CGRectMake(0, 0, self.foregroundContainerView.frame.size.width/2, self.foregroundContainerView.frame.size.height/2), locationPoint)){
        //左上矩形
        self.topLeftCenter_XT = self.topLeftControl.centerX += translation.x/kMoveOffset;
        self.topLeftCenter_YT = self.topLeftControl.centerY += translation.y/kMoveOffset;
        self.topLeftPoint = CGPointMake(self.topLeftCenter_XT , self.topLeftCenter_YT);
    }
    
    if (CGRectContainsPoint(CGRectMake(self.foregroundContainerView.frame.size.width/2, 0, self.foregroundContainerView.frame.size.width/2, self.foregroundContainerView.frame.size.height/2), locationPoint)){
        //右上矩形
        self.topRightCenter_XT = self.topRightControl.centerX += translation.x/kMoveOffset;
        self.topRightCenter_YT = self.topRightControl.centerY += translation.y/kMoveOffset;
        self.topRightPoint = CGPointMake(self.topRightCenter_XT, self.topRightCenter_YT);
    }
    
    if (CGRectContainsPoint(CGRectMake(0, self.foregroundContainerView.frame.size.height/2, self.foregroundContainerView.frame.size.width/2, self.foregroundContainerView.frame.size.height/2), locationPoint)){
        //左下矩形
        self.bottomLeftCenter_XT = self.bottomLeftControl.centerX += translation.x/kMoveOffset;
        self.bottomLeftCenter_YT = self.bottomLeftControl.centerY += translation.y/kMoveOffset;
        self.bottomLeftPoint = CGPointMake(self.bottomLeftCenter_XT, self.bottomLeftCenter_YT);
    }
    
    if (CGRectContainsPoint(CGRectMake(self.foregroundContainerView.frame.size.width/2, self.foregroundContainerView.frame.size.height/2, self.foregroundContainerView.frame.size.width/2, self.foregroundContainerView.frame.size.height/2), locationPoint)){
        //右下矩形
        self.bottomRightCenter_XT = self.bottomRightControl.centerX += translation.x/kMoveOffset;
        self.bottomRightCenter_YT = self.bottomRightControl.centerY += translation.y/kMoveOffset;
        self.bottomRightPoint  = CGPointMake(self.bottomRightCenter_XT, self.bottomRightCenter_YT);
    }
    
    [recognizer setTranslation:CGPointZero inView:self];
    //更新矫正点
    self.foregroundContainerView.layer.quadrilateral = AGKQuadMake(self.topLeftPoint,
                                                     self.topRightPoint,
                                                     self.bottomRightPoint,
                                                     self.bottomLeftPoint);
    
    //激活还原按钮代理
    if ([self.delegate respondsToSelector:@selector(cropViewDidBecomeResettable:)])
    {
        [self.delegate cropViewDidBecomeResettable:self];
    }

}

// 还原初始触控坐标点
- (void)restControlView {
    
    self.foregroundContainerView.transform = CGAffineTransformIdentity;
    
    self.topLeftControl.center = CGPointMake(self.topLeftCenter_X, self.topLeftCenter_Y);
    self.topRightControl.center = CGPointMake(self.topRightCenter_X, self.topRightCenter_Y);
    self.bottomRightControl.center = CGPointMake(self.bottomRightCenter_X, self.bottomRightCenter_Y);
    self.bottomLeftControl.center = CGPointMake(self.bottomLeftCenter_X, self.bottomLeftCenter_Y);
    
    //重置之前临时记录数据
    self.topLeftCenter_XT = 0;
    self.topLeftCenter_YT = 0;
    self.topRightCenter_XT = 0;
    self.topRightCenter_YT = 0;
    self.bottomLeftCenter_XT = 0;
    self.bottomLeftCenter_YT = 0;
    self.bottomRightCenter_XT = 0;
    self.bottomRightCenter_YT = 0;
    
    [self.foregroundContainerView.layer ensureAnchorPointIsSetToZero];

    self.foregroundContainerView.layer.quadrilateral = AGKQuadMake(self.topLeftControl.center,
                                                                   self.topRightControl.center,
                                                                   self.bottomRightControl.center,
                                                                   self.bottomLeftControl.center);
    
}

// 移除所有关联对象
- (void)removeAssociatedObjects{
    objc_removeAssociatedObjects(self);
}

- (void)dealloc {
    [self removeAssociatedObjects];
}





@end
