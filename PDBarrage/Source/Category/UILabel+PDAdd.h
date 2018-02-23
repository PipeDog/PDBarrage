//
//  UILabel+PDAdd.h
//  PDBarrage
//
//  Created by liang on 2018/2/23.
//  Copyright © 2018年 PipeDog. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (PDAdd)

+ (UILabel *)building:(UIView *)superview
      backgroundColor:(UIColor *)backgroundColor
                 font:(UIFont *)font
            textColor:(UIColor *)textColor
        textAlignment:(NSTextAlignment)textAlignment
        numberOfLines:(NSInteger)numberOfLines;

@end
