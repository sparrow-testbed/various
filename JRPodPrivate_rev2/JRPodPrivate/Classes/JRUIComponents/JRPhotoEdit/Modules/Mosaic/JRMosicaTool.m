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

#import "JRMosicaTool.h"
#import "JRMosicaToolBar.h"
#import "JRScratchView.h"
#import "JRRGBTool.h"
#import "Masonry.h"
#import "UIView+TouchBlock.h"
#import <XXNibBridge/XXNibBridge.h>
#import "JRUIKit.h"
#import "JRTextToolView.h"
@interface JRMosicaTool ()
@property (nonatomic, strong) JRMosicaToolBar *mosicaToolBar;
@property (nonatomic, weak) JRScratchView *scratchView;
@end

@implementation JRMosicaTool
- (void)setup
{
    self.scratchView = self.editor.mosicaView;
    // 初始化 工具栏
    self.mosicaToolBar = [JRMosicaToolBar xx_instantiateFromNib];
    [self.editor.view addSubview:self.mosicaToolBar];
    [self.mosicaToolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo([JRMosicaToolBar fixedHeight]);
        make.bottom.mas_equalTo(self.editor.mainToolBarView.mas_top).mas_offset(0);
    }];
    
    [self setupActions];
    
    CGFloat height = [JRMosicaToolBar fixedHeight];
    CGFloat y = HEIGHT_SCREEN - height - [self.editor.mainToolBarView height];
    self.mosicaToolBar.frame = CGRectMake(0, y, WIDTH_SCREEN, height);
    //获取马赛克图像
    if (!self.scratchView.mosaicImage)
    {
        self.scratchView.mosaicImage = [JRRGBTool getMosaicImageWith:self.editor.originImage level:0];
    }
    


    self.editor.drawingView.userInteractionEnabled = NO;
    self.editor.scrollView.panGestureRecognizer.minimumNumberOfTouches = 2;
    self.editor.scrollView.panGestureRecognizer.delaysTouchesBegan = NO;
    self.editor.scrollView.pinchGestureRecognizer.delaysTouchesBegan = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(visableCurrentTool:) name:@"REATOREACURRENTTOOLBAR" object:nil];
}

- (void)visableCurrentTool:(NSNotification *)notice {

    int currentModel = [notice.object intValue];
    if (currentModel == 6) {
        self.editor.currentMode = 0;
        [self.editor paperAction];
    }
}


- (void)cleanup
{
    [self.mosicaToolBar removeFromSuperview];
    
    self.editor.drawingView.userInteractionEnabled = YES;
}

- (UIView *)drawView
{
    if (self.mosicaToolBar.brushSizeWith >0) {
        self.scratchView.shapeLayer.lineWidth = self.mosicaToolBar.brushSizeWith;
    }
    
    self.mosicaToolBar.backButton.enabled = YES;
    self.mosicaToolBar.backButton.userInteractionEnabled = YES;
    
    return self.scratchView;

}

- (void)hideTools:(BOOL)hidden
{
    if (hidden)
    {
        self.editor.mainToolBarView.alpha = 0;
        self.mosicaToolBar.alpha = 0;
    }
    else
    {
        self.editor.mainToolBarView.alpha = 1.0f;
        self.mosicaToolBar.alpha = 1.0f;
    }
}

- (void)setupActions
{
//  目前只有一种样式不用
//    __weak __typeof(self)weakSelf = self;
//    self.mosicaToolBar.mosicaStyleButtonClickBlock = ^(UIButton *btn, WBGMosicaStyle style)
//    {
//        __strong __typeof(weakSelf) strongSelf = weakSelf;
//    };
    
    __weak __typeof(self)weakSelf = self;
    
    [self.scratchView setTouchesBeganBlock:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.editor hiddenTopAndBottomBar:YES animation:YES];
        
        [strongSelf drawView];
    }];
    
    [self.scratchView setTouchesCancelledBlock:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.editor hiddenTopAndBottomBar:NO animation:YES];
    }];
    
    [self.scratchView setTouchesEndedBlock:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf.editor hiddenTopAndBottomBar:NO animation:YES];
    }];
    
//    [self.scratchView setTapGestureBlock:^{
//        __strong __typeof(weakSelf)strongSelf = weakSelf;
//        [strongSelf.editor hiddenTopAndBottomBar:!strongSelf.editor.barsHiddenStatus animation:YES];
//    }];
    
    self.scratchView.tapGestureBlock = ^(UITapGestureRecognizer *sender) {
        //取消所有加入文字激活状态
        for (UIView *subView in self.editor.drawingView.subviews)
        {
            if ([subView isKindOfClass:[JRTextToolView class]])
            {
                [JRTextToolView setNewActiveTextView:(JRTextToolView *)subView withGesture:sender];
            }
        }
    };
    
    self.mosicaToolBar.backButtonClickBlock = ^(UIButton *btn) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
       NSArray *temAry = [strongSelf.scratchView backToLastDraw];
        if (temAry.count == 0) {
            strongSelf.mosicaToolBar.backButton.enabled = NO;
        }
    };
    self.mosicaToolBar.lineWidthClickBlock = ^(NSInteger brushSizeWidth) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf drawView];
    };

}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
