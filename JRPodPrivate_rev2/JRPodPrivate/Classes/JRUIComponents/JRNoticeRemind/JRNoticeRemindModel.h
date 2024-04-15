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

@interface JRNoticeRemindModel : NSObject

/// 标题
@property (nonatomic, copy) NSString *title;
/// 日期字段
@property (nonatomic, copy) NSString *createTime;
/// 详细内容
@property (nonatomic, copy) NSString *body;
/// 头部内容
@property (nonatomic, copy) NSString *headerContent;
/// 底部内容
@property (nonatomic, copy) NSString *bottomContent;
/// 是否有详情
@property (nonatomic, assign) BOOL hasDetail;
/// 中间内容(字典数组)
@property (nonatomic, copy) NSArray *contentArray;
/// 可读
@property (nonatomic, assign) BOOL isRead;
//其它字段 兼容
@property (nonatomic,copy)NSString *others;

@property (nonatomic, assign) NSInteger centerContentHeight;

@end

@interface JRNoticeContentModel : NSObject

@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) NSString *value;

@end

NS_ASSUME_NONNULL_END
