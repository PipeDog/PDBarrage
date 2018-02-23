//
//  CALayer+PDAdd.h
//  PDBarrage
//
//  Created by liang on 2018/2/23.
//  Copyright © 2018年 PipeDog. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CALayer (PDAdd)

@property (nonatomic, assign) CGFloat top;

@property (nonatomic, assign) CGFloat bottom;

@property (nonatomic, assign) CGFloat left;

@property (nonatomic, assign) CGFloat right;

@property (nonatomic, assign) CGFloat width;

@property (nonatomic, assign) CGFloat height;

@property (nonatomic, assign) CGFloat centerX;

@property (nonatomic, assign) CGFloat centerY;

@property (nonatomic, assign) CGSize size;

@property (nonatomic, assign) CGPoint origin;

@end
