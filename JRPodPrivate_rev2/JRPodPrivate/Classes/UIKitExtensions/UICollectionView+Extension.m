//
/**
 * 所属系统:
 * 所属模块:
 * 功能描述:
 * 创建时间: 2019/12/16
 * 维护人:  金煜祥
 * Copyright @ Jerrisoft 2019. All rights reserved.
 *┌─────────────────────────────────────────────────────┐
 *│ 此技术信息为本公司机密信息，未经本公司书面同意禁止向第三方披露．│
 *│ 版权所有：杰人软件(深圳)有限公司                          │
 *└─────────────────────────────────────────────────────┘
 */


#import "UICollectionView+Extension.h"
#include <objc/message.h>

@implementation UICollectionView (Extension)
-(void)collectionViewLayoutAlignmentLeft{
    SEL sel = NSSelectorFromString(@"_setRowAlignmentsOptions:");
    
    if ([self.collectionViewLayout respondsToSelector:sel]) {
        ((void(*)(id,SEL,NSDictionary*))objc_msgSend)(self.collectionViewLayout,sel,@{@"UIFlowLayoutCommonRowHorizontalAlignmentKey":@(NSTextAlignmentLeft),@"UIFlowLayoutLastRowHorizontalAlignmentKey" : @(NSTextAlignmentLeft),@"UIFlowLayoutRowVerticalAlignmentKey" : @(NSTextAlignmentCenter)});
        
    }
}

-(void)collectionViewLayoutAlignmentCenter{
    SEL sel = NSSelectorFromString(@"_setRowAlignmentsOptions:");
    
    if ([self.collectionViewLayout respondsToSelector:sel]) {
        ((void(*)(id,SEL,NSDictionary*))objc_msgSend)(self.collectionViewLayout,sel,@{@"UIFlowLayoutCommonRowHorizontalAlignmentKey":@(NSTextAlignmentCenter),@"UIFlowLayoutLastRowHorizontalAlignmentKey" : @(NSTextAlignmentRight),@"UIFlowLayoutRowVerticalAlignmentKey" : @(NSTextAlignmentCenter)});
        
    }
}
@end
