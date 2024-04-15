//
/**
* 所属系统: component
* 所属模块:
* 功能描述:
* 创建时间: 2020/9/16
* 维护人:  王伟
* Copyright © 2020 杰人软件. All rights reserved.
*┌─────────────────────────────────────────────────────┐
*│ 此技术信息为本公司机密信息，未经本公司书面同意禁止向第三方披露．│
*│ 版权所有：杰人软件(深圳)有限公司                          │
*└─────────────────────────────────────────────────────┘
*/

#import "JROptionsTableViewCell.h"
#import "JRUIKit.h"

@implementation JROptionsTableViewCell

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
        
        self.txtLabel = [[UILabel alloc]initWithFrame:CGRectMake(28, 12, SCREEN_WIDTH-100, 20)];
        [self.contentView addSubview:self.txtLabel];
        self.txtLabel.font = [UIFont fontWithName:@"PingFang SC" size: 16];
        self.txtLabel.textColor = [UIColor colorWithHex:@"#666666"];
        
        self.selectImage = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-65, 13, 18, 18)];
        [self.contentView addSubview:self.selectImage];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.line = [[UILabel alloc]initWithFrame:CGRectMake(29, 43, SCREEN_WIDTH-75, 1/[UIScreen mainScreen].scale)];
        [self.contentView addSubview:self.line];
        self.line.backgroundColor = [UIColor colorWithHex:@"#ABC0BA"];
    }
    return self;
}

- (void)updateView:(NSString*)title withOptions:(BOOL)options withidx:(NSInteger)idx withSelect:(NSArray *)selectArray{
   
    self.txtLabel.text = title;
//    NSNumber *num = [NSNumber numberWithInteger:idx];
    if ([selectArray containsObject:title]){
        //多选和单选的选中框UI不一样，需要做判断
        if (options) {
            self.selectImage.image = [JRUIHelper imageNamed:@"btn_select_many_pre"];
        }else{
            self.selectImage.image = [JRUIHelper imageNamed:@"btn_select_single_pre"];
        }
    }else{
        if (options) {
            self.selectImage.image = [JRUIHelper imageNamed:@"btn_select_many_nor"];
        }else{
            self.selectImage.image = [JRUIHelper imageNamed:@"btn_select_single_nor"];
        }
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
