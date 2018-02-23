//
//  PDBulletController.m
//  PDBarrage
//
//  Created by liang on 2018/2/23.
//  Copyright © 2018年 PipeDog. All rights reserved.
//

#import "PDBulletController.h"
#import "PDTrajectoryView.h"
#import "PDBulletEntity.h"
#import "PDCustomMacro.h"
#import <Masonry/Masonry.h>

NSString *const PDBulletControllerTouchBulletNotification = @"PDBulletControllerTouchBulletNotification";
CGFloat const PDBulletControllerTrajectoryViewHeight = 27.f;

typedef NS_ENUM(NSUInteger, PDBulletStatus) {
    PDBulletStatusHide = 0,
    PDBulletStatusShow = 1,
};

static NSInteger const kTrajectoryViewTag = 1000000;

@interface PDBulletController ()

@property (nonatomic, assign) NSInteger trajectoryNumber;
@property (nonatomic, assign) PDBulletStatus bulletStatus;
@property (nonatomic, assign) PDBulletStatus originalBulletStatus;
// The history message saved when the bullet screen is closed.
@property (nonatomic, strong) NSMutableArray<PDBulletEntity *> *messageQueue;

@end

@implementation PDBulletController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor clearColor];
    [self configParams];
}

- (void)configParams {
    self.bulletStatus = PDBulletStatusShow;
    self.originalBulletStatus = self.bulletStatus;
    self.trajectoryNumber = 0;
}

- (void)receiveMessage:(PDBulletEntity *)message {
    if (self.bulletStatus == PDBulletStatusShow) {
        PDTrajectoryView *trajectoryView = [self.view viewWithTag:kTrajectoryViewTag + self.trajectoryNumber];
        [trajectoryView receiveMessage:message];
        self.trajectoryNumber += 1;
        self.trajectoryNumber %= self.trajectoryCount;
    } else {
        [self.messageQueue addObject:message];
    }
}

#pragma mark - Manage Bullet Methods
- (void)start {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.bulletStatus = PDBulletStatusShow;
        if (self.messageQueue.count == 0) return;

        for (PDBulletEntity *obj in self.messageQueue) {
            [self receiveMessage:obj];
        }
        [self.messageQueue removeAllObjects];
    });
}

- (void)stop {
    self.bulletStatus = PDBulletStatusHide;
    self.trajectoryNumber = 0;
    
    for (int i = 0; i < self.trajectoryCount; i += 1) {
        PDTrajectoryView *trajectoryView = [self.view viewWithTag:kTrajectoryViewTag + i];
        while (trajectoryView.subviews.count > 0) {
            UIView *bulletView = trajectoryView.subviews.lastObject;
            PDRelease_UIView(bulletView);
        }
    }
}

#pragma mark - Setter Methods
- (void)setTrajectoryCount:(NSInteger)trajectoryCount {
    _trajectoryCount = trajectoryCount;
    
    while (self.view.subviews.count > 0) {
        UIView *subview = self.view.subviews.lastObject;
        PDRelease_UIView(subview);
    }
    for (int i = 0; i < self.trajectoryCount; i += 1) {
        PDTrajectoryView *trajectoryView = [[PDTrajectoryView alloc] init];
        trajectoryView.tag = kTrajectoryViewTag + i;
        [self.view addSubview:trajectoryView];
        
        [trajectoryView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.equalTo(self.view);
            make.height.mas_equalTo(PDBulletControllerTrajectoryViewHeight);
            make.top.mas_equalTo(i * PDBulletControllerTrajectoryViewHeight);
        }];
    }
}

#pragma mark - Getter Methods
- (NSMutableArray<PDBulletEntity *> *)messageQueue {
    if (!_messageQueue) {
        _messageQueue = [NSMutableArray array];
    }
    return _messageQueue;
}

@end
