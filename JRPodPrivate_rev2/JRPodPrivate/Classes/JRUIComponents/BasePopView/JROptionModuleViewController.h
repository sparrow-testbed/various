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

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
//选项回调
typedef void (^SelectCompleteBlock)(NSArray *list,BOOL backAction);
@interface JROptionModuleViewController : UIViewController
//数据源
@property(nonatomic,strong)NSArray *dataSource;

//默认选择的数据
@property(nonatomic,strong)NSArray *defaultList;

@property(nonatomic,copy)NSString * titleStr;

@property(nonatomic,copy)NSString * key;

//其它有全选
@property(nonatomic,assign)BOOL isCheckAll;
//是否多选
@property(nonatomic,assign)BOOL options;
//是否取消
@property(nonatomic,assign)BOOL isCancle;
///是否显示确定按钮
@property(nonatomic,assign)BOOL isShowEnter;

@property(nonatomic,copy)SelectCompleteBlock block;

- (void)cancleAction;
@end

NS_ASSUME_NONNULL_END
