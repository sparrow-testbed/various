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

#import "JRImageToolBase.h"

@implementation JRImageToolBase
- (instancetype)initWithImageEditor:(JRPhotoImageEditorViewController *)editor
{
    self = [super init];
    if(self)
    {
        self.editor = editor;
    }
    return self;
}

#pragma mark - need subclass override
- (void)setup
{
    
}

- (void)cleanup
{
    
}

- (void)hideTools:(BOOL)hidden
{
    
}

- (UIView *)drawView
{
    return nil;
}

@end
