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

#import "JRUsersTableViewCell.h"
#import "JRUIKit.h"

@implementation JRUsersTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.iconImageView = [[UIImageView alloc] init];
        self.iconImageView.layer.cornerRadius = 30;
        self.iconImageView.layer.masksToBounds = true;
        self.iconImageView.image = [JRUIHelper imageNamed:@"jr_pic_head"];
        [self.contentView addSubview:self.iconImageView];
        [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(@20);
            make.size.mas_equalTo(CGSizeMake(60, 60));
            make.top.mas_equalTo(12);
            make.bottom.mas_equalTo(-12);
        }];
        
        self.nameLabel = [[UILabel alloc] init];
        self.nameLabel.textColor = [UIColor colorWithHex:@"#000000"];
        self.nameLabel.font = [UIFont systemFontOfSize:18];
        [self.contentView addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.iconImageView.mas_right).offset(9);
            make.top.mas_equalTo(self.iconImageView.mas_top).offset(6);
        }];
        
        self.positionLabel = [[UILabel alloc] init];
        self.positionLabel.textColor = [UIColor colorWithHex:@"#666666"];
        self.positionLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:self.positionLabel];
        [self.positionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.nameLabel.mas_right).offset(9);
            make.bottom.mas_equalTo(self.nameLabel.mas_bottom);
        }];
        
        self.sexLabel = [[UILabel alloc] init];
        self.sexLabel.textColor = [UIColor colorWithHex:@"#666666"];
        self.sexLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:self.sexLabel];
        [self.sexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.positionLabel.mas_right).offset(9);
            make.bottom.mas_equalTo(self.nameLabel.mas_bottom);
        }];
        
        self.scoreLabel = [[UILabel alloc] init];
        self.scoreLabel.textColor = [UIColor colorWithHex:@"#666666"];
        self.scoreLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:self.scoreLabel];
        
        self.rightImageView = [[UIImageView alloc] init];
        self.rightImageView.image = [JRUIHelper imageNamed:@"cell_rightArrow"];
        [self.contentView addSubview:self.rightImageView];
        
        [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-20);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
        }];
        
        [self.scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.rightImageView.mas_left);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
        }];
        
        self.campusLabel = [[UILabel alloc] init];
        self.campusLabel.textColor = [UIColor colorWithHex:@"#333333"];
        self.campusLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:self.campusLabel];
        [self.campusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.nameLabel.mas_left);
            make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(10);
        }];
        
        
        self.nameLabel.text = @"张楠楠";
        self.positionLabel.text = @"主教";
        self.sexLabel.text = @"女";
        self.scoreLabel.text = @"评分";
        self.campusLabel.text = @"深圳南山蛇口校区";
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
