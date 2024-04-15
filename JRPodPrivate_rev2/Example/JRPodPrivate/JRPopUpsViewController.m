//
/**
 * 所属系统: component
 * 所属模块:
 * 功能描述:
 * 创建时间: 2020/9/23
 * 维护人:  王伟
 * Copyright © 2020 wni. All rights reserved.
 *┌─────────────────────────────────────────────────────┐
 *│ 此技术信息为本公司机密信息，未经本公司书面同意禁止向第三方披露．│
 *│ 版权所有：杰人软件(深圳)有限公司                          │
 *└─────────────────────────────────────────────────────┘
 */

#import "JRPopUpsViewController.h"
#import "JRPickerView.h"
#import "JRActionSheetView.h"
#import "JRCurrencyView.h"

@interface JRPopUpsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)NSArray *titleArray;

@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,strong)NSArray *defaultList;

@property(nonatomic,strong)JROptionModuleViewController *optionVC;

@end

@implementation JRPopUpsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    // Do any additional setup after loading the view.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = self.titleArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    if (indexPath.row == 0) {
        [[JRPickerView shareInstance] showInView:self.view type:PickerViewTypeYear currentContent:@"2020.02" title:@"请选择年份" maxYear:2025 minYear:1998 selectCompleteHander:^(NSString * _Nonnull selectDate, NSInteger tag) {
            JRLog(@"selectDate == %@",selectDate);
        }] ;
    }
    else if (indexPath.row == 1){
        [[JRPickerView shareInstance] showInView:self.view type:PickerViewTypeYearMonth currentContent:@"2020-02" title:@"请选择月份" maxYear:2025 minYear:2010 selectCompleteHander:^(NSString * _Nonnull selectDate, NSInteger tag) {
            JRLog(@"selectDate == %@",selectDate);
        }] ;
    }
    else if (indexPath.row == 2){
        
        [[JRPickerView shareInstance] showInView:self.view type:PickerViewTypeYearMonthDay currentContent:@"2020.02.10" title:@"请选择创作日期" maxYear:2025 minYear:1998 selectCompleteHander:^(NSString * _Nonnull selectDate, NSInteger tag) {
            JRLog(@"selectDate == %@",selectDate);
        }] ;
    }
    else if (indexPath.row == 3){
        NSArray *array = @[@"海请",@"李海东",@"王德军",@"雷神",@"大红花",@"飞羽社",@"新空气",@"飞轮海",@"吴克群",@"周杰伦",@"周建华"];
        [[JRPickerView shareInstance] showInView:self.view type:PickerViewTypeOther currentContent:@"新空气" title:@"请选择替补讲师" contentArray:array selectCompleteHander:^(NSString * _Nonnull selectDate, NSInteger tag) {
            JRLog(@"selectDate == %@",selectDate);
        }];
    }
    else if (indexPath.row == 4){
        
        JRActionSheetView * sheet = [[JRActionSheetView alloc] initWithFrame:[UIScreen mainScreen].bounds titleArray:@[@"逐条转发", @"合并转发"]];
        [[UIApplication sharedApplication].keyWindow addSubview:sheet];
    }
    else if (indexPath.row == 5){
        [MBProgressHUD showHUD:@"请选择收件人最多十个字"];
    }
    else if (indexPath.row == 6){
        JROptionModuleViewController *options = [[JROptionModuleViewController alloc] init];
        self.optionVC = options;
        options.dataSource = @[
            @{@"name":@"报销付款"},
            @{@"name":@"借款"},
            @{@"name":@"礼品/招待用餐"},
            @{@"name":@"印章/证书文件"},
        ];
        options.defaultList = self.defaultList;
        options.key = @"name";
        options.titleStr = self.titleArray[indexPath.row];
        options.isCancle = true;
        options.options = false;
        options.block = ^(NSArray * list,BOOL backAction) {
            JRLog(@"%@",list);
        };
        [self.view.window addSubview:options.view];
    }
    else if (indexPath.row == 7){
        JROptionModuleViewController *options = [[JROptionModuleViewController alloc] init];
        self.optionVC = options;
        options.dataSource = @[
            @{@"name":@"报销付款"},
            @{@"name":@"借款"},
            @{@"name":@"礼品/招待用餐"},
            @{@"name":@"印章/证书文件"},
            @{@"name":@"报销付款1"},
            @{@"name":@"借款1"},
            @{@"name":@"礼品/招待用餐1"},
            @{@"name":@"印章/证书文件1"},
            @{@"name":@"报销付款2"},
            @{@"name":@"借款2"},
            @{@"name":@"礼品/招待用餐2"},
            @{@"name":@"印章/证书文件2"},
            @{@"name":@"请假/调休12"},
            @{@"name":@"请假/调休13"},
            @{@"name":@"请假/调休14"},
            @{@"name":@"请假/调休15"},
            @{@"name":@"测试跳转"},
            @{@"name":@"报销付款"},
            @{@"name":@"借款"},
            @{@"name":@"礼品/招待用餐"},
            @{@"name":@"印章/证书文件"},
            @{@"name":@"报销付款1"},
            @{@"name":@"借款1"},
            @{@"name":@"礼品/招待用餐1"},
            @{@"name":@"印章/证书文件1"},
            @{@"name":@"报销付款2"},
            @{@"name":@"借款2"},
            @{@"name":@"礼品/招待用餐2"},
            @{@"name":@"印章/证书文件2"},
            @{@"name":@"请假/调休12"},
            @{@"name":@"请假/调休13"},
            @{@"name":@"请假/调休14"},
            @{@"name":@"请假/调休15"},
            @{@"name":@"报销付款"},
            @{@"name":@"借款"},
            @{@"name":@"礼品/招待用餐"},
            @{@"name":@"印章/证书文件"},
            @{@"name":@"报销付款1"},
            @{@"name":@"借款1"},
            @{@"name":@"礼品/招待用餐1"},
            @{@"name":@"印章/证书文件1"},
            @{@"name":@"报销付款2"},
            @{@"name":@"借款2"},
            @{@"name":@"礼品/招待用餐2"},
            @{@"name":@"印章/证书文件2"},
            @{@"name":@"请假/调休12"},
            @{@"name":@"请假/调休13"},
            @{@"name":@"请假/调休14"},
            @{@"name":@"请假/调休15"},
            @{@"name":@"报销付款"},
            @{@"name":@"借款"},
            @{@"name":@"礼品/招待用餐"},
            @{@"name":@"印章/证书文件"},
            @{@"name":@"报销付款1"},
            @{@"name":@"借款1"},
            @{@"name":@"礼品/招待用餐1"},
            @{@"name":@"印章/证书文件1"},
            @{@"name":@"报销付款2"},
            @{@"name":@"借款2"},
            @{@"name":@"礼品/招待用餐2"},
            @{@"name":@"印章/证书文件2"},
            @{@"name":@"请假/调休12"},
            @{@"name":@"请假/调休13"},
            @{@"name":@"请假/调休14"},
            @{@"name":@"请假/调休15"},
            @{@"name":@"报销付款"},
            @{@"name":@"借款"},
            @{@"name":@"礼品/招待用餐"},
            @{@"name":@"印章/证书文件"},
            @{@"name":@"报销付款1"},
            @{@"name":@"借款1"},
            @{@"name":@"礼品/招待用餐1"},
            @{@"name":@"印章/证书文件1"},
            @{@"name":@"报销付款2"},
            @{@"name":@"借款2"},
            @{@"name":@"礼品/招待用餐2"},
            @{@"name":@"印章/证书文件2"},
            @{@"name":@"请假/调休12"},
            @{@"name":@"请假/调休13"},
            @{@"name":@"请假/调休14"},
            @{@"name":@"请假/调休15"},
            @{@"name":@"测试跳转2"},
            @{@"name":@"借款1"},
            @{@"name":@"礼品/招待用餐1"},
            @{@"name":@"印章/证书文件1"},
            @{@"name":@"报销付款2"},
            @{@"name":@"借款2"},
            @{@"name":@"礼品/招待用餐2"},
            @{@"name":@"印章/证书文件2"},
            @{@"name":@"请假/调休12"},
            @{@"name":@"请假/调休13"},
            @{@"name":@"请假/调休14"},
            @{@"name":@"请假/调休15"},
        ];
        options.defaultList = @[@{@"name":@"测试跳转2"}];
        options.key = @"name";
        options.titleStr = self.titleArray[indexPath.row];
        options.isCancle = true;
        options.options = false;
        options.block = ^(NSArray * list,BOOL backAction) {
            JRLog(@"%@",list);
        };
        [self.view.window addSubview:options.view];
    }
    else if (indexPath.row == 8){
        JROptionModuleViewController *options = [[JROptionModuleViewController alloc] init];
        self.optionVC = options;
        options.dataSource = @[
            @{@"name":@"借款"},
            @{@"name":@"礼品/招待用餐"},
            @{@"name":@"印章/证书文件"},
            @{@"name":@"请假/调休1"},
            @{@"name":@"请假/调休2"},
        ];
        options.defaultList = @[
            @{@"name":@"借款"},
            @{@"name":@"礼品/招待用餐"},
            @{@"name":@"印章/证书文件"},
            @{@"name":@"请假/调休1"},
            @{@"name":@"请假/调休2"},
        ];
        options.key = @"name";
        options.titleStr = self.titleArray[indexPath.row];
        options.isCancle = true;
        options.options = true;
        options.block = ^(NSArray * list,BOOL backAction) {
            JRLog(@"%@",list);
        };
        [self.view.window addSubview:options.view];
    }
    else if (indexPath.row == 9){
        JROptionModuleViewController *options = [[JROptionModuleViewController alloc] init];
        self.optionVC = options;
        options.dataSource = @[
            @{@"name":@"借款"},
            @{@"name":@"礼品/招待用餐"},
            @{@"name":@"印章/证书文件"},
            @{@"name":@"请假/调休1"},
            @{@"name":@"请假/调休2"},
            @{@"name":@"请假/调休3"},
            @{@"name":@"请假/调休4"},
            @{@"name":@"请假/调休5"},
            @{@"name":@"请假/调休6"},
            @{@"name":@"请假/调休7"},
            @{@"name":@"请假/调休8"},
            @{@"name":@"请假/调休9"},
            @{@"name":@"请假/调休10"},
            @{@"name":@"请假/调休11"},
            @{@"name":@"请假/调休12"},
            @{@"name":@"请假/调休13"},
            @{@"name":@"请假/调休14"},
            @{@"name":@"请假/调休15"},
            @{@"name":@"测试跳转"},
        ];
        options.defaultList = @[@{@"name":@"测试跳转"}];
        options.key = @"name";
        options.titleStr = self.titleArray[indexPath.row];
        options.isCancle = true;
        options.options = true;
        options.block = ^(NSArray * list,BOOL backAction) {
            JRLog(@"%@",list);
        };
        [self.view.window addSubview:options.view];
    }
    else if (indexPath.row == 10){
        JROptionModuleViewController *options = [[JROptionModuleViewController alloc] init];
        self.optionVC = options;
        options.dataSource = @[
            @{@"name":@"借款"},
            @{@"name":@"礼品/招待用餐"},
            @{@"name":@"印章/证书文件"},
            @{@"name":@"请假/调休1"},
            @{@"name":@"请假/调休2"},
            @{@"name":@"请假/调休3"},
            @{@"name":@"请假/调休4"},
            @{@"name":@"请假/调休5"},
            @{@"name":@"请假/调休6"},
            @{@"name":@"请假/调休7"},
            @{@"name":@"请假/调休8"},
            @{@"name":@"请假/调休9"},
            @{@"name":@"请假/调休10"},
            @{@"name":@"请假/调休11"},
        ];
        options.isCheckAll = YES;
        options.defaultList = self.defaultList;
        options.key = @"name";
        options.titleStr = self.titleArray[indexPath.row];
        options.isCancle = true;
        options.options = true;
        options.block = ^(NSArray * list,BOOL backAction) {
            JRLog(@"%@",list);
            //            self.optionVC = nil;
            //            block(list,backAction);
        };
        //        [[UIApplication sharedApplication].keyWindow addSubview:options.view];
        [self.view.window addSubview:options.view];
    }
    else if (indexPath.row == 11){
        [JRAlertView initWithTitle:@"张三为终审人，请先选择刘总/李总审核" ButtonTitles:@[@"去选择"] IsWarning:true warnImageName:nil Block:nil];
                
//        JRCurrencyView *viewss = [[[NSBundle mainBundle]loadNibNamed:@"JRCurrencyView" owner:nil options:nil]firstObject];
//        [JRAlertView initAlertWithTitleView:viewss titleHeight:201 ButtonTitles:@[@"取消",@"确定"] IsWarning:NO warnImageName:nil Block:^(JRAlertView * _Nonnull alertView, NSInteger buttonIndex) {
//            float a = [viewss.textFileld1.text floatValue];
//            float b = a * [viewss.originNumber.text floatValue];
//            viewss.textField2.text = [NSString stringWithFormat:@"%.2f",b];
//            NSLog(@"转换后得到的数据是---%.2f",b);
//            
//        }];
        
    }
    else if (indexPath.row == 12){
        [JRAlertView initWithTitle:@"上课时间不匹配，是否安排插班补课?" ButtonTitles:@[@"取消",@"确定"] IsWarning:true warnImageName:@"i_warning_card" Block:nil];
    }
    else if (indexPath.row == 13){
        [JRAlertView initWithTitle:@"确定撤回该邮件？" subTitle:nil ButtonTitles:@[@"取消",@"确定"] IsWarning:false warnImageName:nil Block:nil];
    }
    else if (indexPath.row == 14){
        [JRAlertView initWithTitle:@"上课时间不匹配，是否安排插班补课?" subTitle:nil ButtonTitles:@[@"取消",@"确定"] IsWarning:false warnImageName:nil Block:nil];
    }
    else if (indexPath.row == 15){
        [JRAlertView initWithTitle:@"确定为肖磊签到?" subTitle:@"系统将发送一条通知告知家长" ButtonTitles:@[@"取消",@"确定"] IsWarning:false warnImageName:nil Block:nil];
    }
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NaviHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (NSArray *)titleArray{
    if (!_titleArray) {
        _titleArray = @[@"选择年度滚轮",@"选择年月滚轮",@"选择年月日滚轮",@"普通文字滚轮",@"底部弹出菜单",@"toast提示",@"底部弹出单项选择框",@"底部弹出单项选择框(搜索)",@"底部弹出多项选择框",@"底部弹出多项选择框(搜索)",@"底部弹出多项选择框(全选)",@"错误弹窗",@"警告弹窗",@"单行确定弹窗",@"多行确定弹窗",@"有副标题确定弹窗"];
    }
    return _titleArray;;
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
