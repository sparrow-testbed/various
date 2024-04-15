//
/**
* 所属系统: component
* 所属模块: 
* 功能描述: 
* 创建时间: 2020/9/22
* 维护人:  王伟
* Copyright © 2020 wni. All rights reserved.
*┌─────────────────────────────────────────────────────┐
*│ 此技术信息为本公司机密信息，未经本公司书面同意禁止向第三方披露．│
*│ 版权所有：杰人软件(深圳)有限公司                          │
*└─────────────────────────────────────────────────────┘
*/

#import "JROtherViewController.h"
#import "JRCheckBoxView.h"

@interface JROtherViewController ()

@end

@implementation JROtherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHex:@"#F9FBF9"];
    CGFloat boxW = 90;
    CGFloat boxX = 80;
    
    UILabel *tlabel1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, CurrentDeviceWidth, 30)];
    tlabel1.font = [UIFont boldSystemFontOfSize:16];
    tlabel1.textColor = [UIColor colorWithHex:@"#174C30"];
    tlabel1.text = @"Checkbox 复选框";
    [self.view addSubview:tlabel1];
    
    UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(tlabel1.frame) + 20, 60, 30)];
    titleL.font = [UIFont systemFontOfSize:16];
    titleL.text = @"单选：";
    [self.view addSubview:titleL];
    JRCheckBoxView *boxView1 = [[JRCheckBoxView alloc] initWithFrame:CGRectMake(boxX, CGRectGetMinY(titleL.frame), boxW, 30)];
    boxView1.contenLabel.text = @"正常";
    boxView1.checkType = JRCheckBoxTypeSingleNormal;
    [self.view addSubview:boxView1];
    
    JRCheckBoxView *boxView11 = [[JRCheckBoxView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(boxView1.frame), CGRectGetMinY(titleL.frame), boxW, 30)];
    boxView11.contenLabel.text = @"禁用";
    boxView11.checkType = JRCheckBoxTypeSingleNormalDisable;
    [self.view addSubview:boxView11];
    
    JRCheckBoxView *boxView21 = [[JRCheckBoxView alloc] initWithFrame:CGRectMake(boxX, CGRectGetMaxY(boxView1.frame) + 10, boxW, 30)];
    boxView21.contenLabel.text = @"选中";
    boxView21.checkType = JRCheckBoxTypeSingleSelect;
    [self.view addSubview:boxView21];
    
    JRCheckBoxView *boxView22 = [[JRCheckBoxView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(boxView21.frame), CGRectGetMaxY(boxView1.frame) + 10, boxW, 30)];
    boxView22.contenLabel.text = @"禁用";
    boxView22.checkType = JRCheckBoxTypeSingleSelectDisable;
    [self.view addSubview:boxView22];
    
    UILabel *titleL1 = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(boxView21.frame) + 20, 60, 30)];
    titleL1.font = [UIFont systemFontOfSize:16];
    titleL1.text = @"复选：";
    [self.view addSubview:titleL1];
    JRCheckBoxView *boxView31 = [[JRCheckBoxView alloc] initWithFrame:CGRectMake(boxX, CGRectGetMaxY(boxView21.frame) + 20, boxW, 30)];
    boxView31.contenLabel.text = @"正常";
    boxView31.checkType = JRCheckBoxTypeMultipleNormal;
    [self.view addSubview:boxView31];
    
    JRCheckBoxView *boxView32 = [[JRCheckBoxView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(boxView31.frame), CGRectGetMaxY(boxView21.frame) + 20, boxW, 30)];
    boxView32.contenLabel.text = @"禁用";
    boxView32.checkType = JRCheckBoxTypeMultipleNormalDisable;
    [self.view addSubview:boxView32];
    
    JRCheckBoxView *boxView41 = [[JRCheckBoxView alloc] initWithFrame:CGRectMake(boxX, CGRectGetMaxY(boxView31.frame) + 10, boxW, 30)];
    boxView41.contenLabel.text = @"选中";
    boxView41.checkType = JRCheckBoxTypeMultipleSelect;
    [self.view addSubview:boxView41];
    
    JRCheckBoxView *boxView42 = [[JRCheckBoxView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(boxView41.frame), CGRectGetMaxY(boxView31.frame) + 10, boxW, 30)];
    boxView42.contenLabel.text = @"禁用";
    boxView42.checkType = JRCheckBoxTypeMultipleSelectDisable;
    [self.view addSubview:boxView42];
    
    UILabel *tlabel2 = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(boxView41.frame) + 50, CurrentDeviceWidth, 30)];
    tlabel2.font = [UIFont boldSystemFontOfSize:16];
    tlabel2.textColor = [UIColor colorWithHex:@"#174C30"];
    tlabel2.text = @"Switch 开关";
    [self.view addSubview:tlabel2];
    
    UILabel *titlecL = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(tlabel2.frame) + 30, 60, 30)];
    titlecL.font = [UIFont systemFontOfSize:16];
    titlecL.text = @"正常：";
    [self.view addSubview:titlecL];
    
    UISwitch *cellSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(boxX, CGRectGetMaxY(tlabel2.frame) + 30, boxW, 30)];
    cellSwitch.on = true;
    [self.view addSubview:cellSwitch];
    [cellSwitch addTarget:self action:@selector(cellSwitchChange:) forControlEvents:UIControlEventValueChanged];
    
    UISwitch *cellSwitch1 = [[UISwitch alloc] initWithFrame:CGRectMake(CGRectGetMaxX(cellSwitch.frame) + 35, CGRectGetMinY(cellSwitch.frame), boxW, 30)];
    cellSwitch1.on = false;
    [self.view addSubview:cellSwitch1];
    [cellSwitch addTarget:self action:@selector(cellSwitchChange:) forControlEvents:UIControlEventValueChanged];
    
    UILabel *titlec2L = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(cellSwitch.frame) + 40, 60, 30)];
    titlec2L.font = [UIFont systemFontOfSize:16];
    titlec2L.text = @"禁用：";
    [self.view addSubview:titlec2L];
    
    UISwitch *cellSwitch2 = [[UISwitch alloc] initWithFrame:CGRectMake(boxX, CGRectGetMaxY(cellSwitch.frame) + 40, boxW, 30)];
    cellSwitch2.on = true;
    [self.view addSubview:cellSwitch2];
    [cellSwitch2 addTarget:self action:@selector(cellSwitchChange:) forControlEvents:UIControlEventValueChanged];
    
    UISwitch *cellSwitch21 = [[UISwitch alloc] initWithFrame:CGRectMake(CGRectGetMaxX(cellSwitch2.frame) + 35, CGRectGetMinY(cellSwitch2.frame), boxW, 30)];
    cellSwitch21.on = false;
    [self.view addSubview:cellSwitch21];
    [cellSwitch21 addTarget:self action:@selector(cellSwitchChange:) forControlEvents:UIControlEventValueChanged];
    
    UIView *maskView = [[UIView alloc] initWithFrame:cellSwitch2.frame];
    maskView.backgroundColor = [UIColor colorWithHex:@"#FFFFFF" alpha:0.5];
    [self.view addSubview:maskView];
    
    UIView *maskView1 = [[UIView alloc] initWithFrame:cellSwitch21.frame];
    maskView1.backgroundColor = [UIColor colorWithHex:@"#FFFFFF" alpha:0.5];
    [self.view addSubview:maskView1];
    // Do any additional setup after loading the view.
}

- (void)cellSwitchChange:(UISwitch *)cellSwitch{
    
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
