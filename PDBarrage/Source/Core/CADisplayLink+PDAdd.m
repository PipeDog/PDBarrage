//
//  CADisplayLink+PDAdd.m
//  PDBarrage
//
//  Created by liang on 2020/2/28.
//  Copyright © 2020 PipeDog. All rights reserved.
//

#import "CADisplayLink+PDAdd.h"

@interface _PDDisplayLinkAdapter : NSObject {
    NSHashTable<id<PDCADisplayLinkDelegate>> *_delegates;
}

@property (nonatomic, strong) CADisplayLink *displayLink;

@end

@implementation _PDDisplayLinkAdapter

+ (instancetype)globalAdapter {
    static _PDDisplayLinkAdapter *_globalAdapter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _globalAdapter = [[self alloc] init];
    });
    return _globalAdapter;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _delegates = [NSHashTable weakObjectsHashTable];
    }
    return self;
}

- (void)bind:(id<PDCADisplayLinkDelegate>)delegate {
    if (![delegate respondsToSelector:@selector(tick:)]) {
        NSAssert(NO, @"The argument `delegate` must impl `- tick:` method!");
        return;
    }
    
    if (![_delegates containsObject:delegate]) {
        [_delegates addObject:delegate];
        [self fire];
    }
}

- (void)unbind:(id<PDCADisplayLinkDelegate>)delegate {
    if (delegate && [_delegates containsObject:delegate]) {
        [_delegates removeObject:delegate];
        [self invlaid];
    }
}

#pragma mark - Tool Methods
- (void)fire {
    if (_displayLink) { return; }
    
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(tick:)];
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)invlaid {
    if (!_displayLink) { return; }
    
    [_displayLink invalidate];
    _displayLink = nil;
}

- (void)tick:(CADisplayLink *)displayLink {
    NSArray<id<PDCADisplayLinkDelegate>> *delegates = _delegates.allObjects;
    
    if (!delegates.count) {
        [self invlaid];
        return;
    }
    
    for (id<PDCADisplayLinkDelegate> delegate in delegates) {
        [delegate tick:displayLink];
    }
}

@end

@implementation CADisplayLink (PDAdd)

+ (void)bind:(id<PDCADisplayLinkDelegate>)delegate {
    [[_PDDisplayLinkAdapter globalAdapter] bind:delegate];
}

+ (void)unbind:(id<PDCADisplayLinkDelegate>)delegate {
    [[_PDDisplayLinkAdapter globalAdapter] unbind:delegate];
}

@end
