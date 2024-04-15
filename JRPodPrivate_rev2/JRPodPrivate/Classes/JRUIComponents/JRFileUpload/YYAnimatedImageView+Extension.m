//
/**
* 所属系统: YMMAD
* 所属模块: 
* 功能描述: 
* 创建时间: 2021/3/22
* 维护人:  马克
* 
*┌─────────────────────────────────────────────────────┐
*│ 此技术信息为本公司机密信息，未经本公司书面同意禁止向第三方披露．│
*│ 版权所有：杰人软件(深圳)有限公司                          │
*└─────────────────────────────────────────────────────┘
*/

#import "YYAnimatedImageView+Extension.h"
#import <objc/message.h>

@implementation YYAnimatedImageView (Extension)

+ (void)load {
    // hook：钩子函数
        Method method1 = class_getInstanceMethod(self, @selector(displayLayer:));
        
        Method method2 = class_getInstanceMethod(self, @selector(dx_displayLayer:));
        method_exchangeImplementations(method1, method2);
}

-(void)dx_displayLayer:(CALayer *)layer {
    
//    if ([UIImageView instancesRespondToSelector:@selector(displayLayer:)]) {
//        [super displayLayer:layer];
//    }
    
    Ivar ivar = class_getInstanceVariable(self.class, "_curFrame");

        UIImage *_curFrame = object_getIvar(self, ivar);

        if (_curFrame) {

          layer.contents = (__bridge id)_curFrame.CGImage;
        }else{

          if (@available(iOS 14.0, *)) {

              [super displayLayer:layer];

          }
        }
    
}

@end
