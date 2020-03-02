//
//  PDDanmakuBeltView.h
//  PDBarrage
//
//  Created by liang on 2020/2/28.
//  Copyright © 2020 PipeDog. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDDanmakuItemCell+Internal.h"

NS_ASSUME_NONNULL_BEGIN

@protocol PDDanmakuBeltViewDelegate, PDDanmakuBeltViewDataSource;

@interface PDDanmakuBeltView : UIView

@property (nonatomic, weak) id<PDDanmakuBeltViewDelegate> delegate;
@property (nonatomic, weak) id<PDDanmakuBeltViewDataSource> dataSource;

- (void)receive:(PDDanmakuDataSource)dataSource;
- (void)removeAllItems;

@end

@protocol PDDanmakuBeltViewDelegate <PDDanmakuItemCellInternalDelegate>

- (void)danmakuBeltView:(PDDanmakuBeltView *)danmakuBeltView didSelectItemInCell:(PDDanmakuItemCell *)cell;

@end

@protocol PDDanmakuBeltViewDataSource <NSObject>

- (__kindof PDDanmakuItemCell *)danmakuBeltView:(PDDanmakuBeltView *)danmakuBeltView cellForDataSource:(PDDanmakuDataSource)dataSource;

@end

NS_ASSUME_NONNULL_END
