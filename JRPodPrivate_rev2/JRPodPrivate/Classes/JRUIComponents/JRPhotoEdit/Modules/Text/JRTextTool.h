//
/**
* 所属系统: YMMAD
* 所属模块: 
* 功能描述: 
* 创建时间: 2021/3/16
* 维护人:  马克
* 
*┌─────────────────────────────────────────────────────┐
*│ 此技术信息为本公司机密信息，未经本公司书面同意禁止向第三方披露．│
*│ 版权所有：杰人软件(深圳)有限公司                          │
*└─────────────────────────────────────────────────────┘
*/

#import "JRImageToolBase.h"
#import "JRTextColorPanel.h"

@class JRTextView;
NS_ASSUME_NONNULL_BEGIN

typedef void(^ChangeTextBagColorCallback)(UIColor *bagColor,BOOL isChangeColor);//改变lable背景色

@interface JRTextTool : JRImageToolBase
@property (nonatomic, copy) void(^dissmissTextTool)(NSString *currentText);//, BOOL isEditAgain);
@property (nonatomic, strong) JRTextView *textView;
@property (nonatomic, assign) BOOL isEditAgain;
@property (nonatomic, assign) BOOL isChangeTexbagColor;
@property (nonatomic, copy) void(^editAgainCallback)(NSString *text,BOOL isChangeBagColor,UIColor *currentColor);
@property (nonatomic, copy) ChangeTextBagColorCallback  changeTextBagColorCallback;
@property (nonatomic, weak) JRTextColorPanel *textColorPanel;
@property (nonatomic,strong)UIColor *bagroundColor;//背景色
@property (nonatomic,assign)BOOL lastChangeBagColor;//记录一下旧的背景色改变状态


- (void)hideTextBorder;
//判断颜色是否一致
-(BOOL)firstColor:(UIColor*)firstColor secondColor:(UIColor*)secondColor;

@end


@interface JRTextView : UIView
@property (nonatomic, strong) UIView *effectView;
@property (nonatomic, copy) void(^dissmissTextTool)(NSString *currentText, BOOL isUse);//, BOOL isEditAgain);
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, weak) JRTextColorPanel *colorPanel;
@property (nonatomic, strong) JRTextTool *textTool;
@end


NS_ASSUME_NONNULL_END
