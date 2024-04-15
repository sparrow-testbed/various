//
//  JRPhotoCamerFilePopView.m
//  JRPodPrivate_Example
//
//  Created by J0224 on 2020/11/24.
//  Copyright © 2020 wni. All rights reserved.
//

#import "JRPhotoCameraFilePopView.h"
#import "JRUIKit.h"

#define CHAT_BUTTON_SIZE 80
#define INSETS 10
#define MOREVIEW_BUTTON_TAG 1000

@interface JRPhotoCameraFilePopView ()

@property (nonatomic,strong)NSArray *titleArray;

@property (nonatomic,strong)NSArray *imageArray;

@property (nonatomic, strong) UIView *bgView;

@end

@implementation JRPhotoCameraFilePopView

- (instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray *)titleArray imageArray:(NSArray *)imageArray
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleArray = titleArray;
        self.imageArray = imageArray;
        [self setUpUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageArray = @[@"btn_shoot_chat",@"btn_photo_chat",@"btn_file_chat"];
        self.titleArray = @[@"拍摄",@"相册",@"文件"];
        [self setUpUI];
    }
    return self;
}


- (void)setUpUI{
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT- (205 - 34 +BottomHeight), SCREEN_WIDTH, 205 - 34 +BottomHeight)];
    _bgView.backgroundColor = UIColor.whiteColor;
    [self addSubview:_bgView];
    [_bgView jk_setRoundedCorners:UIRectCornerTopLeft|UIRectCornerTopRight radius:8];
    _bgView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    
    NSInteger titleCount = self.titleArray.count;
    CGFloat insets = (self.frame.size.width - titleCount * CHAT_BUTTON_SIZE) / (titleCount + 1);

    for (int i = 0; i < titleCount; i ++) {
        UIButton *button =[UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake( insets * (i + 1) + CHAT_BUTTON_SIZE * i, 38, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE)];
        [button setTitle:self.titleArray[i] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:self.imageArray[i]] forState:UIControlStateNormal];
        button.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [button setTitleColor:XZYColorFromRGB(0x666666) forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = MOREVIEW_BUTTON_TAG + i;
        [self.bgView addSubview:button];
        [button setImgViewStyle:JRButtonImgViewStyleTop imageSize:CGSizeMake(69, 69) space:5];
    }
    
    [self jk_addTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        [self hidden];
    }];
    
    
}

- (void)show{
    self.backgroundColor = [UIColor jk_colorWithHex:0x000000 andAlpha:0.6];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

- (void)hidden{
    [self removeFromSuperview];
}

- (void)buttonAction:(UIButton *)sender{
    [self hidden];
    if (self.block) {
        self.block(sender.titleLabel.text,sender.tag - MOREVIEW_BUTTON_TAG);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
