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
#import "JRGPath.h"


@interface JRDrawTool:JRImageToolBase

@property (nonatomic, copy) void (^drawToolStatus)(BOOL canPrev);
@property (nonatomic, copy) void (^drawingCallback)(BOOL isDrawing);
@property (nonatomic, copy) void (^drawingDidTap)(UITapGestureRecognizer *sender);
@property (nonatomic, strong) NSMutableArray<JRGPath *> *allLineMutableArray;
@property (nonatomic, assign) CGFloat pathWidth;

//撤销
- (void)backToLastDraw;
- (void)drawLine;
@end

