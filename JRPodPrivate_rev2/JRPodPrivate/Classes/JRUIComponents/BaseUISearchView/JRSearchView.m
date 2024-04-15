//
/**
* 所属系统: component
* 所属模块: UIView
* 功能描述: 基础搜索View
* 创建时间: 2020/9/21
* 维护人:  王伟
* Copyright © 2020 wni. All rights reserved.
*┌─────────────────────────────────────────────────────┐
*│ 此技术信息为本公司机密信息，未经本公司书面同意禁止向第三方披露．│
*│ 版权所有：杰人软件(深圳)有限公司                          │
*└─────────────────────────────────────────────────────┘
*/

#import "JRSearchView.h"
#import "JRUIKit.h"

@implementation JRSearchView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.cancelButton];
        [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.top.mas_equalTo(@10);
            make.bottom.mas_equalTo(-10);
            make.width.mas_equalTo(CGPointZero);
        }];
        
        self.searchBar = [[JRSearchBar alloc] init];
        [self addSubview:self.searchBar];
        [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.cancelButton.mas_left);
            make.top.mas_equalTo(@3);
            make.bottom.mas_equalTo(-9);
            make.left.mas_equalTo(15);
        }];
    }
    return self;
}

- (void)setSearchType:(JRSearchType)searchType{
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];

    switch (searchType) {
        case JRSearchTypeGreen:
            self.backgroundColor = [UIColor colorWithHex:@"#174C30"];
            self.searchBar.backgroundColor = [UIColor colorWithHex:@"FFFFFF" alpha:0.2];
            self.searchBar.tintColor = [UIColor colorWithHex:@"#FFFFFF"];
            self.searchBar.textColor = [UIColor whiteColor];
            self.searchBar.layer.borderWidth = 0;
            self.searchBar.layer.cornerRadius = 4;
            attrs[NSForegroundColorAttributeName] = [UIColor colorWithHex:@"#FFFFFF" alpha:0.5];
            self.searchBar.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入" attributes:attrs];
            break;
        case JRSearchTypeWhite:
            self.backgroundColor = [UIColor colorWithHex:@"#F1F1F6"];
            self.searchBar.backgroundColor = [UIColor colorWithHex:@"#FFFFFF"];
            self.searchBar.tintColor = [UIColor colorWithHex:@"#1AAD19"];
            self.searchBar.textColor =  [UIColor colorWithHex:@"#000000"];
            // 设置提醒文字
            attrs[NSForegroundColorAttributeName] = [UIColor colorWithHex:@"#AEB2BC"];
            self.searchBar.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入" attributes:attrs];
            break;
        case JRSearchTypeGray:
            self.backgroundColor = [UIColor colorWithHex:@"#FFFFFF"];
            self.searchBar.backgroundColor = [UIColor colorWithHex:@"#F1F1F6"];
            self.searchBar.tintColor = [UIColor colorWithHex:@"#1AAD19"];
            self.searchBar.textColor = [UIColor colorWithHex:@"#000000"];
            // 设置提醒文字
            attrs[NSForegroundColorAttributeName] = [UIColor colorWithHex:@"#AEB2BC"];
            self.searchBar.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入" attributes:attrs];
            break;
        case JRSearchTypeCancel:
            self.backgroundColor = [UIColor colorWithHex:@"#174C30"];
            self.searchBar.backgroundColor = [UIColor colorWithHex:@"FFFFFF" alpha:0.2];
            self.searchBar.tintColor = [UIColor colorWithHex:@"#FFFFFF"];
            self.searchBar.textColor = [UIColor whiteColor];
            self.searchBar.layer.borderWidth = 0;
                  self.searchBar.layer.cornerRadius = 4;
            attrs[NSForegroundColorAttributeName] = [UIColor colorWithHex:@"#FFFFFF" alpha:0.5];
            self.searchBar.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入" attributes:attrs];
            [self.cancelButton mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(43);
            }];
        default:
            break;
    }
    
    // 左边的放大镜图标
    UIImageView *iconView = [[UIImageView alloc] initWithImage:[JRUIHelper imageNamed:@"i_search_tab"]];
    iconView.contentMode = UIViewContentModeCenter;
    self.searchBar.leftView = iconView;
    
    UIButton *clearButton = [self.searchBar valueForKey:@"_clearButton"]; //key是固定的
    [clearButton setImage:[JRUIHelper imageNamed:@"i_clear_search"] forState:UIControlStateNormal];
}

//取消按钮点击
- (void)cancelButtonClicked:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(cancelButtonAction:)]) {
        [self.delegate cancelButtonAction:sender];
    }
}

- (void)setSearchImage:(UIImage *)searchImage{
    _searchImage = searchImage;
    // 左边的放大镜图标
    UIImageView *iconView = [[UIImageView alloc] initWithImage:searchImage];
    iconView.contentMode = UIViewContentModeCenter;
    self.searchBar.leftView = iconView;
}

- (void)setClearImage:(UIImage *)clearImage{
    _clearImage = clearImage;
    UIButton *clearButton = [self.searchBar valueForKey:@"_clearButton"]; //key是固定的
    [clearButton setImage:clearImage forState:UIControlStateNormal];
}

- (void)setTintColor:(UIColor *)tintColor{
    _tintColor = tintColor;
    self.searchBar.tintColor = tintColor;
}

- (UIButton *)cancelButton{
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor colorWithHex:@"#FFFFFF"] forState:UIControlStateNormal];
        [_cancelButton.titleLabel setFont:[UIFont systemFontOfSize:17]];
        [_cancelButton addTarget:self action:@selector(cancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_cancelButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];

    }
    return _cancelButton;;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
