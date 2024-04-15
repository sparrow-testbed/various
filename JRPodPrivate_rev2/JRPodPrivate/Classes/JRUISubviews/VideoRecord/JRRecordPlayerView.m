/**
 * 所属系统: TIM
 * 所属模块: 聊天类：录制视频
 * 功能描述: 自定义视频预览界面
 * 创建时间: 2019/9/16.
 * 维护人:  石拓
 * Copyright @ Jerrisoft 2019. All rights reserved.
 *┌─────────────────────────────────────────────────────┐
 *│ 此技术信息为本公司机密信息，未经本公司书面同意禁止向第三方披露．│
 *│ 版权所有：杰人软件(深圳)有限公司                          │
 *└─────────────────────────────────────────────────────┘
 */

#import "JRRecordPlayerView.h"
#import "JRUIKit.h"
@interface JRRecordPlayerView()

/**
 播放器图层
 */
@property (nonatomic, strong) CALayer *playerLayer;

/**
 播放器对象
 */
@property (nonatomic, strong) AVPlayer *player;

/**
 取消按钮
 */
@property (nonatomic, strong) UIButton *cancelButton;

/**
 确认按钮
 */
@property (nonatomic, strong) UIButton *confirmButton;

@end

@implementation JRRecordPlayerView

/**
 @desc 播放器图层创建
 @author Scott
 @date 2019/9/16
 @return 返回播放器图层对象
 */
- (CALayer *)playerLayer {
    
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    playerLayer.frame = [UIScreen mainScreen].bounds;
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    return playerLayer;
}

/**
 @desc 播放器按钮
 @author Scott
 @date 2019/9/16
 */
- (void)playerButtons {
    CGFloat topMaskViewHeight = 127;
    CGFloat bottomMaskViewHeight = 261;
    UIView * topMaskView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, topMaskViewHeight)];
    topMaskView.backgroundColor = [UIColor jk_gradientFromColor:[UIColor jk_colorWithHex:0x000000 andAlpha:0.4] toColor:[UIColor jk_colorWithHex:0x000000 andAlpha:0] withHeight:topMaskViewHeight];
    UIView * bottomMaskView = [[UIView alloc]initWithFrame:CGRectMake(0, self.height-bottomMaskViewHeight, self.width, bottomMaskViewHeight)];
    bottomMaskView.backgroundColor = [UIColor jk_gradientFromColor:[UIColor jk_colorWithHex:0x000000 andAlpha:0] toColor:[UIColor jk_colorWithHex:0x000000 andAlpha:0.4] withHeight:bottomMaskViewHeight];
    //上下朦板
    [self addSubview:topMaskView];
    [self addSubview:bottomMaskView];
    
    _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    _cancelButton.frame = CGRectMake(16, StateHeight+18, 40, 20);
    
     [_cancelButton setTitle:@"重拍" forState:UIControlStateNormal];
 
    _cancelButton.titleLabel.font = [UIFont systemFontOfSize:18];
    _cancelButton.titleLabel.textColor = [UIColor jk_colorWithHexString:@"#FFFFFF"];
    [_cancelButton addTarget:self action:@selector(clickCancel) forControlEvents:UIControlEventTouchUpInside];
    
    _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [_confirmButton setBackgroundImage:[JRUIHelper imageNamed:@"record_video_confirm"] forState:UIControlStateNormal];
    _confirmButton.frame = CGRectMake(self.width - 84-16, self.height-9-BottomHeight-32, 84, 32);
    _confirmButton.backgroundColor = [UIColor jk_colorWithHexString:@"#0EA856"];
    [_confirmButton setTitle:@"发送" forState:UIControlStateNormal];
    if (self.confirmTitle.length>0) {
        [_confirmButton setTitle:self.confirmTitle forState:UIControlStateNormal];
    }
    [_confirmButton jk_setRoundedCorners:UIRectCornerAllCorners radius:2];
    _confirmButton.titleLabel.font = [UIFont systemFontOfSize:14];
    _confirmButton.titleLabel.textColor = [UIColor jk_colorWithHexString:@"#FFFFFF"];
    [_confirmButton addTarget:self action:@selector(clickConfirm) forControlEvents:UIControlEventTouchUpInside];
    
    
    _cancelButton.alpha = 0;
    _confirmButton.alpha = 0;
    [self addSubview:_confirmButton];
    [self addSubview:_cancelButton];
}

/// @desc 确定事件
/// @author Scott
/// @date 2019/9/21
- (void)clickConfirm {
    
    if (self.confirmBlock) {
        self.confirmBlock();
    }
    
    [self.player pause];
    [self removeFromSuperview];
}

- (void)clickCancel {
    
    if (self.cancelBlock) {
        self.cancelBlock();
    }
    [self.player pause];
    [self removeFromSuperview];
}

- (void)showPlayerButtons {
   
    [UIView animateWithDuration:0.2 animations:^{
        _confirmButton.alpha = 1;
        _cancelButton.alpha = 1;
    }];
    
   
}


/**
 @desc 设置播放路径
 @author Scott
 @date 2019/9/16
 @param playUrl 播放路径参数
 */
- (void)setPlayUrl:(NSURL *)playUrl {
    
    _playUrl = playUrl;
    
    if (!self.player) {
        
        AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:self.playUrl];
        _player = [AVPlayer playerWithPlayerItem:playerItem];
        [self addObserverToPlayerItem:playerItem];
    }
    
    [self.layer addSublayer:self.playerLayer];
    
    if (!_confirmButton) {
        [self playerButtons];
    }
    
    [self showPlayerButtons];
    [self.player play];
}

- (void)playbackFinished:(NSNotification *)notification {
    
    [self.player seekToTime:kCMTimeZero];
    [self.player play];
}

- (void)addObserverToPlayerItem:(AVPlayerItem *)playerItem {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:playerItem];
}

- (void)dealloc {
    [self.player pause];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)configChatVideoPlay {
    self.cancelButton.hidden = YES;
    self.confirmButton.hidden = YES;
    [self.cancelButton removeFromSuperview];
    [self.confirmButton removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
