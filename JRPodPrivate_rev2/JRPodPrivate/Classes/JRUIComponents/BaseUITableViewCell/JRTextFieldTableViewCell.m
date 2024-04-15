//
/**
* 所属系统: component
* 所属模块: 
* 功能描述: 
* 创建时间: 2020/9/21
* 维护人:  王伟
* Copyright © 2020 wni. All rights reserved.
*┌─────────────────────────────────────────────────────┐
*│ 此技术信息为本公司机密信息，未经本公司书面同意禁止向第三方披露．│
*│ 版权所有：杰人软件(深圳)有限公司                          │
*└─────────────────────────────────────────────────────┘
*/

#import "JRTextFieldTableViewCell.h"
#import "JRUIKit.h"

@implementation JRTextFieldTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.text = @"单元格";
        [self.contentView addSubview:self.titleLabel];
        self.titleLabel.textColor = UIColor.blackColor;
        self.titleLabel.font = [UIFont systemFontOfSize:17];
        
        self.contentField = [[UITextField alloc] init];
        self.contentField.textAlignment = NSTextAlignmentRight;
        self.contentField.placeholder = @"请输入";
        [self.contentView addSubview:self.contentField];
        self.contentField.textColor = UIColor.blackColor;
        self.contentField.font = [UIFont systemFontOfSize:17];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(@20);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
//            make.right.mas_equalTo(self.contentField.mas_left).offset(-10);
        }];
        
        [self.contentField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.titleLabel.mas_right).offset(10);
            make.right.mas_equalTo(-20);
            make.centerY.mas_equalTo(self.titleLabel.mas_centerY);
        }];
    }
    return self;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
