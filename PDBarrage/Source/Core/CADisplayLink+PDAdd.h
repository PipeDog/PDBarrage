//
//  CADisplayLink+PDAdd.h
//  PDBarrage
//
//  Created by liang on 2020/2/28.
//  Copyright © 2020 PipeDog. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

@protocol PDCADisplayLinkDelegate <NSObject>

- (void)tick:(CADisplayLink *)displayLink;

@end

@interface CADisplayLink (PDAdd)

+ (void)bind:(id<PDCADisplayLinkDelegate>)delegate;
+ (void)unbind:(id<PDCADisplayLinkDelegate>)delegate;

@end

NS_ASSUME_NONNULL_END
