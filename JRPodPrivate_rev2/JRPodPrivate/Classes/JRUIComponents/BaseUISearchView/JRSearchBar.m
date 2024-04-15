//
/**
* 所属系统: component
* 所属模块: UITextField
* 功能描述: BaseUITextField
* 创建时间: 2020/9/21
* 维护人:  王伟
* Copyright © 2020 wni. All rights reserved.
*┌─────────────────────────────────────────────────────┐
*│ 此技术信息为本公司机密信息，未经本公司书面同意禁止向第三方披露．│
*│ 版权所有：杰人软件(深圳)有限公司                          │
*└─────────────────────────────────────────────────────┘
*/

#import "JRSearchBar.h"
#import "JRUIKit.h"

@implementation JRSearchBar

+ (instancetype)searchBar {
    return [[self alloc] init];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 背景
        self.backgroundColor = [UIColor whiteColor];        
        self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        
        // 左边的放大镜图标
        UIImageView *iconView = [[UIImageView alloc] initWithImage:[JRUIHelper imageNamed:@"i_search_tab"]];
        iconView.contentMode = UIViewContentModeCenter;
        self.leftView = iconView;
        self.leftViewMode = UITextFieldViewModeAlways;
        
        // 字体
        self.font = [UIFont systemFontOfSize:15];
        UIButton *clearButton = [self valueForKey:@"_clearButton"]; //key是固定的
        [clearButton setImage:[JRUIHelper imageNamed:@"i_clear_search"] forState:UIControlStateNormal];
        
        // 右边的清除按钮
        self.clearButtonMode = UITextFieldViewModeAlways;
        
        // 设置提醒文字
        NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
        attrs[NSForegroundColorAttributeName] = [UIColor colorWithHex:@"#FFFFFF" alpha:0.2];
        self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入" attributes:attrs];
        self.tintColor = [UIColor colorWithHex:@"#1AAD19"];
        // 设置键盘右下角按钮的样式
        self.returnKeyType = UIReturnKeySearch;
        self.enablesReturnKeyAutomatically = YES;
        
        self.layer.cornerRadius = 4;
        self.layer.borderWidth = 0.35;
        self.layer.borderColor = [UIColor colorWithHex:@"f1f1f6"].CGColor;
        self.layer.masksToBounds = YES;

    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)cancelKeyBoard {
    
    [self resignFirstResponder];
}

// drawing and positioning overrides
- (CGRect)leftViewRectForBounds:(CGRect)bounds {
    return CGRectMake(8, bounds.size.height/2 -10, 20, 20);
}

//
- (CGRect)placeholderRectForBounds:(CGRect)bounds {
    return CGRectMake(32, 1, bounds.size.width - 52, bounds.size.height);
}

// 编辑区
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectMake(32, 0, bounds.size.width - 56, bounds.size.height);
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectMake(32, 0, bounds.size.width - 40, bounds.size.height);
}

- (CGRect)clearButtonRectForBounds:(CGRect)bounds{
    return CGRectMake(bounds.size.width - 36, 0, 36, bounds.size.height);
}

- (void)clearButtonClicked:(UIButton *)sender{
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
