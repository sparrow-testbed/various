//
/**
* 所属系统: YMMAD
* 所属模块: 
* 功能描述: 
* 创建时间: 2021/1/15
* 维护人:  马克
* 
*┌─────────────────────────────────────────────────────┐
*│ 此技术信息为本公司机密信息，未经本公司书面同意禁止向第三方披露．│
*│ 版权所有：杰人软件(深圳)有限公司                          │
*└─────────────────────────────────────────────────────┘
*/

#import <UIKit/UIKit.h>
#import "JRImageCollectionViewCell.h"
#import "JRFileCollectionViewCell.h"


typedef void(^AddFileEventBlock)(void); //添加文件事件
typedef void(^PreviewPhotoBlock)(id _Nullable object,NSInteger index,JRImageCollectionViewCell * _Nullable cell); //预览图片
typedef void(^PreviewFileBlock)(id _Nullable object,NSInteger index); //预览文件
typedef void(^SubCommitFileBlock)(void); //提交文件


NS_ASSUME_NONNULL_BEGIN

@interface JRAddFileImage : UIView
/// 主scrollview 容器
@property (nonatomic ,strong) UIScrollView *mainScrollView;
/// 自定义标题内容
@property (nonatomic, strong) UILabel *titleLabel;
/// 自定义子标题内容
@property (nonatomic, strong) UILabel *subTitleLabel;
/// 图片数组
@property (nonatomic ,strong) NSMutableArray *photosArray;
/// 其他文件数组
@property (nonatomic ,strong) NSMutableArray *otherLabelArray;
/// 添加图片block
@property (nonatomic ,copy) AddFileEventBlock addFileEventBlock;
/// 预览图片block
@property (nonatomic ,copy) PreviewPhotoBlock previewPhotoBlock;
/// 预览文件block
@property (nonatomic ,copy) PreviewFileBlock  previewFileBlock;
/// 提交上传block
@property (nonatomic ,copy) SubCommitFileBlock  subCommitFileBlock;
/// 是否显示提交按钮
@property (nonatomic, assign)BOOL isVisable;

/// 最大选择张数
@property (nonatomic, assign) NSInteger max;

///更新UI
- (void)updateCollectionFrame;

-(CGFloat)getConllectionHeight;

@end

NS_ASSUME_NONNULL_END
