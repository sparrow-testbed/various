//
/**
* 所属系统: YMMAD
* 所属模块: 
* 功能描述: 
* 创建时间: 2021/3/12
* 维护人:  朱俊标
* 
*┌─────────────────────────────────────────────────────┐
*│ 此技术信息为本公司机密信息，未经本公司书面同意禁止向第三方披露．│
*│ 版权所有：杰人软件(深圳)有限公司                          │
*└─────────────────────────────────────────────────────┘
*/

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ImageEditType)
{
    kImageEditNormal,
    kImageEditOtherType,

};

@protocol JRImageEditorDelegate;


NS_ASSUME_NONNULL_BEGIN

@interface JRImageEditor : UIViewController

@property (nonatomic, assign) ImageEditType editType; // 按钮返回类型

/**
  拍照完成 定制 按钮标题
 */
@property (nonatomic, strong) NSString *confirmTitle;

@property (nonatomic, weak) id<JRImageEditorDelegate> delegate;

@property (nonatomic, assign) BOOL isTextTool;



- (id)initWithImage:(UIImage*)image
           delegate:(id<JRImageEditorDelegate>)delegate;

- (void)addTransitionAnimation:(UIView *)animatinView;
@end



@protocol JRImageEditorDelegate <NSObject>

@optional
- (void)imageEditor:(JRImageEditor *)imageEditor didFinishEdittingWithImage:(UIImage *)image;
- (void)imageEditorDidCancel:(JRImageEditor *)editor;

@end

NS_ASSUME_NONNULL_END
