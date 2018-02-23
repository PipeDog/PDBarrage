//
//  PDTrajectoryView.m
//  PDBarrage
//
//  Created by liang on 2018/2/23.
//  Copyright © 2018年 PipeDog. All rights reserved.
//

#import "PDTrajectoryView.h"
#import "PDBulletEntity.h"
#import "PDBulletController.h"
#import "PDBulletCell.h"
#import "CALayer+PDAdd.h"
#import "PDCustomMacro.h"
#import "UIView+PDAdd.h"

static inline CGRect ConvertRect(CGRect rect, UIEdgeInsets edgeInsets) {
    return CGRectMake(rect.origin.x + edgeInsets.left,
                      rect.origin.y + edgeInsets.top,
                      rect.size.width - edgeInsets.left + edgeInsets.right,
                      rect.size.height - edgeInsets.top + edgeInsets.bottom);
}

@interface PDTrajectoryView ()

@property (nonatomic, strong) NSMutableArray<PDBulletEntity *> *displayingQueue;
@property (nonatomic, strong) NSMutableArray<PDBulletEntity *> *willDisplayQueue;

@end

@implementation PDTrajectoryView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self configUI];
    }
    return self;
}

- (void)configUI {
    self.backgroundColor = [UIColor clearColor];
}

#pragma mark - Touch Event Methods
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = touches.anyObject;
    CGPoint point = [touch locationInView:self];
    NSArray <UIView *>*subviews = [self.subviews copy];
    
    for (UIView *subview in subviews) {
        if (![subview isKindOfClass:[PDBulletCell class]]) continue;

        // Gets the current screen position and expands the click range.
        CALayer *layer = subview.layer.presentationLayer;
        UIEdgeInsets edgeInsets = {-4, 0, 6, 0};
        CGRect rect = ConvertRect(layer.frame, edgeInsets);
        
        if (CGRectContainsPoint(rect, point)) {
            PDBulletCell *cell = (PDBulletCell *)subview;
            [[NSNotificationCenter defaultCenter] postNotificationName:PDBulletControllerTouchBulletNotification object:cell.entity];
            break;
        }
    }
}

#pragma mark - Receive Message Methods
- (void)receiveMessage:(PDBulletEntity *)message {
    if (!message) return;

    if (self.displayingQueue.count < 1) {
        [self.displayingQueue addObject:message];
        [self sendBulletWithVelocity:0];
    } else {
        [self.willDisplayQueue addObject:message];
    }
}

- (void)sendBulletWithVelocity:(CGFloat)velocity {
    if (self.displayingQueue.count > 0) {
        PDBulletEntity *entity = self.displayingQueue.lastObject;
                
        __block PDBulletCell *cell = [[PDBulletCell alloc] initWithEntity:entity];
        cell.top = 0;
        cell.velocity = velocity;
        [self addSubview:cell];
        
        typeof(self) __weak weakSelf = self;
        [cell animateWithFullyDisplayBlock:^(PDBulletCell * _Nonnull cell) {
            typeof(weakSelf) __strong strongSelf = weakSelf;
            if (!strongSelf) return;

            if (strongSelf.displayingQueue.count > 0) {
                [strongSelf.displayingQueue removeObjectAtIndex:0];
            }
            if (strongSelf.willDisplayQueue.count > 0) {
                PDBulletEntity *willDisplayEntity = self.willDisplayQueue.firstObject;
                [strongSelf.willDisplayQueue removeObject:willDisplayEntity];
                [strongSelf.displayingQueue addObject:willDisplayEntity];
                [strongSelf sendBulletWithVelocity:cell.velocity];
            }
        } completion:^{
            PDRelease_UIView(cell);
        }];
    }
}

#pragma mark - Getter Methods
- (NSMutableArray<PDBulletEntity *> *)displayingQueue {
    if (!_displayingQueue) {
        _displayingQueue = [NSMutableArray array];
    }
    return _displayingQueue;
}

- (NSMutableArray<PDBulletEntity *> *)willDisplayQueue {
    if (!_willDisplayQueue) {
        _willDisplayQueue = [NSMutableArray array];
    }
    return _willDisplayQueue;
}

@end
