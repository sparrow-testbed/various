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

#import "JRSwitchTableViewCell.h"
#import "JRUIKit.h"

@implementation JRSwitchTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.text = @"单元格";
        [self.contentView addSubview:self.titleLabel];
        self.titleLabel.textColor = UIColor.blackColor;
        self.titleLabel.font = [UIFont systemFontOfSize:17];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(@20);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
        }];
        
        self.cellSwitch = [[UISwitch alloc] init];
        [self.contentView addSubview:self.cellSwitch];
        [self.cellSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-20);
            make.size.mas_equalTo(CGSizeMake(50, 30));
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
        }];
        [self.cellSwitch addTarget:self action:@selector(cellSwitchChange:) forControlEvents:UIControlEventValueChanged];
    }
    return self;
}

- (void)cellSwitchChange:(UISwitch *)cellSwitch{
    if ([self.delegate respondsToSelector:@selector(cellSwitchAction:indexPath:)]) {
        [self.delegate cellSwitchAction:cellSwitch indexPath:self.indexPath
         ];
    }
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
