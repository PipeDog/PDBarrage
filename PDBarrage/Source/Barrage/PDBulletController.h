//
//  PDBulletController.h
//  PDBarrage
//
//  Created by liang on 2018/2/23.
//  Copyright © 2018年 PipeDog. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PDBulletEntity;

// Click on the bullet screen notification.
FOUNDATION_EXTERN NSString *const PDBulletControllerTouchBulletNotification;
// Trajectory height.
FOUNDATION_EXTERN CGFloat const PDBulletControllerTrajectoryViewHeight;

@interface PDBulletController : UIViewController

@property (nonatomic, assign) NSInteger trajectoryCount; // Count of trajectories.

- (void)start; // Start showing the barrage, including the barrage that was not shown before.
- (void)stop; // Stop showing the barrage, the received information is stored in the queue.

- (void)receiveMessage:(PDBulletEntity *)message;

@end
