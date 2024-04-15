//
//  JRVideoPreviewCell.h
//  JRPodPrivate_Example
//
//  Created by 金煜祥 on 2020/9/26.
//  Copyright © 2020 wni. All rights reserved.
//
#import "JRUIKit.h"
NS_ASSUME_NONNULL_BEGIN
typedef void(^LayoutWarningView)(UIView *warningView);
@interface JRVideoPreviewCell : TZVideoPreviewCell
@property (assign,nonatomic)BOOL jrIsShowWarning;
@property (copy,nonatomic)LayoutWarningView layoutWarningView;
@property (strong,nonatomic)UIView * warningView;
@end

NS_ASSUME_NONNULL_END
