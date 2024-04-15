//
/**
* 所属系统: component
* 所属模块: 
* 功能描述: 
* 创建时间: 2020/9/16
* 维护人:  王伟
* Copyright © 2020 杰人软件. All rights reserved.
*┌─────────────────────────────────────────────────────┐
*│ 此技术信息为本公司机密信息，未经本公司书面同意禁止向第三方披露．│
*│ 版权所有：杰人软件(深圳)有限公司                          │
*└─────────────────────────────────────────────────────┘
*/

#ifndef JRUIKit_h
#define JRUIKit_h

static NSString * const JRUI_VERSION = @"1.0.0";

#pragma mark - # Header

#if __has_include("JRUICommonDefines.h")
#import "JRUICommonDefines.h"
#endif

#if __has_include("JRUIHelper.h")
#import "JRUIHelper.h"
#endif

#if __has_include("JRAlertView.h")
#import "JRAlertView.h"
#endif

#if __has_include("JRUIButton.h")
#import "JRUIButton.h"
#endif

#if __has_include("JRSearchView.h")
#import "JRSearchView.h"
#endif

#if __has_include("JRSearchBar.h")
#import "JRSearchBar.h"
#endif

#if __has_include("JRSegmentView.h")
#import "JRSegmentView.h"
#endif

#if __has_include("JRCheckBoxView.h")
#import "JRCheckBoxView.h"
#endif

#if __has_include("JRUINavigationController.h")
#import "JRUINavigationController.h"
#endif


#if __has_include("JRChooseTextTableViewCell.h")
#import "JRChooseTextTableViewCell.h"
#endif


#if __has_include("JRSwitchTableViewCell.h")
#import "JRSwitchTableViewCell.h"
#endif


#if __has_include("JRTextFieldTableViewCell.h")
#import "JRTextFieldTableViewCell.h"
#endif


#if __has_include("JRTimetableTableViewCell.h")
#import "JRTimetableTableViewCell.h"
#endif


#if __has_include("JRUsersTableViewCell.h")
#import "JRUsersTableViewCell.h"
#endif


#if __has_include("JRWorkListTableViewCell.h")
#import "JRWorkListTableViewCell.h"
#endif


#if __has_include("JRStartFinishTimeTableViewCell.h")
#import "JRStartFinishTimeTableViewCell.h"
#endif

#if __has_include("JROptionModuleViewController.h")
#import "JROptionModuleViewController.h"
#endif

#if __has_include("JRActionSheetView.h")
#import "JRActionSheetView.h"
#endif

//#if __has_include("JRAddFileImage.h")
//#import "JRAddFileImage.h"
//#endif

#import "JRCalendarModel.h"
#import "JRPhotoCameraFilePopView.h"

#import "JRNoticeRemindTableViewCell.h"
#import "JRNoticeContentTableViewCell.h"
#import "JRNoticeRemindModel.h"

#import "JRFileModel.h"
#import "JRSandBoxFilePopView.h"
#import "JRSandBoxFileTableViewCell.h"
#import "JRSandBoxFileViewController.h"
#import "JRNoDataView.h"
#import "JRSideBarView.h"
#import "JRAddFileImage.h"
#import "JRFileCollectionViewCell.h"
#import "JRImageCollectionViewCell.h"
#import "JRProcessView.h"
#import "JRPhotoShowPlayerView.h"
#import "JRPhotoShowEditView.h"
#import "JRImageUploadModel.h"
#import "JRImageEditor.h"
#import "JRImageToolBase.h"
#import "JRRefreshHeader.h"
#import "JRRefreshFooter.h"
//分类
#import "NSString+JRCommon.h"
#import "UIView+Additions.h"
#import "UILabel+XYAdd.h"
#import "UIColor+XYAdd.h"
#import "MBProgressHUD+XYAdd.h"
#import "UICollectionView+Extension.h"
#import "UIButton+JRExtension.h"
#import "NSDate+XYAdd.h"
#import "NSCalendar+XYAdd.h"
#import "UIBarButtonItem+ZF.h"
#import "XYButton.h"

#import <JKCategories/JKCategories.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import <Masonry/Masonry.h>
#import <DateTools/DateTools.h>
#import <YBImageBrowser/YBImageBrowser.h>
#import <YBImageBrowser/YBIBVideoData.h>
#import "JRCameraCustomVC.h"
#import "TZImagePickerController.h"
#import "TZPhotoPickerController.h"
#import "JRVideoPreviewCell.h"
#import "JRImagePickerController.h"
#import "JRThumbImageCollectionViewCell.h"
#import "TZAssetModel+JRAddProperty.h"
#import "JRPhotoPickerController.h"
#import <TZImagePickerController/TZAssetCell.h>
#import <TZImagePickerController/TZPhotoPreviewController.h>
#import <SDWebImage/SDWebImage.h>

#endif /* JRUIKit_h */
