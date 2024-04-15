//
//  JRThumbImageCollectionViewCell.h
//  JRPodPrivate_Example
//
//  Created by 金煜祥 on 2020/9/24.
//  Copyright © 2020 wni. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JRUIKit.h"
NS_ASSUME_NONNULL_BEGIN

@interface JRThumbImageCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong)UIImageView *thumbImageView;
@property (nonatomic,strong)UIImageView *videoFlagImageView;
@property (nonatomic,strong)UIView * maskView;
@property (nonatomic,assign)BOOL jrIsSelected;
@end

NS_ASSUME_NONNULL_END
