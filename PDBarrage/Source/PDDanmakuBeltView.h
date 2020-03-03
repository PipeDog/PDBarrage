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
@property (nonatomic, assign) NSInteger index;

- (void)receive:(PDDanmakuDataSource)dataSource;
- (void)removeAllBuffer;

@end

@protocol PDDanmakuBeltViewDelegate <PDDanmakuItemCellInternalDelegate>

- (void)didClickCell:(PDDanmakuItemCell *)cell inBeltView:(PDDanmakuBeltView *)beltView;

@end

@protocol PDDanmakuBeltViewDataSource <NSObject>

- (__kindof PDDanmakuItemCell *)cellForDataSource:(PDDanmakuDataSource)dataSource inBeltView:(PDDanmakuBeltView *)beltView;

@end

NS_ASSUME_NONNULL_END
