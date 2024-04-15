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

@class JRAlertView;

typedef void (^OnButtonClickBlock)(JRAlertView *alertView, NSInteger buttonIndex);
typedef void (^OnButtonTextfieldClick)(JRAlertView *alertView, NSInteger buttonIndex, NSString *text);

@interface JRAlertView : UIView
/**
 外层dialog视图
 */
@property (nonatomic, strong) UIView *dialogView;

/**
 自定义的布局（子视图）
 */
@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UITextField *textField;

/**
 按钮标题数组
 */
@property (nonatomic, strong) NSArray *buttonTitles;

@property (nonatomic, strong) UIView * titleView;

@property (nonatomic, assign) CGFloat titleHeight;
@property (nonatomic, copy) OnButtonClickBlock onButtonClickBlock; // 按钮点击事件
@property (nonatomic, copy) OnButtonTextfieldClick onButtonTextFieldClick;

+ (void)initWithTitle:(NSString *)msg
         ButtonTitles:(NSArray *)buttonArr
            IsWarning:(BOOL)isWarning
        warnImageName:(nullable NSString *)warnImageName
                Block:(OnButtonClickBlock)complete;

+ (void)initWithTitle:(NSString *)msg
             subTitle:(NSString *)subTitle
         ButtonTitles:(NSArray *)buttonArr
            IsWarning:(BOOL)isWarning
        warnImageName:(nullable NSString *)warnImageName
                Block:(OnButtonClickBlock)complete;


+ (void)initAlertWithTextfieldMsg:(NSString *)msg
                        PlaceHold:(NSString *)placehold
                     ButtonTitles:(NSArray *)buttonArr
                        IsWarning:(BOOL)isWarning
                       WorningStr:(NSString *)warningStr
                            Block:(OnButtonTextfieldClick)complete;
+ (void)initAlertWithTitleView:(UIView *)titleView
                   titleHeight:(CGFloat)titleHeight
                  ButtonTitles:(NSArray *)buttonArr
                     IsWarning:(BOOL)isWarning
                 warnImageName:(nullable NSString *)warnImageName
                         Block:(OnButtonClickBlock)complete;
@end

NS_ASSUME_NONNULL_END
