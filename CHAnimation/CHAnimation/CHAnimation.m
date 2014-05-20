//
//  CHAnimation.m
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

#import "CHAnimation.h"
#import "CHAnimator.h"
#import "CHAnimationState.h"



@implementation CHAnimation
{
    CHAnimationState *_state;
    
}


CHAnimationState *CHAnimationGetState(CHAnimation *a)
{
    return a->_state;
}

- (id)init
{
    self = [super init];
    if (self) {
        _state = [[CHAnimationState alloc] initWithAnimation:self];
    }
    return self;
}


@end

@implementation NSObject (CHAnimation)

- (void)ch_addAnimation:(CHAnimation *)anim forKey:(NSString *)key
{
    anim.obj = self;
    [[CHAnimator sharedAnimator] addAnimation:anim forObject:self key:key];
}

- (void)ch_removeAllAnimations
{
    [[CHAnimator sharedAnimator] removeAllAnimationsForObject:self];
}

- (void)ch_removeAnimationForKey:(NSString *)key
{
    [[CHAnimator sharedAnimator] removeAnimationForObject:self key:key];
}



@end

