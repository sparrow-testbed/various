/**
 * 所属系统: TIM
 * 所属模块: 聊天类：录制视频
 * 功能描述: 自定义视频录制进度倒计时界面
 * 创建时间: 2019/9/16.
 * 维护人:  石拓
 * Copyright @ Jerrisoft 2019. All rights reserved.
 *┌─────────────────────────────────────────────────────┐
 *│ 此技术信息为本公司机密信息，未经本公司书面同意禁止向第三方披露．│
 *│ 版权所有：杰人软件(深圳)有限公司                          │
 *└─────────────────────────────────────────────────────┘
 */

#import <UIKit/UIKit.h>

@interface JRVideoRecordProgressView : UIView

/**
 总进度
 */
@property (nonatomic,assign) CGFloat totolProgress;

/**
 当前进度
 */
@property (nonatomic,assign) CGFloat progress;

@end
