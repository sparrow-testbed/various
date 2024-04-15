//
//  JRThumbImageCollectionViewCell.m
//  JRPodPrivate_Example
//
//  Created by 金煜祥 on 2020/9/24.
//  Copyright © 2020 wni. All rights reserved.
//

#import "JRThumbImageCollectionViewCell.h"

@implementation JRThumbImageCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.thumbImageView = [[UIImageView alloc]init];
        self.thumbImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:self.thumbImageView];
        
        [self.thumbImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(7);
             make.left.equalTo(self.contentView).offset(12);
            make.right.bottom.equalTo(self.contentView);
        }];
        self.thumbImageView.layer.borderColor = [UIColor jk_colorWithHexString:@"#0EA856"].CGColor;
        self.thumbImageView.layer.cornerRadius = 4.0;
        self.thumbImageView.layer.masksToBounds = YES;
        
        self.videoFlagImageView = [[UIImageView alloc]initWithImage:[JRUIHelper imageNamed:@"jr_video_flag"]];
        [self.contentView addSubview:self.videoFlagImageView];
        [self.videoFlagImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView).offset(-2);
            make.left.equalTo(self.contentView.mas_left).offset(16);
        }];
        
        self.maskView = [[UIView alloc]init];
        [self.contentView addSubview:self.maskView];
        [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(7);
            make.left.equalTo(self.contentView).offset(12);
            make.right.bottom.equalTo(self.contentView);
        }];
        self.maskView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
        self.maskView.hidden = YES;
        
        self.maskView.layer.borderColor = [UIColor jk_colorWithHexString:@"#0EA856"].CGColor;
        self.maskView.layer.cornerRadius = 4.0;
        self.maskView.layer.masksToBounds = YES;
        
    }
    return self;
}
- (void)setJrIsSelected:(BOOL)jrIsSelected{
    _jrIsSelected = jrIsSelected;
    if (_jrIsSelected) {
        self.thumbImageView.layer.borderWidth = 2;
        self.maskView.layer.borderWidth = 2;
    }else{
        self.thumbImageView.layer.borderWidth = 0;
        self.maskView.layer.borderWidth = 0;
    }
}
@end
