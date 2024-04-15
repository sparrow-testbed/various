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

#import "JRUPLoadFaileCell.h"

@implementation JRUPLoadFaileCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.image1.layer.cornerRadius = 3;
    self.image2.layer.cornerRadius = 3.0;
    self.image3.layer.cornerRadius = 3.0;
    self.image4.layer.cornerRadius = 3.0;
    
    self.image1.userInteractionEnabled = YES;
    self.image2.userInteractionEnabled = YES;
    self.image4.userInteractionEnabled = YES;

    //添加点击手势
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click1Action:)];
    [self.image1 addGestureRecognizer:tapGesture];
    
    
    //添加点击手势
    UITapGestureRecognizer *click2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click1Action:)];
    [self.image2 addGestureRecognizer:click2];
    
    //添加点击手势
    UITapGestureRecognizer *click4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click1Action:)];
    [self.image4 addGestureRecognizer:click4];
    
    
    
}

- (void)click1Action:(UITapGestureRecognizer *)gesuture {
    YBIBImageData *data1 = [YBIBImageData new];
    //data1.imagePHAsset =  imageModel.phAsset;// 本地图片
    
    if (gesuture.view.tag == 990) {
        data1.projectiveView = self.image1;
        data1.imageName = @"p1.jpeg";
    }else if(gesuture.view.tag == 991) {
        
        NSString *filePath = [[NSBundle mainBundle]pathForResource:@"testVideo" ofType:@"mp4"];
        // 视频
        YBIBVideoData *videoData = [YBIBVideoData new];
        videoData.videoURL = [NSURL URLWithString:filePath];
        videoData.projectiveView = self.image2;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            YBImageBrowser *browser = [YBImageBrowser new];
            browser.dataSourceArray = @[videoData];
            browser.currentPage = 1;
            [browser show];
        });
        
        
    }else if(gesuture.view.tag == 992) {
        data1.projectiveView = self.image4;
        data1.imageName = @"p2.jpeg";
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
