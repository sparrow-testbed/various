//
//  TZAssetModel+JRAddProperty.m
//  JRPodPrivate_Example
//
//  Created by 金煜祥 on 2020/9/25.
//  Copyright © 2020 wni. All rights reserved.
//

#import "TZAssetModel+JRAddProperty.h"

static const void * ThumbImage = &ThumbImage;
@implementation TZAssetModel (JRAddProperty)

- (void)setThumbImage:(UIImage *)thumbImage{
     objc_setAssociatedObject(self, @selector(thumbImage), thumbImage, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (UIImage *)thumbImage{
     return objc_getAssociatedObject(self, @selector(thumbImage));
}
@end
