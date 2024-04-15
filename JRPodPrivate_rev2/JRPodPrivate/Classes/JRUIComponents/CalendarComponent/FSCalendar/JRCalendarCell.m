//
//  JRCalendarCell.m
//  Pods
//
//  Created by Wenchao Ding on 12/3/15.
//
//

#import "JRCalendarCell.h"
#import "JRCalendar.h"
#import "JRCalendarExtensions.h"
#import "JRCalendarDynamicHeader.h"
#import "JRCalendarConstants.h"

@implementation NSDate (HMDateTools)

- (BOOL)isToday {
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:(NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:[NSDate date]];
    NSDate *today = [cal dateFromComponents:components];
    components = [cal components:(NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:self];
    NSDate *otherDate = [cal dateFromComponents:components];
    
    return [today isEqualToDate:otherDate];
}

@end

@interface JRCalendarCell ()

@property (readonly, nonatomic) UIColor *colorForCellFill;
@property (readonly, nonatomic) UIColor *colorForTitleLabel;
@property (readonly, nonatomic) UIColor *colorForSubtitleLabel;
@property (readonly, nonatomic) UIColor *colorForCellBorder;
@property (readonly, nonatomic) NSArray<UIColor *> *colorsForEvents;
@property (readonly, nonatomic) CGFloat borderRadius;

@end

@implementation JRCalendarCell

#pragma mark - Life cycle

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{   
    UILabel *label;
    CAShapeLayer *shapeLayer;
    UIImageView *imageView;
    JRCalendarEventIndicator *eventIndicator;
    
    label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    [self.contentView addSubview:label];
    self.titleLabel = label;
    
    label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:label];
    self.subtitleLabel = label;
    
    shapeLayer = [CAShapeLayer layer];
    shapeLayer.backgroundColor = [UIColor clearColor].CGColor;
    shapeLayer.borderWidth = 1.0;
    shapeLayer.borderColor = [UIColor clearColor].CGColor;
    shapeLayer.opacity = 0;
    [self.contentView.layer insertSublayer:shapeLayer below:_titleLabel.layer];
    self.shapeLayer = shapeLayer;
    
    eventIndicator = [[JRCalendarEventIndicator alloc] initWithFrame:CGRectZero];
    eventIndicator.backgroundColor = [UIColor clearColor];
    eventIndicator.hidden = YES;
    [self.contentView addSubview:eventIndicator];
    self.eventIndicator = eventIndicator;
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    imageView.contentMode = UIViewContentModeBottom|UIViewContentModeCenter;
    [self.contentView addSubview:imageView];
    self.imageView = imageView;
    
    self.clipsToBounds = NO;
    self.contentView.clipsToBounds = NO;
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _titleLabel.text = self.title;
    if (_subtitle) {
        _subtitleLabel.text = _subtitle;
        if (_subtitleLabel.hidden) {
            _subtitleLabel.hidden = NO;
        }
    } else {
        if (!_subtitleLabel.hidden) {
            _subtitleLabel.hidden = YES;
        }
    }
    
    if (_subtitle) {
        CGFloat titleHeight = self.calendar.calculator.titleHeight;
        CGFloat subtitleHeight = self.calendar.calculator.subtitleHeight;
        
        CGFloat height = titleHeight + subtitleHeight;
        _titleLabel.frame = CGRectMake(
                                       self.preferredTitleOffset.x,
                                       (self.contentView.fs_height*5.0/6.0-height)*0.5+self.preferredTitleOffset.y - 2,
                                       self.contentView.fs_width,
                                       titleHeight
                                       );
        _subtitleLabel.frame = CGRectMake(
                                          self.preferredSubtitleOffset.x,
                                          (_titleLabel.fs_bottom-self.preferredTitleOffset.y) - (_titleLabel.fs_height-_titleLabel.font.pointSize)+self.preferredSubtitleOffset.y,
                                          self.contentView.fs_width,
                                          subtitleHeight
                                          );
    } else {
        
        //209.6.17 修改
        NSUserDefaults *userD = [NSUserDefaults standardUserDefaults];
        [userD setObject:@"1" forKey:@"titleY"];
        NSString *titleY = [userD objectForKey:@"titleY"];
        
        if ([titleY isEqualToString:@"1"]) {
            _titleLabel.frame = CGRectMake(
                                           self.preferredTitleOffset.x,
                                           self.preferredTitleOffset.y,
                                           self.contentView.fs_width,
                                           floor(self.contentView.fs_height*5.0/6.0)
                                           );
        }else{
            _titleLabel.frame = CGRectMake(
                                           self.preferredTitleOffset.x,
                                           self.preferredTitleOffset.y - 2,
                                           self.contentView.fs_width,
                                           floor(self.contentView.fs_height*5.0/6.0)
                                           );
        }
        
    }
    
    _imageView.frame = CGRectMake(self.preferredImageOffset.x, self.preferredImageOffset.y, self.contentView.fs_width * 0.8, self.contentView.fs_height * 0.8);
    
    
    
    CGFloat titleHeight = self.bounds.size.height*5.0/6.0;
    CGFloat diameter = MIN(self.bounds.size.height*5.0/6.0,self.bounds.size.width);
    diameter = diameter > JRCalendarStandardCellDiameter ? (diameter - (diameter-JRCalendarStandardCellDiameter)*0.5) : diameter;
    diameter += 4;
    _shapeLayer.frame = CGRectMake((self.bounds.size.width-diameter)/2,
                                   (titleHeight-diameter)/2,
                                   diameter,
                                   diameter);
    
    CGPathRef path = [UIBezierPath bezierPathWithRoundedRect:_shapeLayer.bounds
                                                cornerRadius:CGRectGetWidth(_shapeLayer.bounds)*0.5*self.borderRadius].CGPath;
    if (!CGPathEqualToPath(_shapeLayer.path,path)) {
        _shapeLayer.path = path;
    }
    
    CGFloat eventSize = _shapeLayer.frame.size.height/6.0;
//    _eventIndicator.frame = CGRectMake(
//                                       self.preferredEventOffset.x,
//                                       CGRectGetMaxY(_shapeLayer.frame)+eventSize*0.17+self.preferredEventOffset.y-1,
//                                       self.fs_width,
//                                       eventSize*0.83
//                                      );
    if ( [self dateIsToday] || self.selected){
        _eventIndicator.frame = CGRectMake(
                                           self.preferredEventOffset.x,
                                           CGRectGetMaxY(_shapeLayer.frame)+eventSize*0.17+self.preferredEventOffset.y - 1 - 5,
                                           self.fs_width,
                                           eventSize*0.83
                                           );
    } else {
        _eventIndicator.frame = CGRectMake(
                                           self.preferredEventOffset.x,
                                           CGRectGetMaxY(_shapeLayer.frame)+eventSize*0.17+self.preferredEventOffset.y-6 - 5,
                                           self.fs_width,
                                           eventSize*0.83
                                           );
    
    
    }
    
    NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:@"isCalendar"];
    if ([str isEqualToString:@"0"]) {
        _eventIndicator.frame = CGRectMake(
                                           self.preferredEventOffset.x,
                                           CGRectGetMaxY(_shapeLayer.frame)+eventSize*0.17+self.preferredEventOffset.y-6,
                                           self.fs_width,
                                           eventSize*0.5
                                           );
    }
    
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    [CATransaction setDisableActions:YES];
    _shapeLayer.opacity = 0;
    [self.contentView.layer removeAnimationForKey:@"opacity"];
}

#pragma mark - Public

- (void)performSelecting
{
    _shapeLayer.opacity = 1;
    
#define kAnimationDuration JRCalendarDefaultBounceAnimationDuration
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    CABasicAnimation *zoomOut = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    zoomOut.fromValue = @0.3;
    zoomOut.toValue = @1.2;
    zoomOut.duration = kAnimationDuration/4*3;
    CABasicAnimation *zoomIn = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    zoomIn.fromValue = @1.2;
    zoomIn.toValue = @1.0;
    zoomIn.beginTime = kAnimationDuration/4*3;
    zoomIn.duration = kAnimationDuration/4;
    group.duration = kAnimationDuration;
    group.animations = @[zoomOut, zoomIn];
    [_shapeLayer addAnimation:group forKey:@"bounce"];
    [self configureAppearance];
    
#undef kAnimationDuration
    
}

#pragma mark - Private

- (void)configureAppearance
{
    UIColor *textColor = self.colorForTitleLabel;
    if (![textColor isEqual:_titleLabel.textColor]) {
        _titleLabel.textColor = textColor;
    }
    UIFont *titleFont = self.calendar.appearance.titleFont;
    if (![titleFont isEqual:_titleLabel.font]) {
        _titleLabel.font = titleFont;
    }
    if (_subtitle) {
        textColor = self.colorForSubtitleLabel;
        if (![textColor isEqual:_subtitleLabel.textColor]) {
            _subtitleLabel.textColor = textColor;
        }
        titleFont = self.calendar.appearance.subtitleFont;
        if (![titleFont isEqual:_subtitleLabel.font]) {
            _subtitleLabel.font = titleFont;
        }
    }
    
    UIColor *borderColor = self.colorForCellBorder;
    UIColor *fillColor = self.colorForCellFill;
    
    BOOL shouldHideShapeLayer = !self.selected && !self.dateIsToday && !borderColor && !fillColor;
    
    if (_shapeLayer.opacity == shouldHideShapeLayer) {
        _shapeLayer.opacity = !shouldHideShapeLayer;
    }
    if (!shouldHideShapeLayer) {
        
        CGColorRef cellFillColor = self.colorForCellFill.CGColor;
        if (!CGColorEqualToColor(_shapeLayer.fillColor, cellFillColor)) {
            _shapeLayer.fillColor = cellFillColor;
        }
        
        CGColorRef cellBorderColor = self.colorForCellBorder.CGColor;
        if (!CGColorEqualToColor(_shapeLayer.strokeColor, cellBorderColor)) {
            _shapeLayer.strokeColor = cellBorderColor;
        }
        
        CGPathRef path = [UIBezierPath bezierPathWithRoundedRect:_shapeLayer.bounds
                                                    cornerRadius:CGRectGetWidth(_shapeLayer.bounds)*0.5*self.borderRadius].CGPath;
        if (!CGPathEqualToPath(_shapeLayer.path, path)) {
            _shapeLayer.path = path;
        }
        
    }
    
    if (![_image isEqual:_imageView.image]) {
        _imageView.image = _image;
        _imageView.hidden = !_image;
    }
    
    if (_eventIndicator.hidden == (_numberOfEvents > 0)) {
        _eventIndicator.hidden = !_numberOfEvents;
    }
    
    _eventIndicator.numberOfEvents = self.numberOfEvents;
//    _eventIndicator.color = self.colorsForEvents;
}

- (UIColor *)colorForCurrentStateInDictionary:(NSDictionary *)dictionary
{
    if (self.isSelected) {
        if (self.dateIsToday) {
            return dictionary[@(JRCalendarCellStateSelected|JRCalendarCellStateToday)] ?: dictionary[@(JRCalendarCellStateSelected)];
        }
        return dictionary[@(JRCalendarCellStateSelected)];
    }
    if (self.dateIsToday && [[dictionary allKeys] containsObject:@(JRCalendarCellStateToday)]) {
        return dictionary[@(JRCalendarCellStateToday)];
    }
    if (self.placeholder && [[dictionary allKeys] containsObject:@(JRCalendarCellStatePlaceholder)]) {
        return dictionary[@(JRCalendarCellStatePlaceholder)];
    }
    if (self.weekend && [[dictionary allKeys] containsObject:@(JRCalendarCellStateWeekend)]) {
        return dictionary[@(JRCalendarCellStateWeekend)];
    }
    return dictionary[@(JRCalendarCellStateNormal)];
}

#pragma mark - Properties

- (UIColor *)colorForCellFill
{
    if (self.selected) {
        return self.preferredFillSelectionColor ?: [self colorForCurrentStateInDictionary:_appearance.backgroundColors];
    }
    return self.preferredFillDefaultColor ?: [self colorForCurrentStateInDictionary:_appearance.backgroundColors];
}

- (UIColor *)colorForTitleLabel
{
    if (self.selected) {
        return self.preferredTitleSelectionColor ?: [self colorForCurrentStateInDictionary:_appearance.titleColors];
    }
    return self.preferredTitleDefaultColor ?: [self colorForCurrentStateInDictionary:_appearance.titleColors];
}

- (UIColor *)colorForSubtitleLabel
{
    if (self.selected) {
        return self.preferredSubtitleSelectionColor ?: [self colorForCurrentStateInDictionary:_appearance.subtitleColors];
    }
    return self.preferredSubtitleDefaultColor ?: [self colorForCurrentStateInDictionary:_appearance.subtitleColors];
}

- (UIColor *)colorForCellBorder
{
    if (self.selected) {
        return _preferredBorderSelectionColor ?: _appearance.borderSelectionColor;
    }
    return _preferredBorderDefaultColor ?: _appearance.borderDefaultColor;
}


- (NSArray<UIColor *> *)colorsForEvents
{
//    NSLog(@"&&****&&%@",[self.calendar dateForCell:self]);
    ///这里显示颜色的设置
    if (/*self.selected*/[[self.calendar dateForCell:self] timeIntervalSinceDate:[NSDate date]] > 0 || [[self.calendar dateForCell:self] isToday]) {
//        return _preferredEventSelectionColors ?: @[_appearance.eventSelectionColor];
//        return _preferredEventDefaultColors ?: @[_appearance.eventSelectionColor];
        return @[XZYColorFromRGB(0x37a248)];
    }
    return @[XZYColorFromRGB(0xc6cad2)];
//
    //return _preferredEventDefaultColors ?: @[_appearance.eventDefaultColor];
//
}

- (CGFloat)borderRadius
{
    return _preferredBorderRadius >= 0 ? _preferredBorderRadius : _appearance.borderRadius;
}

#define OFFSET_PROPERTY(NAME,CAPITAL,ALTERNATIVE) \
\
@synthesize NAME = _##NAME; \
\
- (void)set##CAPITAL:(CGPoint)NAME \
{ \
    BOOL diff = !CGPointEqualToPoint(NAME, self.NAME); \
    _##NAME = NAME; \
    if (diff) { \
        [self setNeedsLayout]; \
    } \
} \
\
- (CGPoint)NAME \
{ \
    return CGPointEqualToPoint(_##NAME, CGPointInfinity) ? ALTERNATIVE : _##NAME; \
}

OFFSET_PROPERTY(preferredTitleOffset, PreferredTitleOffset, _appearance.titleOffset);
OFFSET_PROPERTY(preferredSubtitleOffset, PreferredSubtitleOffset, _appearance.subtitleOffset);
OFFSET_PROPERTY(preferredImageOffset, PreferredImageOffset, _appearance.imageOffset);
OFFSET_PROPERTY(preferredEventOffset, PreferredEventOffset, _appearance.eventOffset);

#undef OFFSET_PROPERTY

- (void)setCalendar:(JRCalendar *)calendar
{
    if (![_calendar isEqual:calendar]) {
        _calendar = calendar;
        _appearance = calendar.appearance;
        [self configureAppearance];
    }
}

- (void)setSubtitle:(NSString *)subtitle
{
    if (![_subtitle isEqualToString:subtitle]) {
        BOOL diff = (subtitle.length && !_subtitle.length) || (_subtitle.length && !subtitle.length);
        _subtitle = subtitle;
        if (diff) {
            [self setNeedsLayout];
        }
    }
}

@end


@interface JRCalendarEventIndicator ()

@property (weak, nonatomic) UIView *contentView;

@property (strong, nonatomic) NSPointerArray *eventLayers;
@property (assign, nonatomic) BOOL needsInvalidatingColor;

@end

@implementation JRCalendarEventIndicator

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
        [self addSubview:view];
        self.contentView = view;
        
        self.eventLayers = [NSPointerArray weakObjectsPointerArray];
        for (int i = 0; i < 3; i++) {
            CALayer *layer = [CALayer layer];
            layer.backgroundColor = [UIColor clearColor].CGColor;
            [self.contentView.layer addSublayer:layer];
            [self.eventLayers addPointer:(__bridge void * _Nullable)(layer)];
        }
        
        _needsInvalidatingColor = YES;
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat diameter = MIN(MIN(self.fs_width, self.fs_height),JRCalendarMaximumEventDotDiameter);
    self.contentView.fs_height = self.fs_height;
    self.contentView.fs_width = (self.numberOfEvents*2-1)*diameter;
    self.contentView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
}

- (void)layoutSublayersOfLayer:(CALayer *)layer
{
    [super layoutSublayersOfLayer:layer];
    if (layer == self.layer) {
        
        CGFloat diameter = MIN(MIN(self.fs_width, self.fs_height),JRCalendarMaximumEventDotDiameter);
        
        diameter += 1;
        
        for (int i = 0; i < self.eventLayers.count; i++) {
            CALayer *eventLayer = [self.eventLayers pointerAtIndex:i];
            eventLayer.hidden = i >= self.numberOfEvents;
            if (!eventLayer.hidden) {
//                eventLayer.frame = CGRectMake(2*i*diameter, (self.fs_height-diameter)*0.5, diameter, diameter);
                eventLayer.frame = CGRectMake(2*i*diameter, (self.fs_height-diameter)*0.5 , diameter, diameter);
                if (eventLayer.cornerRadius != diameter/2) {
                    eventLayer.cornerRadius = diameter/2;
                }
            }
        }
        
        if (_needsInvalidatingColor) {
            _needsInvalidatingColor = NO;
            if ([_color isKindOfClass:[UIColor class]]) {
                [self.eventLayers.allObjects makeObjectsPerformSelector:@selector(setBackgroundColor:) withObject:(id)[_color CGColor]];
            } else if ([_color isKindOfClass:[NSArray class]]) {
                NSArray *colors = (NSArray *)_color;
                if (colors.count) {
                    UIColor *lastColor = colors.firstObject;
                    for (int i = 0; i < self.eventLayers.count; i++) {
                        if (i < colors.count) {
                            lastColor = colors[i];
                        }
                        CALayer *eventLayer = [self.eventLayers pointerAtIndex:i];
                        eventLayer.backgroundColor = lastColor.CGColor;
                    }
                }
            }
        }
    }
}

- (void)setColor:(id)color
{
    if (![_color isEqual:color]) {
        _color = color;
        _needsInvalidatingColor = YES;
        [self setNeedsLayout];
    }
}

- (void)setNumberOfEvents:(NSInteger)numberOfEvents
{
    if (_numberOfEvents != numberOfEvents) {
        _numberOfEvents = MIN(MAX(numberOfEvents,0),3);
        [self setNeedsLayout];
    }
}

@end

@implementation JRCalendarBlankCell

- (void)configureAppearance {}

@end



