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
#import "JRTextToolView.h"
#import "JRTextToolOverlapView.h"
#import "JRTextTool.h"
#import "EdgeInsetsLabel.h";
NS_ASSUME_NONNULL_BEGIN

@interface JRTextToolView : UIView
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIColor *fillColor;
@property (nonatomic, strong) UIColor *borderColor;
@property (nonatomic, assign) CGFloat borderWidth;
@property (nonatomic, assign) NSTextAlignment textAlignment;
@property (nonatomic, strong) UIImage *image;

@property (nonatomic, strong) JRTextToolOverlapView *archerBGView;

@property (nonatomic,assign)BOOL isBagColorSelect;//是否背景选中


+ (void)setActiveTextView:(JRTextToolView *)view;
+ (void)setInactiveTextView:(JRTextToolView *)view;
+ (void)setNewActiveTextView:(JRTextToolView *)view;//激活文字编辑状态
+ (void)setNewActiveTextView:(JRTextToolView *)view withGesture:(UITapGestureRecognizer *)sender;
+ (void)hideTextBorder;

- (instancetype)initWithTool:(JRTextTool *)tool text:(NSString *)text font:(UIFont *)font orImage:(UIImage *)image;
- (void)rotate:(CGFloat)angle;
- (void)setScale:(CGFloat)scale;
- (void)sizeToFitWithMaxWidth:(CGFloat)width lineHeight:(CGFloat)lineHeight;
- (void)tapViewMethod:(UITapGestureRecognizer *)sender;
- (void)panViewMethod:(UIPanGestureRecognizer*)recognizer;
@end

@interface JRTextLabel : UILabel
@property (nonatomic, strong) UIColor *outlineColor;
@property (nonatomic, assign) CGFloat outlineWidth;
@property (nonatomic) UIEdgeInsets contentInset;

@end

NS_ASSUME_NONNULL_END
