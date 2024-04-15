//
/**
* 所属系统: YMMAD
* 所属模块: 
* 功能描述: 
* 创建时间: 2021/1/15
* 维护人:  马克
* 
*┌─────────────────────────────────────────────────────┐
*│ 此技术信息为本公司机密信息，未经本公司书面同意禁止向第三方披露．│
*│ 版权所有：杰人软件(深圳)有限公司                          │
*└─────────────────────────────────────────────────────┘
*/

#import "JRFileCollectionViewCell.h"
#import "JRUIKit.h"
#import "FBKVOController.h"
@implementation JRFileCollectionViewCell
{
    FBKVOController                         *_msgKVO;
}
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //初始化子视图
        [self.contentView addSubview:self.imagev];
        [self.contentView addSubview:self.deleteButton];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.faildTitleLabel];
        [self.contentView addSubview:self.matchProessView];
        // 添加布局
        [self buildViewLayout];
    }
    return self;
}

- (void)buildViewLayout {
    //文件图片标识
    [self.imagev mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.mas_equalTo(10);
        make.width.height.mas_equalTo(20);
    }];
    //标题内容
    CGSize size = CGSizeMake(40, 30);
    [_titleLabel.text boundingRectWithSize:size options:NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16]} context:nil];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imagev.mas_right).offset(6);
        make.right.equalTo(self.contentView.mas_right).offset(-30);
        make.centerY.equalTo(self.mas_centerY);
    }];
    // 上传失败文字提示
    [self.faildTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right);
        make.width.mas_equalTo(@47);
        make.height.mas_equalTo(@30);
        make.centerY.equalTo(self.titleLabel.mas_centerY);
    }];
    // 删除按钮
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imagev.mas_top);
        make.right.equalTo(self.mas_right).offset(-5);
        make.width.height.mas_equalTo(20);
    }];
    // 进度显示
    [self.matchProessView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(3);
        make.left.equalTo(self.titleLabel.mas_left);
        make.right.equalTo(self.contentView.mas_right).offset(-37);
        make.height.mas_equalTo(@2);
    }];
}

- (void)setFileModel:(JRFileModel *)fileModel {
    
    if (_fileModel != fileModel ) {
        _fileModel = fileModel;
    }
    self.titleLabel.text = fileModel.name;
    switch (fileModel.fileType) {
        case 0:
        { // FileTypePDF
            self.imagev.image = [JRUIHelper imageNamed:@"i_pdf_medium"];
            break;
        }
        case 1:
        { // FileTypeDOC
            self.imagev.image = [JRUIHelper imageNamed:@"i_word_medium"];
            break;
        }

        case 2:
        {// FileTypePSD
            self.imagev.image = [JRUIHelper imageNamed:@"i_psd_medium"];
            break;
        }

        case 3:
        {// FileTypeXLS
            self.imagev.image = [JRUIHelper imageNamed:@"i_excel_medium"];
            
            break;
        }
            
        case 4:
        {// FileTypePPT
            self.imagev.image = [JRUIHelper imageNamed:@"i_ppt_medium"];
            break;
        }
        case 5:
        {// FileTypeTXT
            self.imagev.image = [JRUIHelper imageNamed:@"i_txt_medium"];
            break;
        }
            
        default:
            // 其他文件
            self.imagev.image = [JRUIHelper imageNamed:@"i_file_medium"];
            
            break;
    }
    
    [self setObserve];

}

-(void)setObserve{
    [_msgKVO unobserveAll];
      if (!_msgKVO) {
          _msgKVO = [FBKVOController controllerWithObserver:self];
      }
    // observe clock date property
    __weak typeof(self) _self = self;
    ///进度添加观察
    [_msgKVO observe:self.fileModel keyPath:@"progress" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
        __strong typeof(_self) self = _self;
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"上传进度--%.1f",self.fileModel.progress);
            self.matchProessView.progressValue = self.fileModel.progress/100.0 * (self.bounds.size.width-20);
        });
        
    }];
    
    ///url添加观察，根据是否存在url判断是否上传成功
    [_msgKVO observe:self.fileModel keyPath:@"fileUrl" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
        __strong typeof(_self) self = _self;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.fileModel.fileUrl.length > 0) {
                self.matchProessView.hidden = YES;
            }else{
                self.matchProessView.hidden = NO;
            }
        });
        
    }];
    
    ///观察是否上传失败
    [_msgKVO observe:self.fileModel keyPath:@"uploadFail" options:NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
        __strong typeof(_self) self = _self;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.fileModel.uploadFail) {
                self.deleteButton.hidden = NO;
//                [self uploadFaildView];
            }else{
                self.deleteButton.hidden = NO;
            }
        });
        
    }];
    
}

-(void)remove{
    if (_msgKVO) {
        [_msgKVO unobserveAll];
    }
}

- (UIImageView *)imagev{
    if (!_imagev) {
        _imagev = [[UIImageView alloc] init];
        _imagev.frame = CGRectMake(0, 0, 20, 20);
    }
    return _imagev;
}
- (UIButton *)deleteButton{
    if (!_deleteButton) {
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteButton.frame = CGRectMake(CGRectGetWidth(self.bounds)-20, 0, 20, 20);
        UIImage *btnImage = [JRUIHelper imageNamed:@"i_clear_search"];
        [_deleteButton setBackgroundImage:btnImage forState:UIControlStateNormal];
    }
    return _deleteButton;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = [UIColor colorWithHex:@"#000000"];
        _titleLabel.font = [UIFont systemFontOfSize:16];
    }
    return _titleLabel;
}

- (UILabel *)faildTitleLabel {
    if (!_faildTitleLabel) {
        _faildTitleLabel = [[UILabel alloc]init];
    }
    _faildTitleLabel.textColor = [UIColor colorWithHex:@"#F55C54"];
    _faildTitleLabel.font = [UIFont systemFontOfSize:16];
    return _faildTitleLabel;
}

-(JRProcessView *)matchProessView{
    if (!_matchProessView) {
        _matchProessView = [[JRProcessView alloc]initWithFrame:CGRectMake(30, 100, [[UIScreen mainScreen] bounds].size.width - 60, 5)];
        _matchProessView.progressHeight = 2.0;
        _matchProessView.changeTintColor = [UIColor colorWithHex:@"#0EA856"];
        _matchProessView.progressTintColor = [UIColor colorWithHex:@"#E2E9E7"];
    }
    return _matchProessView;
}

- (void)dealloc
{
     [self remove];
}

@end
