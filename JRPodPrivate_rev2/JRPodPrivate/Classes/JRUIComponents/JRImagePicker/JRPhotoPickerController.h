//
//  JRPhotoPickerController.h
//  JRPodPrivate_Example
//
//  Created by 金煜祥 on 2020/9/21.
//  Copyright © 2020 wni. All rights reserved.
//

#import "JRUIKit.h"

NS_ASSUME_NONNULL_BEGIN

@interface JRPhotoPickerController : TZPhotoPickerController
- (void)pushPhotoPrevireViewController:(TZPhotoPreviewController *)photoPreviewVc needCheckSelectedModels:(BOOL)needCheckSelectedModels;
@end

NS_ASSUME_NONNULL_END
