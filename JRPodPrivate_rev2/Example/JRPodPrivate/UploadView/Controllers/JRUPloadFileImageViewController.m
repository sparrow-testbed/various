//
/**
* 所属系统: YMMAD
* 所属模块: 
* 功能描述: 
* 创建时间: 2021/1/15
* 维护人:  马克
* Copyright © 2021 wni. All rights reserved.
*┌─────────────────────────────────────────────────────┐
*│ 此技术信息为本公司机密信息，未经本公司书面同意禁止向第三方披露．│
*│ 版权所有：杰人软件(深圳)有限公司                          │
*└─────────────────────────────────────────────────────┘
*/

#import "JRUPloadFileImageViewController.h"
#import "JRImageModel.h"
#define MainScreenWidth [[UIScreen mainScreen]bounds].size.width
#define MainScreenHeight [[UIScreen mainScreen]bounds].size.height


@interface JRUPloadFileImageViewController ()<TZImagePickerControllerDelegate>

@property(nonatomic,strong)JRAddFileImage *addFielimage;

@property(nonatomic,strong)JRImageCollectionViewCell *collectionCell;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, strong)NSMutableArray *mutaArray;
@property (nonatomic, strong)NSMutableArray *videoArray;
@property (nonatomic, strong)JRImageModel *imageModel;
@property (nonatomic, strong)JRFileModel  *fileModel;
@property (nonatomic,assign)NSInteger lock;

@end

@implementation JRUPloadFileImageViewController

- (NSMutableArray *)mutaArray {
    if (!_mutaArray) {
        _mutaArray = [NSMutableArray array];
    }
    return _mutaArray;
}

- (NSMutableArray *)videoArray {
    if (!_videoArray) {
        _videoArray = [NSMutableArray array];
    }
    return _videoArray;
}

- (JRAddFileImage *)addFielimage {
    if (!_addFielimage) {
        _addFielimage = [[JRAddFileImage alloc] initWithFrame:self.view.bounds];
        _addFielimage.isVisable = YES;
        _addFielimage.titleLabel.text = @"附件:";
        _addFielimage.subTitleLabel.text = @"合同电子文档及相关表格、扫描件及图片";
        _addFielimage.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }
    return _addFielimage;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.addFielimage];
    
    self.view.backgroundColor = UIColor.whiteColor;

    WS(weakSelf)
    self.addFielimage.addFileEventBlock = ^{
        [weakSelf checkLocalPhoto];
    };
    NSMutableArray *datas = [NSMutableArray array];
    // 预览图片及视频文件
    self.addFielimage.previewPhotoBlock = ^(id object,NSInteger index,JRImageCollectionViewCell *cell) {
        
        
        for (int i = 0; i<weakSelf.mutaArray.count; i++) {
            id  data = [weakSelf.mutaArray objectAtIndex:index];
            if ([data isKindOfClass:[YBIBImageData class]]) {
                YBIBImageData  *iamgeData = (YBIBImageData *)data;
                iamgeData.projectiveView = cell.imagev;
                iamgeData.allowSaveToPhotoAlbum = NO;

            }else {
                YBIBVideoData  *videoData = (YBIBVideoData *)data;
                videoData.projectiveView = cell.imagev;
                videoData.allowSaveToPhotoAlbum = NO;
            }
        }
        
        YBImageBrowser *browser = [YBImageBrowser new];
        browser.dataSourceArray = weakSelf.mutaArray;
        browser.currentPage = index;
        [browser show];
                
    };
    
}

- (void)fetchImageWithAsset:(PHAsset*)mAsset imageBlock:(void(^)(NSData* imageData))imageBlock {
    
    [[PHImageManager defaultManager] requestImageDataForAsset:mAsset options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
        // 直接得到最终的 NSData 数据
        if (imageBlock) {
            imageBlock(imageData);
        }
    }];

}


- (void)fetchImagePathWithAsset:(PHAsset*)mAsset imageBlock:(void(^)(NSURL * imagePath))imageBlock {
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    
    options.synchronous = YES;
    
    options.networkAccessAllowed = YES;
    
    options.deliveryMode = PHImageRequestOptionsDeliveryModeFastFormat;
    
    
    [[PHImageManager defaultManager] requestImageDataForAsset:mAsset options:options resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
        // 直接得到最终的 NSData 数据
        if ([info objectForKey:@"PHImageFileURLKey"]) {
        }
        NSURL *path = [info objectForKey:@"PHImageFileURLKey"];
        if (imageBlock) {
            imageBlock(path);
        }
        
    }];
}

//预览相册视频文件
- (void)previewVideo:(PHAsset *)phAsset videoBlock:(void(^)(NSURL * videoPath))videoBlock{
    PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
    options.version = PHVideoRequestOptionsVersionOriginal;
    options.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
    
    PHImageManager *manager = [PHImageManager defaultManager];
    [manager requestAVAssetForVideo:phAsset options:options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
        AVURLAsset *urlAsset = (AVURLAsset *)asset;
        NSURL *url = urlAsset.URL;
        if (videoBlock) {
            videoBlock(url);
        }
    }];
}


#pragma mark - 选择相片逻辑

- (void)checkLocalPhoto{
    NSArray *imageArray = @[@"btn_shoot_chat",@"btn_photo_chat",@"btn_file_chat"];
    NSArray *titleArray = @[@"拍摄",@"相册",@"文件"];
    JRPhotoCameraFilePopView *popView = [[JRPhotoCameraFilePopView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) titleArray:titleArray imageArray:imageArray];
    popView.block = ^(NSString * _Nonnull title, NSInteger row) {
        if (row == 0) {
            [self camreaWithType:JRCameraTypeDefault];
        }else if (row == 1){
            //相册
            [self photoWithType:2];
        }else{
            //文件
            [self selectFileToUploadService];
        }
    };
    
    [popView show];
}


/// 弹窗相册素材选择
/// @param Type 0 相册（仅照片） 1 相册（仅视频） 2 相册（图片+视频）
- (void)photoWithType:(NSInteger)type{
    JRImagePickerController  *imagePicker = [[JRImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
    imagePicker.showSelectedIndex = YES;
    imagePicker.showPhotoCannotSelectLayer = YES;
    imagePicker.allowPickingMultipleVideo = YES;
    imagePicker.videoMaximumDuration = 10 *60;
    imagePicker.videoLimitMaxDuration = 10;
    imagePicker.allowPickingMultipleVideo = YES;
    imagePicker.allowTakePicture = NO;
    imagePicker.allowTakeVideo = NO;
    imagePicker.doneBottonString = @"确定";
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

//拍照or拍摄
- (void)camreaWithType:(JRCameraType)type{
    //                拍照
    JRCameraCustomVC *cameraVC = [[JRCameraCustomVC alloc] init];
    cameraVC.confirmTitle = @"确定";
    cameraVC.isIncludeUrl = YES;
    cameraVC.modalPresentationStyle = UIModalPresentationFullScreen;
    cameraVC.cameraType = type;
    WS(weakSelf)
    //视频录制回调
    cameraVC.cameraVideoCompleteBlock = ^(NSURL * _Nonnull fileUrl, NSString * _Nonnull preImgUrlStr) {
                
        weakSelf.imageModel = [[JRImageModel alloc]init];
        weakSelf.imageModel.mediaType = 2; // 代表视频
        weakSelf.imageModel.viedoUrl = fileUrl;
        weakSelf.imageModel.image = [weakSelf getLocationVideoPreViewImage:fileUrl];
        [weakSelf.addFielimage.photosArray addObject:weakSelf.imageModel];
        [weakSelf.addFielimage updateCollectionFrame];
        //开启定时器模拟下载进度
        
        // 视频
        YBIBVideoData *videoData = [YBIBVideoData new];
        videoData.videoURL =fileUrl;
//        videoData.projectiveView = self.addFielimage;
        [self.mutaArray addObject:videoData];
        [weakSelf startTimer];
        
    };
    //图片回调
    cameraVC.cameraPhotoIncloudUrlCompleteBlock = ^(NSURL * _Nonnull imageUrl,UIImage *image) {
        
        weakSelf.imageModel = [[JRImageModel alloc]init];
        weakSelf.imageModel.mediaType = 1; // 代表图片
        weakSelf.imageModel.imageUrl = imageUrl;
        weakSelf.imageModel.image = image;
        [weakSelf.addFielimage.photosArray addObject:weakSelf.imageModel];
        [weakSelf.addFielimage updateCollectionFrame];
        
        YBIBImageData *data1 = [YBIBImageData new];
//        data1.projectiveView = self.addFielimage;
        data1.imageURL = imageUrl;
        data1.imagePath =  imageUrl.absoluteString;
        [self.mutaArray addObject:data1];
        
        
        //开启定时器模拟下载进度
        [weakSelf startTimer];
    };
    [self presentViewController:cameraVC animated:YES completion:nil];
}

// 获取本地视频第一帧
- (UIImage*) getLocationVideoPreViewImage:(NSURL *)path
{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:path options:nil];
    AVAssetImageGenerator *assetGen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    assetGen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [assetGen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *videoImage = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return videoImage;
}

#pragma mark - TZImagePickerControllerDelegate

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto{

    WS(weakSelf)

    if (self.mutaArray == nil) {
        _lock = 0;
    }
    _lock = self.mutaArray.count;

    for (int i = 0; i<photos.count; i++) {

        JRImageModel *imageModel = [[JRImageModel alloc]init];
        UIImage *image = photos[i];
        imageModel.image = image;
        //由于 photos 数量和 aseet 数量是一致的 所以可以用下面方法进行获取
        PHAsset *asset = assets[i];
        imageModel.phAsset = asset;
        if (asset.mediaType == 1) {
            
            imageModel.mediaType = 1;
            YBIBImageData *data1 = [YBIBImageData new];
            data1.imagePHAsset =  asset;// 本地图片
            data1.image = ^UIImage * _Nullable{
                return image;
            };
            
            [self.mutaArray addObject:data1];
        }else {
            imageModel.mediaType = 2;
            [self previewVideo:asset videoBlock:^(NSURL *videoPath) {
                // 视频
                YBIBVideoData *videoData = [YBIBVideoData new];
                videoData.videoURL =videoPath;
                [self.mutaArray insertObject:videoData atIndex:_lock + i];
            }];
            
        }
        [weakSelf.addFielimage.photosArray addObject:imageModel];
    }
    
    [self.addFielimage updateCollectionFrame];
    //开启定时器模拟下载进度
    [self startTimer];

    
    
}

#pragma mark - 文件选择上传逻辑
- (void)selectFileToUploadService {
    WS(weakSelf)
    JRSandBoxFileViewController *sandBoXVC = [[JRSandBoxFileViewController alloc] init];
    sandBoXVC.sandBoxBackBlock = ^(NSURL *fileURL, JRFileModel *fileModel) {

        if (fileModel != nil) {
            weakSelf.fileModel = fileModel;
            [weakSelf.addFielimage.otherLabelArray addObject:fileModel];
            [weakSelf startTimer];
        }
        
        [weakSelf.addFielimage updateCollectionFrame];
        
    };
    sandBoXVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:sandBoXVC animated:true completion:nil];
}

#pragma mark - 定时器 模拟下载进度

- (NSTimer *)timer
{
    if (_timer == nil) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(progressChange) userInfo:nil repeats:YES];
    }
    return _timer;
}


- (void)startTimer
{
    self.progress = 0.0;
    [self.timer setFireDate:[NSDate distantPast]];
}

- (void)stopTimer
{
    [self.timer setFireDate:[NSDate distantFuture]];
}

- (void)progressChange {
    self.progress += 0.25;
    if (self.progress > 1.1) {
        [self stopTimer];
        
        for (JRImageModel *model in self.addFielimage.photosArray) {
            //            if (model.progress <= 100) {
            model.imgUrl = @"imageUrl";
            
            if (model.mediaType != 1) {
                model.videoUrl = @"videoUrl";
            }
        }
        
//        self.imageModel.imgUrl = @"imageUrl";
//        if (self.imageModel.mediaType != 1) {
//            self.imageModel.videoUrl = @"videoUrl";
//        }
        if (self.fileModel) {
            self.fileModel.fileUrl = @"fileUrl";
        }
        return;
    }
    if (self.fileModel) {
        self.fileModel.progress = self.progress*100;
    }
    
    for (JRImageModel *model in self.addFielimage.photosArray) {
        if (model.imageProgress <= 100) {
            model.imageProgress = self.progress*100;
        }
    }
    
}


@end
