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

#import "JRMoreKeyboard+CollectionView.h"
#import "JRMoreKeyboardCell.h"
#import <Masonry/Masonry.h>
#import "FrameAccessor.h"
#import "EXTobjc.h"
#import "JRUIKit.h"

#define     SPACE_TOP        15
#define     WIDTH_CELL       60
#define     EDGE_TOP        (SPACE_TOP-10)

@implementation JRMoreKeyboard (CollectionView)
#pragma mark - Public Methods -
- (void)registerCellClass
{
    [self.collectionView registerClass:[JRMoreKeyboardCell class] forCellWithReuseIdentifier:@"WBGMoreKeyboardCell"];
}

#pragma mark - Delegate -
//MARK: UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.chatMoreKeyboardData.count / self.pageItemCount + (self.chatMoreKeyboardData.count % self.pageItemCount == 0 ? 0 : 1);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.pageItemCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JRMoreKeyboardCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JRMoreKeyboardCell" forIndexPath:indexPath];
    NSUInteger index = indexPath.section * self.pageItemCount + indexPath.row;
    NSUInteger tIndex = [self p_transformIndex:index];  // 矩阵坐标转置
    if (tIndex >= self.chatMoreKeyboardData.count) {
        [cell setItem:nil];
    }
    else {
        [cell setItem:self.chatMoreKeyboardData[tIndex]];
    }
    
    @weakify(self);
    
    [cell setClickBlock:^(JRMoreKeyboardItem *sItem) {
        @strongify(self);
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(moreKeyboard:didSelectedFunctionItem:)])
        {
            [self.delegate moreKeyboard:self didSelectedFunctionItem:sItem];
        }
    }];
    return cell;
}

//MARK: UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(WIDTH_CELL, (collectionView.height - SPACE_TOP) / 2 * 0.93);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return (collectionView.width - WIDTH_CELL * self.pageItemCount / 2) / (self.pageItemCount / 2 + 1);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return (collectionView.height - SPACE_TOP) / 2 * 0.07;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    CGFloat space = (collectionView.width - WIDTH_CELL * self.pageItemCount / 2) / (self.pageItemCount / 2 + 1);
    return UIEdgeInsetsMake(EDGE_TOP*2, space, EDGE_TOP*2, space);
}
//Mark: UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self.pageControl setCurrentPage:(int)(scrollView.contentOffset.x / scrollView.width)];
}

#pragma mark - Private Methods -
- (NSUInteger)p_transformIndex:(NSUInteger)index
{
    NSUInteger page = index / self.pageItemCount;
    index = index % self.pageItemCount;
    NSUInteger x = index / 2;
    NSUInteger y = index % 2;
    return self.pageItemCount / 2 * y + x + page * self.pageItemCount;
}

#pragma mark - # Getter
- (NSInteger)pageItemCount
{
    return (int)(WIDTH_SCREEN / (WIDTH_CELL * 1.3)) * 2;
}

@end
