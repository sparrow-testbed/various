//
//  CollectionViewCell.h
//  多选图片
//
//  Created by holier_zyq on 2016/10/24.
//  Copyright © 2016年 holier_zyq. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JRProcessView;
@class JRImageUploadModel;

@interface JRImageCollectionViewCell : UICollectionViewCell
/// 显示图片
@property (nonatomic ,strong) UIImageView *imagev;
/// 删除按钮
@property (nonatomic ,strong) UIButton *deleteButton;
/// 播放按钮
@property (nonatomic ,strong) UIButton *playButton;
/// 进度值
@property (nonatomic, assign) CGFloat progress;
/// 进行动画VIew
@property (nonatomic ,strong) JRProcessView *circleView1;
/// 失败遮罩view
@property (nonatomic,strong) UIView *faildMaskView;
/// 图片model
@property (nonatomic,strong) JRImageUploadModel * fileModel;

@end
