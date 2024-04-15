//
/**
* 所属系统: component
* 所属模块: 
* 功能描述: 
* 创建时间: 2020/9/26
* 维护人:  李志䶮
* Copyright © 2020 wni. All rights reserved.
*┌─────────────────────────────────────────────────────┐
*│ 此技术信息为本公司机密信息，未经本公司书面同意禁止向第三方披露．│
*│ 版权所有：杰人软件(深圳)有限公司                          │
*└─────────────────────────────────────────────────────┘
*/

#import "NSAttributedString+JRNotictRemind.h"

@implementation NSAttributedString (JRNotictRemind)

+ (NSAttributedString *)attributeString:(NSString *)string textColor:(UIColor *)textColor font:(UIFont *)font lineMargin:(int)lineMargin{
    return [NSAttributedString attributeString:string textColor:textColor font:font lineMargin:lineMargin firstLineHeadIndent:0 headIndent:0];
}

+ (NSAttributedString *)attributeString:(NSString *)string textColor:(UIColor *)textColor font:(UIFont *)font lineMargin:(int)lineMargin firstLineHeadIndent:(CGFloat)firstLineHeadIndent headIndent:(CGFloat)headIndent{
    if (string.length <= 0) {
        return [[NSAttributedString alloc] initWithString:@""];
    }
    
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:string];
    NSDictionary * firstAttributes = @{ NSFontAttributeName:font,NSForegroundColorAttributeName:textColor};
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.headIndent = headIndent;
    paragraphStyle.firstLineHeadIndent = firstLineHeadIndent;
    [paragraphStyle setLineSpacing:lineMargin];
    [attribute setAttributes:firstAttributes range:NSMakeRange(0,attribute.length)];
    [attribute addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0,attribute.length)];
    return attribute;
}

+ (CGFloat)getAttributeStringHeight:(NSString *)string font:(UIFont *)font lineMargin:(int)lineMargin width:(CGFloat)width firstLineHeadIndent:(CGFloat)firstLineHeadIndent headIndent:(CGFloat)headIndent{
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    //    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    /** 行高 */
    paraStyle.lineSpacing = lineMargin;
    paraStyle.headIndent = headIndent;
    paraStyle.firstLineHeadIndent = firstLineHeadIndent;
    // NSKernAttributeName字体间距
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle
                          };
    CGSize size = [string boundingRectWithSize:CGSizeMake(width,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size.height;
}

@end
