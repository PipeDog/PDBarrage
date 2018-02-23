//
//  PDBulletCell.h
//  PDBarrage
//
//  Created by liang on 2018/2/23.
//  Copyright © 2018年 PipeDog. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PDBulletCell;
@class PDBulletEntity;

NS_ASSUME_NONNULL_BEGIN

typedef void (^PDBulletCellFullyDisplayBlock)(PDBulletCell *cell);

@interface PDBulletCell : UIView

@property (nonatomic, assign) CGFloat velocity; // Movement speed.
@property (nonatomic, strong, readonly) PDBulletEntity *entity; // The binding information.

- (instancetype)initWithEntity:(PDBulletEntity *)entity;

- (void)animateWithFullyDisplayBlock:(PDBulletCellFullyDisplayBlock)block
                          completion:(void (^)(void))completion;

@end

NS_ASSUME_NONNULL_END
