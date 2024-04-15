//
//  JRImagePickerController.h
//  JRPodPrivate_Example
//
//  Created by 金煜祥 on 2020/9/21.
//  Copyright © 2020 wni. All rights reserved.
//

#import "JRUIKit.h"

NS_ASSUME_NONNULL_BEGIN

@interface JRImagePickerController : TZImagePickerController

/// 视频可选限制时长（单位分钟）
@property(nonatomic,assign)NSInteger videoLimitMaxDuration;
@property(nonatomic,strong)NSString * doneBottonString;
@end

NS_ASSUME_NONNULL_END
