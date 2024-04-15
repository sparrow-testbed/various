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

#import <UIKit/UIKit.h>

@protocol JRKeyboardProtocol <NSObject>
@required
- (CGFloat)keyboardHeight;

@end

@protocol JRKeyboardDelegate <NSObject>

@optional
- (void)chatKeyboardWillShow:(id)keyboard animated:(BOOL)animated;
- (void)chatKeyboardDidShow:(id)keyboard animated:(BOOL)animated;
- (void)chatKeyboardWillDismiss:(id)keyboard animated:(BOOL)animated;
- (void)chatKeyboardDidDismiss:(id)keyboard animated:(BOOL)animated;
- (void)chatKeyboard:(id)keyboard didChangeHeight:(CGFloat)height;

@end

@interface JRbaseKeyboard : UIView<JRKeyboardProtocol>
///是否正在展示
@property (nonatomic, assign, readonly) BOOL isShow;

///键盘事件回调
@property (nonatomic, weak) id<JRKeyboardDelegate> keyboardDelegate;

/**
 *  显示键盘(keyWindow上)
 *  @param animation 是否显示动画
 */
- (void)showWithAnimation:(BOOL)animation;

/**
 *  显示键盘
 *  @param view      父view
 *  @param animation 是否显示动画
 */
- (void)showInView:(UIView *)view withAnimation:(BOOL)animation;

/**
 *  键盘消失
 *  @param animation 是否显示消失动画
 */
- (void)dismissWithAnimation:(BOOL)animation;

/**
 *  重置键盘⌨️
 */
- (void)reset;
@end

