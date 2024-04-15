/**
 * 所属系统: TIM
 * 所属模块: 聊天类：录制视频
 * 功能描述: 自定义视频预览界面
 * 创建时间: 2019/9/16.
 * 维护人:  石拓
 * Copyright @ Jerrisoft 2019. All rights reserved.
 *┌─────────────────────────────────────────────────────┐
 *│ 此技术信息为本公司机密信息，未经本公司书面同意禁止向第三方披露．│
 *│ 版权所有：杰人软件(深圳)有限公司                          │
 *└─────────────────────────────────────────────────────┘
 */

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

typedef void(^RecordPlayerViewCancelBlock)(void);
typedef void(^RecordPlayerViewConfirmBlock)(void);

@interface JRRecordPlayerView : UIView

/// 取消回调
@property (nonatomic, copy) RecordPlayerViewCancelBlock cancelBlock;

/// 确认回调
@property (nonatomic, copy) RecordPlayerViewConfirmBlock confirmBlock;

/// 预览路径
@property (nonatomic, strong) NSURL *playUrl;

/// 定制拍照完成按钮文字提示
@property (nonatomic, strong) NSString *confirmTitle;


- (void)configChatVideoPlay;

@end
