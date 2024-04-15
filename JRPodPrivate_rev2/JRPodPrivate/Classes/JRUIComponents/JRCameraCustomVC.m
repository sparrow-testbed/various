/**
 * 所属系统: TIM
 * 所属模块: 聊天类：录制视频
 * 功能描述: 自定义视频录制节目
 * 创建时间: 2020/9/18.
 * 维护人:  金煜祥
 * Copyright @ Jerrisoft 2019. All rights reserved.
 *┌─────────────────────────────────────────────────────┐
 *│ 此技术信息为本公司机密信息，未经本公司书面同意禁止向第三方披露．│
 *│ 版权所有：杰人软件(深圳)有限公司                          │
 *└─────────────────────────────────────────────────────┘
 */

#import "JRCameraCustomVC.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "JRVideoRecordProgressView.h"
#import "JRRecordPlayerView.h"

#import "JRPhotoShowPlayerView.h"


#import "JRUIKit.h"
static const CGFloat KTimerInterval = 0.02;  //进度条timer
static const CGFloat KMaxRecordTime = 15;    //最大录制时间

@interface JRCameraCustomVC ()<AVCaptureFileOutputRecordingDelegate,JRImageEditorDelegate>

@property (nonatomic, strong) AVCaptureSession *iSession;
///设备
@property (nonatomic, strong) AVCaptureDevice *iDevice;
///输入
@property (nonatomic, strong) AVCaptureDeviceInput *iInput;

///视频输出
//@property (nonatomic, strong) AVCaptureMovieFileOutput *iMovieOutput;
@property (nonatomic, strong) AVCaptureMovieFileOutput *iMovieOutput;
///预览层
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *iPreviewLayer;
@property (nonatomic, strong) NSURL *recordVideoUrl;

@property (nonatomic, strong) JRVideoRecordProgressView *progressView;
///录制界面按钮
@property (nonatomic, strong) UIView *recordBtn;
@property (nonatomic, strong) UIView *recordBackView;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UIButton *switchCameraButton;
@property (nonatomic, strong) UIButton *flashBtn;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIImageView *focusImageView;

@property (nonatomic, strong) NSTimer *timer;
///录制时间
@property (nonatomic, assign) CGFloat recordTime;

@property (nonatomic, assign) BOOL videoCompressComplete;
@property (nonatomic, strong) NSURL *recordVideoOutPutUrl;

@property (nonatomic, assign) BOOL isVideo;
@end
#define ChangeY 40
#define RecordBtWidth 56.0
#define SmallRecordBtWidth 40.0

#define BackBtWidth 40.0
#define SwitchBtWidth 40.0
@implementation JRCameraCustomVC
{
    JRImageEditor *editor;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.iSession) {
        [self.iSession startRunning];
    }
    
   [UIApplication sharedApplication].statusBarHidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (self.iSession) {
        [self.iSession stopRunning];
    }
    
    [UIApplication sharedApplication].statusBarHidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    self.iSession = [[AVCaptureSession alloc]init];
   
    if ([self.iSession canSetSessionPreset:AVCaptureSessionPresetHigh]) {
        self.iSession.sessionPreset = AVCaptureSessionPresetHigh;
    }
    NSArray *deviceArray = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in deviceArray) {
        if (device.position == AVCaptureDevicePositionBack) {
            self.iDevice = device;
        }
    }
    
    //添加摄像头设备
    //对设备进行设置时需上锁，设置完再打开锁
    [self.iDevice lockForConfiguration:nil];
    if ([self.iDevice isFlashModeSupported:AVCaptureFlashModeAuto]) {
        [self.iDevice setFlashMode:AVCaptureFlashModeAuto];
    }
    if ([self.iDevice isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
        [self.iDevice setFocusMode:AVCaptureFocusModeAutoFocus];
    }
    if ([self.iDevice isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeAutoWhiteBalance]) {
        [self.iDevice setWhiteBalanceMode:AVCaptureWhiteBalanceModeAutoWhiteBalance];
    }
    [self.iDevice unlockForConfiguration];
    
    //添加音频设备
    AVCaptureDevice *audioDevice = [[AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio] firstObject];
    
    AVCaptureDeviceInput *audioInput = [AVCaptureDeviceInput deviceInputWithDevice:audioDevice error:nil];
    
    self.iInput = [[AVCaptureDeviceInput alloc]initWithDevice:self.iDevice error:nil];
    
    self.iMovieOutput = [[AVCaptureMovieFileOutput alloc]init];

    if ([self.iSession canAddInput:self.iInput]) {
        [self.iSession addInput:self.iInput];
    }
    
    if ([self.iSession canAddInput:audioInput]) {
        [self.iSession addInput:audioInput];
    }
    
    self.iPreviewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:self.iSession];
    [self.iPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    self.iPreviewLayer.frame = [UIScreen mainScreen].bounds;
    [self.view.layer insertSublayer:self.iPreviewLayer atIndex:0];
    
    [self.iSession startRunning];
    
    [self videoButtonAction:nil];
    
    [self buildUI];
}

#pragma -mark 创建UI
- (void)buildUI {
    CGFloat topMaskViewHeight = 127;
    CGFloat bottomMaskViewHeight = 261;
    UIView * topMaskView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, topMaskViewHeight)];
    topMaskView.backgroundColor = [UIColor jk_gradientFromColor:[UIColor jk_colorWithHex:0x000000 andAlpha:0.4] toColor:[UIColor jk_colorWithHex:0x000000 andAlpha:0] withHeight:topMaskViewHeight];
    UIView * bottomMaskView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.height-bottomMaskViewHeight, self.view.width, bottomMaskViewHeight)];
    bottomMaskView.backgroundColor = [UIColor jk_gradientFromColor:[UIColor jk_colorWithHex:0x000000 andAlpha:0] toColor:[UIColor jk_colorWithHex:0x000000 andAlpha:0.4] withHeight:bottomMaskViewHeight];
    //上下朦板
    [self.view addSubview:topMaskView];
    [self.view addSubview:bottomMaskView];
    // 取消
    [self.view addSubview:self.backButton];
    
    // 闪光灯
    //[self.view addSubview:self.flashBtn];
    
    [self.view addSubview:self.recordBackView];
    [self.view addSubview:self.tipLabel];
    [self.view addSubview:self.progressView];
    // 前后
    [self.view addSubview:self.switchCameraButton];
    
    // 开始 原型按钮
    [self.view addSubview:self.recordBtn];
    // 添加聚焦手势
    [self.view addSubview:self.focusImageView];
    [self addFocusGensture];
}

- (JRVideoRecordProgressView *)progressView{
    if (!_progressView) {
        _progressView = [[JRVideoRecordProgressView alloc] initWithFrame:self.recordBackView.frame];
    }
    return _progressView;
}

- (UIButton *)backButton {
    
    if (!_backButton) {
        
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton setImage:[JRUIHelper imageNamed:@"record_video_dismiss"] forState:UIControlStateNormal];
        _backButton.frame = CGRectMake(self.recordBackView.left-63-BackBtWidth, self.recordBackView.centerY - 17, BackBtWidth, BackBtWidth);
        [_backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (UIButton *)flashBtn {
    
    if (!_flashBtn) {
        _flashBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_flashBtn setImage:[JRUIHelper imageNamed:@"lightning"] forState:UIControlStateNormal];
        _flashBtn.frame = CGRectMake((SCREEN_WIDTH-30)/2, 20, 30, 30);
        [_flashBtn addTarget:self action:@selector(flashAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _flashBtn;
}

-(UIView *)recordBtn {
    if (!_recordBtn) {
        _recordBtn = [[UIView alloc]init];
     
        _recordBtn.frame = CGRectMake((self.view.width - RecordBtWidth)/2, self.view.height - RecordBtWidth - 34-BottomHeight - 10, RecordBtWidth, RecordBtWidth);
        [_recordBtn.layer setCornerRadius:_recordBtn.frame.size.width/2];
        _recordBtn.backgroundColor = [UIColor whiteColor];
        
        if (self.cameraType == JRCameraTypeDefault || self.cameraType == JRCameraTypePhotograph || self.cameraType == JRCameraTypeNoEdit) {
            UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(stratShot:)];
            [_recordBtn addGestureRecognizer:tgr];
        }
        if (self.cameraType == JRCameraTypeDefault || self.cameraType == JRCameraTypeShot) {
            UILongPressGestureRecognizer *press = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(startRecord:)];
            [_recordBtn addGestureRecognizer:press];
        }
        _recordBtn.userInteractionEnabled = YES;
    }
    return _recordBtn;
}

- (UIView *)recordBackView {
    if (!_recordBackView) {
        CGRect rect = self.recordBtn.frame;
        CGFloat gap = 10;
        rect.size = CGSizeMake(rect.size.width + gap*2, rect.size.height + gap*2);
        rect.origin = CGPointMake(rect.origin.x - gap, rect.origin.y - gap);
        _recordBackView = [[UIView alloc]initWithFrame:rect];
        _recordBackView.backgroundColor = [UIColor whiteColor];
        _recordBackView.alpha = 0.2;
        [_recordBackView.layer setCornerRadius:_recordBackView.frame.size.width/2];
    }
    return _recordBackView;
}

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc]initWithFrame:CGRectMake((self.view.width - 50)/2, self.recordBackView.origin.y - 50, 150, 20)];
        _tipLabel.center = CGPointMake(self.view.center.x, _tipLabel.center.y);
        _tipLabel.textColor = [UIColor whiteColor];
        if (self.cameraType == JRCameraTypeDefault) {
            _tipLabel.text = @"轻触拍照，长按摄像";
        }
        else if (self.cameraType == JRCameraTypePhotograph || self.cameraType == JRCameraTypeNoEdit){
            _tipLabel.text = @"轻触拍照";
        }
        else if (self.cameraType == JRCameraTypeShot){
            _tipLabel.text = @"长按摄像";
        }
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.font = [UIFont systemFontOfSize:12];
    }
    return _tipLabel;
}

- (UIButton *)switchCameraButton {
    if (!_switchCameraButton) {
        _switchCameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_switchCameraButton setImage:[JRUIHelper imageNamed:@"record_video_camera"] forState:UIControlStateNormal];
        _switchCameraButton.frame = CGRectMake(self.recordBackView.right+64, self.recordBackView.top + 17, SwitchBtWidth, SwitchBtWidth);
        [_switchCameraButton addTarget:self action:@selector(changePositionAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _switchCameraButton;
}

#pragma mark 计时器相关
- (NSTimer *)timer {
    
    if (!_timer) {
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:KTimerInterval target:self selector:@selector(fire:) userInfo:nil repeats:YES];
    }
    
    return _timer;
}

#pragma -mark 计时器开启
- (void)fire:(NSTimer *)timer {
    
    self.recordTime += KTimerInterval;
    
    [self recordTimeCurrentTime:self.recordTime totalTime:KMaxRecordTime];
    
    if(_recordTime >= KMaxRecordTime) {
        [self stopRecord];
    }
}

- (void)startTimer {
    
    [self.timer invalidate];
    self.timer = nil;
    self.recordTime = 0;
    
    [self.timer fire];
}

- (void)stopTimer {
    
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark - 返回事件

- (void)backAction:(id)sender {
    
    if (self.cameraVideoCancelBlock) {
        self.cameraVideoCancelBlock();
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma -mark 闪光灯
- (void)flashAction:(id)sender {
    
    [self.iDevice lockForConfiguration:nil];
    
    UIButton *flashButton = (UIButton *)sender;
    flashButton.selected = !flashButton.selected;
    if (flashButton.selected) {
        if ([self.iDevice isFlashModeSupported:AVCaptureFlashModeOn]) {
            [self.iDevice setFlashMode:AVCaptureFlashModeOn];
            
            [MBProgressHUD showHUD:@"闪光灯已开启"];
        }
    } else {
        if ([self.iDevice isFlashModeSupported:AVCaptureFlashModeOff]) {
            [self.iDevice setFlashMode:AVCaptureFlashModeOff];
            [MBProgressHUD showHUD:@"闪光灯已关闭"];
        }
    }
    
    [self.iDevice unlockForConfiguration];
}

#pragma -mark 前后摄像头置换
- (void)changePositionAction:(id)sender {
    
    NSArray *deviceArray = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    AVCaptureDevice *newDevice;
    AVCaptureDeviceInput *newInput;
    
    
    if (self.iDevice.position == AVCaptureDevicePositionBack) {
        for (AVCaptureDevice *device in deviceArray) {
            if (device.position == AVCaptureDevicePositionFront) {
                newDevice = device;
            }
        }
    } else {
        for (AVCaptureDevice *device in deviceArray) {
            if (device.position == AVCaptureDevicePositionBack) {
                newDevice = device;
            }
        }
    }
    
    newInput = [AVCaptureDeviceInput deviceInputWithDevice:newDevice error:nil];
    if (newInput!=nil) {
        
        [self.iSession beginConfiguration];
        
        [self.iSession removeInput:self.iInput];
        if ([self.iSession canAddInput:newInput]) {
            [self.iSession addInput:newInput];
            self.iDevice = newDevice;
            self.iInput = newInput;
        } else{
            [self.iSession addInput:self.iInput];
        }
        
        [self.iSession commitConfiguration];
    }
    
}

#pragma -mark 聚焦框框 View
- (UIImageView *)focusImageView {
    
    if (!_focusImageView) {
        _focusImageView = [[UIImageView alloc]initWithImage:[JRUIHelper imageNamed:@"record_video_focus"]];
        _focusImageView.alpha = 0;
        _focusImageView.frame = CGRectMake(0, 0, 75, 75);
    }
    return _focusImageView;
}

#pragma mark - 点按时聚焦
- (void)addFocusGensture{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapScreen:)];
    [self.view addGestureRecognizer:tapGesture];
}

- (void)tapScreen:(UITapGestureRecognizer *)tapGesture{
    CGPoint point= [tapGesture locationInView:self.view];
    [self setFocusCursorWithPoint:point];
    
    CGPoint cameraPoint= [self.iPreviewLayer captureDevicePointOfInterestForPoint:point];
    [self focusWithMode:AVCaptureFocusModeContinuousAutoFocus exposureMode:AVCaptureExposureModeContinuousAutoExposure atPoint:cameraPoint];
}

-(void)focusWithMode:(AVCaptureFocusMode)focusMode exposureMode:(AVCaptureExposureMode)exposureMode atPoint:(CGPoint)point {
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        //聚焦
        if ([captureDevice isFocusModeSupported:focusMode]) {
            [captureDevice setFocusMode:focusMode];
        }
        //聚焦位置
        if ([captureDevice isFocusPointOfInterestSupported]) {
            [captureDevice setFocusPointOfInterest:point];
        }
        //曝光模式
        if ([captureDevice isExposureModeSupported:exposureMode]) {
            [captureDevice setExposureMode:exposureMode];
        }
        //曝光点位置
        if ([captureDevice isExposurePointOfInterestSupported]) {
            [captureDevice setExposurePointOfInterest:point];
        }
    }];
}

#pragma mark - 改变设备属性方法
- (void)changeDeviceProperty:(void (^)(id obj))propertyChange
{
    NSError *error;
    //注意改变设备属性前一定要首先调用lockForConfiguration:调用完之后使用unlockForConfiguration方法解锁
    if ([self.iDevice lockForConfiguration:&error]) {
        propertyChange(self.iDevice);
        [self.iDevice unlockForConfiguration];
    }else{
        
    }
}

-(void)setFocusCursorWithPoint:(CGPoint)point{
    self.focusImageView.center = point;
    self.focusImageView.transform = CGAffineTransformMakeScale(1.5, 1.5);
    [UIView animateWithDuration:0.2 animations:^{
        self.focusImageView.alpha = 1;
        self.focusImageView.transform = CGAffineTransformMakeScale(1, 1);
    }completion:^(BOOL finished) {
        [self performSelector:@selector(autoHideFocusImageView) withObject:nil afterDelay:1];
    }];
}

- (void)autoHideFocusImageView{
    self.focusImageView.alpha = 0;
}
#pragma mark - 拍摄
-(void)stratShot:(UITapGestureRecognizer*)tgr{
    _isVideo = NO;
    self.recordVideoUrl = nil;
    self.videoCompressComplete = NO;
    self.recordVideoOutPutUrl = nil;
    
    [self startRecord];
    
    self.recordBtn.hidden = YES;
    self.tipLabel.hidden = YES;
    self.switchCameraButton.hidden = YES;
    [self performSelector:@selector(stopRecord) withObject:nil afterDelay:0.6];
   
}

#pragma -mark 开始录制
- (void)startRecord:(UILongPressGestureRecognizer *)gesture {
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        _isVideo = YES;
        self.recordVideoUrl = nil;
        self.videoCompressComplete = NO;
        self.recordVideoOutPutUrl = nil;
        [self startRecordAnimate];
        CGRect rect = self.progressView.frame;
        rect.size = CGSizeMake(self.recordBackView.size.width - 3, self.recordBackView.size.height - 3);
        rect.origin = CGPointMake(self.recordBackView.origin.x + 1.5, self.recordBackView.origin.y + 1.5);
        self.progressView.frame = self.recordBackView.frame;
      
        self.tipLabel.hidden = YES;
        self.backButton.hidden = YES;
        self.switchCameraButton.hidden = YES;
        
    } else if(gesture.state >= UIGestureRecognizerStateEnded) {
        
        [self stopRecord];
    } else if(gesture.state >= UIGestureRecognizerStateCancelled) {
        
        [self stopRecord];
    } else if(gesture.state >= UIGestureRecognizerStateFailed) {
        
        [self stopRecord];
    }
}

- (void)startRecordAnimate {
    
    [UIView animateWithDuration:0.2 animations:^{
        self.recordBtn.transform = CGAffineTransformMakeScale(SmallRecordBtWidth/RecordBtWidth, SmallRecordBtWidth/RecordBtWidth) ;
        self.recordBackView.transform = CGAffineTransformMakeScale(112.0/76.0, 112.0/76.0);
    }];
    
    [self startRecord];
}

- (void)startRecord {
    if (_isVideo) {
        [self startTimer];
    }

    AVCaptureConnection *connect = [self.iMovieOutput connectionWithMediaType:AVMediaTypeVideo];
    if (connect.isActive) {
        NSURL *url = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingString:@"myMovie.mov"]];
        
        if (![self.iMovieOutput isRecording]) {
            [self.iMovieOutput startRecordingToOutputFileURL:url recordingDelegate:self];
        }
    }else{
        
        if ([self.iSession canSetSessionPreset:AVCaptureSessionPresetHigh]) {
            self.iSession.sessionPreset = AVCaptureSessionPresetHigh;
        }
        AVCaptureConnection *connect2 = [self.iMovieOutput connectionWithMediaType:AVMediaTypeVideo];
        if (connect2.isActive) {
            NSURL *url = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingString:@"myMovie.mov"]];
            
            if (![self.iMovieOutput isRecording]) {
                [self.iMovieOutput startRecordingToOutputFileURL:url recordingDelegate:self];
            }
        }
        
    }
}

#pragma mark - 停止录制
- (void)stopRecord {
    if (_isVideo) {
        [self stopTimer];
    }
    if ([self.iMovieOutput isRecording]) {
        [self.iMovieOutput stopRecording];
    } else {
        JRLog(@"No recording...");
    }
    
    if ([self.iSession isRunning]) {
        [self.iSession stopRunning];
    
    }
    self.recordBtn.hidden = YES;
    self.recordBackView.hidden = YES;
    
    self.iPreviewLayer.hidden = YES;
    
    [self recordTimeCurrentTime:0 totalTime:0];
}

- (void)videoButtonAction:(id)sender {
    
    [self.iSession beginConfiguration];
    if ([self.iSession canAddOutput:self.iMovieOutput]) {
        
        [self.iSession addOutput:self.iMovieOutput];
        //设置视频防抖
        AVCaptureConnection *connection = [self.iMovieOutput connectionWithMediaType:AVMediaTypeVideo];
        if ([connection isVideoStabilizationSupported]) {
            connection.preferredVideoStabilizationMode = AVCaptureVideoStabilizationModeCinematic;
        }
    }
    
    [self.iSession commitConfiguration];
}

-(void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error {
    
    if (!error) {
        self.recordVideoUrl = outputFileURL;
        WS(weakSelf)
        if (_isVideo) {

            dispatch_async(dispatch_get_main_queue(), ^{
                [self showVedio:outputFileURL];
                
            });
            [MBProgressHUD showHudLoading:@"视频转码中" toView:self.view];
            [self compressVideo:outputFileURL complete:^(BOOL success, NSURL *outputUrl) {
                dispatch_async(dispatch_get_main_queue(), ^{
                     [MBProgressHUD dismissHudForView:self.view];
                });
              
                if (success && outputUrl) {
                    weakSelf.recordVideoOutPutUrl = outputUrl;
                }
                weakSelf.videoCompressComplete = YES;
            }];
            
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showPhoto:outputFileURL];
            });
        }
    } else {
        [self clickCancel];
       
        JRLog(@"录制出错:%@", error);
    }
}

-(void)showPhoto:(NSURL *)imageURL{
    AVURLAsset *urlSet = [AVURLAsset assetWithURL:imageURL];
    AVAssetImageGenerator *imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:urlSet];
    imageGenerator.appliesPreferredTrackTransform = YES; // 截图的时候调整到正确的方向
    imageGenerator.apertureMode = AVAssetImageGeneratorApertureModeProductionAperture;
    NSError *error = nil;
    CMTime time = CMTimeMake(0,10);//缩略图创建时间 CMTime是表示电影时间信息的结构体，第一个参数表示是视频第几秒，第二个参数表示每秒帧数.(如果要获取某一秒的第几帧可以使用CMTimeMake方法)
    CMTime actucalTime; //缩略图实际生成的时间
    CGImageRef cgImage = [imageGenerator copyCGImageAtTime:time actualTime:&actucalTime error:&error];
    if (error) {
     JRLog(@"截取视频图片失败:%@",error.localizedDescription);
    }
    CMTimeShow(actucalTime);
    UIImage *image = [UIImage imageWithCGImage:cgImage];
    
    CGImageRelease(cgImage);
    if (image) {
     JRLog(@"视频截取成功");
    } else {
     JRLog(@"视频截取失败");
    }

    self.focusImageView.hidden = YES;
    if (self.cameraType == JRCameraTypeNoEdit) {
        if (self.cameraPhotoCompleteBlock) {
            self.cameraPhotoCompleteBlock(image);
        }
        [self backAction:nil];
    }else{
        editor = [[JRImageEditor alloc] initWithImage:image delegate:self];
        editor.editType = self.editType;
        editor.confirmTitle = @"发送";
        editor.modalPresentationStyle = UIModalPresentationFullScreen;
        [editor addTransitionAnimation:self.view];
        [self.view addSubview:editor.view];
    }


    /*
    JRPhotoShowPlayerView * showView = [[JRPhotoShowPlayerView alloc]initWithFrame:[UIApplication sharedApplication].keyWindow.bounds andImage:image];
    if (self.confirmTitle.length>0) {
        [showView.confirmButton setTitle:self.confirmTitle forState:UIControlStateNormal];
    }
    showView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:showView];
    WS(weakSelf);
    showView.cancelBlock = ^{
        [weakSelf clickCancel];
    };

    showView.confirmBlock = ^{
        
        if (weakSelf.isIncludeUrl) {
            //特殊情况下需要 图片路径 所以添加此回调
            if (weakSelf.cameraPhotoIncloudUrlCompleteBlock) {

                weakSelf.cameraPhotoIncloudUrlCompleteBlock(imageURL,image);
            }
        }else {
            if (weakSelf.cameraPhotoCompleteBlock) {

                weakSelf.cameraPhotoCompleteBlock(image);
            }
        }
        
        [weakSelf backAction:nil];
       };
 */
    
}



#pragma mark - JRImageEditorDelegate
- (void)imageEditor:(JRImageEditor *)imageEditor didFinishEdittingWithImage:(UIImage *)image {
    
    if (self.cameraPhotoCompleteBlock) {
        self.cameraPhotoCompleteBlock(image);
    }
//    [editor.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    [editor.view removeFromSuperview];
    [self backAction:nil];

}
- (void)imageEditorDidCancel:(JRImageEditor *)imageEditor{
    [editor.view removeFromSuperview];
    [self clickCancel];
    self.focusImageView.hidden = NO;
}

#pragma mark - 录制结束循环播放视频
- (void)showVedio:(NSURL *)playUrl {
    JRRecordPlayerView *playView= [[JRRecordPlayerView alloc]initWithFrame:self.view.bounds];
    if (self.confirmTitle.length>0) {
        playView.confirmTitle = self.confirmTitle;
    }
    playView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:playView];
    playView.playUrl = playUrl;
    WS(weakSelf);
    playView.cancelBlock = ^{
        [weakSelf clickCancel];
    };
    playView.confirmBlock = ^{
        if (!weakSelf.videoCompressComplete) {
            return ;
        }
        // 测试期间，暂时 同步放入 相册中
        //[weakSelf saveVideo];
        if (weakSelf.cameraVideoCompleteBlock && weakSelf.recordVideoOutPutUrl) {
            
            NSString *urlStr = [JRCameraCustomVC getVideoPreViewImage:weakSelf.recordVideoOutPutUrl];
            
            weakSelf.cameraVideoCompleteBlock(weakSelf.recordVideoOutPutUrl, urlStr);
        }
        [weakSelf backAction:nil];
    };
}

- (void)saveVideo {
    
    ALAssetsLibrary *assetsLibrary=[[ALAssetsLibrary alloc]init];

    [assetsLibrary writeVideoAtPathToSavedPhotosAlbum:self.recordVideoUrl completionBlock:nil];
    [MBProgressHUD showHUD:@"视频保存成功"];
}

#pragma mark - 取消录制的视频
- (void)clickCancel {
    
    self.iPreviewLayer.hidden = NO;
    
    [self.iSession startRunning];
    
    self.recordBtn.transform = CGAffineTransformIdentity;
    self.recordBackView.transform = CGAffineTransformIdentity;
    
    self.recordBtn.hidden = NO;
    self.recordBackView.hidden = NO;

    self.backButton.hidden = NO;
    self.tipLabel.hidden = NO;
    self.switchCameraButton.hidden = NO;
    
    self.recordTime = 0;
}


/**
 @desc 设置录制倒计时圆圈显示
 @author Scott
 @date 2019/9/18
 @param currentTime 当前录制秒数
 @param totalTime 总时长
 */
- (void)recordTimeCurrentTime:(CGFloat)currentTime totalTime:(CGFloat)totalTime{
    self.progressView.totolProgress = totalTime;
    self.progressView.progress = currentTime;
}

#pragma -mark 视频压缩 与 缓存
- (void)compressVideo:(NSURL *)inputFileURL complete:(void(^)(BOOL success, NSURL* outputUrl))complete {
    
    NSURL *outPutUrl = [NSURL fileURLWithPath:[JRCameraCustomVC getCacheDirWithCreate:NO]];
    [self convertVideoQuailtyWithInputURL:inputFileURL outputURL:outPutUrl completeHandler:^(AVAssetExportSession *exportSession) {
        complete(exportSession.status == AVAssetExportSessionStatusCompleted, outPutUrl);
    }];
}

- (void)convertVideoQuailtyWithInputURL:(NSURL*)inputURL
                              outputURL:(NSURL*)outputURL
                        completeHandler:(void (^)(AVAssetExportSession*))handler{
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:inputURL options:nil];
    
    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPresetMediumQuality];
    
    exportSession.outputURL = outputURL;
    exportSession.outputFileType = AVFileTypeMPEG4;
    exportSession.shouldOptimizeForNetworkUse= YES;
    [exportSession exportAsynchronouslyWithCompletionHandler:^(void){
        handler(exportSession);
    }];
}

#pragma mark 获取文件大小
+ (CGFloat)getfileSize:(NSString *)filePath{
    NSFileManager *fm = [NSFileManager defaultManager];
    filePath = [filePath stringByReplacingOccurrencesOfString:@"file://" withString:@""];
    CGFloat fileSize = 0;
    if ([fm fileExistsAtPath:filePath]) {
        fileSize = [[fm attributesOfItemAtPath:filePath error:nil] fileSize];
        JRLog(@"视频大小 - - - - - %fM,--------- %fKB",fileSize / (1024.0 * 1024.0),fileSize / 1024.0);
    }
    return fileSize/1024/1024;
}

#pragma mark 视频缓存目录
+ (NSString *) getCacheDirWithCreate:(BOOL)isCreate {
    
    //  在Documents目录下创建一个名为FileData的文件夹
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject] stringByAppendingPathComponent:@"Cache/VideoData"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = FALSE;
    BOOL isDirExist = [fileManager fileExistsAtPath:path isDirectory:&isDir];
    if(!(isDirExist && isDir)) {
        BOOL bCreateDir = [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        if(!bCreateDir){
            JRLog(@"创建文件夹失败！%@",path);
        }
        JRLog(@"创建文件夹成功，文件路径%@",path);
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    [formatter setDateFormat:@"yyyy_MM_dd_HH_mm_ss"]; //每次启动后都保存一个新的日志文件中
    NSString *dateStr = [formatter stringFromDate:[NSDate date]];
    
    NSString *resultPath = [path stringByAppendingFormat:@"/%@.mp4",dateStr];
    JRLog(@"file path:%@",resultPath);
    JRLog(@"resultPath = %@",resultPath);
    
    return resultPath;
}

#pragma -mark 根据本地路径获取视频的第一帧
+ (NSString *)getVideoPreViewImage:(NSURL *)url
{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:url options:nil];
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    
    gen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *img = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    
    
    //png格式
    NSData *imagedata=UIImagePNGRepresentation(img);

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    [formatter setDateFormat:@"yyyy_MM_dd_HH_mm_ss"]; //每次启动后都保存一个新的日志文件中
    NSString *localCoveriosName = [formatter stringFromDate:[NSDate date]];
    [self saveVideoConverImageData:imagedata imageName:localCoveriosName];

    return localCoveriosName;
}
#pragma mark - 视频第一贞图片
+ (void)saveVideoConverImageData:(NSData *)coverImageData imageName:(NSString *)imageName{
    
    if (!coverImageData || !imageName) {
        return;
    }
    //  在Documents目录下创建一个名为FileData的文件夹
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject] stringByAppendingPathComponent:@"Cache/VideoCover"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = FALSE;
    BOOL isDirExist = [fileManager fileExistsAtPath:path isDirectory:&isDir];
    if(!(isDirExist && isDir)) {
        BOOL bCreateDir = [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        if(!bCreateDir){
            JRLog(@"创建文件夹失败！%@",path);
        }
        JRLog(@"创建文件夹成功，文件路径%@",path);
    }
    
    NSString *resultPath = [path stringByAppendingFormat:@"/%@.png",imageName];
    
    [coverImageData writeToFile:resultPath atomically:YES];


}


- (void)dealloc {
    
    [self.timer invalidate];
    self.timer = nil;
    self.recordTime = 0;
}

@end
