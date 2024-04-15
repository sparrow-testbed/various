//
/**
* 所属系统: component
* 所属模块: 
* 功能描述: 
* 创建时间: 2020/9/24
* 维护人:  王伟
* Copyright © 2020 wni. All rights reserved.
*┌─────────────────────────────────────────────────────┐
*│ 此技术信息为本公司机密信息，未经本公司书面同意禁止向第三方披露．│
*│ 版权所有：杰人软件(深圳)有限公司                          │
*└─────────────────────────────────────────────────────┘
*/

#import "JRSandBoxFileViewController.h"
#import "JRSandBoxFileTableViewCell.h"
#import "JRFileModel.h"
#import "JRSandBoxFilePopView.h"
#import "JRUIKit.h"

#define AlbumCellHeight 64
#define NAV_COLOR [UIColor jk_colorWithHexString:@"#174C30"]

@interface JRSandBoxFileViewController ()<UIDocumentPickerDelegate,UITableViewDelegate, UITableViewDataSource,JRSandBoxFilePopViewDelegate>{
    NSArray *files;
}

@property (nonatomic,strong)UIView *topView;

@property (nonatomic,strong) UIButton * titleButton;

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSArray *titleArray;

@property (nonatomic,strong)JRSandBoxFilePopView *sandBoxFilePopView;
@end

@implementation JRSandBoxFileViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NaviHeight)];
    self.topView.backgroundColor = NAV_COLOR;
    [self.view addSubview:self.topView];
    
    _titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_titleButton setTitle:@"本地文件" forState:UIControlStateNormal];
    _titleButton.frame = CGRectMake(SCREEN_WIDTH/2 - 100, StateHeight + 5, 200, 32);
    
    [_titleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
      _titleButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    _titleButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_titleButton setImage:[JRUIHelper imageNamed:@"title_arrow"] forState:UIControlStateNormal];
    [_titleButton setImage:[[JRUIHelper imageNamed:@"title_arrow"] jk_flipVertical] forState:UIControlStateSelected];
    [_titleButton jk_setImagePosition:LXMImagePositionRight spacing:8];
    [_titleButton addTarget:self action:@selector(chioseCloudFile:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(15, StateHeight + 5, 40, 32);
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [cancelButton addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:cancelButton];
    [self.topView addSubview:_titleButton];
    
    [self addLoadData];
    [self.view addSubview:self.tableView];
    
    _sandBoxFilePopView = [[JRSandBoxFilePopView alloc] initWithFrame:self.view.bounds];
    _sandBoxFilePopView.backgroundColor = [UIColor jk_colorWithHex:0x000000 andAlpha:0];
    _sandBoxFilePopView.frame = CGRectMake(0, NaviHeight, self.view.bounds.size.width,self.view.bounds.size.height-NaviHeight);
    _sandBoxFilePopView.delegate = self;
    [self.view addSubview:_sandBoxFilePopView];
    _sandBoxFilePopView.hidden = YES;
    // Do any additional setup after loading the view.
}

- (void)sandBoxFilePopViewSelect:(BOOL)hidden idx:(NSInteger)idx{
    _titleButton.selected = NO;
    if (idx == 0) {
        [self hidePopView];
    }
    else{
        
        [UIView animateWithDuration:0.3 animations:^{
            self.view.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 0);
        } completion:^(BOOL finished) {
            NSArray *documentTypes = @[@"public.content", @"public.text", @"public.source-code ", @"public.image", @"public.audiovisual-content", @"com.adobe.pdf", @"com.apple.keynote.key", @"com.microsoft.word.doc", @"com.microsoft.excel.xls", @"com.microsoft.powerpoint.ppt"];
            
            UIDocumentPickerViewController *documentPickerViewController = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:documentTypes inMode:UIDocumentPickerModeOpen];
            documentPickerViewController.delegate = self;
            //                documentPickerViewController.modalPresentationStyle = UIModalPresentationOverFullScreen;
            [self presentViewController:documentPickerViewController animated:YES completion:nil];
        }];
    }
}

- (void)cancelButtonClick:(UIButton *)sender{
    if (self.sandBoxBackBlock) {
        self.sandBoxBackBlock(nil, nil);
    }

    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)chioseCloudFile:(UIButton *)sender{
    sender.selected = !sender.selected;
    [self presentDocumentCloud];
}


- (void)presentDocumentCloud {
    if (_sandBoxFilePopView.hidden) {
        [self showPopView];
    }else{
        [self hidePopView];
    }
}

-(void)showPopView{
    _sandBoxFilePopView.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self->_sandBoxFilePopView.backgroundColor = [UIColor colorWithHex:@"#000000" alpha:0.7];
        self->_sandBoxFilePopView.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 72 * 2);
    } completion:^(BOOL finished) {
        
    }];
}

-(void)hidePopView{
    [UIView animateWithDuration:0.3 animations:^{
        self->_sandBoxFilePopView.backgroundColor = [UIColor colorWithHex:@"#000000" alpha:0];
        self->_sandBoxFilePopView.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0);
    } completion:^(BOOL finished) {
        self->_sandBoxFilePopView.hidden = YES;
    }];
}


#pragma mark - UIDocumentPickerDelegate
- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentAtURL:(NSURL *)url {
    
    NSArray *array = [[url absoluteString] componentsSeparatedByString:@"/"];
    NSString *fileName = [array lastObject];
     fileName = [fileName stringByRemovingPercentEncoding];
    
    
    WS(weakSelf)
    if (self.sandBoxBackBlock) {
        self.sandBoxBackBlock(url, [weakSelf getFileModel:fileName]);
    }
    [self dismissViewControllerAnimated:true completion:nil];
    
//    [iCloudManager downloadWithDocumentURL:url callBack:^(id obj) {
//        Document *doc = obj;
//
//        NSInteger length = doc.data.length;   // 图片大小，单位B
//        SS(strongSelf)
//        if ([NSData sd_imageFormatForImageData:doc.data] == -1) {
//
//            IMAMsg *msg = [IMAMsg msgWithFilePath:[FileManager saveTmpFile:doc.data fileName:fileName] fileName:fileName  fileSize:length sessUser:strongSelf->_receiver];
//            [strongSelf sendMsg:msg];
//        }else{
//            UIImage *photo = [UIImage imageWithData:doc.data];
//            IMAMsg *msg = [IMAMsg msgWithImage:photo isOrignal:YES sessUser:strongSelf->_receiver];
//            [strongSelf sendMsg:msg];
//        }
//
//    }];
}

- (JRFileModel *)getFileModel:(NSString *)fileName {
    
    JRFileModel *fileModel = [[JRFileModel alloc]init];
    fileModel.name = fileName;
    fileModel.fileType = [self getFileTypeString:fileName];
   
    return fileModel;
}
-(JRFileType )getFileTypeString:(NSString *)fileName{
    NSString * fileType = fileName;
    if ([fileName hasSuffix:@"doc"]||[fileName hasSuffix:@"docx"]) {
        return  FileTypeDOC;
    }
    else if([fileType hasSuffix:@"pdf"]){
        return FileTypePDF;
    }
    else if([fileType hasSuffix:@"xls"]||[fileType hasSuffix:@"xlsx"]){
        return FileTypeXLS;
    }
    else if([fileType hasSuffix:@"ppt"]||[fileType hasSuffix:@"pptx"]){
        return FileTypePPT;
    }
    else if([fileType hasSuffix:@"txt"]){
        return FileTypeTXT;
    }
    else if([fileType hasSuffix:@"zip"]||[fileType hasSuffix:@"rar"]){
        return FileTypeZIP;
    }
    else if([fileType hasSuffix:@"mp3"]){
        return FileTypeMP3;
    }
    else if([fileType hasSuffix:@"3gp"]||[fileType hasSuffix:@"mov"]||[fileType hasSuffix:@"flv"]||[fileType hasSuffix:@"avi"]||[fileType hasSuffix:@"mp4"]){
        return FileTypeVIDEO;
    }else {
        return FileTypeUnknowFile;
    }
}

- (void)documentPickerWasCancelled:(UIDocumentPickerViewController *)controller{
    [self dismissViewControllerAnimated:true completion:nil];
}

#pragma mark - UITableViewDataSource && Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return files.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JRSandBoxFileTableViewCell *cell = [JRSandBoxFileTableViewCell cellWithTableView:tableView];
    cell.model = files[indexPath.row];
    cell.selectionStyle = UITableViewCellAccessoryNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.sandBoxBackBlock) {
        self.sandBoxBackBlock(nil, files[indexPath.row]);
        [self dismissViewControllerAnimated:true completion:nil];
    }
//    if (_SendFileBlock) {
//        _SendFileBlock(files[indexPath.row]);
//        [self.navigationController popViewControllerAnimated:YES];
//    }
}

- (void)addLoadData {
    
    // 判断当前文件夹是否存在
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDirectory = NO;
    BOOL exist = [fileManager fileExistsAtPath:self.filePath isDirectory:&isDirectory];
    NSArray *temArr;
    if (isDirectory && exist) {
        temArr = [self contentsAtParentDirPath:self.filePath];
    }else{
        // 创建文件路径
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager createDirectoryAtPath:self.filePath withIntermediateDirectories:YES attributes:nil error:nil];
        temArr = nil;
    }
    files = temArr[1];
    if (files.count == 0) {
        [JRNoDataView showNodataWithSuperView:self.tableView noDataImageName:@"pic_error" noDataTitle:@"本地暂无文件"];
    }else{
        [self.tableView reloadData];
    }
}


// 获取父目录下所有字内容 （包含目录和文件）
- (NSArray *)contentsAtParentDirPath:(NSString *)parentDirectory {
    
    //获取当前目录下的所有文件
    NSArray *directoryContents = [[NSFileManager defaultManager] directoryContentsAtPath: parentDirectory];
    
    NSMutableArray *foldersArr = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *photosArr = [NSMutableArray arrayWithCapacity:0];
    
    NSArray *sourceList = @[foldersArr, photosArr];
    
    for (NSUInteger i = 0; i < directoryContents.count; i++) {
        //获取一个文件或文件夹
        NSString *selectedFile = (NSString*)[directoryContents objectAtIndex: i];
        
        //拼成一个完整路径
        NSString *selectedPath = [parentDirectory stringByAppendingPathComponent: selectedFile];
        
        BOOL isDir;
        //判断是否是为目录
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:selectedPath isDirectory:&isDir] && isDir)
        {
            //目录
            [foldersArr addObject:selectedPath];
        }
        else
        {
            //文件
            JRFileModel *model = [[JRFileModel alloc] init];
            model.path = selectedPath;
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            model.name = [userDefaults objectForKey:selectedFile];
            if (model.name.length == 0) {
                model.name = selectedFile;
            }
            
          
            model.fileType = [self getFileTypeString:model.path];
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSString *path = selectedPath;//@"/tmp/List";
            NSError *error = nil;
            NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:path error:&error];
            
            if (fileAttributes != nil) {
                
                NSNumber *fileSize = [fileAttributes objectForKey:NSFileSize];
                //NSString *fileOwner = [fileAttributes objectForKey:NSFileOwnerAccountName];
                //NSDate *fileModDate = [fileAttributes objectForKey:NSFileModificationDate];
                NSDate *fileCreateDate = [fileAttributes objectForKey:NSFileCreationDate];
                
                unsigned long long sizeValue = [fileSize unsignedLongLongValue];
                //                sizeValue/=1024;
                //                if (sizeValue == 0) {
                //                    sizeValue = 1;
                //                }
                model.size = sizeValue;
                
                model.createDate = [NSString getTimeWithDate:fileCreateDate];
            }
            
            [photosArr addObject:model];
        }
    }
    
    return [sourceList copy];
}


- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topView.frame), SCREEN_WIDTH, SCREEN_HEIGHT - CGRectGetMaxY(self.topView.frame)) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (NSArray *)titleArray{
    if (!_titleArray) {
        _titleArray = @[@"本地文件",@"iCloud文件"];
    }
    return _titleArray;
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
