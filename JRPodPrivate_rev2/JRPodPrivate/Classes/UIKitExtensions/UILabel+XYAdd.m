//
//  UILabel+XYAdd.m
//  ArtLibrary
//
//  Created by 徐勇 on 16/8/1.
//  Copyright © 2016年 徐勇. All rights reserved.
//

#import "UILabel+XYAdd.h"
#import <objc/runtime.h>
#import "JRUIKit.h"

/// 获取UIEdgeInsets在水平方向上的值
CG_INLINE CGFloat
UIEdgeInsetsGetHorizontalValue(UIEdgeInsets insets) {
    return insets.left + insets.right;
}

/// 获取UIEdgeInsets在垂直方向上的值
CG_INLINE CGFloat
UIEdgeInsetsGetVerticalValue(UIEdgeInsets insets) {
    return insets.top + insets.bottom;
}

CG_INLINE void
ReplaceMethod(Class _class, SEL _originSelector, SEL _newSelector) {
    Method oriMethod = class_getInstanceMethod(_class, _originSelector);
    Method newMethod = class_getInstanceMethod(_class, _newSelector);
    BOOL isAddedMethod = class_addMethod(_class, _originSelector, method_getImplementation(newMethod), method_getTypeEncoding(newMethod));
    if (isAddedMethod) {
        class_replaceMethod(_class, _newSelector, method_getImplementation(oriMethod), method_getTypeEncoding(oriMethod));
    } else {
        method_exchangeImplementations(oriMethod, newMethod);
    }
}

@implementation UILabel (XYAdd)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ReplaceMethod([self class], @selector(drawTextInRect:), @selector(yf_drawTextInRect:));
        ReplaceMethod([self class], @selector(sizeThatFits:), @selector(yf_sizeThatFits:));
    });
}

- (void)yf_drawTextInRect:(CGRect)rect {
    UIEdgeInsets insets = self.contentInsets;
    [self yf_drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}

- (CGSize)yf_sizeThatFits:(CGSize)size {
    UIEdgeInsets insets = self.contentInsets;
    size = [self yf_sizeThatFits:CGSizeMake(size.width - UIEdgeInsetsGetHorizontalValue(insets), size.height-UIEdgeInsetsGetVerticalValue(insets))];
    size.width += UIEdgeInsetsGetHorizontalValue(insets);
    size.height += UIEdgeInsetsGetVerticalValue(insets);
    return size;
}

const void *kAssociatedYf_contentInsets;
- (void)setContentInsets:(UIEdgeInsets)yf_contentInsets {
    objc_setAssociatedObject(self, &kAssociatedYf_contentInsets, [NSValue valueWithUIEdgeInsets:yf_contentInsets] , OBJC_ASSOCIATION_RETAIN);
}

- (UIEdgeInsets)contentInsets {
    return [objc_getAssociatedObject(self, &kAssociatedYf_contentInsets) UIEdgeInsetsValue];
}


- (void)setText:(NSString*)text lineSpacing:(CGFloat)lineSpacing {
    
    /**
     
    - 作为一个四处使用的工具方法，前面的nil检查很有必要加。因为[[NSMutableAttributedString alloc] initWithString:text] 不接受 nil 参数，会直接 crash。
     
    - 生成的 paragraphStyle 除了配行距之外，还带上了 label 原有的一些常用属性。如果有其他需要，也可以加在这里。
     
    - 代码传参数进去的行距与设计图上量出来的行距是有区别的，代码上要少几个像素，而减少的量跟字体大小有关。
     
     font size  font.lineHeight（近似） 差值
     
     10             12              2
     
     11             13              2
     
     12             14              2
     
     13             15.5            2.5
     
     14             17              3
     
     15             18              3
     
     16             19              3
     
     17             20              3
     
     18             21.5            3.5
     
     19             23              4
     
     20             24              4
     
      - 为了计算效率高，我们就不在运行时现算这个差值了；直接把设计图上量出的行距减去上面这个表里几个像素的差值，作为参数传进去即可。例如：14 号字的 label，设计图上量出的行距是 5 个像素，那就减去 3 个像素，写[label setText:text lineSpacing:2.0f];。不要忘了计算行高的时候也要用同样的参数~
     */
    
    /*********************************************************************/
    //        NSString *labelText = _viewModel.userInfo.resumes ;
    //
    //        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
    //        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    //        [paragraphStyle setLineSpacing:4];//调整行间距
    //
    //        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    //
    //        self.detialLabel.attributedText = attributedString;
    // [self.detialLabel sizeToFit];
    /*********************************************************************/
    
    if (lineSpacing < 0.01 || !text) {
        self.text = text;
        return;
    }
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    [attributedString addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, [text length])];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    // 行间距
    [paragraphStyle setLineSpacing:lineSpacing];
    // 段间距
    [paragraphStyle setParagraphSpacing:5];
    
    //第一行头缩进
    //[paragraphStyle setFirstLineHeadIndent:15.0];
    //头部缩进
    //[paragraphStyle setHeadIndent:15.0];
    //尾部缩进
    //[paragraphStyle setTailIndent:250.0];
    //最小行高
    //[paragraphStyle setMinimumLineHeight:20.0];
    //最大行高
    //[paragraphStyle setMaximumLineHeight:20.0];
    
    [paragraphStyle setLineBreakMode:self.lineBreakMode];
    [paragraphStyle setAlignment:self.textAlignment];
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    
    self.attributedText = attributedString;
}

- (CGFloat)text:(NSString*)text heightWithFontSize:(CGFloat)fontSize width:(CGFloat)width lineSpacing:(CGFloat)lineSpacing {
    
    // 自定义行距之后，计算文本高度的方法也得相应改。很简单，只要利用 sizeToFit、sizeThatFits 之类的方法就可以了。
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, MAXFLOAT)];
    label.font = [UIFont systemFontOfSize:fontSize];
    label.numberOfLines = 0;
    [label setText:text lineSpacing:lineSpacing];
    [label sizeToFit];// 获取合适的文本size  根据文本内容返回最佳的尺寸
    
    return label.height;
}

+ (CGFloat)text:(NSString*)text heightWithFontSize:(CGFloat)fontSize width:(CGFloat)width lineSpacing:(CGFloat)lineSpacing {
    
    // 自定义行距之后，计算文本高度的方法也得相应改。很简单，只要利用 sizeToFit、sizeThatFits 之类的方法就可以了。
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, MAXFLOAT)];
    label.font = [UIFont systemFontOfSize:fontSize];
    label.numberOfLines = 0;
    [label setText:text lineSpacing:lineSpacing];
    [label sizeToFit];// 获取合适的文本size  根据文本内容返回最佳的尺寸
    
    return label.height;
}

/// 计算富文本行高
+ (CGFloat)heightWithText:(NSAttributedString *)text
                 fontSize:(CGFloat)fontSize
                    width:(CGFloat)width
              lineSpacing:(CGFloat)lineSpacing {
    
    UILabel *label = [[UILabel alloc]init];
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:fontSize];
    [label setAttributedText:text];
    CGSize maximumLabelSize = CGSizeMake(width, MAXFLOAT);//labelsize的最大值
    
    //根据文本内容返回最佳的尺寸
    CGSize expectSize = [label sizeThatFits:maximumLabelSize];
    //设置label的frame
    return  expectSize.height + 2;
}

- (CGFloat)paragraphLabelHeightWithText:(NSString *)text
                               maxWidth:(CGFloat)maxWidth
                            lineSpacing:(CGFloat)lineSpacing {
    
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:text];
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:lineSpacing];
    
    NSInteger leng = maxWidth;
    
    if (attStr.length < maxWidth)  leng = attStr.length;
    [attStr addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, leng)];
    
    self.attributedText = attStr;
    CGSize labelSize = [self sizeThatFits:CGSizeMake(maxWidth, MAXFLOAT)];
    
    return labelSize.height;
}

#pragma mark -

//给UILabel设置行间距和字间距
+ (void)setLabelSpace:(UILabel *)label
               string:(NSString *)str
                 font:(UIFont *)font
            lineSpace:(CGFloat)lineSpace {
    
        NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
        paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
        paraStyle.alignment = NSTextAlignmentLeft;
        paraStyle.lineSpacing = lineSpace; //设置行间距
        paraStyle.hyphenationFactor = 1.0;
        paraStyle.firstLineHeadIndent = 0.0;
        paraStyle.paragraphSpacingBefore = 0.0;
        paraStyle.headIndent = 0;
        paraStyle.tailIndent = 0;
        //设置字间距 NSKernAttributeName:@1.5f
    //    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@1.5f
    //                          };
    
        NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle};
    
        NSAttributedString *attributeStr = [[NSAttributedString alloc] initWithString:str attributes:dic];
        label.attributedText = attributeStr;
}

//计算UILabel的高度(带有行间距的情况)
+ (CGFloat)getSpaceLabelHeight:(NSString *)str withFont:(UIFont *)font withWidth:(CGFloat)width {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = 4;
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle};
    
    CGSize size = [str boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size.height;
}

//计算UILabel的高度(带有行间距的情况)
+ (CGFloat)getSpaceLabelHeightWithString:(NSString *)str font:(UIFont *)font width:(CGFloat)width lineSpace:(CGFloat)lineSpace {
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = lineSpace;
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle};
    
    CGSize size = [str boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size.height;
    //
    //    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    //    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    //    paraStyle.alignment = NSTextAlignmentLeft;
    //    paraStyle.lineSpacing = lineSpace;
    //    paraStyle.hyphenationFactor = 1.0;
    //    paraStyle.firstLineHeadIndent = 0.0;
    //    paraStyle.paragraphSpacingBefore = 0.0;
    //    paraStyle.headIndent = 0;
    //    paraStyle.tailIndent = 0;
    ////    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@1.5f
    ////                          };
    //    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle};
    //
    //    CGSize size = [str boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    //    return size.height;
}

@end
