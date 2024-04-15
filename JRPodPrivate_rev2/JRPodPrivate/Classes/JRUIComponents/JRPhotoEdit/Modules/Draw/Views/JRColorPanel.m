//
//  WBGColorPanel.m
//  ZMJImageEditor_Example
//
//  Created by minqin on 2019/5/7.
//  Copyright © 2019 keshiim. All rights reserved.
//

#import "JRColorPanel.h"
#import "JRColorfullButton.h"
#import "JRImageEditor.h"

NSString * const kColorPanNotificaiton = @"kColorPanNotificaiton";

@interface JRColorPanel ()
@property (strong, nonatomic) UIColor *currentColor;
@property (weak, nonatomic) IBOutlet JRColorfullButton *redButton;
//@property (weak, nonatomic) IBOutlet JRColorfullButton *whiteButton;
//@property (weak, nonatomic) IBOutlet JRColorfullButton *yellowButton;
//@property (weak, nonatomic) IBOutlet JRColorfullButton *greenButton;
//@property (weak, nonatomic) IBOutlet JRColorfullButton *blueButton;
@property (weak, nonatomic) IBOutlet JRColorfullButton *pinkButton;

@property (weak, nonatomic) IBOutlet JRColorfullButton *purpleButton;

@property (weak, nonatomic) IBOutlet JRColorfullButton *blueButton;

@property (weak, nonatomic) IBOutlet JRColorfullButton *greenButton;

@property (weak, nonatomic) IBOutlet JRColorfullButton *yellowButton;

@property (weak, nonatomic) IBOutlet JRColorfullButton *blackButton;

@property (weak, nonatomic) IBOutlet JRColorfullButton *whiteButton;

@property (strong, nonatomic) IBOutletCollection(JRColorfullButton) NSArray *colorButtons;


@end

@implementation JRColorPanel

+ (CGFloat)fixedHeight
{
    return 50;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.5];
    [self.backButton setImage:[JRUIHelper imageNamed:@"i_return_big_nor"] forState:UIControlStateNormal];
    self.backButton.alpha = 0.5;
    self.redButton.isUse = YES;
}

- (UIColor *)currentColor
{
    if (_currentColor == nil) {
        _currentColor = self.redButton.color;//([self.dataSource respondsToSelector:@selector(imageEditorDefaultColor)] && [self.dataSource imageEditorDefaultColor]) ? [self.dataSource imageEditorDefaultColor] : self.redButton.color;
    }
    return _currentColor;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)panSelectColor:(UIPanGestureRecognizer *)recognizer
{
    NSLog(@"recon = %@", NSStringFromCGPoint([recognizer translationInView:self]));
}

- (IBAction)buttonAction:(UIButton *)sender
{
    JRColorfullButton *theBtns = (JRColorfullButton *)sender;
    
    for (JRColorfullButton *button in _colorButtons) {
        if (button == theBtns) {
            button.isUse = YES;
            self.currentColor = theBtns.color;
            [[NSNotificationCenter defaultCenter] postNotificationName:kColorPanNotificaiton object:self.currentColor];
        } else {
            button.isUse = NO;
        }
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    NSLog(@"point: %@", NSStringFromCGPoint([touch locationInView:self]));
    NSLog(@"view=%@", touch.view);
    CGPoint touchPoint = [touch locationInView:self];
    for (JRColorfullButton *button in _colorButtons) {
        CGRect rect = [button convertRect:button.bounds toView:self];
        if (CGRectContainsPoint(rect, touchPoint) && button.isUse == NO) {
            [self buttonAction:button];
        }
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    //NSLog(@"move->point: %@", NSStringFromCGPoint([touch locationInView:self]));
    CGPoint touchPoint = [touch locationInView:self];
    
    for (JRColorfullButton *button in _colorButtons) {
        CGRect rect = [button convertRect:button.bounds toView:self];
        if (CGRectContainsPoint(rect, touchPoint) && button.isUse == NO) {
            [self buttonAction:button];
        }
    }
}

- (IBAction)onUndoButtonTapped:(UIButton *)sender
{
    if (self.undoButtonTappedBlock)
    {
        self.undoButtonTappedBlock();
    }
}
@end
