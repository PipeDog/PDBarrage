//
//  PDDanmakuItemQueue.m
//  PDBarrage
//
//  Created by liang on 2020/2/28.
//  Copyright © 2020 PipeDog. All rights reserved.
//

#import "PDDanmakuItemQueue.h"

@implementation PDDanmakuItemQueue {
    NSMutableArray *_holder;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _holder = [NSMutableArray array];
    }
    return self;
}

#pragma mark - Public Methods
- (void)enqueue:(PDDanmakuDataSource)node {
    if (node) {
        [_holder addObject:node];
    }
}

- (id)dequeue {
    if (!_holder.count) {
        return nil;
    }

    id item = _holder.firstObject;
    [_holder removeObjectAtIndex:0];
    return item;
}

- (PDDanmakuDataSource)head {
    if (!_holder.count) {
        return nil;
    }
    return _holder.firstObject;
}

- (PDDanmakuDataSource)tail {
    if (!_holder.count) {
        return nil;
    }
    return _holder.lastObject;
}

- (NSUInteger)count {
    return _holder.count;
}

- (BOOL)isEmpty {
    return !(_holder.count > 0);
}

- (void)removeAllNodes {
    [_holder removeAllObjects];
}

@end
