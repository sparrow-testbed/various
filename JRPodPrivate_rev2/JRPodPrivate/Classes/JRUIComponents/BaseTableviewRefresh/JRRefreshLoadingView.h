//
//  JRRefreshLoadingView.h
//  JRPodPrivate
//
//  Created by 金煜祥 on 2021/4/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JRRefreshLoadingView : UIView<CAAnimationDelegate>
-(void)startAnimation;
-(void)stopAnimation;
@end

NS_ASSUME_NONNULL_END
