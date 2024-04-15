//
/**
* 所属系统: component
* 所属模块: 
* 功能描述: 
* 创建时间: 2020/9/25
* 维护人:  李志䶮
* Copyright © 2020 wni. All rights reserved.
*┌─────────────────────────────────────────────────────┐
*│ 此技术信息为本公司机密信息，未经本公司书面同意禁止向第三方披露．│
*│ 版权所有：杰人软件(深圳)有限公司                          │
*└─────────────────────────────────────────────────────┘
*/

#import "JRNoticeContentTableViewCell.h"
#import "NSAttributedString+JRNotictRemind.h"
#import "JRUIKit.h"

@interface JRNoticeContentTableViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation JRNoticeContentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initUI];
    }
    return self;
}

#pragma mark initUI
- (void)initUI{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.titleLabel];

    [self.contentView addSubview:self.contentLabel];
 
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.contentView).mas_offset(0);
        make.height.mas_equalTo(17);
    }];

    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel.mas_right).mas_offset(5);
        make.top.mas_equalTo(self.titleLabel);
        make.right.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView).mas_offset(-12);
    }];
}

-(void)setDict:(NSDictionary *)dict{
    NSString * title = [dict valueForKey:@"key"];
    if (![title hasSuffix:@"："] && ![title hasSuffix:@":"]) {
        title = [title stringByAppendingString:@"："];
    }
    self.titleLabel.text =title;
    UIColor *color ,*titleColor;
    if (!self.isRead) {
        color = [UIColor colorWithHex:@"#000000"];
        titleColor = [UIColor colorWithHex:@"#878B97"];
    }
    else{
        color = [UIColor colorWithHex:@"#999999"];
        titleColor = color;
    }
    self.contentLabel.attributedText = [NSAttributedString attributeString:dict[@"value"] textColor:color font:[UIFont systemFontOfSize:15] lineMargin:5] ;
    self.titleLabel.textColor = titleColor;
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textColor = [UIColor colorWithHex:@"#999999"];
    }
    return _titleLabel;
}

-(UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc]init];
        _contentLabel.font = [UIFont systemFontOfSize:15];
        _contentLabel.textColor = [UIColor colorWithHex:@"#000000"];
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}

@end
