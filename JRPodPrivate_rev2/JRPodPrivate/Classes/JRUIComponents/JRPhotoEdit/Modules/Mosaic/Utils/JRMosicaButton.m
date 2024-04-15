//
/**
* 所属系统: YMMAD
* 所属模块: 
* 功能描述: 
* 创建时间: 2021/3/17
* 维护人:  马克
* 
*┌─────────────────────────────────────────────────────┐
*│ 此技术信息为本公司机密信息，未经本公司书面同意禁止向第三方披露．│
*│ 版权所有：杰人软件(深圳)有限公司                          │
*└─────────────────────────────────────────────────────┘
*/

#import "JRMosicaButton.h"
#import "FrameAccessor.h"

static CGFloat const kButtonSize = 22.0f;

@implementation JRMosicaButton
{
    UIView *_dotColorView;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setupUI];
    }
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _dotColorView.center = CGPointMake(self.width/2, self.height/2);
}

- (void)setupUI {
    _dotColorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kButtonSize, kButtonSize)];
    _dotColorView.userInteractionEnabled = NO;
    _dotColorView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    [self addSubview:_dotColorView];
    
    self.backgroundColor = [UIColor clearColor];
    
    [self setDotViewSizeWidht:_dotViewSizeWidht];
    
    [self setIsUse:_isUse];
}

- (void)setDotViewSizeWidht:(float )dotViewSizeWidht {
    
    _dotViewSizeWidht = dotViewSizeWidht;
    _dotColorView.viewSize = CGSizeMake(dotViewSizeWidht, dotViewSizeWidht);
    _dotColorView.center = CGPointMake(self.width/2, self.height/2);
    _dotColorView.layer.cornerRadius = dotViewSizeWidht/2;
    _dotColorView.layer.cornerRadius = dotViewSizeWidht/2;
}

- (void)setIsUse:(BOOL)isUse {
    
    _isUse = isUse;
    
    if (!_isUse) {
        _dotColorView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.6];
    }else {
        _dotColorView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    }
    
}

@end
