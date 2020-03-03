//
//  PDDanmakuItemCell.m
//  PDBarrage
//
//  Created by liang on 2020/2/28.
//  Copyright © 2020 PipeDog. All rights reserved.
//

#import "PDDanmakuItemCell.h"
#import "PDDanmakuItemCell+Internal.h"
#import "CADisplayLink+PDAdd.h"

CGFloat const PDDanmakuItemCellMoveVelocityDefaultValue = 120.f;

@interface PDDanmakuItemCell () <PDCADisplayLinkDelegate>

@property (nonatomic, copy) void (^callnext)(__kindof PDDanmakuItemCell *);
@property (nonatomic, copy) void (^completion)(void);

@end

@implementation PDDanmakuItemCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _velocity = PDDanmakuItemCellMoveVelocityDefaultValue;
        _position = PDDanmakuItemCellPositionCenterY;
        _row = -1;
    }
    return self;
}

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (void)launchWithCallnext:(void (^)(__kindof PDDanmakuItemCell * _Nonnull))callnext completion:(void (^)(void))completion {
    self.callnext = callnext;
    self.completion = completion;
    
    CGFloat beltHeight = [self.internalDelegate beltHeightForCell:self inRow:self.row];
    CGFloat beltWidth = [self.internalDelegate beltWidthForCell:self];
    CGSize size = [self.internalDelegate sizeForCell:self];
    CGFloat moveDistance = size.width + beltWidth;
    NSTimeInterval duration = moveDistance / self.velocity;
    
    // Calculate frame.
    CGFloat top = 0.f;
    
    switch (self.position) {
        case PDDanmakuItemCellPositionTop: {
            top = 0.f;
        } break;
        case PDDanmakuItemCellPositionCenterY: {
            top = (beltHeight - size.height) / 2.f;
        } break;
        case PDDanmakuItemCellPositionBottom: {
            top = (beltHeight - size.height);
        } break;
        default: break;
    }
    
    CGRect beginRect = CGRectMake(beltWidth,
                                  top,
                                  size.width,
                                  size.height);
    CGRect endRect = CGRectMake(-size.width,
                                top,
                                size.width,
                                size.height);
    
    // Launch danmaku cell.
    self.frame = beginRect;
    [self fire];
    
    UIViewAnimationOptions options = (UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction);
    [UIView animateWithDuration:duration delay:0.f options:options animations:^{
        self.frame = endRect;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        !completion ?: completion();
    }];
}

- (void)fire {
    [CADisplayLink bind:self];
}

- (void)invalid {
    [CADisplayLink unbind:self];
}

#pragma mark - PDCADisplayLinkDelegate
- (void)tick:(CADisplayLink *)displayLink {
    CGFloat beltWidth = [self.internalDelegate beltWidthForCell:self];
    CGFloat itemSpacing = [self.internalDelegate itemSpacingForCell:self];
    CGFloat threshold = beltWidth - itemSpacing;
    CGFloat right = CGRectGetMaxX(self.layer.presentationLayer.frame);

    if (right >= threshold) {
        return;
    }
    
    [self invalid];
    !self.callnext ?: self.callnext(self);
}

@end
