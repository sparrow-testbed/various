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

#import "JRNoticeRemindTableViewCell.h"
#import "JRNoticeContentTableViewCell.h"
#import "NSString+JRNoticeRemind.h"
#import "NSAttributedString+JRNotictRemind.h"
#import "JRUIKit.h"

@interface JRNoticeRemindTableViewCell ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation JRNoticeRemindTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

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
    self.contentView.backgroundColor = [UIColor colorWithHex:@"#F9FBF9"];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.bgView];
    [self.bgView addSubview:self.titleLabel];
    [self.bgView addSubview:self.headerLabel];
    [self.bgView addSubview:self.bottomLabel];
    [self.bgView addSubview:self.lineLabel];
    [self.bgView addSubview:self.enterDetailButton];
    [self.enterDetailButton addSubview:self.rightImageView];
    [self.bgView addSubview:self.contentTableView];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.contentView).mas_offset(18);
        make.height.mas_equalTo(15);
    }];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).mas_offset(15);
        make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-15);
        make.top.mas_equalTo(self.timeLabel.mas_bottom).mas_offset(9);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bgView.mas_top).mas_offset(20);
        make.left.mas_equalTo(self.bgView.mas_left).mas_offset(16);
        make.right.mas_equalTo(self.bgView.mas_right).mas_offset(16);
    }];

    [self.headerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(10);
        make.left.mas_equalTo(self.bgView.mas_left).mas_offset(16);
        make.right.mas_equalTo(self.bgView.mas_right).mas_offset(-16);
    }];

    [self.bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentTableView.mas_bottom).mas_offset(12);
        make.left.mas_equalTo(self.bgView.mas_left).mas_offset(16);
        make.right.mas_equalTo(self.bgView.mas_right).mas_offset(-16);
    }];

    [self.contentTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headerLabel.mas_bottom).mas_offset(12);
        make.left.mas_equalTo(self.bgView.mas_left).mas_offset(16);
        make.right.mas_equalTo(self.bgView.mas_right).mas_offset(-16);
        make.height.mas_equalTo(80);
    }];

    [self.lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bottomLabel.mas_bottom).mas_offset(16);
        make.left.mas_equalTo(self.bgView.mas_left).mas_offset(16);
        make.right.mas_equalTo(self.bgView.mas_right).mas_offset(-16);
        make.height.mas_equalTo(PixelOne);
    }];

    [self.enterDetailButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.lineLabel.mas_bottom).mas_offset(0);
        make.left.mas_equalTo(self.bgView.mas_left).mas_offset(16);
        make.right.mas_equalTo(self.bgView.mas_right).mas_offset(-16);
        make.bottom.mas_equalTo(self.bgView);
    }];

    [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.centerY.mas_equalTo(self.enterDetailButton.mas_centerY);
        make.right.mas_equalTo(self.enterDetailButton.mas_right).mas_offset(-5);
    }];
}

-(void)setModel:(JRNoticeRemindModel *)model{
    _model = model;
    
    //如果是时间戳 转换成指定格式日期 不是时间错直接显示
    if ([model.createTime stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]].length > 0) {
        self.timeLabel.text = model.createTime;
    }
    else{
        self.timeLabel.text = [NSString changeTimeStamp:[model.createTime integerValue]];
    }
    
    self.titleLabel.text =  model.title;
    
    [self updateViewConstrains:model];
}

- (void)updateViewConstrains:(JRNoticeRemindModel *)model{
    //文字颜色处理
    UIColor *titleColor,*headerColor,*bottomColor;
    if (model.isRead) {
        titleColor = [UIColor colorWithHex:@"#999999"];
        headerColor = [UIColor colorWithHex:@"#999999"];
        bottomColor = [UIColor colorWithHex:@"#999999"];
    }
    else{
        titleColor = [UIColor colorWithHex:@"#000000"];
        headerColor = [UIColor colorWithHex:@"#616B75"];
        bottomColor = [UIColor colorWithHex:@"#616B75"];
    }
    
    self.titleLabel.textColor = titleColor;
    
    //头部内容处理
    if (model.headerContent.length > 0) {
        self.headerLabel.attributedText = [NSAttributedString attributeString:model.headerContent textColor:headerColor font:[UIFont systemFontOfSize:15] lineMargin:6];
        self.headerLabel.hidden = NO;
        [self.contentTableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.headerLabel.mas_bottom).mas_offset(10);
        }];
    }
    else{
        self.headerLabel.hidden = YES;
        [self.contentTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(10);
            make.left.mas_equalTo(self.bgView.mas_left).mas_offset(16);
            make.right.mas_equalTo(self.bgView.mas_right).mas_offset(-16);
            make.height.mas_equalTo(80);
        }];
    }
    
    //更新中间内容高度
    [self.contentTableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.model.centerContentHeight);
    }];
    
    //底部内容处理
    if (model.bottomContent.length > 0) {
        self.bottomLabel.attributedText = [NSAttributedString attributeString:model.bottomContent textColor:bottomColor font:[UIFont systemFontOfSize:15] lineMargin:6];
        self.bottomLabel.hidden = NO;
        [self.lineLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.bottomLabel.mas_bottom).mas_offset(16);
        }];
    }
    else{
        self.bottomLabel.hidden = YES;
        [self.lineLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentTableView.mas_bottom).mas_offset(16);
            make.left.mas_equalTo(self.bgView.mas_left).mas_offset(16);
            make.right.mas_equalTo(self.bgView.mas_right).mas_offset(-16);
            make.height.mas_equalTo(PixelOne);
        }];
    }
    
    //查看详情处理
    if (model.hasDetail) {
        self.enterDetailButton.hidden = NO;
        self.lineLabel.hidden = NO;
        [self.enterDetailButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_greaterThanOrEqualTo(40);
        }];
    }
    else{
        self.enterDetailButton.hidden = YES;
        self.lineLabel.hidden = YES;
        
        //没有详情查看时 底部的处理
        if (model.bottomContent.length > 0) {
            [self.bottomLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(self.contentView).mas_offset(-16);
            }];
        }
        else{
            [self.contentTableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(self.contentView).mas_offset(-12);
            }];
        }
    }
    
}

#pragma mark action
- (void)enterDetail:(UIButton *)btn{
    if (self.enterDetailBlock) {
        self.enterDetailBlock(self);
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.model.contentArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JRNoticeContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"forIndexPath:indexPath];
    NSDictionary *dict = [self.model.contentArray objectAtIndex:indexPath.row];
    cell.isRead = self.model.isRead;
    cell.dict = dict;
    [cell layoutIfNeeded];
    return cell;
}

-(UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.font = [UIFont systemFontOfSize:14];
        _timeLabel.textColor = [UIColor colorWithHex:@"#626C76"];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _timeLabel;
}

-(UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.layer.masksToBounds = YES;
        _bgView.layer.cornerRadius = 3;
        _bgView.layer.borderWidth = PixelOne;
        _bgView.layer.borderColor = [UIColor colorWithHex:@"#ABC0BA"].CGColor;
    }
    return _bgView;;
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont systemFontOfSize:18];
        _titleLabel.textColor = [UIColor colorWithHex:@"#000000"];
    }
    return _titleLabel;
}

-(UILabel *)headerLabel{
    if (!_headerLabel) {
        _headerLabel = [[UILabel alloc]init];
        _headerLabel.font = [UIFont systemFontOfSize:15];
        _headerLabel.textColor = [UIColor colorWithHex:@"#626C76"];
        _headerLabel.numberOfLines = 0;
    }
    return _headerLabel;
}

-(UILabel *)bottomLabel{
    if (!_bottomLabel) {
        _bottomLabel = [[UILabel alloc]init];
        _bottomLabel.font = [UIFont systemFontOfSize:15];
        _bottomLabel.textColor = [UIColor colorWithHex:@"#626C76"];
        _bottomLabel.numberOfLines = 0;
    }
    return _bottomLabel;
}

-(UIView *)lineLabel{
    if (!_lineLabel) {
        _lineLabel = [[UIView alloc]init];
        _lineLabel.backgroundColor = [UIColor colorWithHex:@"#ABC0BA"];
    }
    return _lineLabel;
}

- (UIButton *)enterDetailButton{
    if (!_enterDetailButton) {
        _enterDetailButton = [[UIButton alloc]init];
        [_enterDetailButton setTitle:@"查看详情" forState:UIControlStateNormal];
        _enterDetailButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_enterDetailButton setTitleColor:[UIColor colorWithHex:@"#0EA856"] forState:UIControlStateNormal];
        _enterDetailButton.titleLabel.textAlignment = NSTextAlignmentLeft;
        [_enterDetailButton addTarget:self action:@selector(enterDetail:) forControlEvents:UIControlEventTouchUpInside];
        _enterDetailButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    }
    return _enterDetailButton;
}

-(UIImageView *)rightImageView{
    if (!_rightImageView) {
        _rightImageView = [[UIImageView alloc]init];
        _rightImageView.image = [JRUIHelper imageNamed:@"cell_rightArrow"];
    }
    return _rightImageView;
}

-(UITableView *)contentTableView{
    if (!_contentTableView) {
        _contentTableView = [[UITableView alloc]init];
        _contentTableView.delegate = self;
        _contentTableView.dataSource = self;
        [_contentTableView registerClass:[JRNoticeContentTableViewCell class] forCellReuseIdentifier:@"cell"];
        _contentTableView.estimatedRowHeight = 40;
        _contentTableView.rowHeight = UITableViewAutomaticDimension;
        _contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _contentTableView.scrollEnabled = NO;
    }
    return _contentTableView;
}

@end
