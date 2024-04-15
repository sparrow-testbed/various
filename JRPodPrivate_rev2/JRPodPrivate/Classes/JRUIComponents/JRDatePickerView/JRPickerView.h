//
/**
* 所属系统: component
* 所属模块: 
* 功能描述: 
* 创建时间: 2020/9/25
* 维护人:  李志䶮
* Copyright © 2020 wni. All rights reserved.
*┌─────────────────────────────────────────────────────┐
*│ 此技术信息为本公司机密信息，未经本公司书面同意禁止向第三方披露．│
*│ 版权所有：杰人软件(深圳)有限公司                          │
*└─────────────────────────────────────────────────────┘
*/

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, PickerViewType){
    PickerViewTypeYearMonthDay,
    PickerViewTypeYearMonth,
    PickerViewTypeYear,
    PickerViewTypeOther
};

NS_ASSUME_NONNULL_BEGIN

typedef void(^SelectPickerCallback)(NSString *selectDate, NSInteger tag);

@interface JRPickerView : UIView{
    SelectPickerCallback selectCompleteHander;
}

+ (JRPickerView *)shareInstance;

- (void)showInView:(UIView *)superView type:(PickerViewType)type currentContent:(NSString *)currentContent title:(NSString *)title selectCompleteHander:(SelectPickerCallback)dateCallback;

- (void)showInView:(UIView *)superView type:(PickerViewType)type currentContent:(NSString *)currentContent title:(NSString *)title maxYear:(NSInteger)maxYear minYear:(NSInteger)minYear selectCompleteHander:(SelectPickerCallback)dateCallback;

- (void)showInView:(UIView *)superView type:(PickerViewType)type currentContent:(NSString *)currentContent title:(NSString *)title contentArray:(NSArray * __nullable)contentArray selectCompleteHander:(SelectPickerCallback)dateCallback;

@end

NS_ASSUME_NONNULL_END
