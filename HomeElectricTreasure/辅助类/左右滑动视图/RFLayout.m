//
//  RFLayout.m
//  RFCircleCollectionView
//
//  Created by Arvin on 15/11/25.
//  Copyright © 2015年 mobi.refine. All rights reserved.
//

#import "RFLayout.h"
#import "XZMRefresh.h"

#define ACTIVE_DISTANCE 200
#define ZOOM_FACTOR 0.04
#define kScreen_Height      ([UIScreen mainScreen].bounds.size.height)
#define kScreen_Width       ([UIScreen mainScreen].bounds.size.width)


@implementation RFLayout

-(id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}
/**
 * 用来做布局的初始化操作（不建议在init方法中进行布局的初始化操作）
 */
- (void)prepareLayout
{
    [super prepareLayout];
    CGFloat height;
    if (SCREEN_WIDTH ==320) {
        height = 155;
    }else if(SCREEN_WIDTH == 375){
        height = 200;
    }else if(SCREEN_WIDTH == 414){
        height = 245;
    }
    self.itemSize = CGSizeMake(SCREEN_WIDTH, height);
    self.minimumLineSpacing = 0;
    // 水平滚动
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    CGFloat inset = 0;
    /** 设置内边距 */
    self.sectionInset = UIEdgeInsetsMake(15, inset, 30, inset);
}
//-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect
//{
//    NSArray* array = [super layoutAttributesForElementsInRect:rect];
//    CGRect visibleRect;
//    visibleRect.origin = self.collectionView.contentOffset;
//    visibleRect.size = self.collectionView.bounds.size;
//    
//    for (UICollectionViewLayoutAttributes* attributes in array) {
//        if (CGRectIntersectsRect(attributes.frame, rect)) {
//            CGFloat distance = CGRectGetMidX(visibleRect) - attributes.center.x;
//            
//            distance = ABS(distance);
//            
//            if (distance < kScreen_Width / 2 + self.itemSize.width) {
//                CGFloat zoom = 1 + ZOOM_FACTOR * (1 - distance / ACTIVE_DISTANCE);
//                NSLog(@"state:%d",self.myCollectionView.xzm_header.state);
//                NSLog(@"contentOffset:%f",self.myCollectionView.contentOffset.x);
//                if(self.myCollectionView.xzm_header.state==XZMRefreshStateNormal && self.myCollectionView.contentOffset.x>0){
//                    attributes.transform3D = CATransform3DMakeScale(zoom, zoom, 1.0);
//                    //                attributes.transform3D = CATransform3DTranslate(attributes.transform3D, 0 , 0, 0);
//                    attributes.alpha = zoom - ZOOM_FACTOR;
//                }else{
//                }
//                
//            }
//            
//        }
//    }
//    
//    return array;
//}
/**
 UICollectionViewLayoutAttributes *attrs;
 1.一个cell对应一个UICollectionViewLayoutAttributes对象
 2.UICollectionViewLayoutAttributes对象决定了cell的frame
 */
/**
 * 这个方法的返回值是一个数组（数组里面存放着rect范围内所有元素的布局属性）
 * 这个方法的返回值决定了rect范围内所有元素的排布（frame）
 */
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    // 获得super已经计算好的布局属性
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    
    // 计算collectionView最中心点的x值
 //   CGFloat centerX = self.collectionView.contentOffset.x + self.collectionView.frame.size.width * 0.5;
    
    // 在原有布局属性的基础上，进行微调
    for (UICollectionViewLayoutAttributes *attrs in array) {
        if(self.myCollectionView.xzm_header.state==XZMRefreshStateNormal && self.myCollectionView.contentOffset.x>0){
        // cell的中心点x 和 collectionView最中心点的x值 的间距
 //       CGFloat delta = ABS(attrs.center.x - centerX);
        
        // 根据间距值 计算 cell的缩放比例
            CGFloat scale = 1; //- delta / self.collectionView.frame.size.width * 0.15;
        
        // 设置缩放比例
        attrs.transform = CGAffineTransformMakeScale(scale, scale);
        }
    }
    
    return array;
}


//- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
//{
//    CGFloat offsetAdjustment = MAXFLOAT;
//    CGFloat horizontalCenter = proposedContentOffset.x + (CGRectGetWidth(self.collectionView.bounds) / 2.0);
//    
//    CGRect targetRect = CGRectMake(proposedContentOffset.x, 0.0, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
//    NSArray* array = [super layoutAttributesForElementsInRect:targetRect];
//    
//    for (UICollectionViewLayoutAttributes* layoutAttributes in array) {
//        CGFloat itemHorizontalCenter = layoutAttributes.center.x;
//        if (ABS(itemHorizontalCenter - horizontalCenter) < ABS(offsetAdjustment)) {
//            offsetAdjustment = itemHorizontalCenter - horizontalCenter;
//        }
//        break ;//只循环数组中第一个元素即可，所以直接break了
//    }
//    return CGPointMake(proposedContentOffset.x + offsetAdjustment, proposedContentOffset.y);
//}
/**
 * 这个方法的返回值，就决定了collectionView停止滚动时的偏移量
 */
//- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
//{
//    // 计算出最终显示的矩形框
//    CGRect rect;
////    rect.origin.y = 0;
//    rect.origin = proposedContentOffset;
//    rect.size = self.collectionView.frame.size;
//    
//    // 获得super已经计算好的布局属性
//    NSArray *array = [super layoutAttributesForElementsInRect:rect];
//    
//    // 计算collectionView最中心点的x值
//    CGFloat centerX = proposedContentOffset.x + self.collectionView.frame.size.width * 0.5;
//    
//    // 存放最小的间距值
//    CGFloat minDelta = MAXFLOAT;
//    for (UICollectionViewLayoutAttributes *attrs in array) {
//        if (ABS(minDelta) > ABS(attrs.center.x - centerX)) {
//            minDelta = attrs.center.x - centerX;
//        }
//    }
//    
//    // 修改原有的偏移量
//    proposedContentOffset.x += minDelta;
//    return proposedContentOffset;
//}
//-(CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
//{
//    //1.计算scrollview最后停留的范围
//    CGRect lastRect ;
//    lastRect.origin = proposedContentOffset;
//    lastRect.size = self.collectionView.frame.size;
//    
//    //2.取出这个范围内的所有属性
//    NSArray *array = [self layoutAttributesForElementsInRect:lastRect];
//    
//    //起始的x值，也即默认情况下要停下来的x值
//    CGFloat startX = proposedContentOffset.x;
//    
//    //3.遍历所有的属性
//    CGFloat adjustOffsetX = MAXFLOAT;
//    for (UICollectionViewLayoutAttributes *attrs in array) {
//        CGFloat attrsX = CGRectGetMinX(attrs.frame);
//        CGFloat attrsW = CGRectGetWidth(attrs.frame) ;
//        
//        if (startX - attrsX  < attrsW/2) {
//            adjustOffsetX = -(startX - attrsX+15);
//        }else{
//            adjustOffsetX = attrsW - (startX - attrsX);
//        }
//        
//        
//    }
//    return CGPointMake(proposedContentOffset.x + adjustOffsetX, proposedContentOffset.y);
//}
@end
