//
/**
* 所属系统: component
* 所属模块: 
* 功能描述: 
* 创建时间: 2020/9/22
* 维护人:  王伟
* Copyright © 2020 wni. All rights reserved.
*┌─────────────────────────────────────────────────────┐
*│ 此技术信息为本公司机密信息，未经本公司书面同意禁止向第三方披露．│
*│ 版权所有：杰人软件(深圳)有限公司                          │
*└─────────────────────────────────────────────────────┘
*/

#import "JRCheckBoxView.h"
#import "JRUIKit.h"

@interface JRCheckBoxView ()
{
    BOOL _selected;
}
@end

@implementation JRCheckBoxView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.checkImageView = [[UIImageView alloc] init];
        [self addSubview:self.checkImageView];
        
        self.contenLabel = [[UILabel alloc] init];
        self.contenLabel.textColor = [UIColor colorWithHex:@"#010101"];
        self.contenLabel.font = [UIFont systemFontOfSize:16];
        [self addSubview:self.contenLabel];
        
        [self.checkImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.mas_centerY);
            make.left.mas_equalTo(@0);
        }];
        
        [self.contenLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.checkImageView.mas_right).offset(5);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(checkBoxClick:)];
        [self addGestureRecognizer:tap];
 
    }
    return self;
}

- (void)checkBoxClick:(UITapGestureRecognizer *)tap{
    _selected = !_selected;
    if (self.checkType == JRCheckBoxTypeSingleNormal || self.checkType == JRCheckBoxTypeSingleSelect) {
        if (_selected) {
            self.checkImageView.image = [JRUIHelper imageNamed:@"btn_select_single_pre"];
        }else{
            self.checkImageView.image = [JRUIHelper imageNamed:@"btn_select_single_nor"];
        }
    }
    else{
        if (_selected) {
            self.checkImageView.image = [JRUIHelper imageNamed:@"btn_select_many_pre"];
        }else{
            self.checkImageView.image = [JRUIHelper imageNamed:@"btn_select_many_nor"];
        }
    }
   
}

- (void)setCheckType:(JRCheckBoxType)checkType{
    _checkType = checkType;

    switch (checkType) {
        case JRCheckBoxTypeSingleNormal:
            _selected = NO;
            self.checkImageView.image = [JRUIHelper imageNamed:@"btn_select_single_nor"];
            self.contenLabel.textColor = [UIColor colorWithHex:@"#010101"];
            self.userInteractionEnabled = true;
            break;
        case JRCheckBoxTypeSingleSelect:
            _selected = YES;
            self.checkImageView.image = [JRUIHelper imageNamed:@"btn_select_single_pre"];
            self.contenLabel.textColor = [UIColor colorWithHex:@"#010101"];
            self.userInteractionEnabled = true;
            break;
        case JRCheckBoxTypeSingleNormalDisable:
            self.checkImageView.image = [JRUIHelper imageNamed:@"btn_noselect_single_dis"];
            self.contenLabel.textColor = [UIColor colorWithHex:@"#010101" alpha:0.5];
            self.userInteractionEnabled = false;
            break;
        case JRCheckBoxTypeSingleSelectDisable:
            self.checkImageView.image = [JRUIHelper imageNamed:@"btn_select_single_dis"];
            self.contenLabel.textColor = [UIColor colorWithHex:@"#010101" alpha:0.5];
            self.userInteractionEnabled = false;
            break;
        case JRCheckBoxTypeMultipleNormal:
            _selected = NO;
            self.checkImageView.image = [JRUIHelper imageNamed:@"btn_select_many_nor"];
            self.contenLabel.textColor = [UIColor colorWithHex:@"#010101"];
            self.userInteractionEnabled = true;
            break;
        case JRCheckBoxTypeMultipleSelect:
            _selected = YES;
            self.checkImageView.image = [JRUIHelper imageNamed:@"btn_select_many_pre"];
            self.contenLabel.textColor = [UIColor colorWithHex:@"#010101"];
            self.userInteractionEnabled = true;
            break;
        case JRCheckBoxTypeMultipleNormalDisable:
            self.checkImageView.image = [JRUIHelper imageNamed:@"btn_select_many_nor"];
            self.contenLabel.textColor = [UIColor colorWithHex:@"#010101" alpha:0.5];
            self.userInteractionEnabled = false;
            break;
        case JRCheckBoxTypeMultipleSelectDisable:
            self.checkImageView.image = [JRUIHelper imageNamed:@"btn_select_many_pre"];
            self.contenLabel.textColor = [UIColor colorWithHex:@"#010101" alpha:0.5];
            self.userInteractionEnabled = false;
            break;
            
        default:
            break;
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
