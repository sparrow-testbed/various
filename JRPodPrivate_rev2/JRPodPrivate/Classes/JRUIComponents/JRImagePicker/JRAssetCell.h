//
//  JRAssetCell.h
//  JRPodPrivate_Example
//
//  Created by 金煜祥 on 2020/9/28.
//  Copyright © 2020 wni. All rights reserved.
//
#import "TZAssetCell.h"
NS_ASSUME_NONNULL_BEGIN

@interface JRAssetCell : TZAssetCell
/// 视频可选限制时长（单位分钟）
@property(nonatomic,assign)NSInteger videoLimitMaxDuration;

@end

NS_ASSUME_NONNULL_END
