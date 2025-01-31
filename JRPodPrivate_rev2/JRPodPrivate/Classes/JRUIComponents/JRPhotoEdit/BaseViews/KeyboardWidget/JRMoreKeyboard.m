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

#import "JRMoreKeyboard.h"
#import "JRMoreKeyboard+CollectionView.h"
#import "UIColor+TLChat.h"
#import <Masonry/Masonry.h>
#import "FrameAccessor.h"
#import "JRUIKIt.h"
@implementation JRMoreKeyboard

+ (JRMoreKeyboard *)keyboard
{
    static JRMoreKeyboard *moreKB = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        moreKB = [[JRMoreKeyboard alloc] init];
    });
    return moreKB;
}

- (id)init
{
    if (self = [super init]) {
        [self setBackgroundColor:[UIColor whiteColor]];//[UIColor colorGrayForChatBar]];
        [self addSubview:self.collectionView];
        [self addSubview:self.pageControl];
        [self p_addMasonry];
        
        [self registerCellClass];
    }
    return self;
}

- (CGFloat)keyboardHeight
{
    return HEIGHT_CHAT_KEYBOARD;
}

#pragma mark - # Public Methods
- (void)setChatMoreKeyboardData:(NSMutableArray *)chatMoreKeyboardData
{
    _chatMoreKeyboardData = chatMoreKeyboardData;
    [self.collectionView reloadData];
    NSUInteger pageNumber = chatMoreKeyboardData.count / self.pageItemCount + (chatMoreKeyboardData.count % self.pageItemCount == 0 ? 0 : 1);
    [self.pageControl setNumberOfPages:pageNumber];
}

- (void)reset
{
    [self.collectionView scrollRectToVisible:CGRectMake(0, 0, self.collectionView.width, self.collectionView.height) animated:NO];
}

#pragma mark - # Event Response
- (void)pageControlChanged:(UIPageControl *)pageControl
{
    [self.collectionView scrollRectToVisible:CGRectMake(self.collectionView.width * pageControl.currentPage, 0, self.collectionView.width, self.collectionView.height) animated:YES];
}

#pragma mark - Private Methods -
- (void)p_addMasonry
{
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self);
        make.left.and.right.mas_equalTo(self);
        make.bottom.mas_equalTo(-25);
    }];
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(self);
        make.height.mas_equalTo(20);
        make.bottom.mas_equalTo(-2);
    }];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 0.5);
    CGContextSetStrokeColorWithColor(context, [UIColor colorGrayLine].CGColor);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, WIDTH_SCREEN, 0);
    CGContextStrokePath(context);
}

#pragma mark - # Getter
- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [_collectionView setBackgroundColor:[UIColor clearColor]];
        [_collectionView setPagingEnabled:YES];
        [_collectionView setDataSource:self];
        [_collectionView setDelegate:self];
        [_collectionView setShowsHorizontalScrollIndicator:NO];
        [_collectionView setShowsHorizontalScrollIndicator:NO];
        [_collectionView setScrollsToTop:NO];
    }
    return _collectionView;
}

- (UIPageControl *)pageControl
{
    if (_pageControl == nil) {
        _pageControl = [[UIPageControl alloc] init];
        [_pageControl setPageIndicatorTintColor:[UIColor colorGrayLine]];
        [_pageControl setCurrentPageIndicatorTintColor:[UIColor grayColor]];
        [_pageControl setHidesForSinglePage:YES];
        [_pageControl addTarget:self action:@selector(pageControlChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _pageControl;
}


@end
