//
//  PDBulletEntity.h
//  PDBarrage
//
//  Created by liang on 2018/2/23.
//  Copyright © 2018年 PipeDog. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDBulletEntity : NSObject

@property (nonatomic, copy) NSString *text;
// Valid format: #RGB #RGBA #RRGGBB #RRGGBBAA 0xRGB ...
@property (nonatomic, copy) NSString *backgroundColorValue;
@property (nonatomic, copy) NSString *textColorValue;

@property (nonatomic, strong, readonly) UIColor *backgroundColor;
@property (nonatomic, strong, readonly) UIColor *textColor;

@end
