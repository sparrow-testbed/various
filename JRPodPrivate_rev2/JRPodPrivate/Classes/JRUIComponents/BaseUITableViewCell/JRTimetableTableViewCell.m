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

#import "JRTimetableTableViewCell.h"
#import "JRUIKit.h"

@implementation JRTimetableTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.timeLabel = [[UILabel alloc] init];
        self.timeLabel.textColor = [UIColor colorWithHex:@"#174C30"];
        self.timeLabel.font = [UIFont boldSystemFontOfSize:18];
        [self.contentView addSubview:self.timeLabel];
        
        self.classNameLabel = [[UILabel alloc] init];
        self.classNameLabel.textColor = [UIColor colorWithHex:@"#333333"];
        self.classNameLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:self.classNameLabel];
        
        self.classLocationLabel = [[UILabel alloc] init];
        self.classLocationLabel.textColor = [UIColor colorWithHex:@"#333333"];
        self.classLocationLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:self.classLocationLabel];
        
        
        self.rightImageView = [[UIImageView alloc] init];
        self.rightImageView.image = [JRUIHelper imageNamed:@"cell_rightArrow"];
        [self.contentView addSubview:self.rightImageView];
        
        [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-20);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
        }];
        
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(@20);
            make.top.mas_equalTo(20);
        }];
        
        [self.classNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.timeLabel.mas_left);
            make.top.mas_equalTo(self.timeLabel.mas_bottom).offset(8);
        }];
        
        [self.classLocationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.timeLabel.mas_left);
            make.top.mas_equalTo(self.classNameLabel.mas_bottom).offset(8);
            make.bottom.mas_equalTo(-20);
        }];
        
    }
    return self;
}

- (void)setHiddenLication:(BOOL)hiddenLication{
    _hiddenLication = hiddenLication;
    if (hiddenLication) {
        [self.classLocationLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-10);
        }];
    }
    else{
        [self.classLocationLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-20);
        }];
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
