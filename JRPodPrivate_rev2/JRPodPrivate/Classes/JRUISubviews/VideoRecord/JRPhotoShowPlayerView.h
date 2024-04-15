//
/**
* 所属系统: TIM
* 所属模块: 
* 功能描述: 
* 创建时间: 2020/3/2.
* 维护人:  金煜祥
* Copyright @ Jerrisoft 2020. All rights reserved.
*┌─────────────────────────────────────────────────────┐
*│ 此技术信息为本公司机密信息，未经本公司书面同意禁止向第三方披露．│
*│ 版权所有：杰人软件(深圳)有限公司                          │
*└─────────────────────────────────────────────────────┘
*/
       

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

typedef void(^RecordPlayerViewCancelBlock)(void);
typedef void(^RecordPlayerViewConfirmBlock)(void);
NS_ASSUME_NONNULL_BEGIN

@interface JRPhotoShowPlayerView : UIView
/// 取消回调
@property (nonatomic, copy) RecordPlayerViewCancelBlock cancelBlock;

/// 确认回调
@property (nonatomic, copy) RecordPlayerViewConfirmBlock confirmBlock;

/// 预览路径
@property (nonatomic, strong) NSURL *imageUrl;

/**
 取消按钮
 */
@property (nonatomic, strong) UIButton *cancelButton;

/**
 确认按钮
 */
@property (nonatomic, strong) UIButton *confirmButton;

/**
 图片展示
 */
@property (nonatomic, strong) UIImageView *imageView;


- (instancetype)initWithFrame:(CGRect)frame andImage:(UIImage *)image;
@end

NS_ASSUME_NONNULL_END
