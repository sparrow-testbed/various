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

#import "JRMoreKeyboardItem.h"

@implementation JRMoreKeyboardItem
+ (JRMoreKeyboardItem *)createByTitle:(NSString *)title imagePath:(NSString *)imagePath image:(UIImage *)image
{
    JRMoreKeyboardItem *item = [[JRMoreKeyboardItem alloc] init];
    item.title = title;
    item.imagePath = imagePath;
    item.image = image;
    return item;
}
@end
