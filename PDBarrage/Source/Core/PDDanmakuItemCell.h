//
//  PDDanmakuItemCell.h
//  PDBarrage
//
//  Created by liang on 2020/2/28.
//  Copyright © 2020 PipeDog. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT CGFloat const PDDanmakuItemCellMoveVelocityDefaultValue; ///< 120.f per seconds.

typedef id PDDanmakuItem;

typedef NS_ENUM(NSUInteger, PDDanmakuItemCellPosition) {
    PDDanmakuItemCellPositionTop     = 0,
    PDDanmakuItemCellPositionCenterY = 1,
    PDDanmakuItemCellPositionBottom  = 2,
};

@interface PDDanmakuItemCell : UIView

@property (nonatomic, strong, nullable) PDDanmakuItem item;
@property (nonatomic, assign) CGFloat velocity; // Default PDDanmakuItemCellMoveVelocityDefaultValue
@property (nonatomic, assign) CGSize contentSize; // Default CGSizeZero
@property (nonatomic, assign) PDDanmakuItemCellPosition position; // Default PDDanmakuItemCellPositionCenterY

@end

NS_ASSUME_NONNULL_END
