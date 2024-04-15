//
/**
* 所属系统: YMMAD
* 所属模块: 
* 功能描述: 
* 创建时间: 2021/2/25
* 维护人:  马克
* 
*┌─────────────────────────────────────────────────────┐
*│ 此技术信息为本公司机密信息，未经本公司书面同意禁止向第三方披露．│
*│ 版权所有：杰人软件(深圳)有限公司                          │
*└─────────────────────────────────────────────────────┘
*/

#import "NSMutableArray+SafeArray.h"
#import <objc/runtime.h>
@implementation NSMutableArray (SafeArray)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        id obj = [[self alloc]init];
        [obj swizzleMethod:@selector(addObject:) withMethod:@selector(safeAddObject:)];
        [obj swizzleMethod:@selector(objectAtIndex:) withMethod:@selector(safeObjectAtIndex:)];
        
    });
}

- (void)safeAddObject:(id)anObject
{
    if (anObject) {
        [self safeAddObject:anObject];
    }else{
        NSLog(@"obj is nil");
    }
}

- (id)safeObjectAtIndex:(NSInteger)index
{
    if(index<[self count]){
        return [self safeObjectAtIndex:index];
    }else{
        NSLog(@"index is beyond bounds ");
    }
    return nil;
}


- (void)swizzleMethod:(SEL)orgSelector withMethod:(SEL)newSelector {
    Class cls = [self class];
    Method  originleMethod = class_getInstanceMethod(cls, orgSelector);
    Method  swizzeMethod = class_getInstanceMethod(cls, newSelector);
    BOOL didAddMethod = class_addMethod(cls, orgSelector, method_getImplementation(swizzeMethod), method_getTypeEncoding(swizzeMethod));
    if (didAddMethod) {
        class_replaceMethod(cls, newSelector, method_getImplementation(originleMethod), method_getTypeEncoding(originleMethod));
    }else {
        method_exchangeImplementations(originleMethod, swizzeMethod);
    }
}

@end
