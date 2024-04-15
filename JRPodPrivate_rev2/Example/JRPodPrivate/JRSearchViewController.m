//
/**
* 所属系统: component
* 所属模块: 
* 功能描述: 
* 创建时间: 2020/9/21
* 维护人:  王伟
* Copyright © 2020 wni. All rights reserved.
*┌─────────────────────────────────────────────────────┐
*│ 此技术信息为本公司机密信息，未经本公司书面同意禁止向第三方披露．│
*│ 版权所有：杰人软件(深圳)有限公司                          │
*└─────────────────────────────────────────────────────┘
*/

#import "JRSearchViewController.h"

@interface JRSearchViewController ()<UITextFieldDelegate,JRSearchViewDelegate>

@end

@implementation JRSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    JRSearchView *searchView = [[JRSearchView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 56)];
    searchView.searchType = JRSearchTypeGreen;
    [self.view addSubview:searchView];
    
    JRSearchView *searchView1 = [[JRSearchView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(searchView.frame) + 10 , SCREEN_WIDTH, 56)];
    searchView1.searchType = JRSearchTypeWhite;
    [self.view addSubview:searchView1];
    
    JRSearchView *searchView2 = [[JRSearchView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(searchView1.frame) + 10, SCREEN_WIDTH, 56)];
    searchView2.searchType = JRSearchTypeGray;
    [self.view addSubview:searchView2];
    
    JRSearchView *searchView3 = [[JRSearchView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(searchView2.frame) + 10, SCREEN_WIDTH, 56)];
    searchView3.delegate = self;
    searchView3.searchType = JRSearchTypeCancel;
    [self.view addSubview:searchView3];
    // Do any additional setup after loading the view.
}

- (void)cancelButtonAction:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:true];
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
