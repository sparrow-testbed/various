//
/**
* 所属系统: component
* 所属模块: 
* 功能描述: 
* 创建时间: 2020/9/15
* 维护人:  王伟
* Copyright © 2020 杰人软件. All rights reserved.
*┌─────────────────────────────────────────────────────┐
*│ 此技术信息为本公司机密信息，未经本公司书面同意禁止向第三方披露．│
*│ 版权所有：杰人软件(深圳)有限公司                          │
*└─────────────────────────────────────────────────────┘
*/

#import "JRUINavigationController.h"
#import "JRUIKit.h"

@interface JRUINavigationController ()

@end

@implementation JRUINavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.automaticallyAdjustsScrollViewInsets = YES;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = UIColor.whiteColor;
    self.navigationBar.barTintColor = [UIColor jk_colorWithHexString:@"#184C30"];
    self.navigationBar.translucent  =NO;

    UIColor* color = [UIColor whiteColor];
    NSDictionary* dict=[NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    self.navigationBar.titleTextAttributes= dict;
    self.navigationBar.tintColor = [UIColor whiteColor];

    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[JRUIHelper imageNamed:@"i_back_nav_nor"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction:)];
    // Do any additional setup after loading the view.
}

- (void)backAction:(UIBarButtonItem *)item{
    [self popViewControllerAnimated:false];
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
