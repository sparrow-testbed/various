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

#import "JRStartFinishTimeTableViewCell.h"
#import "JRUIKit.h"

@implementation JRStartFinishTimeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.startTitleLabel = [[UILabel alloc] init];
        self.startTitleLabel.text = @"开始时间";
        self.startTitleLabel.textColor = [UIColor colorWithHex:@"#999999"];
        self.startTitleLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.startTitleLabel];
        
        self.finishTitleLabel = [[UILabel alloc] init];
        self.finishTitleLabel.text = @"结束时间";
        self.finishTitleLabel.textColor = [UIColor colorWithHex:@"#999999"];
        self.finishTitleLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.finishTitleLabel];
        
        self.startTimeLabel = [[UILabel alloc] init];
        self.startTimeLabel.textColor = [UIColor colorWithHex:@"#000000"];
        self.startTimeLabel.font = [UIFont systemFontOfSize:17];
        [self.contentView addSubview:self.startTimeLabel];
        
        self.finishTimeLabel = [[UILabel alloc] init];
        self.finishTimeLabel.textColor = [UIColor colorWithHex:@"#000000"];
        self.finishTimeLabel.font = [UIFont systemFontOfSize:17];
        [self.contentView addSubview:self.finishTimeLabel];
        
        UIImageView *centerImageView = [[UIImageView alloc] init];
        centerImageView.image = [JRUIHelper imageNamed:@"cell_rightArrow"];
        [self.contentView addSubview:centerImageView];
        [centerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.contentView.mas_centerX);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
        }];
        
        [self.startTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(@20);
            make.top.mas_equalTo(16);
        }];
        
        [self.startTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.startTitleLabel.mas_left);
            make.top.mas_equalTo(self.startTitleLabel.mas_bottom).offset(7);
            make.bottom.mas_equalTo(-16);
        }];
        
        [self.finishTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.startTitleLabel.mas_centerY);
            make.left.mas_equalTo(centerImageView.mas_right).offset(18);
        }];
        
        [self.finishTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.startTimeLabel.mas_centerY);
            make.left.mas_equalTo(self.finishTitleLabel.mas_left);
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
