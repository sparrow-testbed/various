//
//  TOCropViewController.h
//
//  Copyright 2015-2017 Timothy Oliver. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to
//  deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
//  OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR
//  IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "TOCropViewController.h"
#import "TOCropViewControllerTransitioning.h"
#import "TOActivityCroppedImageProvider.h"
#import "UIImage+CropRotate.h"
#import "TOCroppedImageAttributes.h"
#import <extobjc/extobjc.h>
#import "TOCropView+CorrectView.h"
#import "UIImage+JKFXImage.h"

@interface TOCropViewController () <UIActionSheetDelegate, UIViewControllerTransitioningDelegate, TOCropViewDelegate>

/* The target image */
@property (nonatomic, readwrite) UIImage *image;

/* The cropping style of the crop view */
@property (nonatomic, assign, readwrite) TOCropViewCroppingStyle croppingStyle;

/* Views */
@property (nonatomic, strong) TOCropToolbar *toolbar;
@property (nonatomic, strong) CALayer *toolbarBgLayer;
@property (nonatomic, strong, readwrite) TOCropView *cropView;
@property (nonatomic, strong) UIView *toolbarSnapshotView;

/* Transition animation controller */
@property (nonatomic, copy) void (^prepareForTransitionHandler)(void);
@property (nonatomic, strong) TOCropViewControllerTransitioning *transitionController;
@property (nonatomic, assign) BOOL inTransition;
@property (nonatomic, assign) BOOL initialLayout;

/* If pushed from a navigation controller, the visibility of that controller's bars. */
@property (nonatomic, assign) BOOL navigationBarHidden;
@property (nonatomic, assign) BOOL toolbarHidden;
/* Flag to perform initial setup on the first run */
@property (nonatomic, assign) BOOL firstTime;

/* On iOS 7, the popover view controller that appears when tapping 'Done' */
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
@property (nonatomic, strong) UIPopoverController *activityPopoverController;
#pragma clang diagnostic pop

/* Button callback */
- (void)cancelButtonTapped;
- (void)doneButtonTapped;
- (void)showAspectRatioDialog;
- (void)resetCropViewLayout;
// - (void)rotateCropViewClockwise;
// - (void)rotateCropViewCounterclockwise;

/* View layout */
- (CGRect)frameForToolBarWithVerticalLayout:(BOOL)verticalLayout;
- (CGRect)frameForCropViewWithVerticalLayout:(BOOL)verticalLayout;

@end

@implementation TOCropViewController

- (instancetype)initWithCroppingStyle:(TOCropViewCroppingStyle)style image:(UIImage *)image
{
    // NSParameterAssert(image);

    self = [super init];
    if (self) {
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        self.modalPresentationStyle = UIModalPresentationFullScreen;
        self.automaticallyAdjustsScrollViewInsets = NO;
        
        _transitionController = [[TOCropViewControllerTransitioning alloc] init];
        _image = image;
        _croppingStyle = style;
        
        _aspectRatioPreset = TOCropViewControllerAspectRatioPresetOriginal;
        _toolbarPosition = TOCropViewControllerToolbarPositionBottom;
        _rotateClockwiseButtonHidden = YES;
    }
    
    return self;
}

- (instancetype)initWithImage:(UIImage *)image
{
    return [self initWithCroppingStyle:TOCropViewCroppingStyleDefault image:image];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    BOOL circularMode = (self.croppingStyle == TOCropViewCroppingStyleCircular);

    self.cropView.frame = [self frameForCropViewWithVerticalLayout:CGRectGetWidth(self.view.bounds) < CGRectGetHeight(self.view.bounds)];
    [self.view addSubview:self.cropView];
    
    self.toolbarBgLayer = [CALayer layer];
    self.toolbarBgLayer.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7f].CGColor;
    [self.view.layer addSublayer:self.toolbarBgLayer];
    
    self.toolbar.frame = [self frameForToolBarWithVerticalLayout:CGRectGetWidth(self.view.bounds) < CGRectGetHeight(self.view.bounds)];
    self.toolbar.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.9];
    [self.view addSubview:self.toolbar];
    
    @weakify(self);
    self.toolbar.doneButtonTapped =     ^{ @strongify(self); [self doneButtonTapped]; };
    self.toolbar.cancelButtonTapped =   ^{ @strongify(self); [self cancelButtonTapped]; };
    
    self.toolbar.resetButtonTapped =    ^{ @strongify(self); [self resetCropViewLayout]; };
    self.toolbar.resetCorrectButtonTapped = ^(UIButton * _Nullable sender) {
        @strongify(self);
        sender.enabled = NO;
        [self resetCropViewLayout];
    };
    self.toolbar.clampButtonTapped =    ^{ @strongify(self); [self showAspectRatioDialog]; };
    
    self.toolbar.rotateCounterclockwiseButtonTapped = ^{ @strongify(self); [self rotateCropViewCounter]; };
    self.toolbar.rotateClockwiseButtonTapped        = ^{ @strongify(self); [self rotateCropView]; };
    
    self.toolbar.clampButtonHidden = self.aspectRatioPickerButtonHidden || circularMode;
    self.toolbar.rotateClockwiseButtonHidden = self.rotateClockwiseButtonHidden && !circularMode;
    
    self.transitioningDelegate = self;
    self.view.backgroundColor = self.cropView.backgroundColor;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (animated) {
        self.inTransition = YES;
        [self setNeedsStatusBarAppearanceUpdate];
    }
    
    if (self.navigationController) {
        self.navigationBarHidden = self.navigationController.navigationBarHidden;
        self.toolbarHidden = self.navigationController.toolbarHidden;
        
        [self.navigationController setNavigationBarHidden:YES animated:animated];
        [self.navigationController setToolbarHidden:YES animated:animated];
        
        self.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    }
    else {
        [self.cropView setBackgroundImageViewHidden:YES animated:NO];
    }

    if (self.aspectRatioPreset != TOCropViewControllerAspectRatioPresetOriginal) {
        [self setAspectRatioPreset:self.aspectRatioPreset animated:NO];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.inTransition = NO;
    self.cropView.simpleRenderMode = NO;
    if (animated && [UIApplication sharedApplication].statusBarHidden == NO) {
        [UIView animateWithDuration:0.3f animations:^{ [self setNeedsStatusBarAppearanceUpdate]; }];
        
        if (self.cropView.gridOverlayHidden) {
            [self.cropView setGridOverlayHidden:NO animated:YES];
        }
        
        if (self.navigationController == nil) {
            [self.cropView setBackgroundImageViewHidden:NO animated:YES];
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.inTransition = YES;
    [UIView animateWithDuration:0.5f animations:^{ [self setNeedsStatusBarAppearanceUpdate]; }];
    
    if (self.navigationController) {
        [self.navigationController setNavigationBarHidden:self.navigationBarHidden animated:animated];
        [self.navigationController setToolbarHidden:self.toolbarHidden animated:animated];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.inTransition = NO;
    [self setNeedsStatusBarAppearanceUpdate];
}

#pragma mark - Status Bar -
- (UIStatusBarStyle)preferredStatusBarStyle
{
    if (self.navigationController) {
        return UIStatusBarStyleLightContent;
    }
    
    
    if (@available(iOS 13.0, *)) {
        return UIStatusBarStyleDarkContent;
    } else {
        return UIStatusBarStyleDefault;
    }
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (CGRect)frameForToolBarWithVerticalLayout:(BOOL)verticalLayout
{
    CGRect frame = CGRectZero;
    if (!verticalLayout)
    {
        frame.origin.x = 0.0f;
        frame.origin.y = 0.0f;
        frame.size.width = 44.0f + 54;
        frame.size.height = CGRectGetHeight(self.view.frame);
    }
    else
    {
        frame.origin.x = 0.0f;
        UIEdgeInsets edge = UIEdgeInsetsZero;
        if (@available(iOS 11.0, *))
        {
            edge = [[[UIApplication sharedApplication] keyWindow] safeAreaInsets];
        }
        
        if (self.toolbarPosition == TOCropViewControllerToolbarPositionBottom)
        {
            frame.size.height = 44.0f + 54 + edge.bottom;
            frame.origin.y = CGRectGetHeight(self.view.bounds) - frame.size.height;
        }
        else
        {
            frame.origin.y = 0;
            frame.size.height = 44.0f + 54 + edge.top;
        }
        
        frame.size.width = CGRectGetWidth(self.view.bounds);
        
        // If the bar is at the top of the screen and the status bar is visible, account for the status bar height
        if (self.toolbarPosition == TOCropViewControllerToolbarPositionTop && self.prefersStatusBarHidden == NO) {
            frame.size.height = 64.0f + 54;
        }
    }
    
    return frame;
}

- (CGRect)frameForCropViewWithVerticalLayout:(BOOL)verticalLayout
{
    //On an iPad, if being presented in a modal view controller by a UINavigationController,
    //at the time we need it, the size of our view will be incorrect.
    //If this is the case, derive our view size from our parent view controller instead
    
    CGRect bounds = CGRectZero;
    if (self.parentViewController == nil) {
        bounds = self.view.bounds;
    }
    else {
        bounds = self.parentViewController.view.bounds;
    }
    
    CGRect frame = CGRectZero;
    if (!verticalLayout)
    {
        frame.origin.x = 44.0f;
        frame.origin.y = 0.0f;
        frame.size.width = CGRectGetWidth(bounds) - 44.0f;
        frame.size.height = CGRectGetHeight(bounds);
    }
    else
    {
        frame.origin.x = 0.0f;
        UIEdgeInsets edge = UIEdgeInsetsZero;
        if (@available(iOS 11.0, *))
        {
            edge = [[[UIApplication sharedApplication] keyWindow] safeAreaInsets];
        }
        
        if (_toolbarPosition == TOCropViewControllerToolbarPositionBottom)
        {
            frame.origin.y = 0.0f + edge.top;
            frame.size.height = CGRectGetHeight(bounds) - 44.0f - 54 - edge.bottom;
        }
        else
        {
            frame.origin.y = 44.0f + edge.top;
            frame.size.height = CGRectGetHeight(bounds) - 44.0f - 54 - edge.bottom;
        }

        frame.size.width = CGRectGetWidth(bounds);
    }
    
    return frame;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    BOOL verticalLayout = CGRectGetWidth(self.view.bounds) < CGRectGetHeight(self.view.bounds);
    self.cropView.frame = [self frameForCropViewWithVerticalLayout:verticalLayout];
    [self.cropView moveCroppedContentToCenterAnimated:NO];
    
    
    [UIView performWithoutAnimation:^{
        self.toolbar.statusBarVisible = (self.toolbarPosition == TOCropViewControllerToolbarPositionTop && !self.prefersStatusBarHidden);
        self.toolbar.frame = [self frameForToolBarWithVerticalLayout:verticalLayout];
        self.toolbarBgLayer.frame = self.toolbar.frame;
        [self.toolbar setNeedsLayout];
    }];
}

#pragma mark - Rotation Handling -

//TODO: Deprecate iOS 7 properly at the right time
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    self.toolbarSnapshotView = [self.toolbar snapshotViewAfterScreenUpdates:NO];
    self.toolbarSnapshotView.frame = self.toolbar.frame;
    
    if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation))
        self.toolbarSnapshotView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    else
        self.toolbarSnapshotView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin;
    
    [self.view addSubview:self.toolbarSnapshotView];
    
    [UIView performWithoutAnimation:^{
        self.toolbar.frame = [self frameForToolBarWithVerticalLayout:UIInterfaceOrientationIsPortrait(toInterfaceOrientation)];
        self.toolbarBgLayer.frame = self.toolbar.frame;
        [self.toolbar layoutIfNeeded];
        self.toolbar.alpha = 0.0f;
    }];
    
    [self.cropView prepareforRotation];
    self.cropView.frame = [self frameForCropViewWithVerticalLayout:!UIInterfaceOrientationIsPortrait(toInterfaceOrientation)];
    self.cropView.simpleRenderMode = YES;
    self.cropView.internalLayoutDisabled = YES;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    //Remove all animations in the toolbar
    self.toolbar.frame = [self frameForToolBarWithVerticalLayout:!UIInterfaceOrientationIsLandscape(toInterfaceOrientation)];
    [self.toolbar.layer removeAllAnimations];
    for (CALayer *sublayer in self.toolbar.layer.sublayers) {
        [sublayer removeAllAnimations];
    }
    
    self.cropView.frame = [self frameForCropViewWithVerticalLayout:!UIInterfaceOrientationIsLandscape(toInterfaceOrientation)];
    [self.cropView performRelayoutForRotation];
    
    [UIView animateWithDuration:duration animations:^{
        self.toolbarSnapshotView.alpha = 0.0f;
        self.toolbar.alpha = 1.0f;
    }];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self.toolbarSnapshotView removeFromSuperview];
    self.toolbarSnapshotView = nil;
    
    [self.cropView setSimpleRenderMode:NO animated:YES];
    self.cropView.internalLayoutDisabled = NO;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    UIInterfaceOrientation orientation = UIInterfaceOrientationPortrait;
    CGSize currentSize = self.view.bounds.size;
    if (currentSize.width < size.width)
        orientation = UIInterfaceOrientationLandscapeLeft;
    
    [self willRotateToInterfaceOrientation:orientation duration:coordinator.transitionDuration];
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        [self willAnimateRotationToInterfaceOrientation:orientation duration:coordinator.transitionDuration];
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        [self didRotateFromInterfaceOrientation:orientation];
    }];
}
#pragma clang diagnostic pop

#pragma mark - Reset -
- (void)resetCropViewLayout
{
    BOOL animated = (self.cropView.angle == 0);
    
    if (self.resetAspectRatioEnabled) {
        self.aspectRatioLockEnabled = NO;
    }
    
    [self.cropView resetLayoutToDefaultAnimated:animated];
    
    
    
}

#pragma mark - Aspect Ratio Handling -
- (void)showAspectRatioDialog
{
    if (self.cropView.aspectRatioLockEnabled) {
        self.cropView.aspectRatioLockEnabled = NO;
        self.toolbar.clampButtonGlowing = NO;
        return;
    }
    
    //Depending on the shape of the image, work out if horizontal, or vertical options are required
    BOOL verticalCropBox = self.cropView.cropBoxAspectRatioIsPortrait;
    
    // In CocoaPods, strings are stored in a separate bundle from the main one
    NSBundle *resourceBundle = nil;
    NSBundle *classBundle = [NSBundle bundleForClass:[self class]];
    NSURL *resourceBundleURL = [classBundle URLForResource:@"TOCropViewControllerBundle" withExtension:@"bundle"];
    if (resourceBundleURL) {
        resourceBundle = [[NSBundle alloc] initWithURL:resourceBundleURL];
    }
    else {
        resourceBundle = classBundle;
    }
    
    //Prepare the localized options
    NSString *cancelButtonTitle = NSLocalizedStringFromTableInBundle(@"Cancel", @"TOCropViewControllerLocalizable", resourceBundle, nil);
    NSString *originalButtonTitle = NSLocalizedStringFromTableInBundle(@"Original", @"TOCropViewControllerLocalizable", resourceBundle, nil);
    NSString *squareButtonTitle = NSLocalizedStringFromTableInBundle(@"Square", @"TOCropViewControllerLocalizable", resourceBundle, nil);
    
    //Prepare the list that will be fed to the alert view/controller
    NSMutableArray *items = [NSMutableArray array];
    [items addObject:originalButtonTitle];
    [items addObject:squareButtonTitle];
    if (verticalCropBox) {
        [items addObjectsFromArray:@[@"2:3", @"3:5", @"3:4", @"4:5", @"5:7", @"9:16"]];
    }
    else {
        [items addObjectsFromArray:@[@"3:2", @"5:3", @"4:3", @"5:4", @"7:5", @"16:9"]];
    }
    
    //Present via a UIAlertController if >= iOS 8
    if (NSClassFromString(@"UIAlertController")) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        [alertController addAction:[UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:nil]];
        
        //Add each item to the alert controller
        NSInteger i = 0;
        for (NSString *item in items) {
            UIAlertAction *action = [UIAlertAction actionWithTitle:item style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self setAspectRatioPreset:(TOCropViewControllerAspectRatioPreset)i animated:YES];
                self.aspectRatioLockEnabled = YES;
            }];
            [alertController addAction:action];
            
            i++;
        }
        
        alertController.modalPresentationStyle = UIModalPresentationPopover;
        UIPopoverPresentationController *presentationController = [alertController popoverPresentationController];
        presentationController.sourceView = self.toolbar;
        presentationController.sourceRect = self.toolbar.clampButtonFrame;
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else {
    //TODO: Completely overhaul this once iOS 7 support is dropped
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                 delegate:self
                                                        cancelButtonTitle:cancelButtonTitle
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:nil];
        
        for (NSString *item in items) {
            [actionSheet addButtonWithTitle:item];
        }
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            [actionSheet showFromRect:self.toolbar.clampButtonFrame inView:self.toolbar animated:YES];
        else
            [actionSheet showInView:self.view];
#pragma clang diagnostic pop
    }
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [self setAspectRatioPreset:(TOCropViewControllerAspectRatioPreset)buttonIndex animated:YES];
    self.aspectRatioLockEnabled = YES;
}
#pragma clang diagnostic pop

- (void)setAspectRatioPreset:(TOCropViewControllerAspectRatioPreset)aspectRatioPreset animated:(BOOL)animated
{
    CGSize aspectRatio = CGSizeZero;
    
    _aspectRatioPreset = aspectRatioPreset;
    
    switch (aspectRatioPreset) {
        case TOCropViewControllerAspectRatioPresetOriginal:
            aspectRatio = CGSizeZero;
            break;
        case TOCropViewControllerAspectRatioPresetSquare:
            aspectRatio = CGSizeMake(1.0f, 1.0f);
            break;
        case TOCropViewControllerAspectRatioPreset3x2:
            aspectRatio = CGSizeMake(3.0f, 2.0f);
            break;
        case TOCropViewControllerAspectRatioPreset5x3:
            aspectRatio = CGSizeMake(5.0f, 3.0f);
            break;
        case TOCropViewControllerAspectRatioPreset4x3:
            aspectRatio = CGSizeMake(4.0f, 3.0f);
            break;
        case TOCropViewControllerAspectRatioPreset5x4:
            aspectRatio = CGSizeMake(5.0f, 4.0f);
            break;
        case TOCropViewControllerAspectRatioPreset7x5:
            aspectRatio = CGSizeMake(7.0f, 5.0f);
            break;
        case TOCropViewControllerAspectRatioPreset16x9:
            aspectRatio = CGSizeMake(16.0f, 9.0f);
            break;
        case TOCropViewControllerAspectRatioPresetCustom:
            aspectRatio = self.customAspectRatio;
            break;
    }
    
    //If the image is a portrait shape, flip the aspect ratio to match
    if (aspectRatioPreset != TOCropViewControllerAspectRatioPresetCustom &&
        self.cropView.cropBoxAspectRatioIsPortrait &&
        !self.aspectRatioLockEnabled)
    {
        CGFloat width = aspectRatio.width;
        aspectRatio.width = aspectRatio.height;
        aspectRatio.height = width;
    }
    
    [self.cropView setAspectRatio:aspectRatio animated:animated];
}

- (void)rotateCropView
{
    [self.cropView rotateImageNinetyDegreesAnimated:YES clockwise:NO];
}

- (void)rotateCropViewCounter
{
    [self.cropView rotateImageNinetyDegreesAnimated:YES clockwise:NO];
}

#pragma mark - Crop View Delegates -
- (void)cropView:(TOCropView *)cropView maskLayerDidChangeVisible:(BOOL)hidden
{
    [self.toolbarBgLayer setHidden:hidden];
}

- (void)cropViewDidBecomeResettable:(TOCropView *)cropView
{
    self.toolbar.resetButtonEnabled = YES;
    self.toolbar.doneButtonEnabled =  YES;

}

- (void)cropViewDidBecomeNonResettable:(TOCropView *)cropView
{
    self.toolbar.resetButtonEnabled = NO;
    self.toolbar.doneButtonEnabled = NO;
}

#pragma mark - Presentation Handling -
- (void)presentAnimatedFromParentViewController:(UIViewController *)viewController
                                       fromView:(UIView *)fromView
                                      fromFrame:(CGRect)fromFrame
                                          setup:(void (^)(void))setup
                                     completion:(void (^)(void))completion
{
    [self presentAnimatedFromParentViewController:viewController fromImage:nil fromView:fromView fromFrame:fromFrame
                                            angle:0 toImageFrame:CGRectZero setup:setup completion:nil];
}

- (void)presentAnimatedFromParentViewController:(UIViewController *)viewController
                                      fromImage:(UIImage *)image
                                       fromView:(UIView *)fromView
                                      fromFrame:(CGRect)fromFrame
                                          angle:(NSInteger)angle
                                   toImageFrame:(CGRect)toFrame
                                          setup:(void (^)(void))setup
                                     completion:(void (^)(void))completion
{
    self.transitionController.image     = image ? image : self.image;
    self.transitionController.fromFrame = fromFrame;
    self.transitionController.fromView  = fromView;
    self.prepareForTransitionHandler    = setup;
    
    if (self.angle != 0 || !CGRectIsEmpty(toFrame)) {
        self.angle = angle;
        self.imageCropFrame = toFrame;
    }
    
    @weakify(self);
    [viewController presentViewController:self animated:YES completion:^ {
        @strongify(self);
        if (completion) {
            completion();
        }
        
        [self.cropView setCroppingViewsHidden:NO animated:YES];
        if (!CGRectIsEmpty(fromFrame)) {
            [self.cropView setGridOverlayHidden:NO animated:YES];
        }
    }];
   // [self resetCropViewLayout];// 此方法导致旋转问题
}

- (void)dismissAnimatedFromParentViewController:(UIViewController *)viewController
                                         toView:(UIView *)toView
                                        toFrame:(CGRect)frame
                                          setup:(void (^)(void))setup
                                     completion:(void (^)(void))completion
{
    [self dismissAnimatedFromParentViewController:viewController withCroppedImage:nil toView:toView toFrame:frame setup:setup completion:completion];
}

- (void)dismissAnimatedFromParentViewController:(UIViewController *)viewController
                               withCroppedImage:(UIImage *)image
                                         toView:(UIView *)toView
                                        toFrame:(CGRect)frame
                                          setup:(void (^)(void))setup
                                     completion:(void (^)(void))completion
{
    // If a cropped image was supplied, use that, and only zoom out from the crop box
    if (image)
    {
        self.transitionController.image     = image ? image : self.image;
        self.transitionController.fromFrame = [self.cropView convertRect:self.cropView.cropBoxFrame toView:self.view];
    }
    else
    {   // else use the main image, and zoom out from its entirety
        self.transitionController.image     = self.image;
        self.transitionController.fromFrame = [self.cropView convertRect:self.cropView.imageViewFrame toView:self.view];
    }
    
    self.transitionController.toView    = toView;
    self.transitionController.toFrame   = frame;
    self.prepareForTransitionHandler    = setup;

    [viewController dismissViewControllerAnimated:YES completion:^ {
        if (completion) {
            completion();
        }
    }];
}

#pragma mark - UIViewControllerTransitioning
- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    if (self.navigationController || self.modalTransitionStyle == UIModalTransitionStyleCoverVertical) {
        return nil;
    }
    
    self.cropView.simpleRenderMode = YES;
    
    @weakify(self);
    self.transitionController.prepareForTransitionHandler = ^{
        @strongify(self);
        
        TOCropViewControllerTransitioning *transitioning = self.transitionController;
        
        transitioning.toFrame = [self.cropView convertRect:self.cropView.cropBoxFrame toView:self.view];
        if (!CGRectIsEmpty(transitioning.fromFrame) || transitioning.fromView) {
            self.cropView.croppingViewsHidden = YES;
        }

        if (self.prepareForTransitionHandler)
            self.prepareForTransitionHandler();
        
        self.prepareForTransitionHandler = nil;
    };
    
    self.transitionController.isDismissing = NO;
    return self.transitionController;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    if (self.navigationController || self.modalTransitionStyle == UIModalTransitionStyleCoverVertical) {
        return nil;
    }
    
    @weakify(self);
    self.transitionController.prepareForTransitionHandler = ^{
        @strongify(self);
        
        TOCropViewControllerTransitioning *transitioning = self.transitionController;
        
        if (!CGRectIsEmpty(transitioning.toFrame) || transitioning.toView)
            self.cropView.croppingViewsHidden = YES;
        else
            self.cropView.simpleRenderMode = YES;
        
        if (self.prepareForTransitionHandler)
            self.prepareForTransitionHandler();
    };
    
    self.transitionController.isDismissing = YES;
    return self.transitionController;
}

#pragma mark - Button Feedback -
- (void)cancelButtonTapped
{
    if ([self.delegate respondsToSelector:@selector(cropViewController:didFinishCancelled:)]) {
        [self.delegate cropViewController:self didFinishCancelled:YES];
        return;
    }
    
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        self.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)doneButtonTapped
{
    CGRect cropFrame = self.cropView.imageCropFrame;
    NSInteger angle = self.cropView.angle;

    //If desired, when the user taps done, show an activity sheet
    if (self.showActivitySheetOnDone) {
        TOActivityCroppedImageProvider *imageItem = [[TOActivityCroppedImageProvider alloc] initWithImage:self.image cropFrame:cropFrame angle:angle circular:(self.croppingStyle == TOCropViewCroppingStyleCircular)];
        TOCroppedImageAttributes *attributes = [[TOCroppedImageAttributes alloc] initWithCroppedFrame:cropFrame angle:angle originalImageSize:self.image.size];
        
        NSMutableArray *activityItems = [@[imageItem, attributes] mutableCopy];
        if (self.activityItems)
            [activityItems addObjectsFromArray:self.activityItems];
        
        UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:self.applicationActivities];
        activityController.excludedActivityTypes = self.excludedActivityTypes;
        
        if (NSClassFromString(@"UIPopoverPresentationController")) {
            activityController.modalPresentationStyle = UIModalPresentationPopover;
            activityController.popoverPresentationController.sourceView = self.toolbar;
            activityController.popoverPresentationController.sourceRect = self.toolbar.doneButtonFrame;
            [self presentViewController:activityController animated:YES completion:nil];
        }
        else {
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
                [self presentViewController:activityController animated:YES completion:nil];
            }
            else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                [self.activityPopoverController dismissPopoverAnimated:NO];
                self.activityPopoverController = [[UIPopoverController alloc] initWithContentViewController:activityController];
                [self.activityPopoverController presentPopoverFromRect:self.toolbar.doneButtonFrame inView:self.toolbar permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
#pragma clang diagnostic pop
            }
        }
        __weak UIActivityViewController *blockController = activityController;
        #if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
        activityController.completionWithItemsHandler = ^(NSString *activityType, BOOL completed, NSArray *returnedItems, NSError *activityError) {
            if (!completed)
                return;
            
            if ([self.delegate respondsToSelector:@selector(cropViewController:didFinishCancelled:)]) {
                [self.delegate cropViewController:self didFinishCancelled:NO];
            }
            else {
                [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
                blockController.completionWithItemsHandler = nil;
            }
        };
        #else
        activityController.completionHandler = ^(NSString *activityType, BOOL completed) {
            if (!completed)
                return;
            
            if ([self.delegate respondsToSelector:@selector(cropViewController:didFinishCancelled:)]) {
                [self.delegate cropViewController:self didFinishCancelled:NO];
            }
            else {
                [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
                blockController.completionHandler = nil;
            }
        };
        #endif
        
        return;
    }

    BOOL delegateHandled = NO;

    //If the delegate that only supplies crop data is provided, call it
    if ([self.delegate respondsToSelector:@selector(cropViewController:didCropImageToRect:angle:)]) {
        [self.delegate cropViewController:self didCropImageToRect:cropFrame angle:angle];
        delegateHandled = YES;
    }

    //If cropping circular and the circular generation delegate is implemented, call it
    if (self.croppingStyle == TOCropViewCroppingStyleCircular && [self.delegate respondsToSelector:@selector(cropViewController:didCropToCircularImage:withRect:angle:)]) {
        UIImage *image = [self.image croppedImageWithFrame:cropFrame angle:angle circularClip:YES];
        
        //dispatch on the next run-loop so the animation isn't interuppted by the crop operation
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.03f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.delegate cropViewController:self didCropToCircularImage:image withRect:cropFrame angle:angle];
        });

        delegateHandled = YES;
    }
    
    if (self.cropView.topRightControl) {
        //If the delegate that requires the specific cropped image is  for 矫正裁剪
        if ([self.delegate respondsToSelector:@selector(cropViewController:didCropCorrectToImage:withRect:angle:)]) {
            UIImage *image = self.image;
            //进行校正裁剪
            image =  [self cropViewCorrect];
//            image = [self produce];// 原生采集矫正过的图片
            
            //dispatch on the next run-loop so the animation isn't interuppted by the crop operation
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.03f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.delegate cropViewController:self didCropCorrectToImage:image withRect:cropFrame angle:angle];
            });
            
            delegateHandled = YES;
        }
    }else {
        //If the delegate that requires the specific cropped image is provided, call it
        if ([self.delegate respondsToSelector:@selector(cropViewController:didCropToImage:withRect:angle:)]) {
            UIImage *image = nil;
            if (angle == 0 && CGRectEqualToRect(cropFrame, (CGRect){CGPointZero, self.image.size})) {
                image = self.image;
            }else {
                image = [self.image croppedImageWithFrame:cropFrame angle:angle circularClip:NO];
            }
      
            //dispatch on the next run-loop so the animation isn't interuppted by the crop operation
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.03f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.delegate cropViewController:self didCropToImage:image withRect:cropFrame angle:angle];
            });

            delegateHandled = YES;
        }
    }

    if (!delegateHandled) {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}
//进行校正后裁剪
- (UIImage *)cropViewCorrect {
    self.cropView.gridOverlayView.alpha = 0;
    self.cropView.topLeftControl.alpha = 0;
    self.cropView.topRightControl.alpha = 0;
    self.cropView.bottomLeftControl.alpha = 0;
    self.cropView.bottomRightControl.alpha = 0;
    
    UIImage *testImage = [self doScreenShot:self.cropView];
    CGRect rectTest = CGRectMake(self.cropView.cropBoxFrame.origin.x, self.cropView.cropBoxFrame.origin.y+58, self.cropView.cropBoxFrame.size.width, self.cropView.cropBoxFrame.size.height-48);

    UIImage * resultImage =  [self clicpViewWithRect:rectTest withImage:testImage];
//    UIImage * resultImage =  [self clicpImageViewWithRect:self.cropView.foregroundContainerView.frame withImage:testImage];

    return resultImage;
}

// 采集原始矫正结果
- (UIImage *)produce
{
    UIImage *image = self.cropView.foregroundImageView.image;

    AGKQuad quad;
    quad.tl.x = AGKRemap(self.cropView.topLeftPoint.x, 0, self.cropView.foregroundContainerView.boundsWidth/100, 0, self.cropView.foregroundContainerView.boundsWidth/100);
    
    quad.tl.y = AGKRemap(self.cropView.topLeftPoint.y, 0, self.cropView.foregroundContainerView.boundsHeight/100, 0, self.cropView.foregroundContainerView.boundsHeight/100);
    quad.tr.x = AGKRemap(self.cropView.topRightPoint.x, 0, self.cropView.foregroundContainerView.boundsWidth/100, 0, self.cropView.foregroundContainerView.boundsWidth/100);
    quad.tr.y = AGKRemap(self.cropView.topRightPoint.y, 0, self.cropView.foregroundContainerView.boundsHeight/100, 0, self.cropView.foregroundContainerView.boundsHeight/100);
    quad.bl.x = AGKRemap(self.cropView.bottomLeftPoint.x, 0, self.cropView.foregroundContainerView.boundsWidth/100, 0, self.cropView.foregroundContainerView.boundsWidth/100);
    quad.bl.y = AGKRemap(self.cropView.bottomLeftPoint.y, 0, self.cropView.foregroundContainerView.boundsHeight/100, 0, self.cropView.foregroundContainerView.boundsWidth/100);
    quad.br.x = AGKRemap(self.cropView.bottomRightPoint.x, 0, self.cropView.foregroundContainerView.boundsWidth/100, 0, self.cropView.foregroundContainerView.boundsWidth/100);
    quad.br.y = AGKRemap(self.cropView.bottomRightPoint.y, 0, self.cropView.foregroundContainerView.boundsHeight/100, 0, self.cropView.foregroundContainerView.boundsHeight/100);

    return  [self cropImage:image toQuad:quad];
}

- (UIImage *)cropImage:(UIImage *)image toQuad:(AGKQuad)quad
{
    UIImage *result = [image imageByCroppingToQuad:quad destinationSize:self.cropView.foregroundContainerView.bounds.size];

    return result;
}
//返回裁剪区域图片2
-(UIImage*)clicpImageViewWithRect:(CGRect)aRect withImage:(UIImage *)cropImage{
    UIImage *result = [cropImage imageByCroppingToRect:aRect];
    return result;
}

//返回裁剪区域图片
-(UIImage*)clicpViewWithRect:(CGRect)aRect withImage:(UIImage *)cropImage{
    
    CGFloat scale = [UIScreen mainScreen].scale;
    aRect.origin.x*= scale;
    aRect.origin.y*= scale;
    aRect.size.width*= scale;
    aRect.size.height*= scale;

    UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.cropView.cropBoxFrame.size.width, self.cropView.cropBoxFrame.size.height), YES, scale);//-98
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = cropImage;
    UIGraphicsEndImageContext();
    CGImageRef imageRef = viewImage.CGImage;
    CGImageRef imageRefRect = CGImageCreateWithImageInRect(imageRef, aRect);

    UIImage *finishImage = [[UIImage alloc]initWithCGImage:imageRefRect];
    return finishImage;

}

#pragma mark -
- (UIImage *)doScreenShot:(UIView *)currentView{
    // 开启图片上下文
    UIGraphicsBeginImageContextWithOptions(currentView.bounds.size, NO, 0);
    // 获取当前上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    // 截图:实际是把layer上面的东西绘制到上下文中
    [self.view.layer renderInContext:ctx];
    //iOS7+ 推荐使用的方法，代替上述方法
     [self.view drawViewHierarchyInRect:currentView.frame afterScreenUpdates:YES];
    // 获取截图
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    // 关闭图片上下文
    UIGraphicsEndImageContext();
    // 保存相册
    UIImageWriteToSavedPhotosAlbum(image, NULL, NULL, NULL);

    return image;
}

#pragma mark - Property Methods -

- (TOCropView *)cropView {
    if (!_cropView) {
        _cropView = [[TOCropView alloc] initWithCroppingStyle:self.croppingStyle image:self.image];
        _cropView.delegate = self;
        _cropView.frame = [UIScreen mainScreen].bounds;
        _cropView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _cropView;
}

- (TOCropToolbar *)toolbar {
    if (!_toolbar) {
        _toolbar = [[TOCropToolbar alloc] initWithFrame:CGRectZero];
    }
    return _toolbar;
}

- (void)setAspectRatioLockEnabled:(BOOL)aspectRatioLockEnabled
{
    self.toolbar.clampButtonGlowing = aspectRatioLockEnabled;
    self.cropView.aspectRatioLockEnabled = aspectRatioLockEnabled;
    self.aspectRatioPickerButtonHidden = (aspectRatioLockEnabled && self.resetAspectRatioEnabled == NO);
}

- (BOOL)aspectRatioLockEnabled
{
    return self.cropView.aspectRatioLockEnabled;
}

- (void)setRotateButtonsHidden:(BOOL)rotateButtonsHidden
{
    self.toolbar.rotateCounterclockwiseButtonHidden = rotateButtonsHidden;
    
    if (self.rotateClockwiseButtonHidden == NO) {
        self.toolbar.rotateClockwiseButtonHidden = rotateButtonsHidden;
    }
}

- (BOOL)rotateButtonsHidden
{
    if (self.rotateClockwiseButtonHidden == NO) {
        return self.toolbar.rotateCounterclockwiseButtonHidden && self.toolbar.rotateClockwiseButtonHidden;
    }
    
    return self.toolbar.rotateCounterclockwiseButtonHidden;
}

- (void)setRotateClockwiseButtonHidden:(BOOL)rotateClockwiseButtonHidden
{
    if (_rotateClockwiseButtonHidden == rotateClockwiseButtonHidden) {
        return;
    }
    
    _rotateClockwiseButtonHidden = rotateClockwiseButtonHidden;
    
    if (self.rotateButtonsHidden == NO) {
        self.toolbar.rotateClockwiseButtonHidden = _rotateClockwiseButtonHidden;
    }
}

- (void)setAspectRatioPickerButtonHidden:(BOOL)aspectRatioPickerButtonHidden
{
    self.toolbar.clampButtonHidden = aspectRatioPickerButtonHidden;
}

- (BOOL)aspectRatioPickerButtonHidden
{
    return self.toolbar.clampButtonHidden;
}

- (void)setResetAspectRatioEnabled:(BOOL)resetAspectRatioEnabled
{
    self.cropView.resetAspectRatioEnabled = resetAspectRatioEnabled;
    self.aspectRatioPickerButtonHidden = (resetAspectRatioEnabled == NO && self.aspectRatioLockEnabled);
}

- (void)setCustomAspectRatio:(CGSize)customAspectRatio
{
    _customAspectRatio = customAspectRatio;
    [self setAspectRatioPreset:TOCropViewControllerAspectRatioPresetCustom animated:NO];
}

- (BOOL)resetAspectRatioEnabled
{
    return self.cropView.resetAspectRatioEnabled;
}

- (void)setAngle:(NSInteger)angle
{
    self.cropView.angle = angle;
}

- (NSInteger)angle
{
    return self.cropView.angle;
}

- (void)setImageCropFrame:(CGRect)imageCropFrame
{
    self.cropView.imageCropFrame = imageCropFrame;
}

- (CGRect)imageCropFrame
{
    return self.cropView.imageCropFrame;
}

@end
