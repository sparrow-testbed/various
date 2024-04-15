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

#import "NSString+JRCommon.h"

@implementation NSString (JRCommon)
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize {
    
    NSDictionary *attrs = @{NSFontAttributeName : font};
    NSInteger options = NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin;
    return [self boundingRectWithSize:maxSize options:options attributes:attrs context:nil].size;
    
}
- (CGSize)sizeFont:(UIFont *)font lineSpacing:(NSInteger)lineSpactin maxSize:(CGSize)maxSize {
    
    NSInteger options = NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin;
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineSpacing = lineSpactin;
    paraStyle.hyphenationFactor = 0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    paraStyle.lineHeightMultiple = 0;
    
    NSDictionary *attrs = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle};
    return [self boundingRectWithSize:maxSize options:options attributes:attrs context:nil].size;
    
}

+ (NSString *)FileSizeFromSizeValue:(unsigned long long)sizeValue {
    
    NSString *sizeStr;
    if (sizeValue > 1024 *1024 *1024 ) {
        sizeStr = [NSString stringWithFormat:@"%.2fG", sizeValue/1024/1024/1024.f];
    } else if (sizeValue > 1024 *1024 ) {
        
        sizeStr = [NSString stringWithFormat:@"%.2fMB", sizeValue/1024.f/1024.f];
    } else if (sizeValue > 1024 ) {
        sizeStr = [NSString stringWithFormat:@"%.2fKB", sizeValue/1024.f];
    } else{
        sizeStr = [NSString stringWithFormat:@"%lldB", sizeValue];
    }
    
    return [NSString stringWithFormat:@"%@", sizeStr];
}

+ (NSString *)getTimeWithDate:(NSDate *)date {
    // 获取当前时间
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm"];
    return [dateFormatter stringFromDate:date];;
}

@end
