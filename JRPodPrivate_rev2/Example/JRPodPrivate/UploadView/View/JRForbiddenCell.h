//
/**
* 所属系统: YMMAD
* 所属模块: 
* 功能描述: 
* 创建时间: 2021/2/20
* 维护人:  马克
* Copyright © 2021 wni. All rights reserved.
*┌─────────────────────────────────────────────────────┐
*│ 此技术信息为本公司机密信息，未经本公司书面同意禁止向第三方披露．│
*│ 版权所有：杰人软件(深圳)有限公司                          │
*└─────────────────────────────────────────────────────┘
*/

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JRForbiddenCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *addImage;
@property (assign,nonatomic) BOOL isState; //状态禁用还是正常
@end

NS_ASSUME_NONNULL_END
