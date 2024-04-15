//
//  JRCamreaTableViewController.m
//  JRPodPrivate_Example
//
//  Created by J0224 on 2020/11/26.
//  Copyright © 2020 wni. All rights reserved.
//

#import "JRCamreaTableViewController.h"

@interface JRCamreaTableViewController ()
@property (nonatomic,copy)NSArray *titleArray;

@end

@implementation JRCamreaTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [UIView new];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = self.titleArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//@[@"仅拍照",@"仅拍摄",@"拍照+拍摄",@"相册（仅照片）",@"相册（仅视频）",@"相册（图片+视频）",@"拍摄+相册",@"拍摄+相册+文件",@"只能选择一张"];
    if (indexPath.row == 0) {
        [self camreaWithType:JRCameraTypePhotograph];
    }
    else if (indexPath.row == 1){
        [self camreaWithType:JRCameraTypeShot];
    }
    else if (indexPath.row == 2){
        [self camreaWithType:JRCameraTypeDefault];
    }
    else if (indexPath.row == 3){
        //                相册
        [self photoWithType:0];
    }
    else if (indexPath.row == 4){
        [self photoWithType:1];
    }
    else if (indexPath.row == 5){
        [self photoWithType:2];
    }
    else if (indexPath.row == 6){
        NSArray *imageArray = @[@"btn_shoot_chat",@"btn_photo_chat"];
        NSArray *titleArray = @[@"拍摄",@"相册"];
        
        JRPhotoCameraFilePopView *popView = [[JRPhotoCameraFilePopView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) titleArray:titleArray imageArray:imageArray];
        popView.block = ^(NSString * _Nonnull title, NSInteger row) {
            if (row == 0) {
                [self camreaWithType:JRCameraTypeDefault];
            }
            else if (row == 1){
                //                相册
                [self photoWithType:2];
            }else{
                //                文件
                JRSandBoxFileViewController *sandBoXVC = [[JRSandBoxFileViewController alloc] init];
                sandBoXVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
                [self presentViewController:sandBoXVC animated:true completion:nil];
            }
        };
        [popView show];
    }
    else if (indexPath.row == 7){
        NSArray *imageArray = @[@"btn_shoot_chat",@"btn_photo_chat",@"btn_file_chat"];
        NSArray *titleArray = @[@"拍摄",@"相册",@"文件"];
        JRPhotoCameraFilePopView *popView = [[JRPhotoCameraFilePopView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) titleArray:titleArray imageArray:imageArray];
        popView.block = ^(NSString * _Nonnull title, NSInteger row) {
            if (row == 0) {
                [self camreaWithType:JRCameraTypeDefault];
            }
            else if (row == 1){
                //                相册
                [self photoWithType:2];
            }else{
                //                文件
                JRSandBoxFileViewController *sandBoXVC = [[JRSandBoxFileViewController alloc] init];
                sandBoXVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
                [self presentViewController:sandBoXVC animated:true completion:nil];
            }
        };
        [popView show];
    }
//    else{
//        [self photoOnlyOne];
//    }
    
}

//拍照or拍摄
- (void)camreaWithType:(JRCameraType)type{
    //                拍照
    JRCameraCustomVC *cameraVC = [[JRCameraCustomVC alloc] init];
    cameraVC.modalPresentationStyle = UIModalPresentationFullScreen;
    cameraVC.cameraType = type;
    [self presentViewController:cameraVC animated:YES completion:nil];
}


/// 相册
/// @param Type 0 相册（仅照片） 1 相册（仅视频） 2 相册（图片+视频）
- (void)photoWithType:(NSInteger)type{
    JRImagePickerController  *imagePicker = [[JRImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
    imagePicker.showSelectedIndex = YES;
    imagePicker.showPhotoCannotSelectLayer = YES;
    imagePicker.allowPickingMultipleVideo = YES;
    imagePicker.videoMaximumDuration = 10 *60;
    imagePicker.videoLimitMaxDuration = 10;
    imagePicker.allowTakePicture = NO;
    imagePicker.allowTakeVideo = NO;
    if (type == 0) {
        imagePicker.allowPickingImage = YES;
        imagePicker.allowPickingVideo = NO;
    }
    else if (type == 1){
        imagePicker.allowPickingImage = NO;
        imagePicker.allowPickingVideo = YES;
    }
    else if (type == 2){
        imagePicker.allowPickingImage = YES;
        imagePicker.allowPickingVideo = YES;
    }
    
    imagePicker.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

-(void)photoOnlyOne{
    JRImagePickerController  *imagePicker = [[JRImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    imagePicker.showSelectedIndex = YES;
    imagePicker.showPhotoCannotSelectLayer = YES;
    imagePicker.allowPickingMultipleVideo = YES;
    imagePicker.videoMaximumDuration = 10 *60;
    imagePicker.videoLimitMaxDuration = 10;
    imagePicker.allowTakePicture = NO;
    imagePicker.allowTakeVideo = NO;
  
        imagePicker.allowPickingImage = YES;
        imagePicker.allowPickingVideo = NO;
    
    imagePicker.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:imagePicker animated:YES completion:nil];
}
- (NSArray *)titleArray{
    if (!_titleArray) {
        _titleArray = @[@"仅拍照",@"仅拍摄",@"拍照+拍摄",@"相册（仅照片）",@"相册（仅视频）",@"相册（图片+视频）",@"拍摄+相册",@"拍摄+相册+文件"];
    }
    return _titleArray;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
