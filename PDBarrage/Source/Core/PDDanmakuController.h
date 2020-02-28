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

- (void)receiveItem:(PDDanmakuItem)item;

- (void)start;
- (void)stop;

- (void)removeAllBuffer;

@end

@protocol PDDanmakuControllerDataSource <NSObject>

- (NSInteger)numberOfBeltsInDanmakuController:(PDDanmakuController *)danmakuController;
- (__kindof PDDanmakuItemCell *)danmakuController:(PDDanmakuController *)danmakuController cellForItem:(PDDanmakuItem)item;

@end

@protocol PDDanmakuControllerDelegate <NSObject>

- (CGFloat)heightForBeltInDanmakuController:(PDDanmakuController *)danmakuController;

@optional
- (CGFloat)beltSpacingInDanmakuController:(PDDanmakuController *)danmakuController;
- (CGFloat)itemSpacingInDanmakuController:(PDDanmakuController *)danmakuController;
- (void)danmakuController:(PDDanmakuController *)danmakuController didSelectItemInCell:(__kindof PDDanmakuItemCell *)cell;

@end

NS_ASSUME_NONNULL_END
