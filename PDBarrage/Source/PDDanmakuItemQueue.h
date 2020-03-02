//
//  PDDanmakuItemQueue.h
//  PDBarrage
//
//  Created by liang on 2020/2/28.
//  Copyright © 2020 PipeDog. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PDDanmakuItemCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface PDDanmakuItemQueue : NSObject

@property (nonatomic, assign, readonly) NSUInteger count;
@property (nonatomic, assign, readonly, getter=isEmpty) BOOL empty;

- (void)enqueue:(PDDanmakuDataSource)node;
- (nullable PDDanmakuDataSource)dequeue;

- (nullable PDDanmakuDataSource)head;
- (nullable PDDanmakuDataSource)tail;

- (void)removeAllItems;

@end

NS_ASSUME_NONNULL_END
