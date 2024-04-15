//
/**
* 所属系统: component
* 所属模块: 
* 功能描述: 
* 创建时间: 2020/9/25
* 维护人:  李志䶮
* Copyright © 2020 wni. All rights reserved.
*┌─────────────────────────────────────────────────────┐
*│ 此技术信息为本公司机密信息，未经本公司书面同意禁止向第三方披露．│
*│ 版权所有：杰人软件(深圳)有限公司                          │
*└─────────────────────────────────────────────────────┘
*/

#import "JRNoticeRemindViewController.h"

@interface JRNoticeRemindViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *contentTableView;
@property (nonatomic, strong) NSArray *array;

@end

@implementation JRNoticeRemindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title = @"提醒";
    self.view.backgroundColor = [UIColor colorWithHex:@"#F9FBF9"];
    
    JRNoticeRemindModel *model1 = [[JRNoticeRemindModel alloc]init];
    model1.createTime = @"1602492058";
    model1.title = @"新日程提醒";
    model1.headerContent = @"对2018.10.12 14:30到校通知的未到校申诉，请于签到后24小时内联系家长处理。";
    model1.bottomContent = @"请于签到后24小时内联系家长处理。";
    model1.contentArray = @[@{@"key":@"时间",@"value":@"2017年12月18日 18:00至17:00"},@{@"key":@"内容",@"value":@"魔鬼训练营启动活动，如何提高孩子们的学习兴趣及积极性。"}];
    model1.hasDetail = YES;
    
    JRNoticeRemindModel *model2 = [[JRNoticeRemindModel alloc]init];
    model2.createTime = @"1602402058";
    model2.title = @"日程取消提醒";
    model2.headerContent = @"对2018.10.12 14:30到校通知的未到校申诉，请于签到后24小时内联系家长处理。";
    model2.bottomContent = @"请于签到后24小时内联系家长处理。";
    model2.contentArray = @[@{@"key":@"时间",@"value":@"2017年12月18日 18:00至17:00"},@{@"key":@"内容",@"value":@"魔鬼训练营启动活动，如何提高孩子们的学习兴趣及积极性。"}];
    model2.hasDetail = YES;
    model2.isRead = YES;
    
    JRNoticeRemindModel *model3 = [[JRNoticeRemindModel alloc]init];
    model3.createTime = @"1601402058";
    model3.title = @"新日程提醒";
    model3.headerContent = @"对2018.10.12 14:30到校通知的未到校申诉，请于签到后24小时内联系家长处理。";
    model3.bottomContent = @"请于签到后24小时内联系家长处理。";
    model3.contentArray = @[@{@"key":@"时间",@"value":@"2017年12月18日 18:00至17:00"},@{@"key":@"内容",@"value":@"魔鬼训练营启动活动，如何提高孩子们的学习兴趣及积极性。"}];
    model3.hasDetail = YES;
    model3.isRead = NO;
    
    JRNoticeRemindModel *model4 = [[JRNoticeRemindModel alloc]init];
    model4.createTime = @"1601402058";
    model4.title = @"新日程提醒";
    model4.headerContent = @"请于签到后24小时内联系家长处理。";
//    model4.bottomContent = @"请于签到后24小时内联系家长处理。";
    model4.hasDetail = YES;
    model4.isRead = NO;
    
    self.array = @[model1,model2,model3,model4];
    [self.view addSubview:self.contentTableView];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.array.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *str = @"cell";
    JRNoticeRemindTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str forIndexPath:indexPath];
    JRNoticeRemindModel *model = [self.array objectAtIndex:indexPath.row];
    cell.model = model;
    cell.enterDetailBlock = ^(JRNoticeRemindTableViewCell * _Nonnull cell) {
        
    };
    return cell;
}

-(UITableView *)contentTableView{
    if (!_contentTableView) {
        _contentTableView = [[UITableView alloc]initWithFrame:self.view.bounds];
        _contentTableView.delegate = self;
        _contentTableView.dataSource = self;
        _contentTableView.estimatedRowHeight = 300;
        _contentTableView.rowHeight = UITableViewAutomaticDimension;
        _contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_contentTableView registerClass:[JRNoticeRemindTableViewCell class] forCellReuseIdentifier:@"cell"];
        _contentTableView.contentInset = UIEdgeInsetsMake(0, 0, 300, 0);
        _contentTableView.backgroundColor = [UIColor colorWithHex:@"#F9FBF9"];
    }
    return _contentTableView;
}

@end
