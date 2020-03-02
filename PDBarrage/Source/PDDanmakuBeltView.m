//
//  PDDanmakuBeltView.m
//  PDBarrage
//
//  Created by liang on 2020/2/28.
//  Copyright © 2020 PipeDog. All rights reserved.
//

#import "PDDanmakuBeltView.h"
#import "PDDanmakuItemQueue.h"
#import "PDDanmakuItemCell+Internal.h"

@interface PDDanmakuBeltView ()

@property (nonatomic, strong) PDDanmakuItemQueue *queue;

@end

@implementation PDDanmakuBeltView

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commitInit];
    }
    return self;
}

- (void)commitInit {
    self.backgroundColor = [UIColor clearColor];
    _queue = [[PDDanmakuItemQueue alloc] init];
}

#pragma mark - Tool Methods
- (void)send {
    if (!self.queue.count) {
        return;
    }
    
    PDDanmakuDataSource dataSource = [self.queue head];
    PDDanmakuItemCell *danmakuItemCell = [self.dataSource danmakuBeltView:self cellForDataSource:dataSource];
    danmakuItemCell.internalDelegate = self.delegate;

    if (!danmakuItemCell) {
        [self.queue dequeue];
        [self send];
        return;
    }
    
    [self addSubview:danmakuItemCell];
    
    [danmakuItemCell launchWithCallnext:^(__kindof PDDanmakuItemCell * _Nonnull cell) {
        [self.queue dequeue];
        [self send];
    } completion:^{
        // Do nothing...
    }];
}

- (BOOL)touchesView:(UIView *)aView withPoint:(CGPoint)point {
    return ([aView isKindOfClass:[PDDanmakuItemCell class]] &&
            CGRectContainsPoint(aView.layer.presentationLayer.frame, point));
}

#pragma mark - Override Methods
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = touches.anyObject;
    CGPoint point = [touch locationInView:self];
    NSArray<UIView *> *subviews = [self.subviews copy];
    
    for (UIView *subview in subviews) {
        if (![self touchesView:subview withPoint:point]) {
            continue;
        }
        
        [self.delegate danmakuBeltView:self
                   didSelectItemInCell:(PDDanmakuItemCell *)subview];
        break;
    }
}

#pragma mark - Public Methods
- (void)receive:(PDDanmakuDataSource)dataSource {
    if (!dataSource) { return; }

    [self.queue enqueue:dataSource];

    if (!(self.queue.count > 1)) {
        [self send];
    }
}

- (void)removeAllItems {
    [self.queue removeAllItems];

    while (self.subviews.count > 0) {
        UIView *subview = self.subviews.lastObject;
        [subview removeFromSuperview];
    }
}

#pragma mark - Setter Methods
- (void)setDelegate:(id<PDDanmakuBeltViewDelegate>)delegate {
    _delegate = delegate;
    
    NSAssert([_delegate respondsToSelector:@selector(danmakuBeltView:didSelectItemInCell:)], @"The protocol methods `- danmakuBeltView:didSelectItemInCell:` must be impl!");
}

- (void)setDataSource:(id<PDDanmakuBeltViewDataSource>)dataSource {
    _dataSource = dataSource;
    
    NSAssert([_dataSource respondsToSelector:@selector(danmakuBeltView:cellForDataSource:)], @"The protocol methods `- danmakuBeltView:cellForDataSource:` must be impl!");
}

@end
