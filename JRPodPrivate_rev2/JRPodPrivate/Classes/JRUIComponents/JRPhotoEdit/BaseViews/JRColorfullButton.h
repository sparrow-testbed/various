//
//  colorfullButton.h
//  CLImageEditorDemo
//
//  Created by Jason on 2017/2/27.
//  Copyright © 2017年 CALACULU. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface JRColorfullButton : UIButton
@property (nonatomic, assign) IBInspectable CGFloat radius;
@property (nonatomic, strong) IBInspectable UIColor *color;
@property (nonatomic, assign) BOOL isUse;

@end
