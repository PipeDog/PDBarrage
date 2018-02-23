//
//  PDBulletCell.m
//  PDBarrage
//
//  Created by liang on 2018/2/23.
//  Copyright © 2018年 PipeDog. All rights reserved.
//

#import "PDBulletCell.h"
#import "PDBulletEntity.h"
#import "UIView+PDAdd.h"
#import "CALayer+PDAdd.h"
#import "PDCustomMacro.h"
#import "UILabel+PDAdd.h"

static NSInteger const kFontSize = 13;

static CGFloat const kPadding = 10;
static CGFloat const kHeight = 22;
// The default speed is 120 pixels per second.
static CGFloat const kDefaultVelocity = 120;
static CGFloat const kBulletSpacing = 30.f;

@interface PDBulletCell ()

@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, copy) PDBulletCellFullyDisplayBlock fullyDisplayBlock;

@end

@implementation PDBulletCell

- (instancetype)initWithEntity:(PDBulletEntity *)entity {
    self = [super init];
    if (self) {
        _entity = entity;
        [self configParams];
        [self configUI];
    }
    return self;
}

- (void)configParams {
    _velocity = kDefaultVelocity;
}

- (void)configUI {
    NSString *text = STR_SAFE(self.entity.text);
    UIFont *font = [UIFont systemFontOfSize:kFontSize];
    NSDictionary *attributes = @{NSFontAttributeName: font};
    CGFloat textWidth = ceil([text sizeWithAttributes:attributes].width);
    
    // Config self.
    self.clipsToBounds = YES;
    self.layer.cornerRadius = kHeight / 2.f;
    self.backgroundColor = self.entity.backgroundColor;
    self.layer.contentsScale = [UIScreen mainScreen].scale;
    
    self.left = [self trajectoryWidth];
    self.size = CGSizeMake(textWidth + 2 * kPadding, kHeight);
    
    // Config label.
    self.textLabel = [UILabel building:self
                       backgroundColor:[UIColor clearColor]
                                  font:[UIFont systemFontOfSize:kFontSize]
                             textColor:self.entity.textColor
                         textAlignment:NSTextAlignmentLeft
                         numberOfLines:1];
    self.textLabel.layer.contentsScale = [UIScreen mainScreen].scale;
    self.textLabel.text = text;
    self.textLabel.frame = CGRectMake(kPadding, 0, textWidth, kHeight);
}

#pragma mark - Animation Methods
- (void)animateWithFullyDisplayBlock:(PDBulletCellFullyDisplayBlock)block completion:(void (^)(void))completion {
    self.fullyDisplayBlock = block;
    
    CGFloat animationWidth = [self trajectoryWidth] + self.width;
    NSTimeInterval duration = animationWidth / self.velocity;
    
    [self startObserver];
    
    UIViewAnimationOptions options = (UIViewAnimationOptionCurveLinear |
                                      UIViewAnimationOptionAllowUserInteraction);
    [UIView animateWithDuration:duration delay:0 options:options animations:^{
        self.right = 0;
    } completion:^(BOOL finished) {
        PDRelease_UIView(self.textLabel);
        [self removeFromSuperview];
        BLOCK_EXE(completion);
    }];
}

#pragma mark - Observer Methods
- (void)startObserver {
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkReload:)];
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)stopObserver {
    [self.displayLink invalidate];
    self.displayLink = nil;
}

- (void)displayLinkReload:(CADisplayLink *)displayLink {
    CGFloat layerRight = self.layer.presentationLayer.right;
    CGFloat referRight = [self trajectoryWidth] - kBulletSpacing;
    
    if (!layerRight) return;
    if (layerRight >= referRight) return;
    
    [self stopObserver];
    BLOCK_EXE(self.fullyDisplayBlock, self);
}

#pragma mark - Setter Methods
- (void)setVelocity:(CGFloat)velocity {
    if (velocity > 0) _velocity = velocity;
}

#pragma mark - Trajectory width
- (CGFloat)trajectoryWidth {
    return MAX(PDScreenWidth, PDScreenHeight);
}

@end
