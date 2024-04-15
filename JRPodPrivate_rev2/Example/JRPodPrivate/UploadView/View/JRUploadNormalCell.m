//
/**
* 所属系统: YMMAD
* 所属模块: 
* 功能描述: 
* 创建时间: 2021/2/20
* 维护人:  马克
* Copyright © 2021 wni. All rights reserved.
*┌─────────────────────────────────────────────────────┐
*│ 此技术信息为本公司机密信息，未经本公司书面同意禁止向第三方披露．│
*│ 版权所有：杰人软件(深圳)有限公司                          │
*└─────────────────────────────────────────────────────┘
*/

#import "JRUploadNormalCell.h"

@implementation JRUploadNormalCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.image1.layer.cornerRadius = 3;
    self.image2.layer.cornerRadius = 3;
    self.image3.layer.cornerRadius = 3;
    self.image4.layer.cornerRadius = 3;
    self.image5.layer.cornerRadius = 3;
        
    self.image1.userInteractionEnabled = YES;
    self.image2.userInteractionEnabled = YES;
    self.image3.userInteractionEnabled = YES;
    self.image4.userInteractionEnabled = YES;
    self.image5.userInteractionEnabled = YES;
    
    for (int i = 0 ; i<=5; i++) {
        //添加点击手势
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click1Action:)];
        if (i == 0) {
            [self.image1 addGestureRecognizer:tapGesture];
        }
        if (i == 1) {
            [self.image2 addGestureRecognizer:tapGesture];
        }
        if (i == 2) {
            [self.image3 addGestureRecognizer:tapGesture];
        }
        if (i == 3) {
            [self.image4 addGestureRecognizer:tapGesture];
        }
        if (i == 4) {
            [self.image5 addGestureRecognizer:tapGesture];
        }
    }
    
}

- (void)click1Action:(UITapGestureRecognizer *)gesuture {
    YBIBImageData *data1 = [YBIBImageData new];
    //data1.imagePHAsset =  imageModel.phAsset;// 本地图片
    
    if (gesuture.view.tag == 990) {
        data1.projectiveView = self.image1;
        data1.imageName = @"p1.jpeg";
    }else if(gesuture.view.tag == 991) {
        data1.projectiveView = self.image2;
        data1.imageName = @"p2.jpeg";
    }else if(gesuture.view.tag == 992) {
        data1.projectiveView = self.image3;
        data1.imageName = @"p1.jpeg";
    }else if(gesuture.view.tag == 993) {
        data1.projectiveView = self.image4;
        data1.imageName = @"p2.jpeg";
    }else if(gesuture.view.tag == 994) {
        data1.projectiveView = self.image5;
        data1.imageName = @"p3.jpeg";
    }
    
    YBImageBrowser *browser = [YBImageBrowser new];
    browser.dataSourceArray = @[data1];
    browser.currentPage = 1;
    [browser show];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
