//
//  CHAnimationState.m
//  CHAnimation
//
//  Created by hangchen on 5/20/14.
//  Copyright (c) 2014 Hang Chen (https://github.com/cyndibaby905)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

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
    else if ([_animation.fromValue isKindOfClass:NSNumber.class] && [_animation.toValue isKindOfClass:NSNumber.class]) {
        CGFloat fromValue = [_animation.fromValue floatValue];
        CGFloat toValue = [_animation.toValue floatValue];
        CGFloat value = fromValue + (toValue - fromValue)*progress;
        _animation.writeBlock(_animation,[NSNumber numberWithFloat:value]);
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
