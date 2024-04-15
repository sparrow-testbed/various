//
/**
* 所属系统: 移动组件
* 所属模块: 空数据页面
* 功能描述: 
* 创建时间: 2020/9/21
* 维护人:  李志䶮
* Copyright © 2020 wni. All rights reserved.
*┌─────────────────────────────────────────────────────┐
*│ 此技术信息为本公司机密信息，未经本公司书面同意禁止向第三方披露．│
*│ 版权所有：杰人软件(深圳)有限公司                          │
*└─────────────────────────────────────────────────────┘
*/

#import "JRNoDataView.h"
#import "JRUIKit.h"

@implementation JRNoDataView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.whiteColor;
        //占位图
        self.placeholderImageV = [[UIImageView alloc] init];
        [self addSubview:self.placeholderImageV];
        self.placeholderImageV.image = [JRUIHelper imageNamed:@"pic_nothing"];
        //占位文字
        
        self.placeholderLabel = [[UILabel alloc] init];
        self.placeholderLabel.textAlignment = NSTextAlignmentCenter;
        self.placeholderLabel.numberOfLines = 0;
        [self addSubview:self.placeholderLabel];
        self.placeholderLabel.textColor = [UIColor jk_colorWithHexString:@"#999999"];
        self.placeholderLabel.font = [UIFont systemFontOfSize:14];
        self.placeholderLabel.text = @"搜索不到结果";
        
        [self.placeholderImageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(@0);
            make.centerX.mas_equalTo(self.mas_centerX);
        }];
        
        [self.placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.placeholderImageV.mas_bottom);
            make.centerX.mas_equalTo(self.mas_centerX);
            make.bottom.mas_equalTo(@0);
        }];
    }
    return self;
}

/// 弹出空白弹窗
/// @param superView 被添加的View
/// @param noDataImageName 空白图片名
/// @param noDataTitle 空白标题
/// @param topInset 距离顶部距离
+(void)showNodataWithSuperView:(UIView*)superView noDataImageName:(nullable NSString *)noDataImageName noDataTitle:(nullable NSString *)noDataTitle topInset:(CGFloat)topInset{
    JRNoDataView * nodataView = [[JRNoDataView alloc]init];
    if (noDataImageName.length) {
        nodataView.placeholderImageV.image = [JRUIHelper imageNamed:noDataImageName];
    }
    if (noDataTitle.length) {
        nodataView.placeholderLabel.text = noDataTitle;
    }
    [superView addSubview:nodataView];
    [nodataView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(superView.mas_centerY).offset(-(30 + topInset));
        make.centerX.mas_equalTo(superView.mas_centerX);
    }];
}

/// 弹出空白弹窗
/// @param superView 被添加的View
/// @param noDataImageName 空白图片名
/// @param noDataTitle 空白标题
+(void)showNodataWithSuperView:(UIView*)superView noDataImageName:(nullable NSString *)noDataImageName noDataTitle:(nullable NSString *)noDataTitle{
    [self showNodataWithSuperView:superView noDataImageName:noDataImageName noDataTitle:noDataTitle topInset:0];
}

+(void)hidNodataWithSuperView:(UIView*)superView{
    for (UIView * view in superView.subviews) {
        if ([view isKindOfClass:self]) {
            [view removeFromSuperview];
        }
    }
}


@end
