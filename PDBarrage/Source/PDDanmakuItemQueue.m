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
- (void)enqueue:(PDDanmakuItem)item {
    if (item) {
        [_holder addObject:item];
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

- (PDDanmakuItem)head {
    if (!_holder.count) {
        return nil;
    }
    return _holder.firstObject;
}

- (PDDanmakuItem)tail {
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

- (void)removeAllItems {
    [_holder removeAllObjects];
}

@end
