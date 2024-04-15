//
/**
* 所属系统: component
* 所属模块: 
* 功能描述: 
* 创建时间: 2020/9/23
* 维护人:  李志䶮
* Copyright © 2020 wni. All rights reserved.
*┌─────────────────────────────────────────────────────┐
*│ 此技术信息为本公司机密信息，未经本公司书面同意禁止向第三方披露．│
*│ 版权所有：杰人软件(深圳)有限公司                          │
*└─────────────────────────────────────────────────────┘
*/

#import "JRSideBarViewController.h"
#import "JRSideBarView.h"

@interface JRSideBarViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation JRSideBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITableView *tableview = [[UITableView alloc]initWithFrame:self.view.bounds];
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.tableFooterView = [UIView new];
    [self.view addSubview:tableview];
    
    self.view.backgroundColor = [UIColor whiteColor];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *str = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:str];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
   
    cell.textLabel.text = @"侧边弹窗";
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 250, MAIN_SCREEN_WIDTH, MAIN_SCREEN_HEIGHT + 100)];
    view.backgroundColor = [UIColor whiteColor];
    [JRNoDataView showNodataWithSuperView:view noDataImageName:@"pic_error" noDataTitle:@"暂无内容"];
    [JRSideBarView showSideBarViewWithSuperView:[UIApplication sharedApplication].keyWindow containView:view];
}

@end
