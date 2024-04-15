//
/**
* 所属系统: component
* 所属模块: 
* 功能描述: 
* 创建时间: 2020/9/18
* 维护人:  王伟
* Copyright © 2020 wni. All rights reserved.
*┌─────────────────────────────────────────────────────┐
*│ 此技术信息为本公司机密信息，未经本公司书面同意禁止向第三方披露．│
*│ 版权所有：杰人软件(深圳)有限公司                          │
*└─────────────────────────────────────────────────────┘
*/

#import "JRButtonViewController.h"

@interface JRButtonViewController ()

@end

@implementation JRButtonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIScrollView *scrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    scrollerView.contentSize = CGSizeMake(0, SCREEN_HEIGHT * 1.5);
    [self.view addSubview:scrollerView];
    
    self.view.backgroundColor = [UIColor colorWithHex:@"#F9FBF9"];
    JRUIButton *button = [[JRUIButton alloc] initWithFrame:CGRectMake(20, 20, SCREEN_WIDTH - 40, 48)];
    button.buttonStatus = JRPrincipalButtonStatus;
    button.title = @"主要按钮";
    [scrollerView addSubview:button];
    
    JRUIButton *button1 = [[JRUIButton alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(button.frame) + 12, SCREEN_WIDTH - 40, 48)];
    button1.buttonStatus = JRPrincipalButtonStatus;
    button1.disable = true;
    button1.title = @"禁用状态";
    [scrollerView addSubview:button1];
    
    JRUIButton *button2 = [[JRUIButton alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(button1.frame) + 12, SCREEN_WIDTH - 40, 48)];
    button2.buttonStatus = JRSecondaryButtonStatus;
    button2.title = @"次要按钮";
    [scrollerView addSubview:button2];
    
    JRUIButton *button3 = [[JRUIButton alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(button2.frame) + 12, SCREEN_WIDTH - 40, 48)];
    button3.buttonStatus = JRSecondaryButtonStatus;
    button3.disable = true;
    button3.title = @"禁用状态";
    [scrollerView addSubview:button3];
    
    JRUIButton *button4 = [[JRUIButton alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(button3.frame) + 12, SCREEN_WIDTH - 40, 48)];
    button4.buttonStatus = JRDangerButtonStatus;
    button4.title = @"危险按钮";
    [scrollerView addSubview:button4];
    
    JRUIButton *button5 = [JRUIButton buttonWithType:UIButtonTypeCustom];
    button5.frame = CGRectMake(20, CGRectGetMaxY(button4.frame) + 12, SCREEN_WIDTH - 40, 48);
    button5.buttonStatus = JRDangerButtonStatus;
    button5.disable = true;
    button5.title = @"禁用状态";
    [scrollerView addSubview:button5];
    
    JRUIButton *button61 = [[JRUIButton alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(button5.frame) + 21, SCREEN_WIDTH/2 - 30, 48)];
    button61.buttonStatus = JRPrincipalButtonStatus;
    button61.title = @"主要按钮";
    [scrollerView addSubview:button61];
    
    JRUIButton *button62 = [[JRUIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 + 10, CGRectGetMaxY(button5.frame) + 21, SCREEN_WIDTH/2 - 30, 48)];
    button62.buttonStatus = JRPrincipalButtonStatus;
    button62.bgColor = [UIColor whiteColor];
    button62.borderColor = [UIColor colorWithHex:@"#DCE5E2"];
    button62.shadowColor = [UIColor colorWithHex:@"#182A4D" alpha:0.16];
    button62.title = @"次要按钮";
    button62.titleColor = [UIColor colorWithHex:@"#000000"];
    [scrollerView addSubview:button62];
    
    JRUIButton *button71 = [[JRUIButton alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(button61.frame) + 20, SCREEN_WIDTH/2 - 30, 48)];
    button71.buttonStatus = JRPrincipalButtonStatus;
    button71.disable = true;
    button71.title = @"禁用状态";
    [scrollerView addSubview:button71];
    
    JRUIButton *button72 = [[JRUIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 + 10, CGRectGetMaxY(button61.frame) + 20, SCREEN_WIDTH/2 - 30, 48)];
    button72.buttonStatus = JRPrincipalButtonStatus;
    button72.disable = true;
    button72.bgColor = [UIColor whiteColor];
    button72.borderColor = [UIColor colorWithHex:@"#DCE5E2"];
    button72.shadowColor = [UIColor colorWithHex:@"#182A4D" alpha:0.16];
    button72.title = @"禁用状态";
    button72.titleColor = [UIColor colorWithHex:@"#000000" alpha:0.5];
    [scrollerView addSubview:button72];
    
    [button addTarget:self action:@selector(button72test) forControlEvents:UIControlEventTouchUpInside];
    
    JRUIButton *button81 = [[JRUIButton alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(button71.frame) + 20, 83, 30)];
    button81.title = @"课堂表现";
    button81.buttonStatus = JRSegmentSelectButtonStatus;
    [scrollerView addSubview:button81];
    
    JRUIButton *button82 = [[JRUIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(button81.frame) + 15, CGRectGetMaxY(button71.frame) + 20, 83, 30)];
    button82.title = @"作品点评";
    button82.buttonStatus = JRSegmentNormalButtonStatus;
    [scrollerView addSubview:button82];
    
    JRUIButton *button91 = [[JRUIButton alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(button81.frame) + 20, 83, 30)];
    button91.title = @"禁用状态";
    button91.buttonStatus = JRSegmentSelectButtonStatus;
    button91.disable = true;
    [scrollerView addSubview:button91];
    
    JRUIButton *button92 = [[JRUIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(button81.frame) + 15, CGRectGetMaxY(button81.frame) + 20, 83, 30)];
    button92.title = @"禁用状态";
    button92.buttonStatus = JRSegmentNormalButtonStatus;
    button92.disable = true;
    [scrollerView addSubview:button92];
    
    JRUIButton *button100 = [[JRUIButton alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(button91.frame) + 20, 85, 30)];
    button100.title = @"2020年";
    button100.buttonStatus = JRYearsNormalButtonStatus;
    [scrollerView addSubview:button100];
    
    JRUIButton *button101 = [[JRUIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(button100.frame) + 15, CGRectGetMaxY(button91.frame) + 20, 85, 30)];
    button101.title = @"2020年";
    button101.buttonStatus = JRYearsSelectButtonStatus;
    [scrollerView addSubview:button101];
    // Do any additional setup after loading the view.
}

- (void)button72test{
    JRLog(@"3123123123");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
