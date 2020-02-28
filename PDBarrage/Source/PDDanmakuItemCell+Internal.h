
//
//  PDDanmakuItemCell+Internal.h
//  PDBarrage
//
//  Created by liang on 2020/2/28.
//  Copyright © 2020 PipeDog. All rights reserved.
//

#import "PDDanmakuItemCell.h"

NS_ASSUME_NONNULL_BEGIN

@class PDDanmakuItemCell;

@protocol PDDanmakuItemCellInternalDelegate <NSObject>

- (CGFloat)beltWidthForCell:(__kindof PDDanmakuItemCell *)cell;
- (CGFloat)beltHeightForCell:(__kindof PDDanmakuItemCell *)cell;
- (CGFloat)itemSpacingForCell:(__kindof PDDanmakuItemCell *)cell;

@end

@interface PDDanmakuItemCell ()

@property (nonatomic, weak) id<PDDanmakuItemCellInternalDelegate> internalDelegate;

- (void)launchWithCallnext:(void (^)(__kindof PDDanmakuItemCell *cell))callnext completion:(void (^ __nullable)(void))completion;

@end

NS_ASSUME_NONNULL_END
