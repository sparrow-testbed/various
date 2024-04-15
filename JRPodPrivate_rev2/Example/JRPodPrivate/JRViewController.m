//
//  JRViewController.m
//  JRPodPrivate
//
//  Created by wni on 09/18/2020.
//  Copyright (c) 2020 wni. All rights reserved.
//

#import "JRViewController.h"
#import "JRButtonViewController.h"
#import "JRCellViewController.h"
#import "JRSearchViewController.h"
#import "JRTagsViewController.h"
#import "JROtherViewController.h"
#import "JRPopUpsViewController.h"
#import "JRImagePickerController.h"
#import "JRPhotoPickerController.h"
#import "JRPhotoPreviewController.h"

#import "JRUIKit.h"
#import "JRCalendar.h"
#import "JRCalerdatListViewController.h"
#import "JRCalendarModel.h"
#import "JRNoDataViewController.h"
#import "JRSideBarViewController.h"
#import "JRNoticeRemindViewController.h"
#import "JRSandBoxFileViewController.h"
#import "JRPhotoCameraFilePopView.h"
#import "JRCamreaTableViewController.h"
#import "JRUPloadFileImageViewController.h"
#import "JRUploadPreviewController.h"
#import "JRPhotoEditeViewController.h"
#import "JRRefreshTableViewController.h"
#import "JRLoadingTableViewController.h"
@interface JRViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,strong)NSArray *titleArray;

@end

@implementation JRViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    self.title = @"组件库Demo";
    self.titleArray = @[@[@"Button  按钮",@"Cell 单元格",@"Search 搜索",@"Calendar 日历",@"Tab 标签页",@"Other  其他",@"Sidepopups  侧边弹窗",@"Empty state 空状态",@"Remind 提醒",@"Upload 上传"],@[@"Pop-ups  弹窗"],@[@"拍照/相册/文件"],@[@"图片编辑"],@[@"上拉刷新/下拉刷新"],@[@"loading"]];
    [self.view addSubview:self.tableView];
	// Do any additional setup after loading the view, typically from a nib.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.titleArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.titleArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = self.titleArray[indexPath.section][indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
//    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[JRUIHelper imageNamed:@"i_back_nav_nor"] style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationController.navigationBar setBackIndicatorImage:[JRUIHelper imageNamed:@"i_back_nav_nor"]];
    [self.navigationController.navigationBar setBackIndicatorTransitionMaskImage:[JRUIHelper imageNamed:@"i_back_nav_nor"]];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backItem;
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        JRButtonViewController *buttonVC = [[JRButtonViewController alloc] init];
        buttonVC.title = self.titleArray[indexPath.section][indexPath.row];
        [self.navigationController pushViewController:buttonVC animated:true];
    }
    else if (indexPath.section == 0 && indexPath.row ==1){
        JRCellViewController *cellVC = [[JRCellViewController alloc] init];
        cellVC.title = self.titleArray[indexPath.section][indexPath.row];
        [self.navigationController pushViewController:cellVC animated:true];
    }
    else if (indexPath.section == 0 && indexPath.row ==2){
        JRSearchViewController *searchVC = [[JRSearchViewController alloc] init];
        searchVC.title = self.titleArray[indexPath.section][indexPath.row];
        [self.navigationController pushViewController:searchVC animated:true];
    }

    else if (indexPath.section == 0 && indexPath.row ==3){
        JRCalerdatListViewController *calendarVC = [[JRCalerdatListViewController alloc]init];
        calendarVC.title = self.titleArray[indexPath.section][indexPath.row];
        [self.navigationController pushViewController:calendarVC animated:YES];
    }
    else if (indexPath.section == 0 && indexPath.row ==4){
        JRTagsViewController *tagsVC = [[JRTagsViewController alloc] init];
        tagsVC.title = self.titleArray[indexPath.section][indexPath.row];
        [self.navigationController pushViewController:tagsVC animated:true];
    }
    else if (indexPath.section == 0 && indexPath.row == 5){
        JROtherViewController *othersVC = [[JROtherViewController alloc] init];
        othersVC.title = self.titleArray[indexPath.section][indexPath.row];
        [self.navigationController pushViewController:othersVC animated:true];
    }
    else if (indexPath.section == 0 && indexPath.row == 8){
        JRNoticeRemindViewController *noticeRemindVC = [[JRNoticeRemindViewController alloc]init];
        noticeRemindVC.title = self.titleArray[indexPath.section][indexPath.row];
        [self.navigationController pushViewController:noticeRemindVC animated:YES];
    }

    else if (indexPath.section == 0 && indexPath.row == 6) {
        JRSideBarViewController *sideBarVC = [[JRSideBarViewController alloc]init];
        sideBarVC.title = self.titleArray[indexPath.section][indexPath.row];
        [self.navigationController pushViewController:sideBarVC animated:YES];
    }
    else if (indexPath.section == 0 && indexPath.row == 7) {
        JRNoDataViewController *noDataView = [[JRNoDataViewController alloc]init];
        noDataView.title = self.titleArray[indexPath.section][indexPath.row];
        [self.navigationController pushViewController:noDataView animated:YES];
    }
    else if (indexPath.section == 0 && indexPath.row == 9) {
        
        JRActionSheetView * sheet = [[JRActionSheetView alloc] initWithFrame:[UIScreen mainScreen].bounds titleArray:@[@"上传样式预览", @"上传操作体验"]];
        sheet.ClickBlock = ^(NSInteger clickIndex) {
            if (clickIndex == 0) {
                JRUploadPreviewController *previewVC = [[JRUploadPreviewController alloc]init];
                previewVC.title = @"预览上传样式";
                [self.navigationController pushViewController:previewVC animated:YES];
            }else {
                JRUPloadFileImageViewController *uploadFileImage = [[JRUPloadFileImageViewController alloc]init];
                uploadFileImage.title = self.titleArray[indexPath.section][indexPath.row];
                [self.navigationController pushViewController:uploadFileImage animated:YES];
            }
        };
        [[UIApplication sharedApplication].keyWindow addSubview:sheet];
    }


    else if (indexPath.section == 1 && indexPath.row == 0){
        JRPopUpsViewController *popUpVC = [[JRPopUpsViewController alloc] init];
        popUpVC.title = self.titleArray[indexPath.section][indexPath.row];
        [self.navigationController pushViewController:popUpVC animated:true];
    }else if (indexPath.section == 2) {
        JRCamreaTableViewController *cameraVC = [[JRCamreaTableViewController alloc] init];
        cameraVC.title = self.titleArray[indexPath.section][indexPath.row];
        [self.navigationController pushViewController:cameraVC animated:true];

    }else if (indexPath.section == 3) {
        JRPhotoEditeViewController *cameraVC = [[JRPhotoEditeViewController alloc] init];
        cameraVC.title = self.titleArray[indexPath.section][indexPath.row];
        [self.navigationController pushViewController:cameraVC animated:true];

    }else if (indexPath.section == 4) {
        JRRefreshTableViewController *vc = [[JRRefreshTableViewController alloc] init];
        vc.title = self.titleArray[indexPath.section][indexPath.row];
        [self.navigationController pushViewController:vc animated:true];

    }else if (indexPath.section == 5) {
        JRLoadingTableViewController *vc = [[JRLoadingTableViewController alloc] init];
        vc.title = self.titleArray[indexPath.section][indexPath.row];
        [self.navigationController pushViewController:vc animated:true];

    }
   
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NaviHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorColor = [UIColor colorWithHex:@"#ACC0BA"];
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
