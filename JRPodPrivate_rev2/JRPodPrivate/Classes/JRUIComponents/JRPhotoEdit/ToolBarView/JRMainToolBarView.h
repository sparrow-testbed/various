//
/**
* 所属系统: YMMAD
* 所属模块: 
* 功能描述: 
* 创建时间: 2021/3/10
* 维护人:  马克
* 
*┌─────────────────────────────────────────────────────┐
*│ 此技术信息为本公司机密信息，未经本公司书面同意禁止向第三方披露．│
*│ 版权所有：杰人软件(深圳)有限公司                          │
*└─────────────────────────────────────────────────────┘
*/

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, PhotoEditType)
{
    kPhotoEditCamare,
//    kPhotoEditAsset,
    kPhotoEditOtherType,

};


typedef void(^SelectItemClick)(NSUInteger index);

typedef void (^SelectDoneClick)(void);

NS_ASSUME_NONNULL_BEGIN
static CGFloat rotateToolBarHeight = 70.0f;

@interface JRMainToolBarView : UIView

@property (nonatomic, copy) SelectItemClick selectItemClick;

@property (nonatomic, copy) SelectDoneClick selectDoneClick;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, assign) PhotoEditType editType;

/**
 确认按钮
 */
@property (nonatomic, strong) UIButton *confirmButton;

-(void)buildLayout;//初始化编辑按钮显示

@end

NS_ASSUME_NONNULL_END
