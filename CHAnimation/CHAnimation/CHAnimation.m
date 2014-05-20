//
//  CHAnimation.m
//  CHAnimation
//
//  Created by hangchen on 5/20/14.
//  Copyright (c) 2014 hangchen. All rights reserved.
//

#import "CHAnimation.h"
#import "CHAnimator.h"
#import "CHAnimationState.h"

@implementation CHAnimation

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

