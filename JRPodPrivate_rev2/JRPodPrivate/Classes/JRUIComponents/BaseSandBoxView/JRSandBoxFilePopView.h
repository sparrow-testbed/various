//
/**
* 所属系统: component
* 所属模块: 
* 功能描述: 
* 创建时间: 2020/9/28
* 维护人:  王伟
* Copyright © 2020 wni. All rights reserved.
*┌─────────────────────────────────────────────────────┐
*│ 此技术信息为本公司机密信息，未经本公司书面同意禁止向第三方披露．│
*│ 版权所有：杰人软件(深圳)有限公司                          │
*└─────────────────────────────────────────────────────┘
*/

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol JRSandBoxFilePopViewDelegate <NSObject>

- (void)sandBoxFilePopViewSelect:(BOOL)hidden idx:(NSInteger)idx;

@end
@interface JRSandBoxFilePopView : UIView
@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,assign)id<JRSandBoxFilePopViewDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
