//
/**
* 所属系统: YMMAD
* 所属模块: 
* 功能描述: 
* 创建时间: 2021/5/12
* 维护人:  马克
* Copyright © 2021 wni. All rights reserved.
*┌─────────────────────────────────────────────────────┐
*│ 此技术信息为本公司机密信息，未经本公司书面同意禁止向第三方披露．│
*│ 版权所有：杰人软件(深圳)有限公司                          │
*└─────────────────────────────────────────────────────┘
*/

#import "JRCurrencyView.h"

@implementation JRCurrencyView

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.originNumber.text = @"2990";
    
    self.textFileld1.delegate = self;
    self.textField2.delegate = self;
    
    
    [self.textFileld1 becomeFirstResponder];
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {

}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSLog(@"%@",textField.text);
    if ([textField isEqual:self.textField2]) {
        self.textFileld1.text = [NSString stringWithFormat:@"%.4f",[textField.text floatValue] / [self.originNumber.text floatValue]];
    }
    
    if ([textField isEqual:self.textFileld1]) {
        self.textField2.text = [NSString stringWithFormat:@"%.2f",[textField.text floatValue] * [self.originNumber.text floatValue]];
    }
    return YES;
}



@end
