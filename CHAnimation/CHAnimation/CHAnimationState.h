//
//  CHAnimationState.h
//  CHAnimation
//
//  Created by hangchen on 5/20/14.
//  Copyright (c) 2014 hangchen. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CHAnimation;
@interface CHAnimationState : NSObject
- (id)initWithAnimation:(CHAnimation*)animation;
- (BOOL)startIfNeeded:(id)obj atTime:(CFTimeInterval)time;
- (void)applyAnimation:(id)obj atTime:(CFTimeInterval)time;
- (BOOL)isDone;
- (CGFloat)progress;
@end
