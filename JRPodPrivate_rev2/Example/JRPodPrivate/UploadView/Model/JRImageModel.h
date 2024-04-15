//
//  JRImageModel.h
//  JRPodPrivate_Example
//
//  Created by 朱俊彪 on 2021/2/9.
//  Copyright © 2021 wni. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface JRImageModel : NSObject

@property(nonatomic,assign)NSInteger mediaType;
@property(nonatomic,strong)UIImage *image;
@property(nonatomic,strong)PHAsset *phAsset;
@property(nonatomic,strong)NSURL *imageUrl;
@property(nonatomic,strong)NSURL *viedoUrl;
@property (nonatomic, copy) NSString *videoUrl;
@property(nonatomic,copy)NSString *imgUrl;
@property (nonatomic, assign)CGFloat imageProgress;
/**
 图片本地路径
 */
@property (nonatomic, copy)NSString *localUrl;
/**
 文件名
 */
@property (nonatomic, copy)NSString *name;
/**
 上传失败
 */
@property (nonatomic, assign)BOOL uploadFail;

@end

NS_ASSUME_NONNULL_END
