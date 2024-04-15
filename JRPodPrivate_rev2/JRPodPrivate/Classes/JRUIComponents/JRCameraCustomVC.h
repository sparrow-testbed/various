/**
 * 所属系统: TIM
 * 所属模块: 聊天类：录制视频
 * 功能描述: 自定义视频录制界面 拍照能编辑的页面
 * 创建时间: 2020/9/18.
 * 维护人:  金煜祥
 * Copyright @ Jerrisoft 2019. All rights reserved.
 *┌─────────────────────────────────────────────────────┐
 *│ 此技术信息为本公司机密信息，未经本公司书面同意禁止向第三方披露．│
 *│ 版权所有：杰人软件(深圳)有限公司                          │
 *└─────────────────────────────────────────────────────┘
 */

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    JRCameraTypeDefault = 0,//拍照+拍摄
    JRCameraTypePhotograph = 1,//拍照
    JRCameraTypeShot = 2,//拍摄
    JRCameraTypeNoEdit = 3,//不编辑，拍照完即返回
} JRCameraType;
@interface JRCameraCustomVC : UIViewController

//默认类型
@property (nonatomic,assign)JRCameraType cameraType;

/**
 视频录制：取消回调
 */
@property (nonatomic, copy) void(^cameraVideoCancelBlock) (void);

/**
 视频录制：完成回调
 */
@property (nonatomic, copy) void(^cameraVideoCompleteBlock) (NSURL *fileUrl, NSString *preImgUrlStr);
/**
 照片拍摄：完成回调
 */
@property (nonatomic, copy) void(^cameraPhotoCompleteBlock) (UIImage *image);
/**
 照片拍摄：完成回调带URL
 */
@property (nonatomic, copy) void(^cameraPhotoIncloudUrlCompleteBlock) (NSURL *imageUrl,UIImage *image);

/**
  拍照完成 定制 按钮标题
 */
@property (nonatomic, strong) NSString *confirmTitle;
/**
  拍照完成是否返回图片本地路径
 */
@property (nonatomic, assign) BOOL isIncludeUrl;

//编辑类型
@property (nonatomic,assign)NSInteger editType;// 1 图片矫正 

@end

NS_ASSUME_NONNULL_END
