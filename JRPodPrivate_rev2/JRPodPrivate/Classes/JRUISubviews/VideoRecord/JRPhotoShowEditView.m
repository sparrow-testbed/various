//
/**
* 所属系统: YMMAD
* 所属模块: 
* 功能描述: 
* 创建时间: 2021/3/10
* 维护人:  马克
* 
*┌─────────────────────────────────────────────────────┐
*│ 此技术信息为本公司机密信息，未经本公司书面同意禁止向第三方披露．│
*│ 版权所有：杰人软件(深圳)有限公司                          │
*└─────────────────────────────────────────────────────┘
*/

#import "JRPhotoShowEditView.h"
#import "JRUIKit.h"
#import "JRMainToolBarView.h"
@implementation JRPhotoShowEditView
{
    JRMainToolBarView *_mainToolBarView;
}
- (instancetype)initWithFrame:(CGRect)frame andImage:(UIImage *)image
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat deta = [UIScreen mainScreen].bounds.size.width/375.0;
        CGFloat width = 65.0*deta;
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _imageView.image = image;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_imageView];
        
        [self buildLayout];

        [self addSubview:self.confirmButton];
        [self addSubview:self.cancelButton];
    }
    return self;
}

-(void)buildLayout {

    
    CGFloat topMaskViewHeight = 127;
    CGFloat bottomMaskViewHeight = 261;
    UIView * topMaskView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, topMaskViewHeight)];
    topMaskView.backgroundColor = [UIColor jk_gradientFromColor:[UIColor jk_colorWithHex:0x000000 andAlpha:0.4] toColor:[UIColor jk_colorWithHex:0x000000 andAlpha:0] withHeight:topMaskViewHeight];
    UIView * bottomMaskView = [[UIView alloc]initWithFrame:CGRectMake(0, self.height-bottomMaskViewHeight, self.width, bottomMaskViewHeight)];
    bottomMaskView.backgroundColor = [UIColor jk_gradientFromColor:[UIColor jk_colorWithHex:0x000000 andAlpha:0] toColor:[UIColor jk_colorWithHex:0x000000 andAlpha:0.4] withHeight:bottomMaskViewHeight];
    //上下朦板
    [self addSubview:topMaskView];
    [self addSubview:bottomMaskView];
    
    // 创建图片编辑面板
    _mainToolBarView = [[JRMainToolBarView alloc]init];
    _mainToolBarView.backgroundColor = [UIColor blackColor];
    [self addSubview:_mainToolBarView];

    [_mainToolBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_bottom);
        make.left.mas_equalTo(self.mas_left);
        make.width.mas_equalTo(self.mas_width);
        make.height.equalTo(@102);
    }];
  
}
- (void)clickConfirm {
    
    if (self.confirmBlock) {
        self.confirmBlock();
    }
    
    [self removeFromSuperview];
}

- (void)clickCancel {
    
    if (self.cancelBlock) {
        self.cancelBlock();
    }
 
    [self removeFromSuperview];
}

#pragma mark - lazy method
- (UIButton *)cancelButton {
    if (_cancelButton == nil) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setTitle:@"重拍" forState:UIControlStateNormal];
        if (@available(iOS 11.0, *)) {
            _cancelButton.frame = CGRectMake(16, StateHeight+18, 40, 20);
        } else {
            // Fallback on earlier versions
            _cancelButton.frame = CGRectMake(16, StateHeight+18, 40, 20);
        }
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:18];
        _cancelButton.titleLabel.textColor = [UIColor jk_colorWithHexString:@"#FFFFFF"];
        [_cancelButton addTarget:self action:@selector(clickCancel) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (UIButton *)confirmButton {
    if (_confirmButton == nil) {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _confirmButton.frame = CGRectMake(self.width - 57-16, self.height-9-BottomHeight-32-40, 57, 32);
        _confirmButton.backgroundColor = [UIColor jk_colorWithHexString:@"#0EA856"];
        [_confirmButton setTitle:@"发送" forState:UIControlStateNormal];
        [_confirmButton jk_setRoundedCorners:UIRectCornerAllCorners radius:2];
        _confirmButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _confirmButton.titleLabel.textColor = [UIColor jk_colorWithHexString:@"#FFFFFF"];
        [_confirmButton addTarget:self action:@selector(clickConfirm) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}


@end
