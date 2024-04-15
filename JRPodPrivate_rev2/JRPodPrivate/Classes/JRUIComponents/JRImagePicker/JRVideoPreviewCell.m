//
//  JRVideoPreviewCell.m
//  JRPodPrivate_Example
//
//  Created by 金煜祥 on 2020/9/26.
//  Copyright © 2020 wni. All rights reserved.
//

#import "JRVideoPreviewCell.h"
#define TipViewTag 1000
#define WarningLabelTag 1001

@implementation JRVideoPreviewCell
- (void)configPlayButton {
    
    if (self.playButton) {
        [self.playButton removeFromSuperview];
    }
    self.playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.playButton setImage:[JRUIHelper imageNamed:@"jr_photo_preview_playbutton"] forState:UIControlStateNormal];
//    [self.playButton setImage:[JRUIHelper imageNamed:@"jr_photo_preview_playbutton"] forState:UIControlStateHighlighted];
    [self.playButton addTarget:self action:@selector(playButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.playButton];
    [self addSubview:self.iCloudErrorIcon];
    [self addSubview:self.iCloudErrorLabel];
    [self bringSubviewToFront:_warningView];
}

- (void)playButtonClick {
    CMTime currentTime = self.player.currentItem.currentTime;
    CMTime durationTime = self.player.currentItem.duration;
    if (self.player.rate == 0.0f) {
        if (currentTime.value == durationTime.value) [self.player.currentItem seekToTime:CMTimeMake(0, 1)];
        [self.player play];
        [self.playButton setImage:nil forState:UIControlStateNormal];
        [UIApplication sharedApplication].statusBarHidden = YES;
        self.warningView.hidden = YES;
        if (self.singleTapGestureBlock) {
            self.singleTapGestureBlock();
        }
    } else {
        self.warningView.hidden = !self.jrIsShowWarning;
        [self pausePlayerAndShowNaviBar];
    }
}

- (void)pausePlayerAndShowNaviBar {
    [self.player pause];
     [self.playButton setImage:[JRUIHelper imageNamed:@"jr_photo_preview_playbutton"] forState:UIControlStateNormal];
    if (self.singleTapGestureBlock) {
        self.singleTapGestureBlock();
    }
}

@end
