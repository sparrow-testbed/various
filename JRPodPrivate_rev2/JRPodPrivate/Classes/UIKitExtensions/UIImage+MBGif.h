//
//  UIImage+MBGif.h
//  ManagementPlatform
//
//  Created by Y2785 on 2019/3/2.
//  Copyright © 2019 ITUser. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (MBGif)

//加载调整后的图片动画
+ (UIImage *)sd_animatedGIFNamed:(NSString *)name size:(CGSize)size;
//加载原图动画
+ (UIImage *)sd_animatedGIFNamed:(NSString *)name;

+ (UIImage *)sd_animatedGIFWithData:(NSData *)data;

- (UIImage *)sd_animatedImageByScalingAndCroppingToSize:(CGSize)size;

- (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)size;
@end


