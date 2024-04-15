//
/**
 * 所属系统: TIM
 * 所属模块:
 * 功能描述:
 * 创建时间: 2020/3/2.
 * 维护人:  金煜祥
 * Copyright @ Jerrisoft 2020. All rights reserved.
 *┌─────────────────────────────────────────────────────┐
 *│ 此技术信息为本公司机密信息，未经本公司书面同意禁止向第三方披露．│
 *│ 版权所有：杰人软件(深圳)有限公司                          │
 *└─────────────────────────────────────────────────────┘
 */


#import "JRPhotoShowPlayerView.h"
#import "JRUIKit.h"
@implementation JRPhotoShowPlayerView
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
        
        CGFloat topMaskViewHeight = 127;
        CGFloat bottomMaskViewHeight = 261;
        UIView * topMaskView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, topMaskViewHeight)];
        topMaskView.backgroundColor = [UIColor jk_gradientFromColor:[UIColor jk_colorWithHex:0x000000 andAlpha:0.4] toColor:[UIColor jk_colorWithHex:0x000000 andAlpha:0] withHeight:topMaskViewHeight];
        UIView * bottomMaskView = [[UIView alloc]initWithFrame:CGRectMake(0, self.height-bottomMaskViewHeight, self.width, bottomMaskViewHeight)];
        bottomMaskView.backgroundColor = [UIColor jk_gradientFromColor:[UIColor jk_colorWithHex:0x000000 andAlpha:0] toColor:[UIColor jk_colorWithHex:0x000000 andAlpha:0.4] withHeight:bottomMaskViewHeight];
        //上下朦板
        [self addSubview:topMaskView];
        [self addSubview:bottomMaskView];
        
        
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_cancelButton setTitle:@"重拍" forState:UIControlStateNormal];
        _cancelButton.frame = CGRectMake(16, StateHeight+18, 40, 20);
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:18];
        _cancelButton.titleLabel.textColor = [UIColor jk_colorWithHexString:@"#FFFFFF"];
        [_cancelButton addTarget:self action:@selector(clickCancel) forControlEvents:UIControlEventTouchUpInside];
        
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _confirmButton.frame = CGRectMake(self.width - 84-16, self.height-9-BottomHeight-32, 84, 32);
        _confirmButton.backgroundColor = [UIColor jk_colorWithHexString:@"#0EA856"];
        [_confirmButton setTitle:@"发送" forState:UIControlStateNormal];
        [_confirmButton jk_setRoundedCorners:UIRectCornerAllCorners radius:2];
        _confirmButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _confirmButton.titleLabel.textColor = [UIColor jk_colorWithHexString:@"#FFFFFF"];
        [_confirmButton addTarget:self action:@selector(clickConfirm) forControlEvents:UIControlEventTouchUpInside];
       
        
        [self addSubview:_confirmButton];
        [self addSubview:_cancelButton];
    }
    return self;
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
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
