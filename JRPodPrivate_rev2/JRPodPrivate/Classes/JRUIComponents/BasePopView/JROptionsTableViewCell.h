//
/**
* 所属系统: component
* 所属模块:
* 功能描述:
* 创建时间: 2020/9/16
* 维护人:  王伟
* Copyright © 2020 杰人软件. All rights reserved.
*┌─────────────────────────────────────────────────────┐
*│ 此技术信息为本公司机密信息，未经本公司书面同意禁止向第三方披露．│
*│ 版权所有：杰人软件(深圳)有限公司                          │
*└─────────────────────────────────────────────────────┘
*/

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JROptionsTableViewCell : UITableViewCell
@property(nonatomic,strong)UILabel *txtLabel;//描述

@property(nonatomic,strong)UIImageView *selectImage;//选中图片

@property(nonatomic,strong)UILabel *line;

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier;
//更新cell，需要传递数据源array，cell的序号，是否多选
- (void)updateView:(NSString*)title withOptions:(BOOL)options withidx:(NSInteger)idx withSelect:(NSArray *)selectArray;
@end

NS_ASSUME_NONNULL_END
