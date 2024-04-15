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

#import "JRTagsViewController.h"

@interface JRTagsViewController ()

@end

@implementation JRTagsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHex:@"#F9FBF9"];
    JRSegmentView *tagsView = [[JRSegmentView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 48) dataSource:@[@"全部",@"收/发件人",@"主题",@"附件"] showLine:false textFont:nil defaultColor:nil selectColor:nil];
    [self.view addSubview:tagsView];
    
    JRSegmentView *tagsView1 = [[JRSegmentView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(tagsView.frame) + 20, SCREEN_WIDTH, 48) dataSource:@[@"全部",@"未读 (1)",@"含附件"] showLine:true textFont:nil defaultColor:nil selectColor:nil];
    [self.view addSubview:tagsView1];
    
    JRSegmentView *tagsView2 = [[JRSegmentView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(tagsView1.frame) + 20, SCREEN_WIDTH, 48) dataSource:@[@"我收到的",@"我发送的"] showLine:true textFont:nil defaultColor:nil selectColor:nil];
    [self.view addSubview:tagsView2];
    // Do any additional setup after loading the view.
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
