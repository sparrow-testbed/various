//
/**
* 所属系统: YMMAD
* 所属模块: 
* 功能描述: 
* 创建时间: 2021/3/3
* 维护人:  马克
* Copyright © 2021 wni. All rights reserved.
*┌─────────────────────────────────────────────────────┐
*│ 此技术信息为本公司机密信息，未经本公司书面同意禁止向第三方披露．│
*│ 版权所有：杰人软件(深圳)有限公司                          │
*└─────────────────────────────────────────────────────┘
*/

#import "JRUploadPreviewController.h"
#import "JRForbiddenCell.h"
#import "JRNormalCell.h"
#import "JRUPLoadFaileCell.h"
#import "JRUploadNormalCell.h"

#define MainScreenWidth [[UIScreen mainScreen]bounds].size.width
#define MainScreenHeight [[UIScreen mainScreen]bounds].size.height

@interface JRUploadPreviewController ()
@property(nonatomic,strong)UIScrollView *mainScrollView;
@property(nonatomic,strong)JRForbiddenCell *forBiddenCell;
@property(nonatomic,strong)JRNormalCell *normalCell;
@property(nonatomic,strong)JRUPLoadFaileCell *uploadFaileCell;
@property(nonatomic,strong)JRUploadNormalCell *uploadNormalCell;
@end

@implementation JRUploadPreviewController

- (UIScrollView *)mainScrollView {
    if (!_mainScrollView) {
        _mainScrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
        _mainScrollView.backgroundColor = [UIColor whiteColor];
    }
    return _mainScrollView;
}

//禁用
- (JRForbiddenCell *)forBiddenCell {
    if (!_forBiddenCell) {
        _forBiddenCell =  [[[NSBundle mainBundle]loadNibNamed:@"JRForbiddenCell" owner:nil options:nil]lastObject];
        _forBiddenCell.frame = CGRectMake(0, 0,MainScreenWidth, 100);
    }
    return _forBiddenCell;
}

//正常
- (JRNormalCell *)normalCell {
    if (!_normalCell) {
        _normalCell =  [[[NSBundle mainBundle]loadNibNamed:@"JRNormalCell" owner:nil options:nil]lastObject];
        _normalCell.frame = CGRectMake(0,100,MainScreenWidth, 100);
    }
    return _normalCell;
}

//上传失败cell
- (JRUPLoadFaileCell *)uploadFaileCell {
    if (!_uploadFaileCell) {
        _uploadFaileCell =  [[[NSBundle mainBundle]loadNibNamed:@"JRUPLoadFaileCell" owner:nil options:nil]lastObject];
        _uploadFaileCell.frame = CGRectMake(0, 200, SCREEN_WIDTH, 248);
    }
    _uploadFaileCell.userInteractionEnabled = YES;
    return _uploadFaileCell;
}
//上传成功cell
- (JRUploadNormalCell *)uploadNormalCell {
    if (!_uploadNormalCell) {
        _uploadNormalCell =  [[[NSBundle mainBundle]loadNibNamed:@"JRUploadNormalCell" owner:nil options:nil]lastObject];
        _uploadNormalCell.frame = CGRectMake(0, 448, SCREEN_WIDTH, 248);
    }
    return _uploadNormalCell;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.mainScrollView];
    
    [self.mainScrollView addSubview:self.forBiddenCell];
        
    [self.mainScrollView addSubview:self.normalCell];
        
    [self.mainScrollView addSubview:self.uploadFaileCell];
    
    [self.mainScrollView addSubview:self.uploadNormalCell];
    
    //初始化scrollview 高度
    float scrollsizeHeight = CGRectGetHeight(self.forBiddenCell.frame)+CGRectGetHeight(self.normalCell.frame)+CGRectGetHeight(self.uploadFaileCell.frame)+CGRectGetHeight(self.uploadNormalCell.frame)+200;

    self.mainScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, scrollsizeHeight);
}



@end
