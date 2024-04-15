//
/**
* 所属系统: YMMAD
* 所属模块: 
* 功能描述: 
* 创建时间: 2021/2/22
* 维护人:  马克
* 
*┌─────────────────────────────────────────────────────┐
*│ 此技术信息为本公司机密信息，未经本公司书面同意禁止向第三方披露．│
*│ 版权所有：杰人软件(深圳)有限公司                          │
*└─────────────────────────────────────────────────────┘
*/

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JRImageUploadModel : NSObject
@property (nonatomic, assign) NSInteger width;
@property (nonatomic, assign) NSInteger height;
/**
 视频文件地址
 */
@property (nonatomic, copy) NSString *videoUrl;
/**
 图片网络路径
 */
@property (nonatomic, copy) NSString *imgUrl;
/**
 图片类型 1 图片 其他 为视频
 */
@property(nonatomic,assign)NSInteger mediaType;
/**
 图片本地路径
 */
@property (nonatomic, copy)NSString *localUrl;
/**
 文件大小
 */
@property (nonatomic, assign)int64_t size;
/**
 图片文件的image
 */
@property (nonatomic, strong)UIImage *image;
/**
 图片缩略图
 */
@property (nonatomic, strong)UIImage *thumbImage;
/**
 文件后缀
 */
@property (nonatomic, copy)NSString *suffix;
/**
 文件名
 */
@property (nonatomic, copy)NSString *name;
/**
 文件上传进度
 */
@property (nonatomic, assign)CGFloat imageProgress;
/**
 上传失败
 */
@property (nonatomic, assign)BOOL uploadFail;
/**
 文件MD5值
 */
@property (nonatomic, copy)NSString * md5String;
@end

NS_ASSUME_NONNULL_END
