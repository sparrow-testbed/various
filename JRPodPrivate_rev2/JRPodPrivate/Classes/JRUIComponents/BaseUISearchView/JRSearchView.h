//
/**
* 所属系统: component
* 所属模块: UIView
* 功能描述: 基础搜索View
* 创建时间: 2020/9/21
* 维护人:  王伟
* Copyright © 2020 wni. All rights reserved.
*┌─────────────────────────────────────────────────────┐
*│ 此技术信息为本公司机密信息，未经本公司书面同意禁止向第三方披露．│
*│ 版权所有：杰人软件(深圳)有限公司                          │
*└─────────────────────────────────────────────────────┘
*/

#import <UIKit/UIKit.h>
#import "JRSearchBar.h"

typedef enum : NSUInteger {
    JRSearchTypeGreen,//底色为绿色
    JRSearchTypeWhite,//底色为白色
    JRSearchTypeGray,//底色为灰色
    JRSearchTypeCancel,//取消按钮
} JRSearchType;

NS_ASSUME_NONNULL_BEGIN

@protocol JRSearchViewDelegate <NSObject>

- (void)cancelButtonAction:(UIButton *)sender;

@end

@interface JRSearchView : UIView

@property (nonatomic,strong)JRSearchBar *searchBar;
//取消按钮
@property (nonatomic,strong)UIButton *cancelButton;
//光标颜色
@property(null_resettable, nonatomic, strong) UIColor *tintColor;
//搜索框类型
@property (nonatomic,assign)JRSearchType searchType;

@property (nonatomic,strong)UIImage *searchImage;

@property (nonatomic,strong)UIImage *clearImage;

@property (nonatomic,assign)id <JRSearchViewDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
