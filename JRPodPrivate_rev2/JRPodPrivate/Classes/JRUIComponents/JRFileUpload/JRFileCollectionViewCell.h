//
/**
* 所属系统: YMMAD
* 所属模块: 
* 功能描述: 
* 创建时间: 2021/1/15
* 维护人:  Jedrek
* 
*┌─────────────────────────────────────────────────────┐
*│ 此技术信息为本公司机密信息，未经本公司书面同意禁止向第三方披露．│
*│ 版权所有：杰人软件(深圳)有限公司                          │
*└─────────────────────────────────────────────────────┘
*/

#import <UIKit/UIKit.h>
#import "JRFileModel.h"
@class JRProcessView;
NS_ASSUME_NONNULL_BEGIN

@interface JRFileCollectionViewCell : UICollectionViewCell
/// 文件类型标识图片
@property (nonatomic ,strong) UIImageView *imagev;
/// 删除按钮
@property (nonatomic ,strong) UIButton *deleteButton;
/// 文件标题
@property (nonatomic, strong) UILabel *titleLabel;
/// 失败显示文案
@property (nonatomic, strong) UILabel *faildTitleLabel;
/// 进度显示view
@property (nonatomic, strong) JRProcessView *matchProessView;
/// 文件类型model
@property (nonatomic, strong) JRFileModel *fileModel;

@end

NS_ASSUME_NONNULL_END
