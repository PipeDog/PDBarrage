//
//  PDDanmakuController.h
//  PDBarrage
//
//  Created by liang on 2020/2/28.
//  Copyright © 2020 PipeDog. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDDanmakuItemCell.h"

NS_ASSUME_NONNULL_BEGIN

@protocol PDDanmakuControllerDataSource, PDDanmakuControllerDelegate;

@interface PDDanmakuController : UIViewController

@property (nonatomic, weak) id<PDDanmakuControllerDataSource> dataSource;
@property (nonatomic, weak) id<PDDanmakuControllerDelegate> delegate;

- (void)receive:(PDDanmakuDataSource)dataSource;

- (void)start;
- (void)stop;

- (void)removeAllBuffer;

@end

@protocol PDDanmakuControllerDataSource <NSObject>

- (NSInteger)numberOfBeltsInDanmakuController:(PDDanmakuController *)danmakuController;

- (__kindof PDDanmakuItemCell *)cellForDataSource:(PDDanmakuDataSource)dataSource inDanmakuController:(PDDanmakuController *)danmakuController;

@end

@protocol PDDanmakuControllerDelegate <NSObject>

- (CGFloat)heightForBeltInDanmakuController:(PDDanmakuController *)danmakuController;
- (CGSize)sizeForCell:(PDDanmakuItemCell *)cell inDanmakuController:(PDDanmakuController *)danmakuController;

@optional
- (CGFloat)beltSpacingInDanmakuController:(PDDanmakuController *)danmakuController;
- (CGFloat)itemSpacingInDanmakuController:(PDDanmakuController *)danmakuController;
- (void)didClickCell:(__kindof PDDanmakuItemCell *)cell inDanmakuController:(PDDanmakuController *)danmakuController;

@end

NS_ASSUME_NONNULL_END
