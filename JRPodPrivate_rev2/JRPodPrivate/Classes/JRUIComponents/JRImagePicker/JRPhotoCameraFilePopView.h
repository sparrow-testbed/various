//
//  JRPhotoCamerFilePopView.h
//  JRPodPrivate_Example
//
//  Created by J0224 on 2020/11/24.
//  Copyright © 2020 wni. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^JRPhotoCameraFileBlock)(NSString *title,NSInteger row);
@interface JRPhotoCameraFilePopView : UIView

@property (nonatomic,copy)JRPhotoCameraFileBlock block;

/// 初始化
/// @param frame frame description
/// @param titleArray @[@"拍摄",@"相册",@"文件"]
/// @param imageArray  @[@"btn_shoot_chat",@"btn_photo_chat",@"btn_file_chat"];
- (instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray *)titleArray imageArray:(NSArray *)imageArray;

//页面展示
- (void)show;
//页面隐藏
- (void)hidden;
@end

NS_ASSUME_NONNULL_END
