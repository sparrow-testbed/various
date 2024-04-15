//
/**
* 所属系统: component
* 所属模块: 
* 功能描述: 
* 创建时间: 2020/9/26
* 维护人:  王伟
* Copyright © 2020 wni. All rights reserved.
*┌─────────────────────────────────────────────────────┐
*│ 此技术信息为本公司机密信息，未经本公司书面同意禁止向第三方披露．│
*│ 版权所有：杰人软件(深圳)有限公司                          │
*└─────────────────────────────────────────────────────┘
*/

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    JRContentTypeDirectory = 0,
    JRContentTypeFile,
} JRContentType;

typedef enum : NSUInteger {
    FileTypePDF = 0,
    FileTypeDOC,
    FileTypePSD,
    FileTypeXLS,
    FileTypePPT,
    FileTypeTXT,
    FileTypeZIP,
    FileTypeMP3,
    FileTypeVIDEO,
    FileTypeUnknowFile,
} JRFileType;

/**
 文件类型
 */
@interface JRFileModel : NSObject
@property (nonatomic, assign) JRContentType curConentType; // 内容类型
@property (nonatomic, copy) NSString *name; // 文件名称
@property (nonatomic, copy) NSString *path; // 文件路径
@property (nonatomic, copy) NSString *createDate; // 创建日期
@property (nonatomic, assign) unsigned long long size; // 文件长度
@property (nonatomic, assign) JRFileType fileType; // 文件类型
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, copy) NSString *fileUrl; // 文件名称
@property (nonatomic, assign) BOOL uploadFail;


@end

NS_ASSUME_NONNULL_END
