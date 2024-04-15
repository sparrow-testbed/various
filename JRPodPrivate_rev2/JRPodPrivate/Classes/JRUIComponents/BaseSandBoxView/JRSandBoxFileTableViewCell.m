//
/**
* 所属系统: component
* 所属模块: 
* 功能描述: 
* 创建时间: 2020/9/26
* 维护人:  王伟
* Copyright © 2020 wni. All rights reserved.
*┌─────────────────────────────────────────────────────┐
*│ 此技术信息为本公司机密信息，未经本公司书面同意禁止向第三方披露．│
*│ 版权所有：杰人软件(深圳)有限公司                          │
*└─────────────────────────────────────────────────────┘
*/

#import "JRSandBoxFileTableViewCell.h"
#import "JRFileModel.h"
#import "JRUIKit.h"

#define CELL_TEXT_FONT      [UIFont systemFontOfSize:16]
#define     TEXT_COLOR     [UIColor colorWithHex:@"#29343f"]
#define TIME_TEXT_FONT      [UIFont systemFontOfSize:13]
#define     CELL_TEXT_COLOR  [UIColor colorWithHex:@"#585858"]

@interface JRSandBoxFileTableViewCell ()

@property (nonatomic, strong) UIImageView *fileImgView;
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UILabel *sizeL;
@property (nonatomic, strong) UILabel *stateL;

@end


static NSInteger const INTERVAL = 10;
static NSString *JRSandboxFileCellId = @"JRSandboxFileCellId";

@implementation JRSandBoxFileTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    JRSandBoxFileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:JRSandboxFileCellId];
    if (cell == nil) {
        cell = [[JRSandBoxFileTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:JRSandboxFileCellId];
    }
    return cell;
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self addContentView];
    }
    return self;
}

- (void)addContentView {
    
    [self addSubview:self.fileImgView];
    [self addSubview:self.titleL];
    [self addSubview:self.sizeL];
    [self addSubview:self.stateL];
    
}

- (void)setModel:(JRFileModel *)model {
    
    _model = model;
    
    self.titleL.text = _model.name;
    self.sizeL.text = [NSString FileSizeFromSizeValue:_model.size];
    self.stateL.text = _model.createDate;

    switch (model.fileType) {
        case FileTypePSD:
            self.fileImgView.image = [JRUIHelper imageNamed:@"i_psd_medium"];
            break;
        case FileTypeDOC:
            self.fileImgView.image = [JRUIHelper imageNamed:@"i_word_medium"];
            break;
        case FileTypePDF:
            self.fileImgView.image = [JRUIHelper imageNamed:@"i_pdf_medium"];
            break;
        case FileTypeXLS:
            self.fileImgView.image = [JRUIHelper imageNamed:@"i_excel_medium"];
            break;
        case FileTypePPT:
            self.fileImgView.image = [JRUIHelper imageNamed:@"i_ppt_medium"];
            break;
        case FileTypeTXT:
            self.fileImgView.image = [JRUIHelper imageNamed:@"i_txt_medium"];
            break;
        case FileTypeZIP:
            self.fileImgView.image = [JRUIHelper imageNamed:@"i_zip_medium"];
            break;
     
        case FileTypeVIDEO:
            self.fileImgView.image = [JRUIHelper imageNamed:@"i_video_medium"];
            break;
        default:
            self.fileImgView.image = [JRUIHelper imageNamed:@"i_file_medium"];
            break;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.fileImgView.frame = CGRectMake(INTERVAL, INTERVAL, self.height - 2 *INTERVAL, self.height - 2 *INTERVAL);
    self.titleL.frame = CGRectMake(self.fileImgView.right + INTERVAL, INTERVAL, self.width - self.fileImgView.width - 3*INTERVAL, self.height - 2 *INTERVAL - 40);
    self.sizeL.frame = CGRectMake(self.fileImgView.right + INTERVAL, self.titleL.bottom, self.titleL.width, 20);
    self.stateL.frame = CGRectMake(self.fileImgView.right + INTERVAL, self.sizeL.bottom, self.titleL.width, 20);
}

- (UIImageView *)fileImgView {
    
    if (!_fileImgView) {
        _fileImgView = [[UIImageView alloc] init];
        _fileImgView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _fileImgView;
}

- (UILabel *)titleL {
    
    if (!_titleL) {
        _titleL = [UILabel new];
        _titleL.textAlignment = NSTextAlignmentLeft;
        _titleL.font = CELL_TEXT_FONT;
        _titleL.textColor = TEXT_COLOR;
    }
    return _titleL;
}

- (UILabel *)sizeL {
    
    if (!_sizeL) {
        _sizeL = [UILabel new];
        _sizeL.font = TIME_TEXT_FONT;
        _sizeL.textColor = CELL_TEXT_COLOR;
    }
    return _sizeL;
}

- (UILabel *)stateL {
    
    if (!_stateL) {
        _stateL = [UILabel new];
        _stateL.font = TIME_TEXT_FONT;
        _stateL.textColor = CELL_TEXT_COLOR;
    }
    return _stateL;
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
