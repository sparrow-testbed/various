//
//  JRAssetCell.m
//  JRPodPrivate_Example
//
//  Created by 金煜祥 on 2020/9/28.
//  Copyright © 2020 wni. All rights reserved.
//

#import "JRAssetCell.h"
#import "JRUIKit.h"
#import "UIView+TZLayout.h"

@implementation JRAssetCell

- (void)selectPhotoButtonClick:(UIButton *)sender {
    if (self.model.type == TZAssetModelMediaTypeVideo) {
        BOOL  flag = self.model.asset.duration > self.videoLimitMaxDuration * 60 && self.videoLimitMaxDuration > 0;
        if (flag) {
            [MBProgressHUD showHUD:[NSString stringWithFormat:@"视频时长超过%ld分钟,无法分享",(long)self.videoLimitMaxDuration]];
            return;
        }
    }
    
    if (self.didSelectPhotoBlock) {
        self.didSelectPhotoBlock(sender.isSelected);
    }
    UIImageView * selectImageView = [self valueForKey:@"selectImageView"];
    selectImageView.image = sender.isSelected ? self.photoSelImage : self.photoDefImage;
    if (sender.isSelected) {
        [UIView showOscillatoryAnimationWithLayer:selectImageView.layer type:TZOscillatoryAnimationToBigger];
        // 用户选中了该图片，提前获取一下大图
        [self performSelector:@selector(requestBigImage)];
    } else { // 取消选中，取消大图的获取
        [self performSelector:@selector(cancelBigImageRequest)];
    }
}


@end
