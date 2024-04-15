//
/**
* 所属系统: YMMAD
* 所属模块: 
* 功能描述: 
* 创建时间: 2021/5/18
* 维护人:  马克
* 
*┌─────────────────────────────────────────────────────┐
*│ 此技术信息为本公司机密信息，未经本公司书面同意禁止向第三方披露．│
*│ 版权所有：杰人软件(深圳)有限公司                          │
*└─────────────────────────────────────────────────────┘
*/

#import "JRPhotoImageEditorViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JRPhotoImageEditorViewController (CorrectView)
- (void)beginCorrectView;
- (void)buildCorrectCategoryImageWithBorder:(BOOL)border complete:(void(^)(UIImage *correctImage))complete;
@end

NS_ASSUME_NONNULL_END
