//
//  PDTrajectoryView.h
//  PDBarrage
//
//  Created by liang on 2018/2/23.
//  Copyright © 2018年 PipeDog. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PDBulletEntity;

@interface PDTrajectoryView : UIView

- (void)receiveMessage:(PDBulletEntity *)message;

@end
