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

#import "JRMainToolBarView.h"
#import "JRUIKit.h"
@implementation JRMainToolBarView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.scrollView];
                
        [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left);
            make.top.mas_equalTo(self.mas_top);
            make.width.equalTo(@(SCREEN_WIDTH *0.8));
            make.height.mas_equalTo(self.mas_height);
        }];
//        [self buildLayout];
        
        [self addSubview:self.confirmButton];

    }
    return self;
}

- (void)buildMenuWithPhotoEditType:(PhotoEditType)editType {
    
    switch (editType) {
        case kPhotoEditCamare:
            
            break;
            
        default:
            break;
    }
    
}

-(void)buildLayout
{
    self.backgroundColor = UIColor.blackColor;
    
    NSInteger btnCount = 5;
    if (self.editType == kPhotoEditOtherType) {
        btnCount = 3;
//        btnCount = 2;//无矫正版

    }
    CGFloat btnHeight = 80.0f;//102.0f;
    CGFloat btnWidth = 55.0f;
    
    for (NSInteger i = 0; i<btnCount; i++) {
        CGFloat btnX = btnWidth*i+10;
   
        UIButton *button  = [[UIButton alloc] initWithFrame:CGRectMake(btnX, 0, btnWidth, btnHeight)];
        if (self.editType == kPhotoEditOtherType) {
            if (i == 2) {
                button.tag = 995;
            }else {
                button.tag = 991+i;
            }
        }else {
            button.tag = 990+i;
        }
        button.titleLabel.font = [UIFont systemFontOfSize:11];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:0/255.0 green:212/255.0 blue:99/255.0 alpha:1.0] forState:UIControlStateSelected];

       
        
        if (self.editType == kPhotoEditOtherType) {
            [button setImage:[JRUIHelper imageNamed:([self btnTwoTypeImages][i])] forState:UIControlStateNormal];
            [button setImage:[JRUIHelper imageNamed:([self btnTwoTypeSelectImages][i])] forState:UIControlStateSelected];
            [button setTitle:([self btnTwoTypeNames][i]) forState:UIControlStateNormal];

        }else {
            [button setImage:[JRUIHelper imageNamed:([self btnImages][i])] forState:UIControlStateNormal];
            [button setImage:[JRUIHelper imageNamed:([self btnSelectImages][i])] forState:UIControlStateSelected];
            [button setTitle:([self btnNames][i]) forState:UIControlStateNormal];
        }
        
        CGSize imageSize = button.imageView.frame.size;
        CGSize titleSize = button.titleLabel.frame.size;
        
        [button setImageEdgeInsets:UIEdgeInsetsMake(-titleSize.height-6, 0,0, -titleSize.width)];
        
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0 ,-imageSize.width, -imageSize.height-6,0)];

        if ([button.titleLabel.text isEqualToString:@"马赛克"]) {

            [button setImageEdgeInsets:UIEdgeInsetsMake(-titleSize.height-6, 0,0, -titleSize.width-23)];
        }

        
        [button addTarget:self action:@selector(buttonClickMethod:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:button];
        
        [self.scrollView setContentSize:CGSizeMake(button.width*btnCount, 0)];
    }
}

-(NSArray*)btnImages
{
    return @[@"i_graffiti_pic",@"i_crop_pic",@"i_adjustment_pic",@"i_txt_pic",@"i_mark_pic_nor",@"i_correct_pic_nor"];
}

-(NSArray*)btnSelectImages
{
    return @[@"i_graffiti_pic_pre",@"i_crop_pic",@"i_adjustment_pic_pre",@"i_txt_pic",@"i_mark_pre",@"i_correct_pic_pre"];
}

-(NSArray*)btnNames
{
    return @[@"涂鸦",@"裁剪",@"调节",@"文字",@"马赛克",@"矫正"];
}

-(NSArray*)btnTwoTypeNames
{
    return @[@"裁剪",@"调节",@"矫正"];
//    return @[@"裁剪",@"调节"];//无矫正版

}

-(NSArray*)btnTwoTypeImages
{
    return @[@"i_crop_pic",@"i_adjustment_pic",@"i_correct_pic_nor"];
//    return @[@"i_crop_pic",@"i_adjustment_pic"];//无矫正版

}

-(NSArray*)btnTwoTypeSelectImages
{
    return @[@"i_crop_pic",@"i_adjustment_pic_pre",@"i_correct_pic_pre"];
//    return @[@"i_crop_pic",@"i_adjustment_pic_pre"]; //无矫正版

}


- (void)buttonClickMethod:(UIButton *)sender {
    if (self.selectItemClick) {
        self.selectItemClick(sender.tag);
    }
}

#pragma mark - lazy Method

- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0,self.bounds.size.width, self.bounds.size.height)];
        _scrollView.contentSize = CGSizeMake(self.bounds.size.width, 0);
    }
    return _scrollView;
}

- (UIButton *)confirmButton {
    if (_confirmButton == nil) {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _confirmButton.frame = CGRectMake(SCREEN_WIDTH - 57 - 16, 18, 57, 32);
        _confirmButton.backgroundColor = [UIColor jk_colorWithHexString:@"#0EA856"];
        [_confirmButton setTitle:@"发送" forState:UIControlStateNormal];
        [_confirmButton jk_setRoundedCorners:UIRectCornerAllCorners radius:2];
        _confirmButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _confirmButton.titleLabel.textColor = [UIColor jk_colorWithHexString:@"#FFFFFF"];
        [_confirmButton addTarget:self action:@selector(clickConfirm) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}

- (void)clickConfirm {
    
    if (self.selectDoneClick) {
        self.selectDoneClick();
    }
}


@end
