//
/**
* 所属系统: YMMAD
* 所属模块: 
* 功能描述: 
* 创建时间: 2021/3/16
* 维护人:  马克
* 
*┌─────────────────────────────────────────────────────┐
*│ 此技术信息为本公司机密信息，未经本公司书面同意禁止向第三方披露．│
*│ 版权所有：杰人软件(深圳)有限公司                          │
*└─────────────────────────────────────────────────────┘
*/

#import "JRTextToolView.h"
#import "JRTextTool.h"
#import "JRImageEditorGestureManager.h"
#import "FrameAccessor.h"
//#import "UIImage+library.h"

@interface JRTextToolOverlapContentView : UIView
@property (nonatomic, copy  ) NSString *text;
@property (nonatomic, strong) UIFont *textFont;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, assign) CGFloat defaultFont;
@property (nonatomic, strong) UIImage *image;
@end



@implementation JRTextToolOverlapContentView
- (void)setText:(NSString *)text {
    if (_text != text) {
        _text = text;
        [self setNeedsDisplay];
    }
}

- (void)setTextColor:(UIColor *)textColor {
    if (_textColor != textColor) {
        _textColor = textColor;
        [self setNeedsDisplay];
    }
}

- (void)setTextFont:(UIFont *)textFont {
    if (_textFont != textFont) {
        _textFont = textFont;
        _defaultFont = textFont.pointSize;
        [self setNeedsDisplay];
    }
}

- (void)setImage:(UIImage *)image {
    if (_image != image) {
        _image = image;
        [self setNeedsDisplay];
    }
}

- (void)drawRect:(CGRect)rect
{
    
    return;

    if (self.image)
    {
        [self.image drawInRect:CGRectInset(rect, 21, 25)];
        return;
    }
    
    NSShadow *shadow = [[NSShadow alloc] init];
    // shadow.shadowColor = [UIColor grayColor]; //阴影颜色
    // shadow.shadowOffset= CGSizeMake(2, 2);//偏移量
    // shadow.shadowBlurRadius = 5;//模糊度
    
    UIColor *color = self.textColor ?: [UIColor whiteColor];
    UIFont *font = self.textFont ?: [UIFont systemFontOfSize:12];
    NSDictionary *attributes = @{
                                 NSForegroundColorAttributeName : color,
                                 NSFontAttributeName : font,
                                 NSShadowAttributeName: shadow
                                 };
    
    NSAttributedString *string = [[NSAttributedString alloc]
                                  initWithString:self.text
                                  attributes:attributes];
    
    rect.origin = CGPointMake(1, 2);
    [string drawInRect:CGRectInset(rect, 21, 25)];
}

@end


@interface JRTextToolOverlapView ()
@property (nonatomic, strong) JRTextToolOverlapContentView *contentView;
@end

@implementation JRTextToolOverlapView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _contentView = [[JRTextToolOverlapContentView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _contentView.backgroundColor = [UIColor clearColor];
        [self addSubview:_contentView];
    }
    return self;
}

- (void)setText:(NSString *)text {
    if (_text != text) {
        _text = text;
        [_contentView setText:_text];
    }
}

- (void)setTextColor:(UIColor *)textColor {
    if (_textColor != textColor) {
        _textColor = textColor;
        [_contentView setTextColor:_textColor];
    }
}

- (void)setTextFont:(UIFont *)textFont {
    if (_textFont != textFont) {
        _textFont = textFont;
        _contentView.defaultFont = textFont.pointSize;
        [_contentView setTextFont:_textFont];
    }
}

- (void)setImage:(UIImage *)image {
    if (_image != image) {
        _image = image;
        [_contentView setImage:image];
    }
}


- (void)layoutSubviews {
    [super layoutSubviews];
    _contentView.bounds = self.bounds;
    _contentView.viewOrigin = CGPointZero;
}




@end
