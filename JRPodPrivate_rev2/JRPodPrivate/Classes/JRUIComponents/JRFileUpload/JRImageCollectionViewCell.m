//
//  CollectionViewCell.m
//  多选图片
//
//  Created by holier_zyq on 2016/10/24.
//  Copyright © 2016年 holier_zyq. All rights reserved.
//

#import "JRImageCollectionViewCell.h"
#import "JRUIKit.h"
#import "FBKVOController.h"
#import "UIImage+Extensions.h"
#import "NSString+Encoder.h"
#import "JRImageUploadModel.h"

#define ScreensScale [UIScreen mainScreen].scale



@implementation JRImageCollectionViewCell
{
    @protected
    FBKVOController                         *_msgKVO;
  
}
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.imagev];
        self.imagev.contentMode = UIViewContentModeScaleAspectFill;
        self.imagev.layer.cornerRadius = 3;
        self.imagev.clipsToBounds = YES;
        
        self.imagev.layer.borderWidth = PixelOne;
        self.imagev.layer.borderColor = [UIColor jk_colorWithHexString:@"#ABC0BA"].CGColor;

        //初始化进度遮罩view
        [self setupCircleView];

    }
    return self;
}

// 上传进度遮罩
- (void)setupCircleView {
    
    self.maskView = [[UIView alloc]initWithFrame:self.bounds];
    self.maskView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    self.maskView.layer.cornerRadius = 5;
    
    [self addSubview:self.maskView];
    [self addSubview:self.deleteButton];
    [self addSubview:self.playButton];
    //环形进度view
    self.circleView1 = [[JRProcessView alloc] initWithFrame:CGRectMake((62-30/2),(62-30/2), 30, 30) withProcessType:JRProcessCircle];
    self.circleView1.backgroundColor = [[UIColor grayColor]colorWithAlphaComponent:0.7];
    self.circleView1.titleColor = [UIColor whiteColor];
    self.circleView1.center = self.maskView.center;
    self.circleView1.progressWidth = 2;
    [self.maskView addSubview:self.circleView1];
}


// 上传失败
- (void)uploadFaildView {
    
    [self addSubview:self.faildMaskView];
    
    UILabel *faildLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    faildLabel.text = @"上传失败";
    faildLabel.textColor = [UIColor redColor];
    [self.faildMaskView addSubview:faildLabel];
    
    [faildLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.faildMaskView.centerX);
        make.centerY.mas_equalTo(self.faildMaskView.centerY);
        make.width.equalTo(@100);
        make.height.equalTo(@45);
    }];

}



- (void)setFileModel:(JRImageUploadModel *)fileModel
{
    _fileModel = fileModel;
    
    self.faildMaskView.hidden = YES;
    self.deleteButton.hidden = NO;
    // 项目里使用
//    [self loadImage:fileModel];
//    [self setObserve];

    // 组件demo里的写法
    // 显示缩率图片
    if (fileModel.name) {
        [self loadImage:fileModel];
    }else {
        //组件demo 需要这样处理
        if (fileModel.image) {
            self.imagev.image = fileModel.image;
        }
    }
    if (fileModel) {
        [self setObserve];
    }
     
}

-(void)loadImage:(JRImageUploadModel *)fileModel{
    
    if (fileModel == nil) {
        return;
    }
    //根据图片寻找缓存图片
    UIImage * catchImage = [[SDImageCache sharedImageCache] imageFromCacheForKey:fileModel.name];
    if (catchImage) {
        self.imagev.image = catchImage;
        return;
    }
    
    self.imagev.image = [self imageWithColor:[UIColor colorWithHex:@"#EDF3F5"]];

    if (fileModel.localUrl) {
       
        CGSize imageViewSize =  CGSizeMake(self.bounds.size.width * ScreensScale, self.bounds.size.width * ScreensScale);
        [self getSmallImage:fileModel.image localPath:fileModel.localUrl imageName:fileModel.name imageUrl:fileModel.imgUrl imageViewSize:imageViewSize complete:^(UIImage * _Nonnull scaledImage) {
            if (self.fileModel == fileModel)
                self.imagev.image = scaledImage;
        }];
       
    }else{

        if (fileModel.image) {
            self.imagev.image = fileModel.image;
        }else {
            [self.imagev sd_setImageWithURL:[NSURL URLWithString:[fileModel.imgUrl stringByAppendingString:@"?x-oss-process=image/resize,m_fill,h_180,w_180"]]];
        }
        
    }
}


- (UIImage *)imageWithColor:(UIColor *)color
{
    return [UIImage imageWithColor:color size:CGSizeMake(1, 1)];
}

-(void)setObserve{
    
    NSLog(@"%ld",self.tag);
    [_msgKVO unobserveAll];
      if (!_msgKVO) {
          _msgKVO = [FBKVOController controllerWithObserver:self];
      }
    // observe clock date property
    __weak typeof(self) _self = self;
    ///进度添加观察
    [_msgKVO observe:self.fileModel keyPath:@"imageProgress" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
        __strong typeof(_self) self = _self;
        dispatch_async(dispatch_get_main_queue(), ^{
            JRLog(@"上传进度--%.1f",self.fileModel.imageProgress);
            self.circleView1.progress = self.fileModel.imageProgress;
            if (self.fileModel.uploadFail) {
                self.maskView.hidden = NO;
                self.circleView1.hidden = YES;
            }
        });
        
    }];
    
    ///url添加观察，根据是否存在url判断是否上传成功
    [_msgKVO observe:self.fileModel keyPath:@"imgUrl" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
        __strong typeof(_self) self = _self;
        dispatch_async(dispatch_get_main_queue(), ^{
            //处理播放按钮显示隐藏
            if (self.fileModel == nil) {
                self.maskView.hidden = YES;
                self.deleteButton.hidden = YES;
                self.playButton.hidden = YES;
                return;
            }
            if (self.fileModel.mediaType == 1 || self.fileModel.mediaType == nil) {
                if (self.fileModel.imgUrl.length > 0) {
                    self.maskView.hidden = YES;
                    self.playButton.hidden = YES;
                }else{
                    self.maskView.hidden = NO;
                    self.deleteButton.hidden = NO;
                    self.playButton.hidden = YES;
                }
            }else {
                if (self.fileModel.videoUrl.length>0) {
                    self.maskView.hidden = NO;
                    self.playButton.hidden = NO;
                    self.circleView1.alpha = 0;
                }else {
                    self.circleView1.alpha = 1;
                    self.maskView.hidden = NO;
                    self.deleteButton.hidden = NO;
                    self.playButton.hidden = YES;
                }
            }
        });
        
    }];
    
    ///观察是否上传失败
    [_msgKVO observe:self.fileModel keyPath:@"uploadFail" options:NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
        __strong typeof(_self) self = _self;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.fileModel.uploadFail) {
                self.deleteButton.hidden = NO;
                self.circleView1.hidden = YES;
                self.faildMaskView.hidden = NO;
            }else{
                self.faildMaskView.hidden = YES;
            }
        });
        
    }];
    
}

-(void)remove{
    if (_msgKVO) {
        [_msgKVO unobserveAll];
    }
}

-(void)getSmallImage:(UIImage *)image  localPath:(NSString *)localPath imageName:(NSString *)imageName imageUrl:(NSString *)imageUrl imageViewSize:(CGSize)imageViewSize complete:(void (^)(UIImage * scaledImage))complete{
    if (localPath) {
        
        CGSize imageViewSize =  CGSizeMake(85 * ScreensScale, 85 * ScreensScale);
        @autoreleasepool {
          
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
              
                UIImage * scaledImage = [image getSmallImage:imageViewSize andImageData:nil andURL:[NSURL fileURLWithPath:localPath]];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    complete(scaledImage);
                    [[SDImageCache sharedImageCache] storeImage:scaledImage forKey:imageName completion:nil];
                });
                
            });
        }
    }else{
        
        [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:[imageUrl urlencodeString]] options:SDWebImageAvoidDecodeImage | SDWebImageDownloaderScaleDownLargeImages | SDWebImageDownloaderHighPriority progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
            @autoreleasepool {
                CGSize imageViewSize =  CGSizeMake(85 * ScreensScale, 85 * ScreensScale);
               
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    UIImage * scaledImage = [image getSmallImage:imageViewSize andImageData:data andURL:imageURL];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (scaledImage) {
                            complete(scaledImage);
                            [[SDImageCache sharedImageCache] storeImage:scaledImage forKey:imageName completion:nil];
                        }
                        
                    });
                    
                });
            }
        }];
    }
}
#pragma mark - lazy Method
- (UIImageView *)imagev{
    if (!_imagev) {
        self.imagev = [[UIImageView alloc] initWithFrame:self.bounds];
    }
    return _imagev;
}
- (UIButton *)deleteButton{
    if (!_deleteButton) {
        self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteButton.frame = CGRectMake(CGRectGetWidth(self.bounds)-12,-5, 16, 16);
        [_deleteButton setBackgroundImage:[JRUIHelper imageNamed:@"bg_edit_close_one_jr"] forState:UIControlStateNormal];
    }
    return _deleteButton;
}

- (UIButton *)playButton{
    if (!_playButton) {
        self.playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _playButton.frame = CGRectMake((CGRectGetWidth(self.bounds)-29)/2,(CGRectGetHeight(self.bounds)-29)/2, 29, 29);
        _playButton.userInteractionEnabled = NO;
        [_playButton setImage:[JRUIHelper imageNamed:@"i_play_big_talk"] forState:UIControlStateNormal];
    }
    return _playButton;
}
- (UIView *)faildMaskView {
    if (!_faildMaskView) {
        _faildMaskView = [[UIView alloc]initWithFrame:self.bounds];
        _faildMaskView.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.5];
        _faildMaskView.layer.cornerRadius = 5;
    }
    return _faildMaskView;
}

- (void)dealloc
{
     [self remove];
}


@end
