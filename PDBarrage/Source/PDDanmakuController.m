//
//  PDDanmakuController.m
//  PDBarrage
//
//  Created by liang on 2020/2/28.
//  Copyright © 2020 PipeDog. All rights reserved.
//

#import "PDDanmakuController.h"
#import "PDDanmakuBeltView.h"
#import "PDDanmakuItemQueue.h"

@interface PDDanmakuController () <PDDanmakuBeltViewDelegate, PDDanmakuBeltViewDataSource>

@property (nonatomic, copy) NSArray<PDDanmakuBeltView *> *beltViews;
@property (nonatomic, assign) NSUInteger index;
@property (nonatomic, assign, getter=isActive) BOOL active;
@property (nonatomic, strong) PDDanmakuItemQueue *bufferQueue;

@end

@implementation PDDanmakuController

- (instancetype)init {
    self = [super init];
    if (self) {
        [self loadViewIfNeeded];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)createLayoutBelts {
    if (!self.delegate || !self.dataSource) {
        return;
    }
    
    // Remove old belt views
    for (PDDanmakuBeltView *beltView in self.beltViews) {
        [beltView removeFromSuperview];
    }
    
    _beltViews = nil;
    
    // Get values.
    NSInteger numberOfBelts = [self.dataSource numberOfBeltsInDanmakuController:self];
    CGFloat heightForBelt = [self.delegate heightForBeltInDanmakuController:self];
    CGFloat beltSpacing = 0.f;
    if ([self.delegate respondsToSelector:@selector(beltSpacingInDanmakuController:)]) {
        beltSpacing = [self.delegate beltSpacingInDanmakuController:self];
    }

    // Create new belt views.
    NSMutableArray<PDDanmakuBeltView *> *beltViews = [NSMutableArray array];
    
    for (NSInteger i = 0; i < numberOfBelts; i++) {
        PDDanmakuBeltView *beltView = [[PDDanmakuBeltView alloc] init];
        beltView.translatesAutoresizingMaskIntoConstraints = NO;
        beltView.dataSource = self;
        beltView.delegate = self;
        [self.view addSubview:beltView];
        [beltViews addObject:beltView];
                
        [NSLayoutConstraint activateConstraints:@[
            [beltView.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:((beltSpacing + heightForBelt) * i)],
            [beltView.leftAnchor constraintEqualToAnchor:self.view.leftAnchor],
            [beltView.heightAnchor constraintEqualToConstant:heightForBelt],
            [beltView.rightAnchor constraintEqualToAnchor:self.view.rightAnchor constant:0.f],
        ]];
    }
    
    self.beltViews = [beltViews copy];
}

#pragma mark - Public Methods
- (void)receiveItem:(PDDanmakuItem)item {
    if (!item) { return; }
    if (!self.isActive) {
        [self.bufferQueue enqueue:item];
        return;
    }
    
    NSInteger index = self.index % self.beltViews.count;
    self.index++;

    PDDanmakuBeltView *beltView = self.beltViews[index];
    [beltView receiveItem:item];    
}

- (void)start {
    self.active = YES;
    
    while (self.bufferQueue.count > 0) {
        PDDanmakuItem item = [self.bufferQueue dequeue];
        [self receiveItem:item];
    }
}

- (void)stop {
    self.active = NO;
    
    for (PDDanmakuBeltView *beltView in self.beltViews) {
        [beltView removeAllItems];
    }
}

- (void)removeAllBuffer {
    [self.bufferQueue removeAllItems];
}

#pragma mark - PDDanmakuBeltViewDelegate && PDDanmakuBeltViewDataSource
- (void)danmakuBeltView:(PDDanmakuBeltView *)danmakuBeltView didSelectItemInCell:(PDDanmakuItemCell *)cell {
    if ([self.delegate respondsToSelector:@selector(danmakuController:didSelectItemInCell:)]) {
        [self.delegate danmakuController:self didSelectItemInCell:cell];
    }
}

- (PDDanmakuItemCell *)danmakuBeltView:(PDDanmakuBeltView *)danmakuBeltView cellForItem:(PDDanmakuItem)item {
    return [self.dataSource danmakuController:self cellForItem:item];
}

- (CGFloat)beltWidthForCell:(__kindof PDDanmakuItemCell *)cell {
    return CGRectGetWidth(self.view.bounds);
}

- (CGFloat)beltHeightForCell:(__kindof PDDanmakuItemCell *)cell {
    return [self.delegate heightForBeltInDanmakuController:self];
}

- (CGFloat)itemSpacingForCell:(__kindof PDDanmakuItemCell *)cell {
    return [self.delegate itemSpacingInDanmakuController:self];
}

#pragma mark - Setter Methods
- (void)setDelegate:(id<PDDanmakuControllerDelegate>)delegate {
    _delegate = delegate;
    [self createLayoutBelts];
}

- (void)setDataSource:(id<PDDanmakuControllerDataSource>)dataSource {
    _dataSource = dataSource;
    [self createLayoutBelts];
}

#pragma mark - Getter Methods
- (PDDanmakuItemQueue *)bufferQueue {
    if (!_bufferQueue) {
        _bufferQueue = [[PDDanmakuItemQueue alloc] init];
    }
    return _bufferQueue;
}

@end
