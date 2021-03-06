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
    NSInteger numberOfRows = [self.dataSource numberOfRowsInDanmakuController:self];
    CGFloat lineSpacing = 0.f;
    if ([self.delegate respondsToSelector:@selector(lineSpacingInDanmakuController:)]) {
        lineSpacing = [self.delegate lineSpacingInDanmakuController:self];
    }

    // Create new belt views.
    NSMutableArray<PDDanmakuBeltView *> *beltViews = [NSMutableArray array];
    
    for (NSInteger i = 0; i < numberOfRows; i++) {
        PDDanmakuBeltView *beltView = [[PDDanmakuBeltView alloc] init];
        beltView.index = i;
        beltView.translatesAutoresizingMaskIntoConstraints = NO;
        beltView.dataSource = self;
        beltView.delegate = self;
        [self.view addSubview:beltView];
        [beltViews addObject:beltView];
        
        CGFloat heightForRow = [self.delegate heightForRowAtIndex:i inDanmakuController:self];
        
        [NSLayoutConstraint activateConstraints:@[
            [beltView.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:((lineSpacing + heightForRow) * i)],
            [beltView.leftAnchor constraintEqualToAnchor:self.view.leftAnchor],
            [beltView.heightAnchor constraintEqualToConstant:heightForRow],
            [beltView.rightAnchor constraintEqualToAnchor:self.view.rightAnchor constant:0.f],
        ]];
    }
    
    self.beltViews = [beltViews copy];
}

#pragma mark - Public Methods
- (void)receive:(PDDanmakuDataSource)dataSource {
    if (!dataSource) { return; }
    if (!self.isActive) {
        [self.bufferQueue enqueue:dataSource];
        return;
    }
    
    NSInteger index = self.index % self.beltViews.count;
    self.index++;

    PDDanmakuBeltView *beltView = self.beltViews[index];
    [beltView receive:dataSource];
}

- (void)resume {
    self.active = YES;
    
    while (self.bufferQueue.count > 0) {
        PDDanmakuDataSource dataSource = [self.bufferQueue dequeue];
        [self receive:dataSource];
    }
}

- (void)pause {
    self.active = NO;
    
    for (PDDanmakuBeltView *beltView in self.beltViews) {
        [beltView removeAllBuffer];
    }
}

- (void)removeAllBuffer {
    [self.bufferQueue removeAllNodes];
}

#pragma mark - PDDanmakuBeltViewDelegate && PDDanmakuBeltViewDataSource
- (void)didClickCell:(PDDanmakuItemCell *)cell inBeltView:(PDDanmakuBeltView *)beltView {
    if ([self.delegate respondsToSelector:@selector(didClickCell:inDanmakuController:)]) {
        [self.delegate didClickCell:cell inDanmakuController:self];
    }
}

- (PDDanmakuItemCell *)cellForDataSource:(PDDanmakuDataSource)dataSource inBeltView:(PDDanmakuBeltView *)beltView {
    return [self.dataSource cellForDataSource:dataSource inDanmakuController:self];
}

- (CGFloat)beltWidthForCell:(PDDanmakuItemCell *)cell {
    return CGRectGetWidth(self.view.bounds);
}

- (CGFloat)beltHeightForCell:(PDDanmakuItemCell *)cell inRow:(NSInteger)row {
    return [self.delegate heightForRowAtIndex:row inDanmakuController:self];
}

- (CGFloat)itemSpacingForCell:(PDDanmakuItemCell *)cell {
    if ([self.delegate respondsToSelector:@selector(itemSpacingInDanmakuController:)]) {
        return [self.delegate itemSpacingInDanmakuController:self];
    }
    return 20.f;
}

- (CGSize)sizeForCell:(PDDanmakuItemCell *)cell {
    return [self.delegate sizeForCell:cell inDanmakuController:self];
}

#pragma mark - Setter Methods
- (void)setDelegate:(id<PDDanmakuControllerDelegate>)delegate {
    _delegate = delegate;
    
    NSAssert([_delegate respondsToSelector:@selector(heightForRowAtIndex:inDanmakuController:)], @"The protocol method `- heightForRowAtIndex:inDanmakuController:` must be impl!");
    NSAssert([_delegate respondsToSelector:@selector(sizeForCell:inDanmakuController:)], @"The protocol method `- sizeForCell:inDanmakuController:` must be impl!");

    [self createLayoutBelts];
}

- (void)setDataSource:(id<PDDanmakuControllerDataSource>)dataSource {
    _dataSource = dataSource;
    
    NSAssert([_dataSource respondsToSelector:@selector(numberOfRowsInDanmakuController:)], @"The protocol method `- numberOfRowsInDanmakuController:`");
    NSAssert([_dataSource respondsToSelector:@selector(cellForDataSource:inDanmakuController:)], @"The protocol methods `- cellForDataSource:inDanmakuController:");
    
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
