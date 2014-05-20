//
//  CHAnimator.h
//  CHAnimation
//
//  Created by hangchen on 5/20/14.
//  Copyright (c) 2014 hangchen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CHAnimation;
@interface CHAnimator : NSObject

+ (instancetype)sharedAnimator;

- (void)addAnimation:(CHAnimation *)anim forObject:(id)obj key:(NSString *)key;
- (void)removeAllAnimationsForObject:(id)obj;
- (void)removeAnimationForObject:(id)obj key:(NSString *)key;

@end
