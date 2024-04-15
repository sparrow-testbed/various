//
/**
* 所属系统: YMMAD
* 所属模块: 
* 功能描述: 
* 创建时间: 2021/3/12
* 维护人:  马克
* 
*┌─────────────────────────────────────────────────────┐
*│ 此技术信息为本公司机密信息，未经本公司书面同意禁止向第三方披露．│
*│ 版权所有：杰人软件(深圳)有限公司                          │
*└─────────────────────────────────────────────────────┘
*/

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "JRImageEditor.h"
#import "TOCropScrollView.h"
#import "JRDrawView.h"
#import "JRScratchView.h"
#import "JRMainToolBarView.h"
@class JRImageToolBase;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, JREditorMode)
{
    JREditorModeNone = 0,
    JREditorModeDraw,
    JREditorModeAdjust,
    JREditorModeText,
    JREditorModeClip,
    JREditorModePerspective,  //透视拉伸
    JREditorModeMosica // 马赛克
};

@interface JRPhotoImageEditorViewController : JRImageEditor
@property (nonatomic, copy) UIImage *originImage;
@property (strong, nonatomic) TOCropScrollView *scrollView;
@property (weak, nonatomic) UIImageView *imageView;
@property (nonatomic, assign, readonly) CGSize originSize;
@property (nonatomic, assign, readonly) CGSize originCorrectSize;
@property (strong, nonatomic) UIView *containerView;

///涂鸦画板view
@property (strong, nonatomic) JRDrawView *drawingView;
///马赛克画板view
@property (strong, nonatomic) JRScratchView *mosicaView;
///当前的编辑模式
@property (nonatomic, assign) JREditorMode currentMode;
@property (nonatomic, weak) id dataSource;
@property (nonatomic, assign, readonly) BOOL barsHiddenStatus;
///工具栏
@property (nonatomic, strong)JRMainToolBarView *mainToolBarView;

@property(nonatomic,strong,readonly)JRImageToolBase *currentTool;

/**
 取消按钮
 */
@property (nonatomic, strong) UIButton *cancelButton;

@property (nonatomic, assign) CGRect lastCropRect;
@property (nonatomic, assign) CGFloat lastAngle;

// 最原始矫正功能 暂时不用
@property (nonatomic, strong)  UIImageView *topLeftControl;
@property (nonatomic, strong)  UIImageView *topRightControl;
@property (nonatomic, strong)  UIImageView *bottomLeftControl;
@property (nonatomic, strong)  UIImageView *bottomRightControl;

- (void)resetCurrentTool;

- (void)editTextAgain;

- (void)panAction;

- (void)paperAction;

- (void)hiddenTopAndBottomBar:(BOOL)isHide
                    animation:(BOOL)animation;

@end
NS_ASSUME_NONNULL_END
