//
/**
* 所属系统: YMMAD
* 所属模块: 
* 功能描述: 
* 创建时间: 2021/3/17
* 维护人:  马克
* 
*┌─────────────────────────────────────────────────────┐
*│ 此技术信息为本公司机密信息，未经本公司书面同意禁止向第三方披露．│
*│ 版权所有：杰人软件(深圳)有限公司                          │
*└─────────────────────────────────────────────────────┘
*/

#import "JRAdjustTool.h"
#import "JRAdjustToolBar.h"
#import "JRUIKit.h"
#import <CoreImage/CIFilter.h>
#import "JRColorFilter.h"
#import "JRUIKit.h"

@interface JRAdjustTool ()
@property (nonatomic, strong)JRAdjustToolBar *adjustToolBar;
@property (nonatomic, strong)JRColorFilter *colorFilter;

@end

@implementation JRAdjustTool

- (instancetype)initWithImageEditor:(JRPhotoImageEditorViewController *)editor {
    self = [super init];
    
    if(self)
    {
        
        // 初始化 工具栏
        self.adjustToolBar = [[JRAdjustToolBar alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
        [editor.view addSubview:self.adjustToolBar];
        [self.adjustToolBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo([JRAdjustToolBar fixedHeight]);
            make.bottom.mas_equalTo(editor.mainToolBarView.mas_top).mas_offset(0);
        }];
        
        //还原调节
        WS(weakSelf);
        self.adjustToolBar.backAdjustType = ^{

        };
        //亮度调节
        [self adjustBrightNessView:editor];
    }
    
    return self;
}

- (void)adjustBrightNessView:(JRPhotoImageEditorViewController *)editor {
    self.colorFilter =  [[JRColorFilter alloc]init];
   CIFilter *colorControlsFilter = [self.colorFilter getColorContentFilter:editor.originImage];
        
   __weak JRAdjustTool *weakSelf = self;
   self.adjustToolBar.adjustTypeBlock = ^(AdjustType adjustType, float sliderValue) {
       switch (adjustType) {
           case AdjustBrightness:
               // 修改亮度   -1---1   数越大越亮
               [colorControlsFilter setValue:[NSNumber numberWithFloat:sliderValue] forKey:@"inputBrightness"];
               weakSelf.adjustToolBar.labelStr.text = [NSString stringWithFormat:@"%.0f",sliderValue*400];

               weakSelf.adjustToolBar.brightnessValue = sliderValue;
               break;
           case AdjustContrast:
               // 修改对比度  0---2
               [colorControlsFilter setValue:[NSNumber numberWithFloat:sliderValue] forKey:@"inputContrast"];
               
               [weakSelf.adjustToolBar setLabelStrWithSliderValue:sliderValue];

               weakSelf.adjustToolBar.contrastValue = sliderValue;
               
               break;
           case AdjustSaturability:
               // 修改饱和度  0---2
               [colorControlsFilter setValue:[NSNumber numberWithFloat:sliderValue] forKey:@"inputSaturation"];//设置滤镜参数
               
               [weakSelf.adjustToolBar setLabelStrWithSliderValue:sliderValue];

               weakSelf.adjustToolBar.saturationValue = sliderValue;

               break;
           default:
               break;
       }
       
       [weakSelf.colorFilter getOutPutImageWithImageView:editor.mosicaView.surfaceImageView];
       [weakSelf.colorFilter getOutPutImageWithImageView:editor.imageView];

       
   };
}

- (void)setup {
    self.adjustToolBar.hidden = NO;
    
    self.editor.drawingView.userInteractionEnabled = NO;
    self.editor.scrollView.panGestureRecognizer.minimumNumberOfTouches = 2;
    self.editor.scrollView.panGestureRecognizer.delaysTouchesBegan = NO;
    self.editor.scrollView.pinchGestureRecognizer.delaysTouchesBegan = NO;
}

- (void)cleanup
{
    self.adjustToolBar.hidden = YES;

    self.editor.drawingView.userInteractionEnabled = YES;
    self.editor.mosicaView.userInteractionEnabled = YES;
}



@end
