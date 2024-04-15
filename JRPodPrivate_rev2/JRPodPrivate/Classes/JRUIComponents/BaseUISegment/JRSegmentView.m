//
/**
* 所属系统: component
* 所属模块: UIView
* 功能描述: 基础选型卡
* 创建时间: 2020/9/22
* 维护人:  王伟
* Copyright © 2020 wni. All rights reserved.
*┌─────────────────────────────────────────────────────┐
*│ 此技术信息为本公司机密信息，未经本公司书面同意禁止向第三方披露．│
*│ 版权所有：杰人软件(深圳)有限公司                          │
*└─────────────────────────────────────────────────────┘
*/

#import "JRSegmentView.h"
#import "JRUIKit.h"

@implementation JRSegmentView

/// 初始化标签View
/// @param frame frame description
/// @param dataSource 数据源
/// @param showLine 是否展示竖线分割线
/// @param textFont 字体大小
/// @param defaultColor 默认颜色
/// @param selectColor 选中颜色
- (instancetype)initWithFrame:(CGRect)frame dataSource:(NSArray *)dataSource showLine:(BOOL)showLine textFont:(nullable UIFont *)textFont defaultColor:(nullable UIColor *)defaultColor selectColor:(nullable UIColor *)selectColor
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHex:@"#FFFFFF"];
        self.dataSource = dataSource;
        self.showLine = showLine;
        self.textFont = textFont;
        self.defaultColor = defaultColor;
        self.selectColor = selectColor;
        for (int i = 0; i < dataSource.count; i ++) {
            UIButton *tagsButton = [UIButton buttonWithType:UIButtonTypeCustom];
            tagsButton.tag = 1000 + i;
            [tagsButton setTitle:dataSource[i] forState:UIControlStateNormal];
            tagsButton.titleLabel.font = textFont ?: [UIFont systemFontOfSize:15];
            [tagsButton setTitleColor:defaultColor?:[UIColor colorWithHex:@"#666666"] forState:UIControlStateNormal];
            [tagsButton addTarget:self action:@selector(tagsButtonCilcked:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:tagsButton];
            CGFloat buttonX = frame.size.width / dataSource.count * i;
            CGFloat buttonW = frame.size.width / dataSource.count;
            tagsButton.frame = CGRectMake(buttonX , 0, buttonW, frame.size.height);
            if (i == 0) {
                self.selectButton = tagsButton;
                [self.selectButton setTitleColor:selectColor?:[UIColor colorWithHex:@"#0EA856"] forState:UIControlStateNormal];

                self.dividedView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMidX(tagsButton.frame) - 11, frame.size.height - 2, 22, 2)];
                self.dividedView.layer.cornerRadius = 1;
                self.dividedView.backgroundColor = selectColor ?: [UIColor colorWithHex:@"#0EA856"];
                [self addSubview:self.dividedView];
            }
        }
        
        if (showLine) {
            for (int i = 1; i < dataSource.count; i ++) {
                CGFloat verticallineX = frame.size.width / dataSource.count * i;
                UIView *verticalline = [[UIView alloc] initWithFrame:CGRectMake(verticallineX, CGRectGetMidY(self.bounds) - 7.5, 0.35, 15)];
                verticalline.backgroundColor = [UIColor colorWithHex:@"#ABC0BA"];
                [self addSubview:verticalline];
            }
        }
        
        UIView *botView = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height - PixelOne, frame.size.width, PixelOne)];
        botView.backgroundColor = [UIColor colorWithHex:@"#ACC0BA"];
        [self addSubview:botView];
    }
    return self;
}

- (void)tagsButtonCilcked:(UIButton *)sender{
    if (self.selectButton != sender) {
        [self.selectButton setTitleColor:[UIColor colorWithHex:@"#666666"] forState:UIControlStateNormal];
    }else{
        return;
    }
    [sender setTitleColor:[UIColor colorWithHex:@"#0EA856"] forState:UIControlStateNormal];
    self.selectButton = sender;

    _dividedView.frame = CGRectMake(CGRectGetMidX(sender.frame) - 11, self.size.height - 2, 22, 2);
    if (self.segmentBlock) {
        self.segmentBlock(sender, sender.tag - 1000);
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
