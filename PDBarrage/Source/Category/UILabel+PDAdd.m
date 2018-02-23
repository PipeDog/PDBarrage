//
//  UILabel+PDAdd.m
//  PDBarrage
//
//  Created by liang on 2018/2/23.
//  Copyright © 2018年 PipeDog. All rights reserved.
//

#import "UILabel+PDAdd.h"

@implementation UILabel (PDAdd)

+ (UILabel *)building:(UIView *)superview
      backgroundColor:(UIColor *)backgroundColor
                 font:(UIFont *)font textColor:(UIColor *)textColor
        textAlignment:(NSTextAlignment)textAlignment
        numberOfLines:(NSInteger)numberOfLines {
    
    UILabel *label = [[UILabel alloc] init];
    if (superview) [superview addSubview:label];
    label.font = font;
    label.textColor = textColor;
    label.textAlignment = textAlignment;
    label.numberOfLines = numberOfLines;
    label.backgroundColor = backgroundColor ?: superview.backgroundColor;
    return label;
}

@end
