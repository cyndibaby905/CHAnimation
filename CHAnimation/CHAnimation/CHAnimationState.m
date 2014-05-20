//
//  CHAnimationState.m
//  CHAnimation
//
//  Created by hangchen on 5/20/14.
//  Copyright (c) 2014 hangchen. All rights reserved.
//

#import "CHAnimationState.h"
#import "CHAnimation.h"

@implementation CHAnimationState
{
 
    BOOL _active;
    __weak CHAnimation * _animation;
    CFTimeInterval _startTime;
    CFTimeInterval _currentTime;
}

- (id)initWithAnimation:(CHAnimation*)animation
{
    self = [super init];
    if (self) {
        _animation = animation;
    }
    return self;
}


- (BOOL)startIfNeeded:(id)obj atTime:(CFTimeInterval)time
{
    if (!_active && time >= _animation.beginTime) {
        _active = YES;
        _startTime = time;
    }
    
    return _active;
}

- (void)applyAnimation:(id)obj atTime:(CFTimeInterval)time
{
    _currentTime = time;
    
    CGFloat progress = self.progress;

    
    
    if (!strcmp([_animation.fromValue objCType], @encode(CGPoint)) && !strcmp([_animation.toValue objCType], @encode(CGPoint))) {
        CGPoint fromPoint = [_animation.fromValue CGPointValue];
        CGPoint toPoint = [_animation.toValue CGPointValue];
        CGPoint point = CGPointMake(fromPoint.x + (toPoint.x - fromPoint.x)*progress, fromPoint.y + (toPoint.y - fromPoint.y)*progress);
        _animation.writeBlock(_animation,[NSValue valueWithCGPoint:point]);
    }
    else if (!strcmp([_animation.fromValue objCType], @encode(CGSize)) && !strcmp([_animation.toValue objCType], @encode(CGSize))) {
        CGSize fromSize = [_animation.fromValue CGSizeValue];
        CGSize toSize = [_animation.toValue CGSizeValue];
        CGSize size = CGSizeMake(fromSize.width + (toSize.width - fromSize.width)*progress, fromSize.height + (toSize.height - fromSize.height)*progress);
        _animation.writeBlock(_animation,[NSValue valueWithCGSize:size]);
    }
    
}

- (BOOL)isDone
{
    if (_currentTime >= _startTime + _animation.duration) {
        return YES;
    }
    return NO;
}

- (CGFloat)progress
{
    CGFloat _progress = (_currentTime - _startTime)/_animation.duration;
    if (_progress < 0) {
        _progress = 0;
    }
    if (_progress > 1) {
        _progress = 1.0;
    }
    return _progress;
}


@end
