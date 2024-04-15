//
/**
* 所属系统: component
* 所属模块: 
* 功能描述: 
* 创建时间: 2020/9/26
* 维护人:  李志䶮
* Copyright © 2020 wni. All rights reserved.
*┌─────────────────────────────────────────────────────┐
*│ 此技术信息为本公司机密信息，未经本公司书面同意禁止向第三方披露．│
*│ 版权所有：杰人软件(深圳)有限公司                          │
*└─────────────────────────────────────────────────────┘
*/

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (JRNoticeRemind)

/// 年月日时间小于10两位变一位
/// @param timeString 时间字符串
+ (NSString *)dateStringRemoveZero:(NSString *)timeString;

/// 返回指定格式时间字符串
/// @param timeStamp 时间戳
+ (NSString *)changeTimeStamp:(NSInteger)timeStamp;

@end

NS_ASSUME_NONNULL_END
