
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

- (CGFloat)beltWidthForCell:(PDDanmakuItemCell *)cell;
- (CGFloat)beltHeightForCell:(PDDanmakuItemCell *)cell inRow:(NSInteger)row;
- (CGFloat)itemSpacingForCell:(PDDanmakuItemCell *)cell;
- (CGSize)sizeForCell:(PDDanmakuItemCell *)cell;

@end

@interface PDDanmakuItemCell ()

@property (nonatomic, weak) id<PDDanmakuItemCellInternalDelegate> internalDelegate;
@property (nonatomic, assign) NSInteger row; // Default -1

- (void)launchWithCallnext:(void (^)(__kindof PDDanmakuItemCell *cell))callnext completion:(void (^ __nullable)(void))completion;

@end

NS_ASSUME_NONNULL_END
