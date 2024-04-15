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

#import "JRNoticeRemindModel.h"
#import "NSAttributedString+JRNotictRemind.h"
#import "JRUIKit.h"

@implementation JRNoticeRemindModel

-(NSInteger)centerContentHeight{
    NSInteger height =  0;
    if (self.contentArray.count > 0) {
        for (int i = 0; i < self.contentArray.count; i++) {
            NSDictionary *dict = [self.contentArray objectAtIndex:i];
            UILabel * label = [[UILabel alloc]init];
            label.font = [UIFont systemFontOfSize:15];
            NSString *title = dict[@"key"];
            if (![title hasSuffix:@"："] && ![title hasSuffix:@":"]) {
                title = [title stringByAppendingString:@"："];
            }
            label.text = title;
            [label sizeToFit];
            
            NSInteger contentHeight = [NSAttributedString getAttributeStringHeight:dict[@"value"]  font:[UIFont systemFontOfSize:15] lineMargin:5 width:MAIN_SCREEN_WIDTH - label.width-5- 31-31 firstLineHeadIndent:0 headIndent:0];
            height = height + contentHeight + 15;
        }
    }
    //减掉最后一行间距
    height = height - 13;
    return height ;
}


@end
