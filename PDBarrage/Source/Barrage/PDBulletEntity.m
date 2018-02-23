//
//  PDBulletEntity.m
//  PDBarrage
//
//  Created by liang on 2018/2/23.
//  Copyright © 2018年 PipeDog. All rights reserved.
//

#import "PDBulletEntity.h"
#import "UIColor+PDAdd.h"

@interface PDBulletEntity ()

@property (nonatomic, strong, readwrite) UIColor *backgroundColor;
@property (nonatomic, strong, readwrite) UIColor *textColor;

@end

@implementation PDBulletEntity

#pragma mark - Setter Methods
- (void)setBackgroundColorValue:(NSString *)backgroundColorValue {
    _backgroundColorValue = [backgroundColorValue copy];
    self.backgroundColor = [UIColor colorWithHexString:_backgroundColorValue];
}

- (void)setTextColorValue:(NSString *)textColorValue {
    _textColorValue = [textColorValue copy];
    self.textColor = [UIColor colorWithHexString:_textColorValue];
}

#pragma mark - Getter Methods
- (UIColor *)backgroundColor {
    return _backgroundColor ?: UIColorHex(0x0000007F); // Return default color.
}

- (UIColor *)textColor {
    return _textColor ?: UIColorHex(0xFFFFFF);
}

@end
