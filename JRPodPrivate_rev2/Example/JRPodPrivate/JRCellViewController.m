//
/**
* 所属系统: component
* 所属模块: 
* 功能描述: 
* 创建时间: 2020/9/19
* 维护人:  王伟
* Copyright © 2020 wni. All rights reserved.
*┌─────────────────────────────────────────────────────┐
*│ 此技术信息为本公司机密信息，未经本公司书面同意禁止向第三方披露．│
*│ 版权所有：杰人软件(深圳)有限公司                          │
*└─────────────────────────────────────────────────────┘
*/

#import "JRCellViewController.h"

@interface JRCellViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;

@end

@implementation JRCellViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    self.tableView.estimatedRowHeight = 100;
    // Do any additional setup after loading the view.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 55;
    }
    else{
        return UITableViewAutomaticDimension;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 7;
    }else if (section == 1){
        return 2;
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0 || indexPath.row == 1) {
            JRTextFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            if (!cell) {
                cell = [[JRTextFieldTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            if (indexPath.row == 1) {
                cell.contentField.text = @"输入后的内容";
            }
            return cell;
        }
        else if (indexPath.row == 2 || indexPath.row == 3){
            JRChooseTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"chooseCell"];
            if (!cell) {
                cell = [[JRChooseTextTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"chooseCell"];
            }
            if (indexPath.row == 2) {
                cell.contentField.placeholder = nil;
            }
            return cell;
        }
        else if (indexPath.row == 4){
            JRChooseTextTableViewCell *choosedCell = [tableView dequeueReusableCellWithIdentifier:@"choosedCell"];
            if (!choosedCell) {
                choosedCell = [[JRChooseTextTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"choosedCell"];
            }
            choosedCell.contentField.text = @"内容";
            return choosedCell;
        }
        else{
            JRSwitchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"switchCell"];
            if (!cell) {
                cell = [[JRSwitchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"switchCell"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            if (indexPath.row == 5) {
                cell.cellSwitch.on = true;
            }
            else{
                cell.cellSwitch.on = false;
            }
            return cell;
        }
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 0) {
            JRWorkListTableViewCell *workCell = [tableView dequeueReusableCellWithIdentifier:@"workCell"];
            if (!workCell) {
                workCell = [[JRWorkListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"workCell"];
            }
            workCell.titleLabel.text = @"作品名称";
            workCell.contentLabel.text = @"西瓜的重组";
            return workCell;
        }
        else{
            JRStartFinishTimeTableViewCell *timeCell = [tableView dequeueReusableCellWithIdentifier:@"timeCell"];
            if (!timeCell) {
                timeCell = [[JRStartFinishTimeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"timeCell"];
            }
            timeCell.startTimeLabel.text = @"14:00";
            timeCell.finishTimeLabel.text = @"16:00";
            return timeCell;
        }
    }
    else if (indexPath.section == 2){
        JRTimetableTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableCell"];
        if (!cell) {
            cell = [[JRTimetableTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tableCell"];
        }
        cell.timeLabel.text = @"09:00-10:00 ";
        cell.classNameLabel.text = @"班级名称：米罗小小班（010-3024S1)";
        cell.hiddenLication = true;
        return cell;
    }
    else if (indexPath.section == 3){
        JRTimetableTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"table2Cell"];
        if (!cell) {
            cell = [[JRTimetableTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"table2Cell"];
        }
        cell.timeLabel.text = @"09:00-10:00 ";
        cell.classNameLabel.text = @"班级名称：米罗小小班（010-3024S1)";
        cell.classLocationLabel.text = @"上课地点：302";
        return cell;
    }
    else{
        JRUsersTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userCell"];
        if (!cell) {
            cell = [[JRUsersTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"userCell"];
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }
    else if (section == 1){
        return 10;
    }
    else if (section == 2){
        return 10;
    }
    else{
        return 10;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor colorWithHex:@"#F1F1F6"];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor colorWithHex:@"#F1F1F6"];
        _tableView.separatorColor = [UIColor colorWithHex:@"#ACC0BA"];
        _tableView.separatorInset = UIEdgeInsetsMake(0, 20, 0, 0);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CurrentDeviceWidth, 200)];
    }
    return _tableView;
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
