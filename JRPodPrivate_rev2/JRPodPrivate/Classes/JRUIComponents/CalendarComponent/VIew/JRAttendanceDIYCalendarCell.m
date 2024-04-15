/**
 * 所属系统: 新学生考勤
 * 所属模块: 学生考勤 日历
 * 功能描述: 日历Cell
 * 创建时间: 2019/4/16.
 * 维护人:  罗鸿
 * Copyright @ Jerrisoft 2019. All rights reserved.
 *┌─────────────────────────────────────────────────────┐
 *│ 此技术信息为本公司机密信息，未经本公司书面同意禁止向第三方披露．│
 *│ 版权所有：杰人软件(深圳)有限公司                          │
 *└─────────────────────────────────────────────────────┘
 */

#import "JRAttendanceDIYCalendarCell.h"
#import "JRCalendarExtensions.h"

@implementation JRAttendanceDIYCalendarCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
//        UIImage *image = [UIImage imageNamed:@"b_day_hl"];
//        UIImageView *circleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"b_day_hl"]];
//        circleImageView.contentMode = UIViewContentModeScaleAspectFit;
//        circleImageView.frame = CGRectMake(6.5, 3, image.size.width, image.size.height);
//        [self.contentView insertSubview:circleImageView atIndex:0];
//        self.circleImageView = circleImageView;
        self.backgroundView = [[UIView alloc] initWithFrame:self.bounds];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    //self.backgroundView.frame = CGRectInset(self.bounds, 5, 5);
    //self.circleImageView.frame = self.backgroundView.frame;
    
//    self.circleImageView.center = self.backgroundView.center; // 居中
}


- (void)configureAppearance {
    [super configureAppearance];

    self.eventIndicator.color = [UIColor whiteColor];

    if (self.isSelected) {
        self.eventIndicator.color = [UIColor clearColor];
//        self.circleImageView.hidden = NO;
    } else {
       self.eventIndicator.color = [UIColor whiteColor];
//        self.circleImageView.hidden = YES;
    }

    if (self.mark) {
        self.titleLabel.textColor = [UIColor whiteColor];
    } else {
        self.titleLabel.textColor = [[UIColor whiteColor]colorWithAlphaComponent:0.3];
    }
 
    
}

@end
